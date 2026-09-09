#!/bin/bash
# ==========================================
# Link Validator for Agent Constitution
# ==========================================
# Usage: ./validate-links.sh
# Checks all internal .md links in the repository.

set -e

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

echo "🔍 Validating internal links in: $REPO_ROOT"

ERRORS=0
CHECKED=0

# ── strip_code ────────────────────────────────────────────────────────────
# Emit a file with every fenced code block dropped and every inline code span
# blanked, so link extraction never sees markdown that is being *shown* rather
# than *used*.
#
# Why this exists: without it the extractor reported 16 "broken links" on a
# clean main, every one of them a false positive from inside code — Go generic
# syntax `assertEqual[T comparable](t *testing.T, ...)`, Solidity
# `new uint32[](2)`, an example ADR index table, a generated README's
# `See [CONTRIBUTING.md](CONTRIBUTING.md)`, and prose quoting `[url](url)` to
# describe markdown syntax itself. Those are correct documentation; the
# extractor was wrong. Mangling the docs to satisfy a broken check would have
# been the wrong fix.
strip_code() {
    awk '
        # Fence toggles on ``` or ~~~ at the start of a (possibly indented) line.
        /^[[:space:]]*(```|~~~)/ { in_fence = !in_fence; next }
        in_fence { next }
        {
            # Blank out inline code spans: `...` becomes ``.
            gsub(/`[^`]*`/, "``")
            print
        }
    ' "$1"
}


# Find all markdown files
while IFS= read -r -d '' file; do
    # Extract all markdown links [text](path)
    while IFS= read -r link; do
        # Skip external links, anchors, and empty
        if [[ "$link" =~ ^https?:// ]] || [[ "$link" =~ ^# ]] || [[ -z "$link" ]]; then
            continue
        fi
        
        # Remove anchor from link
        link_path="${link%%#*}"
        
        # Skip empty after anchor removal
        if [[ -z "$link_path" ]]; then
            continue
        fi
        
        # Resolve relative to the file's directory
        file_dir="$(dirname "$file")"
        full_path="$file_dir/$link_path"
        
        # Normalize path
        full_path="$(cd "$file_dir" 2>/dev/null && realpath -m "$link_path" 2>/dev/null || echo "$full_path")"
        
        ((CHECKED++))
        
        if [[ ! -e "$full_path" ]]; then
            echo "❌ Broken link in $file:"
            echo "   -> $link"
            echo "   (Expected: $full_path)"
            ((ERRORS++))
        fi
        
    done < <(strip_code "$file" | grep -oE '\]\([^)]+\)' 2>/dev/null | sed 's/\](//' | sed 's/)$//' || true)
    
done < <(find "$REPO_ROOT" -name "*.md" -not -path "*/.storage/*" -not -path "*/node_modules/*" -print0)

echo ""
echo "📊 Results: $CHECKED links checked, $ERRORS broken"

if [[ $ERRORS -gt 0 ]]; then
    echo "⚠️  Please fix the broken links above."
    exit 1
else
    echo "✅ All links are valid!"
    exit 0
fi
