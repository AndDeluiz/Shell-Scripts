################################################################################
# @author      Anderson Deluiz (Twitter: @AndDeluiz)                           #
# @name        bashCmdAudit.sh                                                 #
# @version     1.0                                                             #
# @date        Aug 12th, 2014                                                  #
# @description Improves bash command history logging.                          #
#              The presented method is very easy to deploy. It is just a shell #
#              script that is running in bash (standard shell on most systems) #
#              and therefore it is architecture independent. It will allow a   #
#              complete audit of all commands/builtins executed interactively  #
#              in the bash.                                                    #
#              Note that a user can avoid calling this file by starting a shell#
#              with options like '--norc'. Therefore this script is useful for #
#              audit but an alternative solution with bash patching should be  #
#              considered if the security requirements are the priority.       #
#              Some solutions exist to improve this, either by patching or     #
#              installing binaries:                                            #
#              - bash-BOFH patching and recompiling: works well but need a new #
#                patch for each release of the bash.                           #
#              - snoopy: is logging all commands except shell builtins.        #
#              - rootsh / sniffy / ttyrpld / ttysnoop: logs everything, also   #
#                output of commands, it may be useful but it generates very    #
#                verbose logs.                                                 #
#              - grsecurity patched kernels: powerful but it may be a not      #
#                suitable solution if an official kernel is required (e.g. for #
#                Oracle DB).                                                   #
#              - screen: can also be useful for cooperation work, but it is not#
#                a command logger.                                             #
#              Testing were done only in RHEL/CentOS 6 (x86_64) environments.  #
#              This may work on other distributions and architechtures as well.#
#                                                                              #
#              This script is based on bash_franzi script written by Francois  #
#              Scheurer from Point Software AG, available at:                  #
#              http://goo.gl/Sjx0ti                                            #
#                                                                              #
# @require     - Syslog (or rsyslog) daemon configured and working             #
#              - Bash shell version 4 or later                                 #
#                                                                              #
# @usage       As root user:                                                   #
#              1. Copy this file to /etc/profile.d/bashCmdAudit.sh.            #
#              2. Change permissions to 0644 and owner/group to root/root      #
#              3. Configure syslog (or rsyslog) to receive messages with       #
#                 priority defined in syslogPriority variable.                 #
#              4. Logging will be available after users logout and login again.#
################################################################################

# Only works in bash environments
if [ "${SHELL##*/}" = "bash" ]
then
   # bash version must be 4 or higher to work
   if [ ${BASH_VERSION%%.*} -lt 4 ]
   then
      return
   fi
else
   return
fi

#---------------------------   GLOBAL VARIABLES   -----------------------------#

userLogin="$(who -mu | awk '{print $1}')"
userTTY="$(who -mu | awk '{print $2}')"
userLoginPID="$(who -mu | awk '{print $6}')"

# Define a prioridade utilizada para envio ao syslog ou rsyslog.
syslogPriority="local1.notice"

# Efetua chamada a funcao que fara a gravacao dos comandos submetidos.
PROMPT_COMMAND="declare auditDone ; trap 'log2Syslog && auditDone=1 ; trap DEBUG' DEBUG"

# Aumenta a quantidade de registros do history para o valor atribuido
HISTSIZE=5000
HISTFILESIZE=5000

# Muda o formato de gravacao dos registros no history, adicionando
# timestamp.
HISTTIMEFORMAT=" %F %T "

# Nao ignora padroes definidos pelo usuario
HISTIGNORE=""

# Nao ignora comandos iniciados por espaco ou vazios
HISTCONTROL=""

# Define timeout de sessao (em segundos)
TMOUT=600

# Garante que as variaveis nao serao alteradas
typeset -rx userLogin userTTY userLoginPID syslogPriority
typeset -rx HISTFILE HISTSIZE HISTFILESIZE HISTTIMEFORMAT HISTIGNORE HISTCONTROL TMOUT

#---------------------------  BASH CONFIGURATION  -----------------------------#
# Garante que comandos multilinha sejam gravados por completo
shopt -s cmdhist

# Garante que comandos sejam concatenados no arquivo "history". Por padrao,
# o bash reescreve o arquivo.
shopt -s histappend

# Habilita operadores estendidos de correlacao de padroes (regex)
shopt -s extglob

#------------------------------------------------------------------------------#
# @function    log2Syslog                                                      #
# @description Record submitted commands to syslog                             #
#              It is recommended to configure syslog facilities before using   #
#              this function.                                                  #
#              Check syslogPriority global variable for syslog priority that   #
#              will be used for recording.                                     #
#                                                                              #
# @usage       log2Syslog                                                      #
# @in          none                                                            #
# @return      none                                                            #
# @return-code                                                                 #
#              0 - Record sent to syslog succesfully                           #
#              1 - Record not sent to syslog                                   #
#------------------------------------------------------------------------------#
set +o functrace
log2Syslog ()
{
   local auditPreString="[${userLogin}/${userLoginPID} as ${USER}/$$ on ${userTTY}]"

   if [ -z ${lastCmdLogLine} ]
   then
      local lastCmdLogged=$(fc -l -1)			# ultimo comando gravado no arquivo indicado em $HISTFILE
      lastCmdLogLine=${lastCmdLogged%%+([^ 0-9])*}	# numero da linha do registro do ultimo comando gravado em $HISTFILE
   else
      lastCmdLogLine=${actualCmdLogLine}
   fi

   local actualCmdToLog=$(history 1)			# ultimo comando executado
   #actualCmdLogLine=${actualCmdToLog%%+([^ 0-9])*}	# numero da linha do ultimo registro (sem timestamp)
   actualCmdLogLine=${actualCmdToLog%%+( [^0-9])*}	# numero da linha do ultimo registro (com timestamp)

   # Evita o registro de comandos nao executados apos digitar CTRL-C, comandos
   # vazios (somente ENTER) ou CTRL-D.
   if [ ${actualCmdLogLine:-0} -ne ${lastCmdLogLine:-0} ] || [ ${actualCmdLogLine:-0} -eq "1" ]
   then
      logger -p ${syslogPriority} -t bash_audit -i -- "${auditPreString} CWD: ${PWD} COMMAND: ${actualCmdToLog/+([ 0-9:-])/}"
      return 0
   else
      return 1
   fi
}
declare -frx +t log2Syslog

#------------------------------------------------------------------------------#
# @function    logOnExit                                                       #
# @description Record bash session ending to syslog.                           #
#              Must be called using EXIT trap.                                 #
#                                                                              #
# @usage       logOnExit                                                       #
# @in          none                                                            #
# @return      none                                                            #
# @exit-code                                                                   #
#              lastRetCode - last returned code before function call.          #
#------------------------------------------------------------------------------#
set +o functrace
logOnExit ()
{
   local lastRetCode=$?
   logger -p ${syslogPriority} -t bash_audit -i -- "[${userLogin}/${userLoginPID} as ${USER}/$$ on ${userTTY}]: ***** session ended *****"
   exit ${lastRetCode}
}
declare -frx +t logOnExit
trap "logOnExit" EXIT

#---------------------------     MAIN SECTION     -----------------------------#

# Garante que o arquivo history nao sofra alteracoes, somente concatenacoes de
# comandos executados. Somente o usuario root pode executar este comando.
if groups | grep -q 'root'
then
   chattr +a ${HISTFILE}
fi

# Grava no syslog o inicio da sessao
logger -p ${syslogPriority} -t bash_audit -i -- "[${userLogin}/${userLoginPID} as ${USER}/$$ on ${userTTY}]: ***** session started *****"
