```justfile
# Justfile (Option A: wget mirror under /docs)
set shell := ["bash", "-euo", "pipefail", "-c"]

# Mirror a docs subtree for offline browsing.
# Usage:
#   just mirror URL=https://example-site.com/docs/ OUT=offline
# Then:
#   just serve OUT=offline PORT=8080
# Open:
#   http://localhost:8080/<domain>/docs/
mirror URL:="https://example-site.com/docs/" OUT:="offline":
  mkdir -p "{{OUT}}"
  domain="$(
    python3 -c 'from urllib.parse import urlparse; import sys; print(urlparse(sys.argv[1]).netloc)' "{{URL}}"
  )"
  wget \
    --mirror \
    --page-requisites \
    --convert-links \
    --adjust-extension \
    --recursive --level=0 \
    --domains "$domain" \
    --no-parent \
    --wait=1 --random-wait \
    --directory-prefix "{{OUT}}" \
    "{{URL}}"
  echo "✅ Mirrored to: {{OUT}}/$domain/"
  echo "➡️  Serve it with: just serve OUT={{OUT}}"
  echo "🌐 Then open: http://localhost:8080/$domain/docs/"

# Serve the mirrored content locally (recommended vs file://).
serve OUT:="offline" PORT:="8080":
  cd "{{OUT}}" && python3 -m http.server "{{PORT}}"
```
