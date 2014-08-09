# ======================= BASH Command History Logging ======================= #

# Funcao para registrar todos os comandos executados via syslog.
# OBS: Valido somente para bash versao 4 ou superior.
#
# Para melhor organizacao, sugere-se que o syslogd direcione as mensagens de 
# prioridade local1.notice ou maiores para um arquivo especifico. Para isso,
# por exemplo, adicione a seguinte linha ao syslog.conf ou rsyslog.conf:
#    local1.notice	/var/log/cmdexec.log
# Rotacionamento dos logs via logrotate tambem e indicado.
set +o functrace
log2Syslog ()
{
   cmdToLog=$(fc -ln -0)
   logger -p local1.notice -t bash -i -- ${USER}@$(tty | sed 's/\/dev\///') COMMAND: ${cmdToLog}
   unset cmdToLog
}
declare -frx +t log2Syslog
[ ${BASH_VERSION%%.*} -ge 4 ] && trap "log2Syslog" DEBUG

# Garante que os comandos sejam gravados no arquivo history assim que
# executados. Por padrão, o bash mantem os comandos em buffer de memoria
# ate que a sessao seja finalizada.
PROMPT_COMMAND="history -a"

# Permite criar um arquivo .bash_history para cada terminal no formato
# .bash_history.<TTY>
# HISTFILE=~/.bash_history.$(tty | sed 's/\/dev\///;s/\///')

# Aumenta a quantidade de registros do history para o valor atribuido
HISTSIZE=5000

# Muda o formato de gravacao dos registros no history, adicionando
# data, hora e terminal de onde o comando foi disparado.
HISTTIMEFORMAT="$(tty | sed 's/\/dev\///') %F %T "

# Garante que as variaveis nao serao alteradas
readonly HISTFILE HISTSIZE HISTFILESIZE HISTTIMEFORMAT HISTIGNORE HISTCONTROL

# Garante que comandos multilinha sejam gravados por completo
shopt -s cmdhist

# Garante que comandos sejam concatenados no arquivo "history". Por padrao,
# o bash reescreve o arquivo.
shopt -s histappend

# Garante que o arquivo history nao sofra alteracoes, somente concatenacoes de
# comandos executados. Somente o usuario root pode executar este comando.
#chattr +a ${HISTFILE}

# ============================================================================ #

