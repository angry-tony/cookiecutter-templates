#!/bin/bash -e
#set -x

function _usage() {
  echo "cd <repo-salt-model>; $0 <cluster.namespace.yxz> <classes/system/xxx/xxx> [<classes/system/yyy>]"
}

function _dirtyExit() {
  echo "$@"
  test -n "$IGNORE_ERRORS" && exit 1
}


# check pos. args. are defined
####
[[ -z "$1" || -z "$2" ]] && {
  _usage; _dirtyExit "ERROR: No cluster or system.class namespace defined. "
}

CLUSTER_NS=$1
shift
IFS=' ' read -r -a ADDSYSTEMS <<< ${@}
BASE=.
CLUSTER_PATH=$BASE/classes/cluster/${CLUSTER_CLASS//\./\//}
CLUSTER_NS_PATH=${CLUSTER_NS//\./\/}



# SANITY CHECKS
####

# check the repo is commited
git diff --quiet HEAD || echo "WARNING: You have an uncommitted changes in working tree."

# check $ADDSYSTEMS exist
for CLASS in ${ADDSYSTEMS[@]}; do
  test -d $CLASS || _dirtyExit "WARNING: System $CLASS to move in cluster was not found"
done

# check $ADD_SYSTEMS are not refered from other classes/system
for CLASS in ${ADDSYSTEMS[@]}; do
  # strip path prefix, keep only system class name
  SYSTEM=${CLASS//classes\/system\//}
  for OTHER_CLASS in $(ls $BASE/classes/system | grep -v "${SYSTEM//\/*/}" | grep -v "reclass"); do
    #echo grep -REq "system.$SYSTEM" "$BASE/classes/system/$(basename ${OTHER_CLASS//\//.} .yml)"
    grep -REq "system.$SYSTEM" "$BASE/classes/system/$(basename ${OTHER_CLASS//\//.} .yml)" && _dirtyExit "WARNING: Class '$OTHER_CLASS' refer '$CLASS'. As you are moving '$CLASS' to '/classes/cluster/$CLUSTER_NS_PATH' you should fix your model first."
  done
done


# Create cluster definition
####

mkdir -p ${CLUSTER_PATH}${CLUSTER_NS_PATH}

# create cluster
for CLASS in ${ADDSYSTEMS[@]}; do

  SYSTEM=${CLASS//classes\/system\//}
  echo "Creating ${CLUSTER_PATH}${CLUSTER_NS_PATH}/${SYSTEM} ..."

  # copy path
  mkdir -p "${CLUSTER_PATH}${CLUSTER_NS_PATH}/${SYSTEM}"
  cp -fa $BASE/classes/system/${SYSTEM}/* ${CLUSTER_PATH}${CLUSTER_NS_PATH}/${SYSTEM}

  # reclass
  find ${CLUSTER_PATH}${CLUSTER_NS_PATH} -type f -exec sed -i "/^[[:blank:]]*-[[:blank:]]*system.${SYSTEM//\//.}/ s/\(^[[:blank:]]*-[[:blank:]]*\)system\.\([-_\.[[:alpha:]]*]*\).*$/\1cluster.${CLUSTER_NS}\.\2/" {} ";"

  # list files created
  test -n "$VERBOSE"  && {
    which tree &>/dev/null && tree "${CLUSTER_PATH}${CLUSTER_NS_PATH}/${SYSTEM}"
  }

done


# Check/suggest additional replacements
####

cat <<EOF

Dont forget to update $CLUSTER_NS specific configuration that's not included in general $BASE/classes namespace.

  - node definition, which classes they load ( classes/system/reclass/storage/system )
    Example:

      cd classes/system/reclass/storage/system
      sed -i "s/^\([[:blank:]]*-[[:blank:]]*\)system\.\([-_\.[[:alpha:]]*]*\).*$/\1cluster.${CLUSTER_NS}\.\2/" ./*_{{cookiecutter.cluster}}.yml

- environment related config under ${CLUSTER_PATH}${CLUSTER_NS_PATH}
    - interfaces, routes
    - etc..



EOF
