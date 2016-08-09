#!/bin/bash
################################################################
function echo_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset CMD_ECHO="${GBL_ECHO:-echo -e }"
  typeset FDNUM=1
  typeset RETCODE="99"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vVu:" OPTION
  do
      case "${OPTION}" in
          'u') FDNUM="${OPTARG}";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_echo_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_echo_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  [[ "_${1}" == "_--" ]] && shift 1
  [[ "_${1}" == "_--" ]] && shift 1
  [[ "_${1}" == "_--" ]] && shift 1
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_echo_zbksh ${0}" EXIT

  if [[ "_${FDNUM}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: File Descriptor number not specified"
    return 2
  fi

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# File Descriptor: ${FDNUM}"

################################################################

  RETCODE=0
  if (( FDNUM == 1 ))
  then
      ${CMD_ECHO} "${@}"
      RETCODE="${?}"
  fi

  if (( FDNUM == 2 ))
  then
      ${CMD_ECHO} "${@}" >&2
      RETCODE="${?}"
  fi

  return ${RETCODE}

}
################################################################
function execl_zbksh {
  typeset REMARK="none"
  typeset RETCODE
  typeset CMD="${@}"
  typeset TMPOUT="/tmp/execl_${$}_${RANDOM}.tmp"
  typeset LOG_EXECL="${LOG_EXECL:-/tmp/execl_${$}.cmd}"

  if [[ "_${CMD}" == "_"        ]] ||
     [[ "_${CMD}" == _[Nn]/[Aa] ]]
  then
      (( VERBOSE  == TRUE )) && stderr_zbksh -- "# REMARK (n/a)...: ${REMARK}"
      RETCODE="2"
  else

#############################################################

#### Define the command execution mode, either local or remote depending upon
#### the value of the SSHADDR variable. If it contains a remote IP address or
#### hostname, define the execution mode variable. Otherwise it are set to
#### NULL, which means the commands will run locally.

# DLF       EXECMODE="print ${SSHADDR:+${CMD_SSH} ${OPT_SSH} -p ${SSHPORT} ${SSHUSER}@${SSHADDR}}"
      EXECMODE="${SSHADDR:+${CMD_SSH} ${OPT_SSH} -p ${SSHPORT} ${SSHUSER}@${SSHADDR}}"
# DLF       [[ "_${EXECMODE}" == "_" ]] && EXECMODE="eval"

      (( VERBOSE == TRUE )) && stderr_zbksh -- "# ${EXECMODE:-eval} \"${CMD}\" > \"${TMPOUT}\" 2>&1  ####  $( date )"

      stdout_zbksh -- "${EXECMODE:-eval} \"${CMD}\" > \"${TMPOUT}\" 2>&1  ####  ${CONFIGFILE##*/}  $( date )" >> "${LOG_EXECL}"

      ${EXECMODE:-eval} "${CMD}" > "${TMPOUT}" 2>&1
      RETCODE="${?}"
      REMARK="$( < ${TMPOUT} )"
      rm -f "${TMPOUT}"

      if (( RETCODE == 0 ))
      then
          (( VERBOSE  == TRUE )) && stderr_zbksh -- "# REMARK (true)..: ${REMARK}"
          RETCODE="0"
      else
          (( VERBOSE  == TRUE )) && stderr_zbksh -- "# REMARK (false).: ${REMARK}"
          RETCODE="1"
      fi
  fi

  stdout_zbksh -- "${REMARK}"

  return ${RETCODE}

}
################################################################

function stdout_zbksh {

  if [[ "_${SHCODE}" == _korn ]]
  then
    typeset VERSION="3.2"
    typeset TRUE="0"
    typeset FALSE="1"
    typeset VERBOSE="${FALSE}"
    typeset VERYVERB="${FALSE}"
    typeset OPTIND="1"
    typeset RETCODE="99"
    typeset FDNUM="1"
  elif [[ "_${SHCODE}" == _bash ]]
  then
    declare VERSION="3.2"
    declare TRUE="0"
    declare FALSE="1"
    declare VERBOSE="${FALSE}"
    declare VERYVERB="${FALSE}"
    declare OPTIND="1"
    declare RETCODE="99"
    declare FDNUM="1"
  else
    VERSION="3.2"
    TRUE="0"
    FALSE="1"
    VERBOSE="${FALSE}"
    VERYVERB="${FALSE}"
    OPTIND="1"
    RETCODE="99"
    FDNUM="1"
  fi

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vV" OPTION
  do
      case "${OPTION}" in
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_stderr_zbksh -- "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_stderr_zbksh -- "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  [[ "_${1}" == "_--" ]] && shift 1
  [[ "_${1}" == "_--" ]] && shift 1
  [[ "_${1}" == "_--" ]] && shift 1
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_stderr_zbksh ${0}" EXIT

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# File Descriptor: ${FDNUM}"

################################################################
################################################################
################################################################

  echo_zbksh -u ${FDNUM} -- "${@}"
  RETCODE=$?

  return ${RETCODE}

}
################################################################
function stderr_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset RETCODE="99"
  typeset FDNUM="2"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vV" OPTION
  do
      case "${OPTION}" in
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_stderr_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_stderr_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  [[ "_${1}" == "_--" ]] && shift 1
  [[ "_${1}" == "_--" ]] && shift 1
  [[ "_${1}" == "_--" ]] && shift 1
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_stderr_zbksh ${0}" EXIT

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# File Descriptor: ${FDNUM}"

################################################################
################################################################
################################################################

  echo_zbksh -u ${FDNUM} -- "${@}"
  RETCODE=$?

  return ${RETCODE}

}
################################################################
function csvout_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset DESC="undefined"
  typeset VERIFIEDBY="undefined"
  typeset ANS[0]="Good"
  typeset ANS[1]="Bad"
  typeset ANS[2]="N/A"
  typeset REMARK="undefined"
  typeset X=","
  typeset RETCODE="99"
  typeset STATUS="${X}${X}${ANS[2]}"
  typeset STATUS="${X}${ANS[2]}"
  typeset QUOTED="${FALSE}"
  typeset RESULT="undefined"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

#### csvout -X "${X}" -Q -R "${RESULT}"      -D "${DESC}"    -S "${STATUS}"
####                     -B "${VERIFIEDBY}"  -M "${REMARK}"  -C "${RETCODE}"

  while getopts ":vVu:X:R:D:B:M:C:Q" OPTION
  do
      case "${OPTION}" in
          'u') VERIFIEDBY="${OPTARG}";;
          'X') X="${OPTARG}";;
          'Q') QUOTED="${TRUE}";;
          'R') RESULT="${OPTARG}";;
          'D') DESC="${OPTARG}";;
          'B') VERIFIEDBY="${OPTARG}";;
          'M') REMARK="${OPTARG}";;
          'C') RETCODE="${OPTARG}";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_csvout_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_csvout_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_csvout_zbksh ${0}" EXIT

  if [[ "_${VERIFIEDBY}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: Verified By User not specified"
    return 2
  fi

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Verified By....: ${VERIFIEDBY}"

################################################################
################################################################
################################################################

  RETCODE="0"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && RETCODE="1"

  (( QUOTED == TRUE )) && X="\"${X}\""

  [[ "_${RESULT}" == "_${ANS[0]}" ]] && STATUS="${ANS[0]}${X}${X}"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && STATUS="${X}${ANS[1]}${X}"
  [[ "_${RESULT}" == "_${ANS[2]}" ]] && STATUS="${X}${X}${ANS[2]}"

  [[ "_${RESULT}" == "_${ANS[0]}" ]] && STATUS="${ANS[0]}${X}"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && STATUS="${ANS[1]}${X}"
  [[ "_${RESULT}" == "_${ANS[2]}" ]] && STATUS="${X}${ANS[2]}"

  if (( QUOTED == TRUE )) 
  then
      (( VERBOSE == TRUE )) && stderr_zbksh -- "# \"Description${X}Result${X}VerifiedBy${X}Remarks${X}Return Code\""
      stdout_zbksh -- "\"${DESC}${X}${STATUS}${X}${VERIFIEDBY}${X}${REMARK}${X}${RETCODE}\""
  else
      (( VERBOSE == TRUE )) && stderr_zbksh -- "# Description ${X} Result ${X} Verified By ${X} Remarks ${X} Return Code"
      stdout_zbksh -- "${DESC}${X}${STATUS}${X}${VERIFIEDBY}${X}${REMARK}${X}${RETCODE}"
  fi

  return ${RETCODE}

}
################################################################
function htmlout_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset DESC="undefined"
  typeset VERIFIEDBY="undefined"
  typeset ANS[0]="Good"
  typeset ANS[1]="Bad"
  typeset ANS[2]="N/A"
  typeset REMARK="undefined"
  typeset X=","
  typeset RETCODE="99"
  typeset STATUS="${X}${X}${ANS[2]}"
  typeset STATUS="${X}${ANS[2]}"
  typeset QUOTED="${FALSE}"
  typeset RESULT="undefined"
  typeset BGGOOD="${BGGOOD:-lightgreen}"
  typeset BGBAD="${BGBAD:-pink}"
  typeset BGNA="${BGNA:-#999999}"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

#### htmlout -X "${X}" -Q -R "${RESULT}"      -D "${DESC}"    -S "${STATUS}"
####                     -B "${VERIFIEDBY}"  -M "${REMARK}"  -C "${RETCODE}"

  while getopts ":vVu:X:R:D:B:M:C:Q" OPTION
  do
      case "${OPTION}" in
          'u') VERIFIEDBY="${OPTARG}";;
          'X') X="${OPTARG}";;
          'Q') QUOTED="${TRUE}";;
          'R') RESULT="${OPTARG}";;
          'D') DESC="${OPTARG}";;
          'B') VERIFIEDBY="${OPTARG}";;
          'M') REMARK="${OPTARG}";;
          'C') RETCODE="${OPTARG}";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_htmlout_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_htmlout_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_htmlout_zbksh ${0}" EXIT

  if [[ "_${VERIFIEDBY}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: Verified By User not specified"
    return 2
  fi

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Verified By....: ${VERIFIEDBY}"

################################################################
################################################################
################################################################

  Z="</TD>"
  X="${Z}<TD>"

  [[ "_${RESULT}" == "_${ANS[0]}" ]] && A="<TD Bgcolor=\"${BGGOOD}\" Width=\"25%\">"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && A="<TD Bgcolor=\"${BGBAD}\" Width=\"25%\">"
  [[ "_${RESULT}" == "_${ANS[2]}" ]] && A="<TD Bgcolor=\"${BGNA}\" Width=\"25%\">"

  [[ "_${RESULT}" == "_${ANS[0]}" ]] && X="${Z}<TD Bgcolor=\"${BGGOOD}\">"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && X="${Z}<TD Bgcolor=\"${BGBAD}\">"
  [[ "_${RESULT}" == "_${ANS[2]}" ]] && X="${Z}<TD Bgcolor=\"${BGNA}\">"

# Obsolete   [[ "_${RESULT}" == "_${ANS[0]}" ]] && STATUS="${ANS[0]}${X}${X}"
# Obsolete   [[ "_${RESULT}" == "_${ANS[1]}" ]] && STATUS="${X}${ANS[1]}${X}"
# Obsolete   [[ "_${RESULT}" == "_${ANS[2]}" ]] && STATUS="${X}${X}${ANS[2]}"

  [[ "_${RESULT}" == "_${ANS[0]}" ]] && STATUS="${ANS[0]}${X}"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && STATUS="${ANS[1]}${X}"
  [[ "_${RESULT}" == "_${ANS[2]}" ]] && STATUS="${X}${ANS[2]}"

  DESC=$( stdout_zbksh -- "${DESC}" | sed -e 's/$/<BR\/>/g' )
  REMARK=$( stdout_zbksh -- "${REMARK}" | sed -e 's/$/<BR\/>/g' )

  (( VERBOSE == TRUE )) && stderr_zbksh -- "# <P><TR>${A} Description ${X} Result ${X} Verified By ${X} Remarks ${X} Return Code ${Z}</TR></P>"
  stdout_zbksh -- "<P><TR>${A}${DESC}${X}${STATUS}${X}${VERIFIEDBY}${X}${REMARK}${X}${RETCODE}${Z}</TR></P>"
  RETCODE="${?}"

  return ${RETCODE}

}
################################################################
function mkheader_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset DESC="Create spreadsheet header information"
  typeset ANS[0]="Good"
  typeset ANS[1]="Bad"
  typeset ANS[2]="N/A"
  typeset OSNAME="${OSNAME:-$( execl_zbksh 'uname -s' )}"
  typeset OSVER="undefined"
  typeset RESULT="${ANS[1]}"
  typeset X=","
  typeset RETCODE="99"
  typeset RMNUM="${CHGREQNUMB:-RITM000000}"
  typeset HNAME="${SSHADDR}"
  typeset DNAME="${DOMAINNAME:-localdomain.pvt}"
  typeset LOCATION="${DCLOCATION:-Anytown}"
  typeset VMWCLUSTER=""
  typeset CSVOUT="-C"
  typeset HTMOUT=""
  typeset TGGL_HTM="${FALSE}"
  typeset TGGL_CSV="${TRUE}"

  typeset BGHEAD="${BGHEAD:-lightblue}"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vVu:X:R:h:D:L:W:H" OPTION
  do
      case "${OPTION}" in

          'R') RMNUM="${OPTARG}";;
          'h') HNAME="${OPTARG}";;
          'D') DNAME="${OPTARG}";;
          'L') LOCATION="${OPTARG}";;
          'W') VMWCLUSTER="${OPTARG}";;
          'X') X="${OPTARG}";;
          'H') HTMOUT="-H"
               CSVOUT=""
               TGGL_HTM="${TRUE}"
               TGGL_CSV="${FALSE}";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_mkheader_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_mkheader_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_mkheader_zbksh ${0}" EXIT

  if [[ "_${RMNUM}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: ${0} Change Request Number not specified"
    return 2
  fi

  if [[ "_${HNAME}" == "_" ]]
  then
        HNAME="$( hostname )"
        HNAME="${HNAME%%.*}"
  fi

  if [[ "_${DNAME}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: ${0}: Domain Name not specified"
    return 4
  fi

  if [[ "_${LOCATION}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: ${0}: Location not specified"
    return 5
  fi

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Description....: ${DESC}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# OS Name........: ${OSNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Change Request.: ${RMNUM}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Server Name....: ${HNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Domain Name....: ${DNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Location.......: ${LOCATION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# VMware Cluster.: ${VMWCLUSTER}"

################################################################
################################################################
################################################################

  RESULT="${ANS[1]}"

  if (( TGGL_CSV == TRUE ))
  then
      stdout_zbksh -- "Unix/Linux Checklist (${VERSION})"

      stdout_zbksh -- "Change Request Number${X}${RMNUM}"
      stdout_zbksh -- "Server Name${X}${HNAME}"
      stdout_zbksh -- "Domain Name${X}${DNAME}"
      stdout_zbksh -- "Location${X}${LOCATION}"
      stdout_zbksh -- "VMware Cluster (Applicable only for Red Hat Linux${X}${VMWCLUSTER}"
      stdout_zbksh -- "FQDN${X}${HNAME%%.*}.${DNAME}"

      stdout_zbksh -- ""
# Obsolete      stdout_zbksh -- "List Items:${X}Status:GOOD${X}Status:BAD${X}Status:N/A${X}Verified by:${X}Remarks:"
      stdout_zbksh -- "List Items:${X}Status:GOOD/BAD${X}Status:N/A${X}Verified by:${X}Remarks:"
  fi

  if (( TGGL_HTM == TRUE ))
  then
      X="</TH><TH Colspan=\"4\" Bgcolor=\"${BGHEAD}\">"
      stdout_zbksh -- "<HTML><BODY>"
      stdout_zbksh -- "<P><TABLE Border=\"1\">"
      stdout_zbksh -- "<P><TR><TH Colspan=\"7\" Bgcolor=\"${BGHEAD}\">Unix/Linux Checklist (${VERSION})<BR/><FONT Size=\"1\">$( date )</FONT></TH></TR></P>"

      stdout_zbksh -- "<P><TR><TH Colspan=\"3\" Bgcolor=\"${BGHEAD}\">Change Request Number${X}${RMNUM}</TH></TR></P>"
      stdout_zbksh -- "<P><TR><TH Colspan=\"3\" Bgcolor=\"${BGHEAD}\">Server Name${X}${HNAME}</TH></TR></P>"
      stdout_zbksh -- "<P><TR><TH Colspan=\"3\" Bgcolor=\"${BGHEAD}\">Domain Name${X}${DNAME}</TH></TR></P>"
      stdout_zbksh -- "<P><TR><TH Colspan=\"3\" Bgcolor=\"${BGHEAD}\">Location${X}${LOCATION}</TH></TR></P>"
      stdout_zbksh -- "<P><TR><TH Colspan=\"3\" Bgcolor=\"${BGHEAD}\">VMware Cluster (Applicable only for Red Hat Linux${X}${VMWCLUSTER}</TH></TR></P>"
      stdout_zbksh -- "<P><TR><TH Colspan=\"3\" Bgcolor=\"${BGHEAD}\">FQDN${X}${HNAME%%.*}.${DNAME}</TH></TR></P>"

      X="</TH><TH Bgcolor=\"${BGHEAD}\">"
      stdout_zbksh -- "<P><TR><TH Colspan=\"7\">&nbsp;</TH></TR></P>"
# Obsolete       stdout_zbksh -- "<P><TR><TH Bgcolor=\"${BGHEAD}\">List Items:${X}Status:GOOD${X}Status:BAD${X}Status:N/A${X}Verified by:${X}Remarks:${X}</TH></TR></P>"
      stdout_zbksh -- "<P><TR><TH Bgcolor=\"${BGHEAD}\">List Items:${X}Status:GOOD/BAD${X}Status:N/A${X}Verified by:${X}Remarks:${X}</TH></TR></P>"
  fi

################################################################
################################################################
################################################################

  RETCODE="0"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && RETCODE="1"

  return ${RETCODE}

}
################################################################
function mkfooter_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset DESC="Create spreadsheet header information"
  typeset ANS[0]="Good"
  typeset ANS[1]="Bad"
  typeset ANS[2]="N/A"
  typeset OSNAME="${OSNAME:-$( execl_zbksh 'uname -s' )}"
  typeset OSVER="undefined"
  typeset RESULT="${ANS[1]}"
  typeset X=","
  typeset RETCODE="99"
  typeset RMNUM="${CHGREQNUMB:-RITM000000}"
  typeset HNAME=""
  typeset DNAME="${DOMAINNAME:-localdomain.pvt}"
  typeset LOCATION="${DCLOCATION:-Anytown}"
  typeset VMWCLUSTER=""
  typeset CSVOUT="-C"
  typeset HTMOUT=""
  typeset TGGL_HTM="${FALSE}"
  typeset TGGL_CSV="${TRUE}"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vVu:X:R:h:D:L:W:H" OPTION
  do
      case "${OPTION}" in

          'R') RMNUM="${OPTARG}";;
          'h') HNAME="${OPTARG}";;
          'D') DNAME="${OPTARG}";;
          'L') LOCATION="${OPTARG}";;
          'W') VMWCLUSTER="${OPTARG}";;
          'X') X="${OPTARG}";;
          'H') HTMOUT="-H"
               CSVOUT=""
               TGGL_HTM="${TRUE}"
               TGGL_CSV="${FALSE}";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_mkfooter_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_mkfooter_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_mkfooter_zbksh ${0}" EXIT

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Description....: ${DESC}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# OS Name........: ${OSNAME}"

################################################################
################################################################
################################################################

  RESULT="${ANS[1]}"

  if (( TGGL_CSV == TRUE ))
  then
      stdout_zbksh -- "CSV Output Complete"
  fi

  if (( TGGL_HTM == TRUE ))
  then
      X="</TH><TH>"
      stdout_zbksh -- "</TABLE></P>"
      stdout_zbksh -- "</BODY></HTML>"
  fi

################################################################
################################################################
################################################################

  RETCODE="0"
  [[ "_${RESULT}" == "_${ANS[1]}" ]] && RETCODE="1"

  return ${RETCODE}

}
################################################################
function tablehead_zbksh {
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset DESC="undefined"
  typeset VERIFIEDBY="undefined"
  typeset ANS[0]="Good"
  typeset ANS[1]="Bad"
  typeset ANS[2]="N/A"
  typeset REMARK="undefined"
  typeset X=","
  typeset RETCODE="99"
  typeset STATUS="${X}${X}${ANS[2]}"
  typeset STATUS="${X}${ANS[2]}"
  typeset QUOTED="${FALSE}"
  typeset RESULT="undefined"
  typeset CSVOUT="-C"
  typeset HTMOUT=""
  typeset TGGL_HTM="${FALSE}"
  typeset TGGL_CSV="${TRUE}"
  typeset BGHEAD="${BGHEAD:-lightblue}"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vVu:X:R:D:B:M:C:QH" OPTION
  do
      case "${OPTION}" in
          'u') VERIFIEDBY="${OPTARG}";;
          'X') X="${OPTARG}";;
          'Q') QUOTED="${TRUE}";;
          'R') RESULT="${OPTARG}";;
          'D') DESC="${OPTARG}";;
          'B') VERIFIEDBY="${OPTARG}";;
          'M') REMARK="${OPTARG}";;
          'C') RETCODE="${OPTARG}";;
          'H') HTMOUT="-H"
               CSVOUT=""
               TGGL_HTM="${TRUE}"
               TGGL_CSV="${FALSE}";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_tablehead_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_tablehead_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_tablehead_zbksh ${0}" EXIT

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Verified By....: ${VERIFIEDBY}"

################################################################
################################################################
################################################################

  if (( TGGL_CSV == TRUE ))
  then
      stdout_zbksh -- "${REMARK}"
  fi

  if (( TGGL_HTM == TRUE ))
  then
      X="</TH><TH>"
      stdout_zbksh -- "<P><TR><TH Colspan=\"7\" Bgcolor=\"${BGHEAD}\">${REMARK}</TH></TR></P>"
  fi

  return ${RETCODE}

}
################################################################
configcmd_zbksh ()
{
  RETURNCODE="0"
  CFILE="${1}"
  
  (( VERBOSE == TRUE )) && stderr_zbksh -- "# Configuration File: ${CFILE}"
  
  if [[ -f ${CFILE} ]]
  then
      (( VERBOSE == TRUE )) && sed -e 's/^/#### /g' "${CFILE}" >&2
      . ${CFILE}
  fi
  
  return ${RETURNCODE}
}

function usagemsg_verifycmd_zbksh {
  stdout_zbksh -- ""
  stdout_zbksh -- "${1:+Program: ${1}}${2:+        Version: ${2}}"

  stdout_zbksh -- ""
  stdout_zbksh -- "Data Center Automation - "

  stdout_zbksh -- ""
  stdout_zbksh -- "Usage: ${1##*/} [-?vV] -u username"
  stdout_zbksh -- "  Where:"
  stdout_zbksh -- "    -v = Verbose mode - displays dpa_runreport function info"
  stdout_zbksh -- "    -V = Very Verbose Mode - debug output displayed"
  stdout_zbksh -- "    -u = Verified By Username"

  stdout_zbksh -- ""
  stdout_zbksh -- "Example Usage:"
  stdout_zbksh -- "    ${1} -v "

  stdout_zbksh -- ""
  stdout_zbksh -- "Author: Dana French, Copyright 2016, All Rights Reserved"
  stdout_zbksh -- ""
  stdout_zbksh -- "\"AutoContent\" enabled"
  stdout_zbksh -- "\"Multi-Shell\" enabled"
  stdout_zbksh -- ""

  return 0

}
function verifycmd_zbksh {
  if [[ "_${SHCODE}" == _korn ]]
  then
    typeset TRUE="0"
    typeset FALSE="1"
    typeset VERBOSE="${FALSE}"
    typeset VERYVERB="${FALSE}"
    typeset OPTIND="1"
    typeset NICID="undefined"
    typeset CSVOUT="-C"
    typeset HTMOUT=""
    typeset CONFIGFILE=""
    typeset HEADER="${FALSE}"
    typeset CONFIG_RETURN=""
    typeset TGGL_SEG="${FALSE}"
    typeset SEGOUT=""
    typeset TGGL_HTM="${FALSE}"
    typeset TGGL_CSV="${TRUE}"
    typeset TGGL_SAV="${FALSE}"
    typeset SAVOUT=""
    typeset TGGL_EXC="${FALSE}"
    typeset EXCOUT=""
    typeset SHOW_VGRP0="${TRUE}"	OUT_VGRP0=""
    typeset SHOW_VGRP1="${FALSE}"	OUT_VGRP1=""
    typeset SHOW_VGRP2="${FALSE}"	OUT_VGRP2=""
    typeset SHOW_VGRP3="${FALSE}"	OUT_VGRP3=""
    typeset SHOW_VGRP4="${FALSE}"	OUT_VGRP4=""
    typeset SHOW_VGRP5="${FALSE}"	OUT_VGRP5=""
    typeset SHOW_VGRP6="${FALSE}"	OUT_VGRP6=""
    typeset SHOW_VGRP7="${FALSE}"	OUT_VGRP7=""
    typeset SHOW_VGRP8="${FALSE}"	OUT_VGRP8=""
    typeset SHOW_VGRP9="${FALSE}"	OUT_VGRP9=""
  elif [[ "_${SHCODE}" == _bash ]]
  then
    declare TRUE="0"
    declare FALSE="1"
    declare VERBOSE="${FALSE}"
    declare VERYVERB="${FALSE}"
    declare OPTIND="1"
    declare NICID="undefined"
    declare CSVOUT="-C"
    declare HTMOUT=""
    declare CONFIGFILE=""
    declare HEADER="${FALSE}"
    declare CONFIG_RETURN=""
    declare TGGL_SEG="${FALSE}"
    declare SEGOUT=""
    declare TGGL_HTM="${FALSE}"
    declare TGGL_CSV="${TRUE}"
    declare TGGL_SAV="${FALSE}"
    declare SAVOUT=""
    declare TGGL_EXC="${FALSE}"
    declare EXCOUT=""
    declare SHOW_VGRP0="${TRUE}"	OUT_VGRP0=""
    declare SHOW_VGRP1="${FALSE}"	OUT_VGRP1=""
    declare SHOW_VGRP2="${FALSE}"	OUT_VGRP2=""
    declare SHOW_VGRP3="${FALSE}"	OUT_VGRP3=""
    declare SHOW_VGRP4="${FALSE}"	OUT_VGRP4=""
    declare SHOW_VGRP5="${FALSE}"	OUT_VGRP5=""
    declare SHOW_VGRP6="${FALSE}"	OUT_VGRP6=""
    declare SHOW_VGRP7="${FALSE}"	OUT_VGRP7=""
    declare SHOW_VGRP8="${FALSE}"	OUT_VGRP8=""
    declare SHOW_VGRP9="${FALSE}"	OUT_VGRP9=""
  else
    TRUE="0"
    FALSE="1"
    VERBOSE="${FALSE}"
    VERYVERB="${FALSE}"
    OPTIND="1"
    NICID="undefined"
    CSVOUT="-C"
    HTMOUT=""
    CONFIGFILE=""
    HEADER="${FALSE}"
    CONFIG_RETURN=""
    TGGL_SEG="${FALSE}"
    SEGOUT=""
    TGGL_HTM="${FALSE}"
    TGGL_CSV="${TRUE}"
    TGGL_SAV="${FALSE}"
    SAVOUT=""
    TGGL_EXC="${FALSE}"
    EXCOUT=""
    SHOW_VGRP0="${TRUE}"	OUT_VGRP0=""
    SHOW_VGRP1="${FALSE}"	OUT_VGRP1=""
    SHOW_VGRP2="${FALSE}"	OUT_VGRP2=""
    SHOW_VGRP3="${FALSE}"	OUT_VGRP3=""
    SHOW_VGRP4="${FALSE}"	OUT_VGRP4=""
    SHOW_VGRP5="${FALSE}"	OUT_VGRP5=""
    SHOW_VGRP6="${FALSE}"	OUT_VGRP6=""
    SHOW_VGRP7="${FALSE}"	OUT_VGRP7=""
    SHOW_VGRP8="${FALSE}"	OUT_VGRP8=""
    SHOW_VGRP9="${FALSE}"	OUT_VGRP9=""
  fi
################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vVb:n:X:c:QHS0123456789Ero" OPTION
  do
      case "${OPTION}" in
          'b') VERIFIEDBY="${OPTARG}";;
          'n') NICID="${OPTARG}";;
          'X') X="${OPTARG}";;
          'c') CONFIGFILE="${OPTARG}";;
          'r') TGGL_SAV="${TRUE}"
               SAVOUT="-r";;
          'Q') QUOTED="${TRUE}";;
          'H') HTMOUT="-H"
               CSVOUT=""
               TGGL_HTM="${TRUE}"
               TGGL_CSV="${FALSE}";;
          'S') TGGL_SEG="${TRUE}"
               SEGOUT="-S";;
          'E') TGGL_EXC="${TRUE}"
               EXCOUT="-E";;
          '0') SHOW_VGRP0="${TRUE}"
               OUT_VGRP0="-0";;
          '1') SHOW_VGRP1="${TRUE}"
               OUT_VGRP1="-1";;
          '2') SHOW_VGRP2="${TRUE}"
               OUT_VGRP2="-2";;
          '3') SHOW_VGRP3="${TRUE}"
               OUT_VGRP3="-3";;
          '4') SHOW_VGRP4="${TRUE}"
               OUT_VGRP4="-4";;
          '5') SHOW_VGRP5="${TRUE}"
               OUT_VGRP5="-5";;
          '6') SHOW_VGRP6="${TRUE}"
               OUT_VGRP6="-6";;
          '7') SHOW_VGRP7="${TRUE}"
               OUT_VGRP7="-7";;
          '8') SHOW_VGRP8="${TRUE}"
               OUT_VGRP8="-8";;
          '9') SHOW_VGRP9="${TRUE}"
               OUT_VGRP9="-9";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_verifycmd_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_verifycmd_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_verifycmd_zbksh ${0}" EXIT

      if [[ "_${VERIFIEDBY}" == "_" ]]
      then
          stderr_zbksh -- "# ERROR: Verified By User not specified"
          return 2
      fi

      if [[ "_${CONFIGFILE}" == "_" ]]
      then
          stderr_zbksh -- "# ERROR: Configuration file not specified"
          return 3
      fi

      if [[ ! -s ${CONFIGFILE} ]]
      then
          stderr_zbksh -- "# ERROR: Configuration file \"${CONFIGFILE}\" does not exist or is empty"
          return 4
      fi

      if (( SHOW_VGRP1 == TRUE )) ||
         (( SHOW_VGRP2 == TRUE )) ||
         (( SHOW_VGRP3 == TRUE )) ||
         (( SHOW_VGRP4 == TRUE )) ||
         (( SHOW_VGRP5 == TRUE )) ||
         (( SHOW_VGRP6 == TRUE )) ||
         (( SHOW_VGRP7 == TRUE )) ||
         (( SHOW_VGRP8 == TRUE )) ||
         (( SHOW_VGRP9 == TRUE ))
      then
          SHOW_VGRP0="${FALSE}"
          OUT_VGRP0=""
      fi

  trap "-" EXIT
  
################################################################

    unset OSCMD

    OSNAME="${OSNAME:-$( execl_zbksh 'uname -s' )}"
    ITEM_VGRP1="${FALSE}"
    ITEM_VGRP2="${FALSE}"
    ITEM_VGRP3="${FALSE}"
    ITEM_VGRP4="${FALSE}"
    ITEM_VGRP5="${FALSE}"
    ITEM_VGRP7="${FALSE}"
    ITEM_VGRP8="${FALSE}"
    ITEM_VGRP9="${FALSE}"

  if ! configcmd_zbksh "${CONFIGFILE}"
  then
      return 0
  fi

# obsolete  [[ "_${OSNAME}" == _CYGWIN* ]] && OSNAME="Cygwin"

################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program........: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version........: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Description....: ${DESC}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Verified By....: ${VERIFIEDBY}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# OS Name........: ${OSNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# HTML Output....: ${HTMOUT}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Config File....: ${CONFIGFILE}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Header ConfFile: ${HEADER}"

  (( VERBOSE  == TRUE )) && (( TGGL_SEG == TRUE  )) && stderr_zbksh -- "# Segmented/Categorized.: TRUE"
  (( VERBOSE  == TRUE )) && (( TGGL_SEG == FALSE )) && stderr_zbksh -- "# Segmented/Categorized.: FALSE"

  (( VERBOSE  == TRUE )) && (( TGGL_EXC == TRUE  )) && stderr_zbksh -- "# Exclude Verify Groups.: TRUE"
  (( VERBOSE  == TRUE )) && (( TGGL_EXC == FALSE )) && stderr_zbksh -- "# Exclude Verify Groups.: FALSE"

  (( VERBOSE  == TRUE )) && (( TGGL_DISPLAYNA == TRUE  )) && stderr_zbksh -- "# Display N/A Records...: TRUE"
  (( VERBOSE  == TRUE )) && (( TGGL_DISPLAYNA == FALSE )) && stderr_zbksh -- "# Display N/A Records...: FALSE"

  (( VERBOSE  == TRUE )) && (( SHOW_VGRP0 == TRUE  )) && stderr_zbksh -- "# Verification Group 0.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP0 == FALSE )) && stderr_zbksh -- "# Verification Group 0.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP1 == TRUE  )) && stderr_zbksh -- "# Verification Group 1.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP1 == FALSE )) && stderr_zbksh -- "# Verification Group 1.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP2 == TRUE  )) && stderr_zbksh -- "# Verification Group 2.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP2 == FALSE )) && stderr_zbksh -- "# Verification Group 2.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP3 == TRUE  )) && stderr_zbksh -- "# Verification Group 3.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP3 == FALSE )) && stderr_zbksh -- "# Verification Group 3.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP4 == TRUE  )) && stderr_zbksh -- "# Verification Group 4.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP4 == FALSE )) && stderr_zbksh -- "# Verification Group 4.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP5 == TRUE  )) && stderr_zbksh -- "# Verification Group 5.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP5 == FALSE )) && stderr_zbksh -- "# Verification Group 5.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP6 == TRUE  )) && stderr_zbksh -- "# Verification Group 6.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP6 == FALSE )) && stderr_zbksh -- "# Verification Group 6.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP7 == TRUE  )) && stderr_zbksh -- "# Verification Group 7.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP7 == FALSE )) && stderr_zbksh -- "# Verification Group 7.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP8 == TRUE  )) && stderr_zbksh -- "# Verification Group 8.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP8 == FALSE )) && stderr_zbksh -- "# Verification Group 8.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP9 == TRUE  )) && stderr_zbksh -- "# Verification Group 9.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP9 == FALSE )) && stderr_zbksh -- "# Verification Group 9.: FALSE"

################################################################

  if (( TGGL_SEG == TRUE  )) &&
     (( HEADER   == TRUE  ))
  then
      if (( TGGL_HTM == TRUE ))
      then
          tablehead_zbksh -H -M "" 
          tablehead_zbksh -H -M "${DESC}"
      else
          tablehead_zbksh -M "" 
          tablehead_zbksh -M "${DESC}"
      fi
      HEADER="${FALSE}"
      return 0
  elif (( TGGL_SEG == FALSE )) &&
       (( HEADER   == TRUE  ))
  then
      HEADER="${FALSE}"
      return 0
  fi

#### If the verification groups are to be EXCLUDED (CLI: -E) then first include all items:
  (( TGGL_EXC == TRUE  )) && SHOW_VGRP0="${TRUE}"

#### If the verification groups are to be EXCLUDED (CLI: -E) and there is a verification
#### item match, then do not process the item, simply return a successful return code:

  if ( (( SHOW_VGRP1 == TRUE )) && (( ITEM_VGRP1 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP2 == TRUE )) && (( ITEM_VGRP2 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP3 == TRUE )) && (( ITEM_VGRP3 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP4 == TRUE )) && (( ITEM_VGRP4 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP5 == TRUE )) && (( ITEM_VGRP5 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP6 == TRUE )) && (( ITEM_VGRP6 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP7 == TRUE )) && (( ITEM_VGRP7 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP8 == TRUE )) && (( ITEM_VGRP8 == TRUE )) && (( TGGL_EXC == TRUE )) ) ||
     ( (( SHOW_VGRP9 == TRUE )) && (( ITEM_VGRP9 == TRUE )) && (( TGGL_EXC == TRUE )) )
  then

      return 0

#### If ALL items are INCLUDED or a verification group is INCLUDED, and there is a 
#### verification item match, then process it and show it in the output:

  elif (( SHOW_VGRP0 == TRUE )) ||
     ( (( SHOW_VGRP1 == TRUE )) && (( ITEM_VGRP1 == TRUE )) ) ||
     ( (( SHOW_VGRP2 == TRUE )) && (( ITEM_VGRP2 == TRUE )) ) ||
     ( (( SHOW_VGRP3 == TRUE )) && (( ITEM_VGRP3 == TRUE )) ) ||
     ( (( SHOW_VGRP4 == TRUE )) && (( ITEM_VGRP4 == TRUE )) ) ||
     ( (( SHOW_VGRP5 == TRUE )) && (( ITEM_VGRP5 == TRUE )) ) ||
     ( (( SHOW_VGRP6 == TRUE )) && (( ITEM_VGRP6 == TRUE )) ) ||
     ( (( SHOW_VGRP7 == TRUE )) && (( ITEM_VGRP7 == TRUE )) ) ||
     ( (( SHOW_VGRP8 == TRUE )) && (( ITEM_VGRP8 == TRUE )) ) ||
     ( (( SHOW_VGRP9 == TRUE )) && (( ITEM_VGRP9 == TRUE )) )
  then

      RESULT="${ANS[1]}"
      REMARK=$( execl_zbksh "${OSCMD:-echo \"${OSNAME} Commands Undefined\"; ! : }" )
      RETCODE="${?}"
      [[ "_${CONFIG_RETURN}" != "_" ]] && [[ "_${CONFIG_RETURN}" == _[012] ]] && RETCODE="${CONFIG_RETURN}"
      [[ "_${RETCODE}" != _[012] ]] && RETCODE="1"
      RESULT="${ANS[${RETCODE}]}"

      if (( RETCODE == 2 )) &&
         [[ "_${TGGL_DISPLAYNA}" == "_${FALSE}" ]]
      then

          (( VERBOSE == TRUE )) && stderr_zbksh -- "# Command is N/A"

      else

          (( TGGL_CSV == TRUE )) && DESC="${DESC}"$'\n'"(${CONFIGFILE##*/})"
          (( TGGL_HTM == TRUE )) && DESC="${DESC}"$'\n'"<FONT Size=\"1\">(${CONFIGFILE##*/})</FONT>"

          (( TGGL_CSV == TRUE )) && csvout_zbksh  -X "${X}" -Q -R "${RESULT}" -D "${DESC}" -B "${VERIFIEDBY}" -M "${REMARK:-${OSCMD}}" -C "${RETCODE}"
          (( TGGL_HTM == TRUE )) && htmlout_zbksh -X "${X}" -Q -R "${RESULT}" -D "${DESC}" -B "${VERIFIEDBY}" -M "${REMARK:-${OSCMD}}" -C "${RETCODE}"

          RSLTFILE="${CONFFILE%.conf}.results"
          RSLTFILE="${RSLTDIR}/${RSLTFILE##*/}"
          if (( TGGL_SAV == TRUE ))
          then
              stdout_zbksh -- "${REMARK}" > "${RSLTFILE}"
          else
              [[ -f "${RSLTFILE}" ]] && rm -f "${RSLTFILE}"
          fi
      fi

#### Otherwise return a successful return code:

  else
      return 0
  fi

  return ${RETCODE}

}
#!/usr/bin/ksh93
#!/bin/bash
#!/bin/zsh
#!/usr/bin/ksh93.att
#!/bin/ksh93
################################################################
#### 
#### This script will run in KornShell93, Zshell, or Bash, all you need to do 
#### is put the desired "shebang" line at the top of the script.
#### 
################################################################
function usagemsg_checklist_zbksh {
  stderr_zbksh -- ""
  stderr_zbksh -- "${1:+Function: ${1}}${2:+        Version: ${2}}"

  stderr_zbksh -- ""
  stderr_zbksh -- "Data Center Automation - Unix/Linux Checklist"

  stderr_zbksh -- ""
  stderr_zbksh -- "This set of scripts provides an automated procedure to perform a"
  stderr_zbksh -- "post-install verification of any Unix system in the data center environment."
  stderr_zbksh -- "These scripts are written in a \"Multi-Shell\" configuration, meaning they"
  stderr_zbksh -- "can be executed by several different interpreters, including Korn Shell"
  stderr_zbksh -- "93, Bash, and Z-Shell."

  stderr_zbksh -- ""
  stderr_zbksh -- "Usage: ${1##*/} [-?vV] -b username [-R RequestNum]"
  stderr_zbksh -- "        [-h sshHostname] [-p sshPortNum] [-u sshuser] [-O OSNAME]"
  stderr_zbksh -- "        [-D domainName] [-L locationName] [-W clusterName]"
  stderr_zbksh -- "        [-X \",\"] [-H] [-S] [-E] [-0123456789]"

  stderr_zbksh -- "  Where:"
  stderr_zbksh -- "    -v = Verbose mode - displays dpa_runreport function info"
  stderr_zbksh -- "    -V = Very Verbose Mode - debug output displayed"
  stderr_zbksh -- "    -b = Verified By Username"
  stderr_zbksh -- "    -u = SSH Username\t\t\t(Default:root)"
  stderr_zbksh -- "    -p = SSH Port number\t\t(Default:22)"
  stderr_zbksh -- "    -h = SSH Hostname or IP address\t(Default:HOSTNAME)"
  stderr_zbksh -- "    -O = Remote OS Name (Default:dynamically determined)"
  stderr_zbksh -- "    -r = Save results from each verification check\t(Default:FALSE)"
  stderr_zbksh -- "    -o = Output directory location for storage of results\t(Default:CONFDIR)"
  stderr_zbksh -- "    -R = Change Request Number\t\t\t(Default:${CHGREQNUMB:-RITM000000})"
  stderr_zbksh -- "    -D = DNS Domain Name\t\t(Default:${DOMAINNAME:-localdomain.pvt})"
  stderr_zbksh -- "    -L = Data Center Location\t\t(Default:${DCLOCATION:-Anytown})"
  stderr_zbksh -- "    -W = VMware Cluster Name\t\t(Default:N/A)"
  stderr_zbksh -- "    -H = Generate HTML output\t\t(Default:CSV)"
  stderr_zbksh -- "    -X = Field Delimiter\t\t(Default:\",\")"
  stderr_zbksh -- "    -S = Segmented and Categorized Output\t\t(Default:\"Alphabetized\")"
  stderr_zbksh -- "    -N = Display configuration items marked N/A in Output\t\t(Default:\"FALSE\")"

  stderr_zbksh -- "    -0 = Include/Exclude ALL Verification Items:\t\t(Default:Include)"
  stderr_zbksh -- "    -1 = Include/Exclude Non-PCI Verification Group 1:\t\t(Default:Include)"
  stderr_zbksh -- "    -2 = Include/Exclude PCI Verification Group 2:\t\t(Default:Include)"
  stderr_zbksh -- "    -3 = Include/Exclude High-Availability Group 3:\t(Default:Include)"
  stderr_zbksh -- "    -4 = Include/Exclude Database Verification Group 4:\t\t(Default:Include)"
  stderr_zbksh -- "    -5 = Include/Exclude Backup Verification Group 5:\t(Default:Include)"
  stderr_zbksh -- "    -6 = Include/Exclude Verification Group 6:\t\t\t(Default:Include)"
  stderr_zbksh -- "    -7 = Include/Exclude Verification Group 7:\t\t\t(Default:Include)"
  stderr_zbksh -- "    -8 = Include/Exclude Verification Group 8:\t\t\t(Default:Include)"
  stderr_zbksh -- "    -9 = Include/Exclude Verification Group 9:\t\t\t(Default:Include)"

  stderr_zbksh -- ""
  stderr_zbksh -- "    -E = Exclude Identified Verification Groups\t\t\t(Default:Include)"
  stderr_zbksh -- "         This option reverses the logic of the Verification Groups."
  stderr_zbksh -- "         Those Groups Identified on the command line are EXCLUDED."
  stderr_zbksh -- ""

  stderr_zbksh -- ""
  stderr_zbksh -- "Example Usage:"
  stderr_zbksh -- "    ${1} -L \"Anytown\" -R \"RITM1234567\" -b username -h localhost -H > tmp.html"

  stderr_zbksh -- ""
  stderr_zbksh -- "Author: Dana French, Copyright 2016, All Rights Reserved"
  stderr_zbksh -- ""
  stderr_zbksh -- "\"AutoContent\" enabled (Grutatxt)"
  stderr_zbksh -- "\"Multi-Shell\" enabled"
  stderr_zbksh -- "\"LocalRemote\" enabled"
  stderr_zbksh -- ""

  return 0

}
################################################################
#### 
#### Description:
#### 
#### This set of scripts provides an automated procedure to perform a
#### post-install verification of any Unix/Linux system in the data center
#### environment. These scripts are written in a "Multi-Shell" configuration,
#### meaning they can be executed by several different interpreters,
#### including Korn Shell 93, Bash, and Z-Shell. This scripts are also written
#### so it can be executed on the local system or remotely using SSH.
#### 
#### 
#### Assumptions:
#### 
#### Remote operation assumes the SSH keys have been exchanged for
#### password-less execution.
#### 
#### 
#### Dependencies:
#### 
#### Products:
#### 
#### A log file for each execution of the script and each command executed by
#### the script, is generated at: /tmp/execl_<PID>.cmd where <PID> is the
#### process ID number of the checklist script execution.
#### 
#### 
#### Configured Usage:
#### 
#### This script has a configuration file named .checklist.conf that is
#### expected to exist in the directory identified by the CONFDIR variable or
#### in the home directory of the user running the checklist script. See the
#### configuration file for details regarding settings and options.
#### 
####     ~/.checklist.conf		1st
####     ${CONFDIR}/.checklist.conf	2nd
#### 
#### 
#### Details:
#### 
################################################################
function trap_checklist_zbksh {
  stderr_zbksh -- "# INFO: key trapped and ignored during critical phase"
  return 0
}
################################################################
####
#### Function to read the program configuration file. 
####

configure_checklist_zbksh()
{

#### Set some HTML table variables that are required regardless of whether or
#### not the configuration file exists.

  BGHEAD="lightblue"
  BGGOOD="lightgreen"
  BGBAD="pink"
  BGNA="#999999"
  BGNA="lightgrey"
  CFILE=""

#### First test for a checklist configuration file in the current users home directory.

  if [[ -f ~/.checklist.conf ]]
  then
      CFILE=~/.checklist.conf

#### Next test for a checklist configuration file in the ${CONFDIR} directory.

  elif [[ -f "${CONFDIR}/.checklist.conf" ]]
  then
      CFILE="${CONFDIR}/.checklist.conf"
  fi

#### If  a configuration file exists, execute it as a "dot" script in the
#### current environment.

  if [[ "_${CFILE}" != "_" ]] &&
     [[ -f "${CFILE}"      ]]
  then
      (( VERBOSE == TRUE )) && stderr_zbksh -- "# Configuration File: ${CFILE}"
      (( VERBOSE == TRUE )) && cat ${CFILE}
      . ${CFILE}
  fi

  return 0
}
################################################################
function checklist_zbksh {
if [[ "_${SHCODE}" == _korn ]]
then
  typeset VERSION="3.2"
  typeset TRUE="0"
  typeset FALSE="1"
  typeset VERBOSE="${FALSE}"
  typeset VERYVERB="${FALSE}"
  typeset OPTIND="1"
  typeset VERIFIEDBY=""
  typeset X=","
  typeset RMNUM="${CHGREQNUMB:-RITM000000}"
  typeset HNAME="${SSHADDR}"
  typeset DNAME="${DOMAINNAME:-localdomain.pvt}"
  typeset LOCATION="${DCLOCATION:-Anytown}"
  typeset VMWCLUSTER="N/A"
  typeset CSVOUT="-C"
  typeset HTMOUT=""
  typeset TGGL_SEG="${FALSE}"
  typeset SEGOUT=""
  typeset TGGL_SAV="${FALSE}"
  typeset SAVOUT=""
  typeset TGGL_EXC="${FALSE}"
  typeset EXCOUT=""
  typeset SHOW_VGRP0="${TRUE}"		OUT_VGRP0=""
  typeset SHOW_VGRP1="${FALSE}"		OUT_VGRP1=""
  typeset SHOW_VGRP2="${FALSE}"		OUT_VGRP2=""
  typeset SHOW_VGRP3="${FALSE}"		OUT_VGRP3=""
  typeset SHOW_VGRP4="${FALSE}"		OUT_VGRP4=""
  typeset SHOW_VGRP5="${FALSE}"		OUT_VGRP5=""
  typeset SHOW_VGRP6="${FALSE}"		OUT_VGRP6=""
  typeset SHOW_VGRP7="${FALSE}"		OUT_VGRP7=""
  typeset SHOW_VGRP8="${FALSE}"		OUT_VGRP8=""
  typeset SHOW_VGRP9="${FALSE}"		OUT_VGRP9=""
elif [[ "_${SHCODE}" == _bash ]]
then
  declare VERSION="3.2"
  declare TRUE="0"
  declare FALSE="1"
  declare VERBOSE="${FALSE}"
  declare VERYVERB="${FALSE}"
  declare OPTIND="1"
  declare VERIFIEDBY=""
  declare X=","
  declare RMNUM="${CHGREQNUMB:-RITM000000}"
  declare HNAME="${SSHADDR}"
  declare DNAME="${DOMAINNAME:-localdomain.pvt}"
  declare LOCATION="${DCLOCATION:-Anytown}"
  declare VMWCLUSTER="N/A"
  declare CSVOUT="-C"
  declare HTMOUT=""
  declare TGGL_SEG="${FALSE}"
  declare SEGOUT=""
  declare TGGL_SAV="${FALSE}"
  declare SAVOUT=""
  declare TGGL_EXC="${FALSE}"
  declare EXCOUT=""
  declare SHOW_VGRP0="${TRUE}"	OUT_VGRP0=""
  declare SHOW_VGRP1="${FALSE}"	OUT_VGRP1=""
  declare SHOW_VGRP2="${FALSE}"	OUT_VGRP2=""
  declare SHOW_VGRP3="${FALSE}"	OUT_VGRP3=""
  declare SHOW_VGRP4="${FALSE}"	OUT_VGRP4=""
  declare SHOW_VGRP5="${FALSE}"	OUT_VGRP5=""
  declare SHOW_VGRP6="${FALSE}"	OUT_VGRP6=""
  declare SHOW_VGRP7="${FALSE}"	OUT_VGRP7=""
  declare SHOW_VGRP8="${FALSE}"	OUT_VGRP8=""
  declare SHOW_VGRP9="${FALSE}"	OUT_VGRP9=""
else
  VERSION="3.2"
  TRUE="0"
  FALSE="1"
  VERBOSE="${FALSE}"
  VERYVERB="${FALSE}"
  OPTIND="1"
  VERIFIEDBY=""
  X=","
  RMNUM="${CHGREQNUMB:-RITM000000}"
  HNAME="${SSHADDR}"
  DNAME="${DOMAINNAME:-localdomain.pvt}"
  LOCATION="${DCLOCATION:-Anytown}"
  VMWCLUSTER="N/A"
  CSVOUT="-C"
  HTMOUT=""
  TGGL_SEG="${FALSE}"
  SEGOUT=""
  TGGL_SAV="${FALSE}"
  SAVOUT=""
  TGGL_EXC="${FALSE}"
  EXCOUT=""
  SHOW_VGRP0="${TRUE}"	OUT_VGRP0=""
  SHOW_VGRP1="${FALSE}"	OUT_VGRP1=""
  SHOW_VGRP2="${FALSE}"	OUT_VGRP2=""
  SHOW_VGRP3="${FALSE}"	OUT_VGRP3=""
  SHOW_VGRP4="${FALSE}"	OUT_VGRP4=""
  SHOW_VGRP5="${FALSE}"	OUT_VGRP5=""
  SHOW_VGRP6="${FALSE}"	OUT_VGRP6=""
  SHOW_VGRP7="${FALSE}"	OUT_VGRP7=""
  SHOW_VGRP8="${FALSE}"	OUT_VGRP8=""
  SHOW_VGRP9="${FALSE}"	OUT_VGRP9=""
fi

################################################################

configure_checklist_zbksh

DNAME="${DOMAINNAME:-localdomain.pvt}"
LOCATION="${DCLOCATION:-Anytown}"
RMNUM="${CHGREQNUMB:-RITM000000}"

################################################################

#### 
#### Process the command line options and arguments, saving
#### the values as appropriate.
#### 

  while getopts ":vVb:X:u:p:h:R:D:L:W:O:HSN0123456789Ero" OPTION
  do
      case "${OPTION}" in
          'b') VERIFIEDBY="${OPTARG}";;
          'X') X="${OPTARG}";;
          'u') SSHUSER="${OPTARG}";;
          'p') SSHPORT="${OPTARG}";;
          'O') OSNAME="${OPTARG}";;
          'h') HNAME="${OPTARG}"
               SSHADDR="${OPTARG}";;
          'r') TGGL_SAV="${TRUE}"
               SAVOUT="-r";;
          'o') RSLTDIR="${OPTARG}";;
          'R') RMNUM="${OPTARG}";;
          'D') DNAME="${OPTARG}";;
          'L') LOCATION="${OPTARG}";;
          'W') VMWCLUSTER="${OPTARG}";;
          'H') HTMOUT="-H"
               CSVOUT="";;
          'S') TGGL_SEG="${TRUE}"
               SEGOUT="-S";;
          'E') TGGL_EXC="${TRUE}"
               EXCOUT="-E";;
          'N') TGGL_DISPLAYNA="${TRUE}";;
          '0') SHOW_VGRP0="${TRUE}"
               OUT_VGRP0="-0";;
          '1') SHOW_VGRP1="${TRUE}"
               OUT_VGRP1="-1";;
          '2') SHOW_VGRP2="${TRUE}"
               OUT_VGRP2="-2";;
          '3') SHOW_VGRP3="${TRUE}"
               OUT_VGRP3="-3";;
          '4') SHOW_VGRP4="${TRUE}"
               OUT_VGRP4="-4";;
          '5') SHOW_VGRP5="${TRUE}"
               OUT_VGRP5="-5";;
          '6') SHOW_VGRP6="${TRUE}"
               OUT_VGRP6="-6";;
          '7') SHOW_VGRP7="${TRUE}"
               OUT_VGRP7="-7";;
          '8') SHOW_VGRP8="${TRUE}"
               OUT_VGRP8="-8";;
          '9') SHOW_VGRP9="${TRUE}"
               OUT_VGRP9="-9";;
          'v') VERBOSE="${TRUE}";;
          'V') VERYVERB="${TRUE}";;
          '?') usagemsg_checklist_zbksh "${0}" ${VERSION} && return 1 ;;
          ':') usagemsg_checklist_zbksh "${0}" ${VERSION} && return 1 ;;
      esac
  done
   
  shift $(( ${OPTIND} - 1 ))
  
################################################################
#### 
#### Check the command line arguments to verify they are valid values and that all
#### necessary information was specified.
#### 

  trap "usagemsg_checklist_zbksh ${0}" EXIT

  if [[ "_${VERIFIEDBY}" == "_" ]]
  then
      stderr_zbksh -- "# ERROR: ${0}: Verified By Username not specified"
      return 6
  fi

#   if [[ "_${SSHADDR}" == "_" ]]
#   then
#       stderr_zbksh -- "# ERROR: ${0}: Hostname or IP address of target system not specified"
#       return 7
#   fi

  if [[ "_${RMNUM}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: ${0} Change Request Number not specified"
    return 2
  fi

#   if [[ "_${HNAME}" == "_" ]]
#   then
#     stderr_zbksh -- "# ERROR: ${0}: Server Name not specified"
#     return 3
#   fi

  if [[ "_${DNAME}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: ${0}: Domain Name not specified"
    return 4
  fi

  if [[ "_${LOCATION}" == "_" ]]
  then
    stderr_zbksh -- "# ERROR: ${0}: Location not specified"
    return 5
  fi

  trap "-" EXIT
  
################################################################

#### 
#### Display some program info and the command line arguments specified
#### if "VERBOSE" mode was specified.
#### 

  (( VERYVERB == TRUE )) && set -x
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Program...............: ${0}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Version...............: ${VERSION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Verified By User Name.: ${VERIFIEDBY}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Field Delimeter.......: ${X}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# EXEC Mode.............: ${EXECMODE}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Change Request Number.: ${RMNUM}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Server Name...........: ${HNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# SSH Address...........: ${SSHADDR}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Target OSNAME.........: ${OSNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Domain Name...........: ${DNAME}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# Location..............: ${LOCATION}"
  (( VERBOSE  == TRUE )) && stderr_zbksh -- "# VMware Cluster........: ${VMWCLUSTER}"

  (( VERBOSE  == TRUE )) && (( TGGL_SEG == TRUE  )) && stderr_zbksh -- "# Segmented/Categorized.: TRUE"
  (( VERBOSE  == TRUE )) && (( TGGL_SEG == FALSE )) && stderr_zbksh -- "# Segmented/Categorized.: FALSE"

  (( VERBOSE  == TRUE )) && (( TGGL_EXC == TRUE  )) && stderr_zbksh -- "# Exclude Verify Groups.: TRUE"
  (( VERBOSE  == TRUE )) && (( TGGL_EXC == FALSE )) && stderr_zbksh -- "# Exclude Verify Groups.: FALSE"

  (( VERBOSE  == TRUE )) && (( TGGL_DISPLAYNA == TRUE  )) && stderr_zbksh -- "# Display N/A Records...: TRUE"
  (( VERBOSE  == TRUE )) && (( TGGL_DISPLAYNA == FALSE )) && stderr_zbksh -- "# Display N/A Records...: FALSE"

  (( VERBOSE  == TRUE )) && (( SHOW_VGRP0 == TRUE  )) && stderr_zbksh -- "# Verification Group 0.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP0 == FALSE )) && stderr_zbksh -- "# Verification Group 0.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP1 == TRUE  )) && stderr_zbksh -- "# Verification Group 1.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP1 == FALSE )) && stderr_zbksh -- "# Verification Group 1.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP2 == TRUE  )) && stderr_zbksh -- "# Verification Group 2.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP2 == FALSE )) && stderr_zbksh -- "# Verification Group 2.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP3 == TRUE  )) && stderr_zbksh -- "# Verification Group 3.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP3 == FALSE )) && stderr_zbksh -- "# Verification Group 3.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP4 == TRUE  )) && stderr_zbksh -- "# Verification Group 4.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP4 == FALSE )) && stderr_zbksh -- "# Verification Group 4.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP5 == TRUE  )) && stderr_zbksh -- "# Verification Group 5.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP5 == FALSE )) && stderr_zbksh -- "# Verification Group 5.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP6 == TRUE  )) && stderr_zbksh -- "# Verification Group 6.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP6 == FALSE )) && stderr_zbksh -- "# Verification Group 6.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP7 == TRUE  )) && stderr_zbksh -- "# Verification Group 7.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP7 == FALSE )) && stderr_zbksh -- "# Verification Group 7.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP8 == TRUE  )) && stderr_zbksh -- "# Verification Group 8.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP8 == FALSE )) && stderr_zbksh -- "# Verification Group 8.: FALSE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP9 == TRUE  )) && stderr_zbksh -- "# Verification Group 9.: TRUE"
  (( VERBOSE  == TRUE )) && (( SHOW_VGRP9 == FALSE )) && stderr_zbksh -- "# Verification Group 9.: FALSE"

################################################################
################################################################
################################################################
#### 
#### Display the table header information according to the user specified
#### output method (CSV or HTML).
#### 

  unset VERBSTAT
  (( VERBOSE == TRUE )) && VERBSTAT="${TRUE}"

  mkheader_zbksh	${VERBSTAT:+ -v} -X "${X}" -R "${RMNUM}" ${HNAME:+-h ${HNAME}} -D "${DNAME}" -L "${LOCATION}" -W "${VMWCLUSTER}"  ${HTMOUT}

################################################################
################################################################
################################################################
#### 
#### Loop thru each configuration file, processing the appropriate operating
#### system command and capturing the success or failure status. Then 
#### display the output according to the user specified method (CSV or HTML).
#### 

    typeset CUSTCONFS=( $( ls -1 ${CONFDIR}/.*.conf 2>/dev/null | grep -v '\.checklist\.conf' ) )

    if [[ "_${#CUSTCONFS[@]}" == _[0-9]* ]] &&
       ((   ${#CUSTCONFS[@]}  >    0     ))
    then

        for CONFFILE in "${CUSTCONFS[@]}"
        do
            verifycmd_zbksh ${VERBSTAT:+ -v} -X "${X}" -b ${VERIFIEDBY} -Q -c "${CONFFILE}"  ${HTMOUT} ${SEGOUT} ${EXCOUT} ${SAVOUT} ${OUT_VGRP0} ${OUT_VGRP1} ${OUT_VGRP2} ${OUT_VGRP3} ${OUT_VGRP4} ${OUT_VGRP5} ${OUT_VGRP6} ${OUT_VGRP7} ${OUT_VGRP8} ${OUT_VGRP9}
        done
    fi

################################################################
################################################################
################################################################
#### 
#### Display the table footer information according to the user specified
#### output method (CSV or HTML).
#### 

  mkfooter_zbksh		${VERBSTAT:+ -v} -X "${X}"  ${HTMOUT}

  return 0

}

################################################################
################################################################
################################################################
#### 
#### Main Body of Script Begins Here
#### 
################################################################

FPATH="/usr/local/scripts/checklist-3.2"
export FPATH

CONFDIR="/usr/local/scripts/checklist-3.2"
RSLTDIR="${CONFDIR}"
export CONFDIR RSLTDIR

TRUE="0"
FALSE="1"

typeset OSCMD

#### 
#### Extract the "shebang" line from the beginning of the script.

read SHEBANG < "${0}"
export SHEBANG

if [[ "_${SHEBANG}" != "_#!"* ]]
then
    stderr_zbksh -- "# ERROR: SHEBANG line not specified at the beginning of script"
    exit 1
fi

#### 
#### Test the "shebang" line to determine what shell interpreter is specified.

SHCODE="unknown"
[[ "_${SHEBANG}" == _*/ksh*  ]] && SHCODE="korn"
[[ "_${SHEBANG}" == _*/bash* ]] && SHCODE="bash"
[[ "_${SHEBANG}" == _*/zsh*  ]] && SHCODE="zshell"
export SHCODE

################################################################
#### Modify the commands and script according to the shell intpreter.
#### 

if [[ "_${SHCODE}" == _korn ]]
then
  typeset GBL_ECHO="print"
#  typeset SSHPORT="22"
#  typeset SSHUSER="root"
#  typeset SSHADDR=""
#  typeset CMD_SSH="/usr/bin/ssh"
#  typeset OPT_SSH="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -o BatchMode=yes -o ConnectTimeout=30"
 typeset LOG_EXECL="/tmp/execl_${$}.cmd"
elif [[ "_${SHCODE}" == _bash ]]
then
  shopt -s extglob    # Turn on extended globbing
  declare GBL_ECHO="echo -e"
#  declare SSHPORT="22"
#  declare SSHUSER="root"
#  declare SSHADDR=""
#  declare CMD_SSH="/usr/bin/ssh"
#  declare OPT_SSH="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -o BatchMode=yes -o ConnectTimeout=30"
  declare LOG_EXECL="/tmp/execl_${$}.cmd"
elif [[ "_${SHCODE}" == _zshell ]]
then
  emulate ksh93
  typeset GBL_ECHO="print"
#  typeset SSHPORT="22"
#  typeset SSHUSER="root"
#  typeset SSHADDR=""
#  typeset CMD_SSH="/usr/bin/ssh"
#  typeset OPT_SSH="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -o BatchMode=yes -o ConnectTimeout=30"
  typeset LOG_EXECL="/tmp/execl_${$}.cmd"
else
  GBL_ECHO="echo -e"
#  SSHPORT="22"
#  SSHUSER="root"
#  SSHADDR=""
#  CMD_SSH="/usr/bin/ssh"
#  OPT_SSH="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -o BatchMode=yes -o ConnectTimeout=30"
  LOG_EXECL="/tmp/execl_${$}.cmd"
fi

################################################################
#### Call the main script function to begin processing.
#### 

checklist_zbksh "${@}"

exit ${?}
