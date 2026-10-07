#!/usr/bin/env bash
set -euo pipefail

# Work around the Ubuntu 20.04 libc6 kernel-version check used by the course image.
mv /bin/uname /bin/uname.orig
cat > /bin/uname <<'EOF'
#!/bin/bash
if [[ $1 == "-r" ]]; then
    echo '4.9.250'
else
    /bin/uname.orig "$@"
fi
EOF
chmod 755 /bin/uname
