#!/bin/bash -e
#set -x

function _usage() {
  cat <<-EOF
  Update class definitions in reclass files.

  $0  [-h] [-r regExp]    <ORIGIN NS>    <DEST NS>                  <PATH[S]>
  $0  -r 's/system.xxx//' system.xxx.yyy cluster.namespace.xxx.yyy  /classes/cluster/prod/region01

    - updates all files regardless suffix
    - regExp rename is run after reclassing
    - regExp rename only affect modified classes
EOF
}

function _dirtyExit() {
  echo "$@"
  exit 1
}


# check args
####

while getopts ":r:h" opt; do
  case $opt in
    h)
      _usage
      exit 0
      ;;
    r)
      #echo "-r was triggered, Parameter: $OPTARG" >&2
      RENAME_CLASS_EXPR=${OPTARG}
      ;;
    \?)
      _dirtyExit "Invalid option: -$OPTARG" >&2
      ;;
    :)
      _dirtyExit "Option -$OPTARG requires an argument." >&2
      ;;
  esac
done
shift $((OPTIND-1))


[[ -z "$1" || -z "$2" || -z "$3" ]] && {
  _usage; _dirtyExit "ERROR: Missing class namespace or PATH positional argument."
}

SED_OPS="-i"
[[ -z "$PREVIEW" ]] || SED_OPS=""

ORIGNS=$1
DESTNS=$2
shift
shift
PATHNS=$@
IFS='.' read -r -a ORIGNS_ARRAY <<< $ORIGNS

# validate
####
for NS in ${PATHNS[@]}; do
  [[ -e "$NS" || -d "$NS" ]] || {
    _usage; _dirtyExit "ERROR: PATH $NS not found found."
  }
done

# reclass
####

function join { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }

echo "Reclassing $ORIGNS with preffix ${DESTNS}"
for NS in ${PATHNS[@]}; do

  find ${NS} -type f -exec sed $SED_OPS "/^[[:blank:]]*-[[:blank:]]*${ORIGINS}/ s/\(^[[:blank:]]*-[[:blank:]]*\)\(${ORIGNS}[-_\.[[:alpha:]]*]*\).*$/\1${DESTNS}\.\2/" {} ";"

  [[ -n "${RENAME_CLASS_EXPR}" ]] && {

    # NOTE, extended use-case where part of the ORIGIN NS is RENAMED
    # NOTE, originally only remove some positions from class name
    #ORIGNS_PREFFIX=${ORIGNS_ARRAY[0]}
    #ORIGNS_WITHOUT_PREFFIX=$(join . ${ORIGNS_ARRAY[@]:1})
    #find ${NS} -type f -exec sed $SED_OPS "/^[[:blank:]]*-[[:blank:]]*${ORIGINS}/ s/\(^[[:blank:]]*-[[:blank:]]*\)${ORIGNS_PREFFIX}\.\(${ORIGNS_WITHOUT_PREFFIX}[-_\.[[:alpha:]]*]*\).*$/\1${DESTNS}\.\2/" {} ";"

    # affect only modified 'class' lines
    echo "Renaming classes with $RENAME_CLASS_EXPR"
    find ${NS} -type f -exec sed $SED_OPS "/^[[:blank:]]*-[[:blank:]]*${DESTNS}\.${ORIGINS}/ ${RENAME_CLASS_EXPR}" {} ";"

  }
done

exit 0


