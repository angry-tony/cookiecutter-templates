#!/bin/bash

BRANCH=$(git rev-parse --abbrev-ref HEAD)
M=$(find classes/system -name credentials.yml;ls classes/system/openssh/client/*)
git diff $M

echo "Files with modified instance data:"
ls -lh $M

cat <<EOF


If there are no changes in model than updated credentials feel free to checkout HEAD state"

  git checkout -- $(echo $M|xargs)

Othervise perform a manual merge and add chnages to:

  git difftool ${BRANCH} ${BRANCH}~1 -- $(echo $M|xargs)

EOF

