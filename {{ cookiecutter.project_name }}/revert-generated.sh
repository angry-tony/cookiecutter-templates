#!/bin/bash

BRANCH=$(git rev-parse --abbrev-ref HEAD)
M=$(find classes/system -name credentials.yml;ls classes/system/openssh/client/*; ls nodes/{{cookiecutter.cfg01_name}}*.yml)
git status

echo "Type [yes] to auto revert known generated/credential files?"
read answ
[[ "$answ" == "yes" ]] &&{
  echo "Reverting ..."
  git checkout -- $(echo $M|xargs)
}

cat <<EOF

Use git diff to preview changes:

  git diff $(echo $M|xargs)

If there are no changes in model than updated generated/credentials files, revert HEAD state with:

  git checkout -- $(echo $M|xargs)

Othervise perform a manual merge:

  git difftool ${BRANCH} ${BRANCH}~1 -- $(echo $M|xargs)

EOF

