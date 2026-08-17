---
name: smr-rclone-throughput
description: Use when moving hundreds of GB with rclone to or from an external drive (SMR/shingled HDD, USB SSD) and throughput is disappointing — picking transfers/streams/buffer, reading the real rate, and finding the actual bottleneck layer.
version: 1.0.0
updated: 2026-08-18
metadata:
  origin: measured on the sandisk project, 2026-08-11..18
tools: Read, Write, Edit, Bash, Grep, Glob
---

# SMR + rclone Throughput

Measured on a 4 TB WD My Passport (SMR) and a 1 TB SanDisk Extreme (SSD) over
USB3, restoring ~1.4 TB from Google Drive on macOS. Every number below came from
a real run, not from documentation. Companion to `data-throughput-accelerator`
(that one is about pipelines; this one is about bytes onto a spinning disk).

## The configuration (start here)

Split the job by file size and run two passes. There is **no single optimal
config** — the two regimes want opposite slot counts.

| Pass | Filter | transfers | multi-thread-streams | buffer-size | measured |
|---|---|---|---|---|---|
| **Small** | `--max-size 256M` | **32** | **0** | **16M** | **30.7 MiB/s** · 4.12 files/s |
| **Large** | `--min-size 256M` | **8** | **0** | **64M** | **40.9 MiB/s** |

```bash
# large pass
rclone copy "remote:path" "/Volumes/Archive/path" \
  --min-size 256M --transfers 8 --multi-thread-streams 0 --buffer-size 64M \
  --checkers 16 --fast-list --progress --stats 2s \
  --log-level INFO --log-file "$LOG"

# small pass — same command, only these four differ
#   --max-size 256M --transfers 32 --multi-thread-streams 0 --buffer-size 16M
```

With `streams=0` the flags `--multi-thread-cutoff` and
`--multi-thread-chunk-size` do nothing — **delete them** so the next person is
not misled into thinking multi-thread is active.

## The one rule that matters: `--multi-thread-streams` is poison on SMR

Shingled drives overwrite whole zones. Splitting one file into N parallel chunks
writes at N distant offsets at once, which forces zone read-modify-write:

```
--transfers 12 --multi-thread-streams 4   (48 concurrent write points)
  17:36:09  16.983 GiB  33.932 MiB/s
  17:36:39  17.000 GiB   5.174 MiB/s   ← bytes froze
  17:38:39  17.000 GiB   2.294 KiB/s   ← drive locked
  local dd, no network: 4.65 MB/s  →  3 min idle  →  35.0 MB/s again
```

The wrong lesson to draw is "too many streams". **32 concurrent transfers with
`streams=0` ran at 30.7 MiB/s with zero stalls.** The drive does not care how
many files you write at once; it cares that each file is written **sequentially
from offset 0**. Many sequential writers: fine. One chunked writer: fatal.

## Reading the rate without fooling yourself

The instantaneous number in `--progress` is a short window, not an average. It
was misread three times in two days by two different agents, each time producing
a wrong diagnosis ("SMR wall", "1.5 MiB/s ceiling") that a flag change then
disproved by going 27× faster.

**Measure from the log instead** — completion timestamps × file sizes:

```python
# rows of (timestamp, name) from "INFO  : <name>: Multi-thread Copied (new)"
win = rows[-20:]
span = (win[-1][0] - win[0][0]).total_seconds()
total = sum(os.path.getsize(os.path.join(dst, name)) for _, name in win)
print(f"{total/1e6/span:.1f} MB/s")     # 9.76 GB / 582 s = 16.8 MB/s
```

`df` on the destination is **not** a meter: rclone preallocates, so used space
jumps when a file *starts*, not while it is written.

## Diagnose bottom-up, and name the write-side constraint

Four ceilings were hit in sequence on one job. Each was mistaken for the last
one, because each new ceiling appeared only after the previous was removed.

1. **Physical link.** A daisy-chained USB2 hub capped the drive at 480 Mbps for
   four days while nine flag combinations were benchmarked against it.
   **First command, always:**
   `ioreg -p IOUSB -w0 -l | grep -A4 "<drive>" | grep "Device Speed"`
   (`2`=USB2 480 Mbps · `3`=USB3 5 Gbps · `4`=Gen2 10 Gbps)
2. **Per-file latency.** 0.93 files/s with 4 slots on ~13 MiB files ⇒ ~80% of
   each slot's time was API open + metadata + rename, not transfer. Lever:
   `--transfers`.
3. **Write pattern** (the SMR trap above). Lever: `--multi-thread-streams 0`.
4. **The internet link.** 38–41 MiB/s against a measured 332 Mbps ≈ 41.5 MB/s
   downlink = saturated. No flag adds bandwidth. Stop tuning here.

## Memory: predict it, don't watch it

RSS is essentially `transfers × buffer-size` plus the `--fast-list` object list.
Verified across three configs:

| config | predicted | measured RSS |
|---|---|---|
| `T=2 buffer=64M` | ~128 M | 74 MB |
| `T=32 buffer=16M` | ~512 M | 646 MB |
| `T=8 buffer=64M` | ~512 M | 701–923 MB |

So `T=32 buffer=64M` would be ~2 GB — the reason the large pass uses 8 and not
32 is memory, plus the link being saturated anyway.

Do **not** diagnose a transfer from macOS memory figures:

- **Cached Files** is the page cache. It grows with I/O volume and is *clean* —
  reclaimed instantly, never swapped. Not pressure.
- Its **direction** is the useful signal: swelling = disk behind the network;
  draining = disk ahead. `6.43 GB → 3.92 GB` was the clearest proof the large-file
  fix worked.
- **Swap** only holds anonymous memory; page cache never causes it.
- **Compressed** = inactive anonymous pages compressed in RAM, the step before
  swap. On Apple Silicon convert with **16 KB** pages, not 4 KB:
  `83,242 compressor pages × 16 KB = 1.36 GB`.
- `--buffer-size` touches rclone's own RSS only. There is no flag to bypass the
  kernel page cache; `F_NOCACHE`/`O_DIRECT` are not exposed, and `--vfs-cache-*`
  belongs to `mount`/`serve`, not `copy`.

## Benchmarking guardrail

An SMR drive has a media cache. **Any benchmark shorter than the time it takes to
fill that cache measures the cache, not the disk.** A 9-cell flag matrix produced
CV ≈ 25% and no separable signal — the dominant hidden variable was cache
fill state, not the flags. Identical settings gave 17.07 and 12.02 MiB/s.

So: run long enough to saturate the cache, record the USB link speed next to
every number, and treat any stored benchmark whose link was not recorded as void.

## Operational traps

- `--files-from` **overrides all other filters** — rclone exits 1 if you also
  pass `--exclude`. Split flags into BASE + FILTERS and run files-from jobs with
  filters off.
- Run `rclone check` with **exactly** the excludes used by `rclone copy`, or every
  deliberately-skipped file reports as missing (`673 differences` that were all
  `._*` and `.git/**`).
- Orphan `*.partial` files from killed runs are never resumed (the hash suffix
  changes per run). Clean them **after** all passes, never during.
- exFAT cluster size inflates `du` enormously for file-dense trees (512 KB
  clusters ⇒ 334,516 small files occupied 210 GB for 13.4 GB of content).
  Zipping such a tree recovered ~197 GB without losing a byte.
- `Operation not permitted` on `rm` over exFAT is usually the `uchg` flag, not a
  read-only mount: `chflags -R nouchg <dir>` first.
- NTFS volumes mount read-only on macOS. You can still convert them: copy out
  what you keep, `diskutil eraseVolume`, copy back. No third-party driver needed.
- `diskutil eraseDisk` destroys **every** partition on the device. Use
  `eraseVolume` on the specific slice, and check for a Ventoy/EFI partition first.
