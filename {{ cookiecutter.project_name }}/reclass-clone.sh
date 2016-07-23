#!/bin/bash -e
#set -x

function _usage() {
  echo "cd <repo-salt-model>; $0 <cluster.namespace.yxz> <classes/system/xxx/xxx> [<classes/system/yyy>]"
}

function _dirtyExit() {
  echo "$@"
  test -n "$IGNORE_ERRORS" && exit 1
}


# check pos. args.
####

[[ -z "$1" || -z "$2" ]] && {
  _usage; _dirtyExit "ERROR: No cluster or system.class namespace defined. "
}

CLUSTER_NS=$1
CLUSTER_NS_PATH=${CLUSTER_NS//\./\/}
shift
IFS=' ' read -r -a ADDSYSTEMS <<< ${@}
MODEL=${SALT_MODEL_PATH:-.}
CLASSES_PATH=$MODEL/classes
SYSTEMS_PATH=$CLASSES_PATH/system



# SANITY CHECKS
####

# check the repo is commited
git diff --quiet HEAD || echo "WARNING: You have an uncommitted changes in working tree."

# check ./reclass.sh script exist
test -f $MODEL/reclass.sh || _dirtyExit "ERROR: $MODEL/reclass.sh script is missing in model PATH."

# check $ADDSYSTEMS exist
for CLASS in ${ADDSYSTEMS[@]}; do
  test -d $CLASS || _dirtyExit "ERROR: System $CLASS to move in cluster was not found"
done

# check $ADD_SYSTEMS are not refered from other classes/system
for CLASS in ${ADDSYSTEMS[@]}; do
  # strip path prefix, keep only system class name
  SYSTEM=${CLASS//classes\/system\//}
  for OTHER_CLASS in $(ls $SYSTEMS_PATH | grep -v "${SYSTEM//\/*/}" | grep -v "reclass"); do
    #echo grep -REq "system.$SYSTEM" "$SYSTEMS_PATH/$(basename ${OTHER_CLASS//\//.} .yml)"
    grep -REq "system.$SYSTEM" "$SYSTEMS_PATH/$(basename ${OTHER_CLASS//\//.} .yml)" && \
      _dirtyExit "ERROR: Class '$OTHER_CLASS' refer '$CLASS'. As you are moving '$CLASS' to '$CLASSES_PATH/$CLUSTER_NS_PATH' you should fix your model first."
  done
done


# Create cluster definition
####

mkdir -p ${CLASSES_PATH}/${CLUSTER_NS_PATH}

# create cluster
for CLASS in ${ADDSYSTEMS[@]}; do

  # strip path prefix
  SYSTEM=${CLASS//classes\//}
  echo "Creating ${CLASSES_PATH}/${CLUSTER_NS_PATH}/${SYSTEM} ..."

  # copy path
  mkdir -p "${CLASSES_PATH}/${CLUSTER_NS_PATH}/${SYSTEM}"
  cp -fa ${CLASS}/* ${CLASSES_PATH}/${CLUSTER_NS_PATH}/${SYSTEM}

done

# reclass
for CLASS in ${ADDSYSTEMS[@]}; do
  # strip path prefix
  SYSTEM=${CLASS//classes\//}

  #find ${CLASSES_PATH}/${CLUSTER_NS_PATH} -type f -exec sed -i "/^[[:blank:]]*-[[:blank:]]*system.${SYSTEM//\//.}/ s/\(^[[:blank:]]*-[[:blank:]]*\)system\.\([-_\.[[:alpha:]]*]*\).*$/\1cluster.${CLUSTER_NS}\.\2/" {} ";"
  $MODEL/reclass.sh "${SYSTEM//\//.}" "${CLUSTER_NS}" ${CLASSES_PATH}/${CLUSTER_NS_PATH}

  # list files created
  test -n "$VERBOSE"  && {
    which tree &>/dev/null && tree "${CLASSES_PATH}/${CLUSTER_NS_PATH}/${SYSTEM}"
  }
done


# Check/suggest additional replacements
####

cat <<EOF

Dont forget to update $CLUSTER_NS specific configuration that's not included in general $MODEL/classes namespace.

  - environment related config under ${CLASSES_PATH}/${CLUSTER_NS_PATH}
    - interfaces, routes
    - etc..

  - node definition, which classes they load ( classes/system/reclass/storage/system )
    Example:
EOF

for CLASS in ${ADDSYSTEMS[@]}; do
  # strip path prefix, keep only system class name
  SYSTEM=${CLASS//classes\/}
  echo "      $MODEL/reclass.sh "${SYSTEM//\//.}" "${CLUSTER_NS}" classes/system/reclass/storage/system/*{{cookiecutter.cluster}}*"
done

