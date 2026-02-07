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
        
    done < <(grep -oE '\]\([^)]+\)' "$file" 2>/dev/null | sed 's/\](//' | sed 's/)$//' || true)
    
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
