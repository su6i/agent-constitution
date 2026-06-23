# Agent Constitution — CLI Demo
# Run: vhs assets/demo.tape
# Requires: brew install vhs ffmpeg ttyd

Output assets/demo.gif

Set Width 1100
Set Height 550
Set FontSize 14
Set FontFamily "JetBrains Mono"
Set Theme "GitHub Dark"
Set TypingSpeed 40ms
Set Framerate 30

Hide
Type "clear"
Enter
Show

# Show the skill count
Type "ls skills/ | wc -l"
Enter
Sleep 1.5s

# Search for a specific skill
Type "ls skills/ | grep fastapi"
Enter
Sleep 1.5s

# Peek inside a skill
Type "head -6 skills/fastapi-patterns.md"
Enter
Sleep 2s

# Show the install one-liner
Type "# Install globally:"
Enter
Type "bash <(curl -fsSL https://raw.githubusercontent.com/su6i/agent-constitution/main/install.sh)"
Sleep 3s
