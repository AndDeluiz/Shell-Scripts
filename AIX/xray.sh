########################### 
# 
# Script: MENU_SERVICE.sh 
# Data: 23/12/2005 
# Finalidade: Este script foi desenvolvido 
# para facilitar a coleta de dados do Servidor. 
# 
############################################### 
# 
rotate() 
{ 
                INTERVAL=1 
                TCOUNT="0" 
                while : 
                do 
                TCOUNT=`expr $TCOUNT + 1` 
                case $TCOUNT in 
                "1") echo '-'"\b\c" 
                     sleep $INTERVAL 
                     ;; 
                "2") echo '\\'"\b\c" 
                     sleep $INTERVAL 
                     ;; 
                "3") echo "|\b\c" 
                     sleep $INTERVAL 
                     ;; 
                "4") echo "/\b\c" 
                     sleep $INTERVAL 
                     ;; 
                *) TCOUNT="0" ;; 
                esac 
                done 
} 
########## VARIAVEIS DE AMBIENTE ########## 
XVERSION=v.2.0 
XHOSTNAME=`hostname` 
XDATA=`date +'%d/%m/%Y'` 
XHORA=`date +'%H:%M'` 
XOUT=$XHOSTNAME".html" 
 
 
########################################### 
clear 
tput smso 
echo "                      SERVICE IT SOLUTIONS          RAIOX $XVERSION " 
tput rmso 
echo " " 
echo "Este script ir▒ coletar dados do SERVIDOR: `hostname` 
O Prop▒sito deste script ▒ obter informa▒▒es para uma 
an▒lise mais detalhada sobre a configura▒▒o do SERVIDOR. 
Aten▒▒o: 
O start deste script n▒o causa nenhum impacto em seu ambiente. 
Pressione <ENTER> para continuar" 
read ENTER 
echo "Gerando relat▒rio do servidor $XHOSTNAME" 
echo " " 
echo "  - Data: $XDATA" 
echo "  - Hora: $XHORA" 
echo " " 
echo "Relat▒rio sendo gerado em: `pwd`/$XOUT" 
rotate & 
ROTATE_PID=$! 
########################### 
# CABECALHO DO HTML 
########################### 
echo "<HTML><HEAD>" > $XOUT 
echo "<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'>" >> $XOUT 
echo "<META NAME='GENERATOR' CONTENT='raiox/v1 [AIX]'>" >> $XOUT 
echo "<TITLE>.: Service IT Solutions -  Raio-X $XVERSION :. </TITLE>">> $XOUT 
echo "</HEAD>">> $XOUT 
echo "<BODY BGCOLOR='#FFFFFF' TEXT='#000000'> " >> $XOUT 
echo "<H1>Service IT Solutions</H1> 
<H3>Raio-X $XVERSION </H3> 
<H4>Analise executada em $XDATA as $XHORA </H4> <HR>" >> $XOUT 
 
 
########################### 
# INICIO DO HTML 
########################### 
echo "<H3>SERVIDOR: `hostname` </H3> <p>" >> $XOUT 
lsconf > /tmp/lsconf.txt 2>> /tmp/lsconf.txt 
echo "<PRE>" >>$XOUT 
echo "<H4>`cat /tmp/lsconf.txt |head -10` </H4>" >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<HR><H2> <A NAME='_contents'> INDICE </a> </h2>" >> $XOUT 
echo "<TABLE cellpadding=2 border=0>">> $XOUT 
echo "<TR> <OL>" >> $XOUT 
echo "<TD WIDTH='33%'>" >> $XOUT 
echo "<LI><A HREF='#PI_0'>Error Log (resumido)</A>">>$XOUT 
echo "<LI><A HREF='#PI_1'>Error Log (detalhado)</A>">>$XOUT 
echo "<LI><A HREF='#PI_2'>Pacotes Instalados</A>">>$XOUT 
echo "<LI><A HREF='#PI_3'>Maintenance Levels Instalados</A>">>$XOUT 
echo "<LI><A HREF='#PI_4'>Patches Instalados</A>">>$XOUT 
echo "<LI><A HREF='#PI_5'>Patches Requeridos para Maintenance Level Completo</A>">>$XOUT 
echo "<LI><A HREF='#PI_6'>Console</A>">>$XOUT 
echo "<LI><A HREF='#PI_7'>Licenciamento</A>">>$XOUT 
#echo "<LI><A HREF='#PI_8'>System Configuration File</A>">>$XOUT 
#echo "<LI><A HREF='#PI_9'>sysconfig Settings</A>">>$XOUT 
#echo "<LI><A HREF='#PI_10'>rc.config Settings</A>">>$XOUT 
#echo "<LI><A HREF='#PI_11'>System Startup Procedures</A>">>$XOUT 
#echo "<LI><A HREF='#PI_12'>Virtual Memory and Swap</A>">>$XOUT 
#echo "<LI><A HREF='#PI_13'>CPUs and Processes</A>">>$XOUT 
#echo "<LI><A HREF='#PI_14'>Device Special Files</A>">>$XOUT 
#echo "<LI><A HREF='#PI_15'>Installed LMF licenses</A>">>$XOUT 
#echo "<LI><A HREF='#PI_16'>setld Installed Products</A>">>$XOUT 
#echo "<LI><A HREF='#PI_17'>TruCluster V5</A>">>$XOUT 
#echo "<LI><A HREF='#PI_18'>TruCluster Available/Production Server</A>">>$XOUT 
#echo "<LI><A HREF='#PI_19'>LPD Printers</A>">>$XOUT 
#echo "<LI><A HREF='#PI_20'>Advanced Printing Software</A>">>$XOUT 
#echo "<LI><A HREF='#PI_21'>crontab and at</A>">>$XOUT 
#echo "<LI><A HREF='#PI_22'>X11 / CDE</A>">>$XOUT 
#echo "<LI><A HREF='#PI_23'>Accounting</A>">>$XOUT 
#echo "<LI><A HREF='#PI_24'>Adhoc information from System Administrator</A>">>$XOUT 
#echo "<LI><A HREF='#PI_25'>Event Manager (EVM)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_26'>System Logs</A>">>$XOUT 
 
#echo "<LI><A HREF='#PI_27'>Log File Sizes</A>">>$XOUT 
#echo "<LI><A HREF='#PI_28'>UERF Error Information</A>">>$XOUT 
#echo "<LI><A HREF='#PI_29'>DECevent Error Information</A>">>$XOUT 
#echo "<LI><A HREF='#PI_30'>Crash Files</A>">>$XOUT 
#echo "<LI><A HREF='#PI_31'>Security Information (Users and Groups)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_32'>Audit Subsystem</A>">>$XOUT 
#echo "<LI><A HREF='#PI_33'>Disk Drives and Disk Labels</A>">>$XOUT 
#echo "<LI><A HREF='#PI_34'>HS* RAID Controllers</A>">>$XOUT 
#echo "<LI><A HREF='#PI_35'>HSV RAID Controllers</A>">>$XOUT 
#echo "<LI><A HREF='#PI_36'>Tape Drives</A>">>$XOUT 
#echo "<LI><A HREF='#PI_37'>SCSI Buses</A>">>$XOUT 
echo "<LI><A HREF='#PI_38'>Volume Groups</A>">>$XOUT 
echo "<LI><A HREF='#PI_39'>Logical Volumes</A>">>$XOUT 
echo "<LI><A HREF='#PI_40'>Filesystems</A>">>$XOUT 
echo "<LI><A HREF='#PI_41'>Physical Volumes</A>">>$XOUT 
#echo "<LI><A HREF='#PI_42'>Mounted File Systems, fstab, Disk Space, and Quotas</A>">>$XOUT 
#echo "<LI><A HREF='#PI_43'>VFS layer</A>">>$XOUT 
echo "<LI><A HREF='#PI_44'>Devices</A>">>$XOUT 
echo "<LI><A HREF='#PI_45'>LSCFG -VP</A>">>$XOUT 
#echo "<LI><A HREF='#PI_46'>Network File System (NFS)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_47'>NetWorker</A>">>$XOUT 
#echo "<LI><A HREF='#PI_48'>Storage Map</A>">>$XOUT 
#echo "<LI><A HREF='#PI_49'>TCP/IP Network</A>">>$XOUT 
#echo "<LI><A HREF='#PI_50'>IP Routing Tables</A>">>$XOUT 
#echo "<LI><A HREF='#PI_51'>Firewall Configuration</A>">>$XOUT 
#echo "<LI><A HREF='#PI_52'>Point to Point Protocol (PPP)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_53'>Host and Domain Name Server</A>">>$XOUT 
#echo "<LI><A HREF='#PI_54'>Streams Information</A>">>$XOUT 
#echo "<LI><A HREF='#PI_55'>Network Time Protocol (NTP)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_56'>Simple Network Management Protocol (SNMP)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_57'>bootp and joind</A>">>$XOUT 
#echo "<LI><A HREF='#PI_58'>Portmap</A>">>$XOUT 
#echo "<LI><A HREF='#PI_59'>NIS / YP</A>">>$XOUT 
#echo "<LI><A HREF='#PI_60'>Mail Configuration</A>">>$XOUT 
#echo "<LI><A HREF='#PI_61'>Distributed Computing Environment (DCE)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_62'>DECnet OSI</A>">>$XOUT 
#echo "<LI><A HREF='#PI_63'>tty Settings</A>">>$XOUT 
#echo "<LI><A HREF='#PI_64'>Local Area Transport (LAT)</A>">>$XOUT 
#echo "<LI><A HREF='#PI_65'>Advanced Server for UNIX</A>">>$XOUT 
#echo "<LI><A HREF='#PI_66'>Baan</A>">>$XOUT 
#echo "<LI><A HREF='#PI_67'>BMC Patrol</A>">>$XOUT 
#echo "<LI><A HREF='#PI_68'>Informix</A>">>$XOUT 
#echo "<LI><A HREF='#PI_69'>Netscape http server</A>">>$XOUT 
#echo "<LI><A HREF='#PI_70'>Oracle</A>">>$XOUT 
#echo "<LI><A HREF='#PI_71'>Performance Manager</A>">>$XOUT 
#echo "<LI><A HREF='#PI_72'>Samba</A>">>$XOUT 
#echo "<LI><A HREF='#PI_73'>SAP</A>">>$XOUT 
#echo "<LI><A HREF='#PI_74'>Sybase</A>">>$XOUT 
#echo "<LI><A HREF='#PI_75'>WEBES</A>">>$XOUT 
echo "<LI><A HREF='#PI_76'>Characteristics of Operating System</A>">>$XOUT 
echo "<LI><A HREF='#PI_77'>Characteristics of Inet0</A>">>$XOUT 
echo "<LI><A HREF='#PI_78'>Parametros de Tuning (Kernel)</A>">>$XOUT 
echo "<LI><A HREF='#PI_79'>Processor SMT (simultaneous multi-threading)</A>">>$XOUT 
echo "<LI><A HREF='#PI_80'>Paginacao (SWAP)</A>">>$XOUT 
echo "<LI><A HREF='#PI_81'>Print Spooling</A>">>$XOUT 
echo "<LI><A HREF='#PI_82'>Rotas</A>">>$XOUT 
echo "<LI><A HREF='#PI_83'>Interfaces de rede ativas</A>">>$XOUT 
echo "<LI><A HREF='#PI_84'>Name Resolution (DNS)</A>">>$XOUT 
echo "<LI><A HREF='#PI_85'>Ordem Name Resolution</A>">>$XOUT 
echo "<LI><A HREF='#PI_86'>Tabela HOSTS</A>">>$XOUT 
echo "<LI><A HREF='#PI_87'>HACMP Configuration</A>">>$XOUT 
echo "<LI><A HREF='#PI_88'>Processos Ativos</A>">>$XOUT 
#echo "<LI><A HREF='#PI_89'>PV Identifier</A>">>$XOUT 
#echo "<LI><A HREF='#PI_90'>Physical volume Available</A>">>$XOUT 
echo "<LI><A HREF='#PI_91'>Inittab</A>">>$XOUT 
echo "<LI><A HREF='#PI_92'>Asynchronous I/O</A>">>$XOUT 
echo "<LI><A HREF='#PI_93'>Users</A>">>$XOUT 
echo "<LI><A HREF='#PI_94'>Group</A>">>$XOUT 
echo "<LI><A HREF='#PI_95'>Limits dos Users</A>">>$XOUT 
echo "<LI><A HREF='#PI_96'>NFS</A>">>$XOUT 
echo "<LI><A HREF='#PI_97'>Crontab</A>">>$XOUT 
echo "</TD><TD WIDTH='33%'>">>$XOUT 
echo "<LI><A HREF='#PI_130'>Ifconfig</A>">>$XOUT 
echo "<LI><A HREF='#PI_98'>Consistencia dos filesets</A>">>$XOUT 
echo "<LI><A HREF='#PI_99'>Boot Info</A>">>$XOUT 
echo "<LI><A HREF='#PI_100'>Conf Geral</A>">>$XOUT 
echo "<LI><A HREF='#PI_101'>Tape</A>">>$XOUT 
echo "<LI><A HREF='#PI_102'>Adaptadores</A>">>$XOUT 
echo "<LI><A HREF='#PI_103'>Storage</A>">>$XOUT 
#echo "<LI><A HREF='#PI_104'>Adaptadores Defined</A>">>$XOUT 
echo "<LI><A HREF='#PI_105'>Adaptadores Hot Plug</A>">>$XOUT 
echo "<LI><A HREF='#PI_106'>Informa▒▒es LPAR</A>">>$XOUT 
echo "<LI><A HREF='#PI_107'>CDROM /DVD</A>">>$XOUT 
 
echo "<LI><A HREF='#PI_108'>Tipo de Hardware</A>">>$XOUT 
echo "<LI><A HREF='#PI_109'>Firmware Sysplanar</A>">>$XOUT 
echo "<LI><A HREF='#PI_110'>Vers▒o SNMP</A>">>$XOUT 
echo "<LI><A HREF='#PI_111'>DUMP</A>">>$XOUT 
echo "<LI><A HREF='#PI_112'>CPU 32bits/64bits</A>">>$XOUT 
echo "<LI><A HREF='#PI_113'>HACMP Configuration 4.*</A>">>$XOUT 
echo "<LI><A HREF='#PI_114'>Clock Processor</A>">>$XOUT 
echo "<LI><A HREF='#PI_115'>Info Rede</A>">>$XOUT 
echo "<LI><A HREF='#PI_123'>VMSTAT</A>">>$XOUT 
echo "<LI><A HREF='#PI_124'>Info HBA</A>">>$XOUT 
echo "<LI><A HREF='#PI_125'>Info IBM.ManagementServer HMC</A>">>$XOUT 
echo "<LI><A HREF='#PI_126'>Uptime</A>">>$XOUT 
echo "<LI><A HREF='#PI_127'>Variaveis de Ambiente</A>">>$XOUT 
 
echo "</p><br><LI><H1><strong>VIO Server</strong></H1>">>$XOUT 
echo "<LI><A HREF='#PI_116'>Dispositivos Virtuais</A>">>$XOUT 
echo "<LI><A HREF='#PI_117'>Discos Virtuais</A>">>$XOUT 
echo "<LI><A HREF='#PI_118'>Adaptadores virtuais</A>">>$XOUT 
echo "<LI><A HREF='#PI_119'>Licen▒a VIO</A>">>$XOUT 
echo "<LI><A HREF='#PI_120'>Todos os dispositivos Virtuais</A>">>$XOUT 
echo "<LI><A HREF='#PI_121'>Placas de redes virtuais</A>">>$XOUT 
echo "<LI><A HREF='#PI_122'>Vers▒o VIO Server</A>">>$XOUT 
echo "</TD>">>$XOUT 
echo "</OL> </TR> </TABLE> " >> $XOUT 
 
#################### 
## SECOES INDEPENDENTES 
#################### 
  
################ PI_0 - Error Log Resumido 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_0'> Error Log (Resumido)  </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
errpt >> $XOUT 
 
echo "</PRE>" >>$XOUT 
################ PI_1 - Error Log Detalhado 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_1'> Error Log (Detalhado)  </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
errpt -a  >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_2 - Pacotes Instalados 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_2'> Pacotes Instalados </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lslpp -l >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_3 - Maintenance Levels Instalados 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_3'> Maintenance Levels Instalados </A></H2> ">> $XOUT 
echo "<strong>Versao AIX: `oslevel -r`</strong><br>" >> $XOUT 
echo "<PRE>" >>$XOUT 
instfix -i | grep ML >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<strong>Versao AIX Service Pack: `oslevel -s`</strong><br>" >> $XOUT 
################ PI_4 - Patches Instalados 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_4'> Patches Instalados </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
instfix -icq  >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_5 - Patches Requeridos para Maintenance Level Completo 
 
 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_5'> Patches Requeridos para Maintenance Level Completo</A></H2> ">> $XOUT 
 
echo "<TABLE border=1>" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <b> Maintenance Level </b> </TD>" >> $XOUT 
echo "<TD> <b> Fileset </b> </TD>" >> $XOUT 
echo "<TD> <b> Vers▒o Atual </b> </TD>" >> $XOUT 
echo "<TD> <b> Vers▒o Requerida </b> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
instfix -i |grep ML | grep "Not all filesets" | awk '{print $5}' | while read xML 
do 
  instfix -icqk $xML | grep ":-:" | while read xlinha 
  do 
    xfs=`echo $xlinha | cut -f 2 -d : ` 
    xatual=`echo $xlinha | cut -f 4 -d : ` 
    xreq=`echo $xlinha | cut -f 3 -d : ` 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xML  </TD>" >> $XOUT 
    echo "<TD> $xfs  </TD>" >> $XOUT 
    echo "<TD> $xatual  </TD>" >> $XOUT 
    echo "<TD> $xreq  </TD>" >> $XOUT 
    echo "</TR> ">> $XOUT 
  done 
done 
echo "</TABLE> ">> $XOUT 
################ PI_6 - Console 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_6'> Console</A></H2> ">> $XOUT 
echo " <LI> Dispositivo definido como console default: <i> `lscons` </i> <BR>" >> $XOUT 
echo " <LI> Detalhes do dispositivo: <BR>" >> $XOUT 
echo "<PRE>" >>$XOUT 
xconsole=`lscons | cut -f 3 -d /` 
lsattr -El $xconsole >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_7 - Licenciamento 
 
 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_7'> Licenciamento</A></H2> ">> $XOUT 
echo " <LI> Detalhes do Licenciamento <BR>" >> $XOUT 
echo "<PRE>" >>$XOUT 
lslicense -A >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_38 - Volume Groups 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_38'> Volume Groups </A></H2> ">> $XOUT 
echo " <LI> Volumes groups">>$XOUT 
echo "<TABLE border=1 width=300>" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Volume Group </I> </TD>" >> $XOUT 
echo "<TD> <I> Status </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg | while read xvg 
do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xvg </TD>" >> $XOUT 
    echo "<TD> " >> $XOUT 
    xvgonline=`lsvg -o | grep $xvg` 
    if [ "$xvgonline" = "" ] 
    then 
       echo "OFFLINE" >> $XOUT 
    else 
       echo "ONLINE" >> $XOUT 
    fi 
    echo "</TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Volumes groups em Detalhes ">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Volume Group </I> </TD>" >> $XOUT 
 
echo "<TD> <I> Status do Volume Group </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg -o | while read xvg 
do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xvg </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lsvg $xvg >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
 
echo "<BR>" >> $XOUT 
echo " <LI> Volumes groups em Detalhes - Physical Volumes">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Volume Group </I> </TD>" >> $XOUT 
echo "<TD> <I> Status dos Physical Volumes </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg -o | while read xvg 
do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xvg </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lsvg -p $xvg >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Volumes groups em Detalhes - Logical Volumes">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Volume Group </I> </TD>" >> $XOUT 
echo "<TD> <I> Status dos Logical Volumes </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg -o | while read xvg 
do 
    echo "<TR>" >> $XOUT 
 
    echo "<TD> $xvg </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lsvg -l $xvg >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
################ PI_39 - Logical Volumes 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_39'> Logical Volumes </A></H2> ">> $XOUT 
echo " <LI> Logical Volumes ">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Volume Group </I> </TD>" >> $XOUT 
echo "<TD> <I> Logical Volume </I> </TD>" >> $XOUT 
echo "<TD> <I> Tipo </I> </TD>" >> $XOUT 
echo "<TD> <I> Logical Partitions </I> </TD>" >> $XOUT 
echo "<TD> <I> Physical Partitions </I> </TD>" >> $XOUT 
echo "<TD> <I> Copias </I> </TD>" >> $XOUT 
echo "<TD> <I> Status </I> </TD>" >> $XOUT 
echo "<TD> <I> Mount Point </I> </TD>" >> $XOUT 
echo "<TD> <I> Physical Partition Size </I> </TD>" >> $XOUT 
echo "<TD> <I> Logical Volume size em Megabytes </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg -o | while read xvg 
do 
  xPPsize=`lsvg $xvg | grep "PP SIZE:" | awk '{print $6}'` 
  lsvg -l $xvg | tail -n +3 | while read xlv xtipo xlps xpps xcopies xstatus xmp 
  do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xvg </TD>" >> $XOUT 
    echo "<TD> $xlv </TD>" >> $XOUT 
    echo "<TD> $xtipo </TD>" >> $XOUT 
    echo "<TD> $xlps </TD>" >> $XOUT 
    echo "<TD> $xpps </TD>" >> $XOUT 
    echo "<TD> $xcopies </TD>" >> $XOUT 
    echo "<TD> $xstatus </TD>" >> $XOUT 
    echo "<TD> $xmp </TD>" >> $XOUT 
    echo "<TD> $xPPsize </TD>" >> $XOUT 
    let xLVsize=$xPPsize*$xlps 
    echo "<TD> $xLVsize </TD>" >> $XOUT 
    echo "</TR> ">> $XOUT 
  done 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Logical Volumes em Detalhes - Configura▒▒o ">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Logical Volumes </I> </TD>" >> $XOUT 
echo "<TD> <I> Configuracao dos Logical Volumes </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg -o | while read xvg 
do 
  lsvg -l $xvg | tail -n +3 | while read xlv resto 
  do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xlv </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lslv -L $xlv >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
  done 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Logical Volumes em Detalhes - Distribui▒ao">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Logical Volumes </I> </TD>" >> $XOUT 
echo "<TD> <I> Distribui▒▒o dos Logical Volumes </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsvg -o | while read xvg 
do 
  lsvg -l $xvg | tail -n +3 | while read xlv resto 
  do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xlv </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lslv -l $xlv >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
  done 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR><br><LI> Informacoes LVs" >>$XOUT 
echo "<PRE>" >>$XOUT 
lsvg -o |while read VG 
do 
echo "<BR>" >> $XOUT 
echo "<strong>Volume Group: $VG </strong>"  >> $XOUT 
echo "<BR><BR>" >> $XOUT 
lsvg -l $VG |awk '{print $1}'|while read POINT 
do 
lslv -m $POINT >> $XOUT 
echo "<BR><BR><BR>" >> $XOUT 
done 
done 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
 
################ PI_40 - Filesystems 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_40'> Filesystems </A></H2> ">> $XOUT 
echo " <LI> Lista dos Filesystems">>$XOUT 
echo "<PRE>" >>$XOUT 
lsfs  >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Status dos Filesystems em KB">>$XOUT 
echo "<PRE>" >>$XOUT 
df -k   >> $XOUT 
echo "</PRE>" >>$XOUT 
echo " <LI> Status dos Filesystems em MB">>$XOUT 
echo "<PRE>" >>$XOUT 
df -m   >> $XOUT 
echo "</PRE>" >>$XOUT 
echo " <LI> Status dos Filesystems em GB">>$XOUT 
echo "<PRE>" >>$XOUT 
df -g   >> $XOUT 
echo "</PRE>" >>$XOUT 
echo " <LI> Arquivo dos Filesystems /etc/filesystems">>$XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/filesystems  >> $XOUT 
echo "</PRE>" >>$XOUT 
 
################ PI_41 - Physical Volumes 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_41'> Physical Volumes </A></H2> ">> $XOUT 
echo " <LI> Lista dos PV Identifier">>$XOUT 
echo "<PRE>" >>$XOUT 
lspv | sort -n |cat -n >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Lista dos Physical Volumes">>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>. Available</strong><br>"  >>$XOUT 
lsdev -Cc disk |grep -i Available | sort | cat -n >>$XOUT 
echo "<p><br><br><br><strong>. Defined</strong><br>"  >>$XOUT 
lsdev -Cc disk |grep -i Defined | sort | cat -n >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
echo " <LI>Path para os discos MPIO">>$XOUT 
echo "<PRE>" >>$XOUT 
lspath >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
 
echo " <LI> Detalhes dos Physical Volumes">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Physical  Volumes </I> </TD>" >> $XOUT 
echo "<TD> <I> Detalhes </I> </TD>" >> $XOUT 
lspv  | while read xdisk resto 
do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xdisk </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lspv $xdisk >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR>" >> $XOUT 
  
echo " <LI> Conte▒do dos Physical Volumes">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Physical  Volumes </I> </TD>" >> $XOUT 
echo "<TD> <I> Conte▒do </I> </TD>" >> $XOUT 
lspv  | while read xdisk resto 
do 
    echo "<TR>" >> $XOUT 
    echo "<TD> $xdisk </TD>" >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lspv -l $xdisk >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
echo "<BR><BR><LI>Detalhes Discos INQ EMC">>$XOUT 
echo "<PRE>" >>$XOUT 
inq >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
 
################ PI_44 - Devices 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_44'> Devices </A></H2> ">> $XOUT 
echo " <LI>  Lista dos Dispositivos ">>$XOUT 
echo "<BR>">> $XOUT 
echo "<TABLE border=0 >" >> $XOUT 
echo "<BR><BR><strong>. Devices Available</strong><br><br>" >> $XOUT 
lsdev -C |grep -i Available | sort | while read xline 
do 
    xdevice=`echo $xline | awk '{print $1}'` 
    echo "<TR>">>$XOUT 
    echo "<TD><A NAME='#DEV_$xdevice'> </A> <PRE> $xline </PRE> </TD>" >> $XOUT 
    echo "<TD> <A HREF='#ATTR_$xdevice'> Atributos </A>  </TD> " >> $XOUT 
    echo "<TD> <A HREF='#VPD_$xdevice'> Vital Product Data </A> </TD>  " >> $XOUT 
    echo "</TR>">>$XOUT 
done 
echo "</TABLE> <BR> ">> $XOUT 
echo "<LI>  Atributos dos Dispositivos">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Device </I> </TD>" >> $XOUT 
echo "<TD> <I> Atributos </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsdev -C |grep -i Available | sort | while read xline 
do 
    xdevice=`echo $xline | awk '{print $1}'` 
    echo "<TR>" >> $XOUT 
    echo "<TD> " >> $XOUT 
    echo "<A NAME='#ATTR_$xdevice'>$xdevice</A> ">>$XOUT 
    echo "<BR> <A HREF='#DEV_$xdevice'> Voltar </a> </TD>  " >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lsattr -El $xdevice >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> <BR> ">> $XOUT 
 
echo " <LI>  Vital Product Data dos Dispositivos">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Device </I> </TD>" >> $XOUT 
echo "<TD> <I> VPD </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsdev -C |grep -i Available | sort | while read xline 
do 
    xdevice=`echo $xline | awk '{print $1}'` 
    echo "<TR>" >> $XOUT 
    echo "<TD> " >> $XOUT 
    echo "<A NAME='#VPD_$xdevice'>$xdevice</A> ">>$XOUT 
    echo "<BR> <A HREF='#DEV_$xdevice'> Voltar </a> </TD>  " >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lscfg -vl $xdevice >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
 
echo "<BR>">> $XOUT 
echo "<TABLE border=0 >" >> $XOUT 
echo "<br><strong>. Devices Defined</strong><br><br>" >> $XOUT 
lsdev -C |grep -i Defined | sort | while read xline 
do 
    xdevice=`echo $xline | awk '{print $1}'` 
    echo "<TR>">>$XOUT 
    echo "<TD><A NAME='#DEV_$xdevice'> </A> <PRE> $xline </PRE> </TD>" >> $XOUT 
    echo "<TD> <A HREF='#ATTR_$xdevice'> Atributos </A>  </TD> " >> $XOUT 
    echo "<TD> <A HREF='#VPD_$xdevice'> Vital Product Data </A> </TD>  " >> $XOUT 
    echo "</TR>">>$XOUT 
done 
echo "</TABLE> <BR> ">> $XOUT 
echo "<LI>  Atributos dos Dispositivos">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Device </I> </TD>" >> $XOUT 
echo "<TD> <I> Atributos </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsdev -C |grep -i Defined | sort | while read xline 
do 
    xdevice=`echo $xline | awk '{print $1}'` 
    echo "<TR>" >> $XOUT 
    echo "<TD> " >> $XOUT 
    echo "<A NAME='#ATTR_$xdevice'>$xdevice</A> ">>$XOUT 
    echo "<BR> <A HREF='#DEV_$xdevice'> Voltar </a> </TD>  " >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lsattr -El $xdevice >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> <BR> ">> $XOUT 
 
echo " <LI>  Vital Product Data dos Dispositivos">>$XOUT 
echo "<TABLE border=1 >" >> $XOUT 
echo "<TR>" >> $XOUT 
echo "<TD> <I> Device </I> </TD>" >> $XOUT 
echo "<TD> <I> VPD </I> </TD>" >> $XOUT 
echo "</TR> ">> $XOUT 
lsdev -C |grep -i Defined | sort | while read xline 
do 
    xdevice=`echo $xline | awk '{print $1}'` 
    echo "<TR>" >> $XOUT 
    echo "<TD> " >> $XOUT 
    echo "<A NAME='#VPD_$xdevice'>$xdevice</A> ">>$XOUT 
    echo "<BR> <A HREF='#DEV_$xdevice'> Voltar </a> </TD>  " >> $XOUT 
    echo "<TD> <PRE> " >> $XOUT 
    lscfg -vl $xdevice >> $XOUT 
    echo "</PRE> </TD>">>$XOUT 
    echo "</TR> ">> $XOUT 
done 
echo "</TABLE> ">> $XOUT 
 
################ PI_45 - LSCFG -VP 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_45'> LSCFG -VP </A></H2> ">> $XOUT 
echo "<strong>`lsmcode`</strong><br><br>" >>$XOUT 
echo "<PRE>" >> $XOUT 
lscfg -vp >> $XOUT 
echo "</PRE>" >> $XOUT 
################ PI_46 - Hierarquia de Dispositivos 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_46'> Hierarquia de Dispositivos </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsdev -C | sort  -k 3.2b >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_76 - Characteristics of Operating System 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_76'>Characteristics of Operating System</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsattr -El sys0 >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_77 - Characteristics of Inet0 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_77'>Characteristics of Inet0</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsattr -El inet0 >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_78 - Parametros de Tuning (Kernel) 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_78'>Parametros de Tuning (Kernel)</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<br><strong>Memoria Virtual</strong><br><br>">> $XOUT 
vmo -L >> $XOUT 
echo "<p><br><br><br><strong>I/O</strong><br><br>">> $XOUT 
ioo -L >> $XOUT 
echo "<p><br><br><br><strong>Rede</strong><br><br>">> $XOUT 
no -L >> $XOUT 
echo "<p><br><br><br><br><strong>RC.TUNING</strong><br>">> $XOUT 
cat /etc/rc.tuning >> $XOUT 
echo "<p>" >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<p><br><br><br><strong>Utilizacao simultaneous multi-threading</strong><br>">> $XOUT 
mpstat -s 5 2 >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<p><br><br><br><strong>Detalhes statistics threads para logical processors</strong><br>">> $XOUT 
mpstat -d 5 2 >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_79 - Processor SMT (simultaneous multi-threading) 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_79'>Processor SMT (simultaneous multi-threading)</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
smtctl >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<p><br><br><strong>Numero de Processadores L▒gicos</strong><br>">> $XOUT 
bindprocessor -q >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<p><br><br><strong>Numero de Processadores Virtuais (F▒sicos)</strong><br>">> $XOUT 
lsdev -Cc processor >> $XOUT 
echo "</PRE>" >>$XOUT 
 
################ PI_80 - Paginacao (SWAP) 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_80'>Paginacao (SWAP)</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsps -s >> $XOUT 
echo "<br>" >> $XOUT 
lsps -a >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_81 - Print Spooling 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_81'>Print Spooling</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/qconfig >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_82 - Rotas 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_82'>Rotas</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
netstat -nr >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_83 - Interfaces de rede ativas 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_83'>Interfaces de rede ativas</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
netstat -in >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_84 - Name Resolution (DNS) 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_84'>Name Resolution (DNS)</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/resolv.conf >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_85 - Ordem Name Resolution 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_85'>Ordem Name Resolution</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/netsvc.conf >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_86 - Tabela HOSTS 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_86'>Tabela HOSTS</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/hosts >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_87 - HACMP Configuration 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_87'>HACMP Configuration</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>Servicos Ativos</strong><br>" >> $XOUT 
/usr/sbin/cluster/utilities/clshowsrv -a >>$XOUT 
echo "<p><br><br><br><br><strong>Configuracao de Network</strong><br>" >> $XOUT 
/usr/es/sbin/cluster/utilities/cltopinfo >> $XOUT 
echo "<p>" >> $XOUT 
echo "<p><br><br><br><br><strong>Policies e Resource Group</strong><br>" >> $XOUT 
/usr/es/sbin/cluster/utilities/cldisp 
echo "<p>" >> $XOUT 
echo "<p><br><br><br><br><strong>Verifica▒▒o Status Resource Group</strong><br>" >> $XOUT 
/usr/es/sbin/cluster/utilities/clRGinfo -p 
echo "<p>" >> $XOUT 
/usr/es/sbin/cluster/utilities/cllsif >> $XOUT 
echo "<p><br><br><br><br><strong>Configuracao Resource Group</strong><br>" >> $XOUT 
/usr/es/sbin/cluster/utilities/clshowres >> $XOUT 
echo "<p><br><br><br><br><strong>Status do Cluster</strong><br>" >> $XOUT 
/usr/es/sbin/cluster/utilities/cldump >> $XOUT 
echo "<p><br><br><br><strong>Log HACMP</strong><br>" >> $XOUT 
echo "--------- /tmp/hacmp.out ---------" >> $XOUT 
echo "<BR>"  >> $XOUT 
cat /tmp/hacmp.out >> $XOUT 2>>$XOUT 
echo "<p><br><br>" >> $XOUT 
echo "--------- /usr/es/adm/cluster.log ---------" >> $XOUT 
echo "<br><br>" >> $XOUT 
cat /usr/es/adm/cluster.log |grep -i `date |awk '{print $2}'` >> $XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_88 - Processos Ativos 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_88'>Processos Ativos</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
ps aux | cat -n >>$XOUT 
echo "<p><br><br><br><strong>Total de Processos Ativos</strong><br>" >> $XOUT 
ps aux| wc -l >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_89 - PV Identifier 
#echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
#echo " <A NAME='PI_89'>PV Identifier</A></H2> ">> $XOUT 
#echo "<PRE>" >>$XOUT 
#lspv | sort |cat -n >>$XOUT 
#echo "</PRE>" >>$XOUT 
################ PI_90 - Physical volume Available 
#echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
#echo " <A NAME='PI_90'>Physical volume Available</A></H2> ">> $XOUT 
#echo "<PRE>" >>$XOUT 
#lsdev -Cc disk |grep -i Available | sort | cat -n >>$XOUT 
#echo "</PRE>" >>$XOUT 
################ PI_91 - Inittab 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_91'>Inittab /etc/inittab</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsitab -a >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_92 - Asynchronous I/O 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_92'>Asynchronous I/O</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsattr -El aio0  >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>Numero de AIO Server Running - flag -c </strong><br>" >>$XOUT 
pstat -a | grep -c aios | wc ▒l >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>Numero de AIO Server Running - Sem flag</strong><br>" >>$XOUT 
pstat -a | grep aios | wc ▒l >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_93 - Users 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_93'>Users</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
sort /etc/passwd >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_94 - Group 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_94'>Group</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
sort /etc/group >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_95 - Limits dos Users 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_95'>Limits dos Users</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/security/limits >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_96 - NFS 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_96'>NFS</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>File Systems Exportados</strong><br>" >>$XOUT 
showmount -e >>$XOUT 
echo "<p><br><br><br><br><strong>File Systems Montados Remotamente</strong><br>" >>$XOUT 
showmount -d >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_97 - Crontab 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_97'>Crontab</A></H2> ">> $XOUT 
CRON=/var/spool/cron/crontabs 
echo "<PRE>" >>$XOUT 
ls -l $CRON | grep -v total | awk '{print $9}' |while read xcron 
do 
  echo "<LI>" Arquivo de crontab do usuario $xcron "<BR>" >> $XOUT 
  echo "<PRE>" >> $XOUT 
  cat $CRON/$xcron >> $XOUT 
  echo "</PRE><BR>" >>$XOUT 
done 
################ PI_98 - File sets Inconsistentes 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_98'>File sets Inconsistentes</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lppchk -v 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_99 - Boot Info 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_99'>Boot Info</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>Kernel em uso</strong>" >>$XOUT 
bootinfo -K >>$XOUT 
echo "<BR><br><br><strong>Kernel Suportado</strong>" >>$XOUT 
bootinfo -y >>$XOUT 
echo "<BR><br><br><strong>Boot device</strong>" >>$XOUT 
bootlist -m normal -o >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_100 - Conf Geral 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_100'>Conf Geral</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsconf >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_101 - Tape 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_101'>Tape</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<br><strong>Tape Available</strong><br><br>" >>$XOUT 
lsdev -Cc tape |grep -i Available |sort |cat -n >>$XOUT 
echo "<p><br><br><br><strong>Tape Defined</strong><br><br>" >>$XOUT 
lsdev -Cc tape |grep -i Defined |sort |cat -n >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_102 - Adaptadores 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_102'>Adaptadores </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<br><strong>Adaptadores Available</strong><br><br>" >>$XOUT 
lsdev -Cc adapter |grep -i Available |sort |cat -n >>$XOUT 
echo "<p><br><br><br><strong>Adaptadores Defined</strong><br><br>" >>$XOUT 
lsdev -Cc adapter |grep -i Defined |sort |cat -n >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_103 - Storage 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_103'>Storage</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<H3><strong>SHARK</strong></H3>" >> $XOUT 
echo "<br><br><strong>Versao Device Driver</strong><br>" >> $XOUT 
lslpp -l |grep -i sdd  | tee -a  $XOUT 
echo "<br><br><BR>"  >> $XOUT 
for i in 2105 2145 2062 2107 1750; do lslpp -l |grep -i $i >> $XOUT; done;  >> $XOUT 
echo "<p><BR><br><br><br><strong>Devices</strong><br><br>" >> $XOUT 
datapath query device >> $XOUT 2>> $XOUT 
echo "<p><br><br><br><strong>Adaptadores </strong><br><br>">> $XOUT 
datapath query adapter >> $XOUT 2>> $XOUT 
echo "<p><br><br><br><strong>Relacao dos vpaths com hdisk</strong><br><br>" >> $XOUT 
lsvpcfg 2>> $XOUT |sort -th +1 -n |cat -n >> $XOUT 
echo "<p><br><br><br><strong>Detalhes dos vpaths com hdisk</strong><br>" >> $XOUT 
lssdd 2>> $XOUT 
echo "<p><BR><br><br><br><br><br><H3><strong>FastT / DS</strong></H3>" >> $XOUT 
echo "<br><br><strong>Versao Device Driver</strong><br><br>" >> $XOUT 
for i in SMclient SMagent SMruntime SMutil; do lslpp -l |grep -i $i >> $XOUT; done; >> $XOUT 
echo "<BR><br><br><br><br>RDAC<br><br><br>" >> $XOUT 
lslpp -l |grep devices.fcp.disk. >> $XOUT 
lslpp -l |grep devices.common.IBM.fc >> $XOUT 
lslpp -l |grep devices.pci.df1000f7 >> $XOUT 
lslpp -l |grep devices.pci.df1000f9 >> $XOUT 
echo "<p><br><br><br><br><br><strong>Path dos Discos</strong><br><br>" >> $XOUT 
for i in 0 1 2 3 4 5; do echo "<br>dar$i<br>" >> $XOUT; lsdev -C |grep -i dar$i >> $XOUT; fget_config -l dar$i >> $XOUT; echo "<br><br><br>" >> $XOUT; done; >> $XOUT 
echo "<br><br><strong>Detalhes Paths</strong><br><br>" >> $XOUT 
fget_config -Av >> $XOUT 
echo "<br><br><br><br><br><br><br><strong>Path Preferencial</strong><br><br>" >> $XOUT 
SMdevices >> $XOUT 2>> $XOUT 
echo "<p><BR><br><br><br><br><br><H3><strong>SSA</strong></H3><br>" >> $XOUT 
echo "<br><br><strong>Versao Device Driver</strong><br><br>" >> $XOUT 
lslpp -l |grep SSA >> $XOUT 
lslpp -l |grep devices.common.IBM.ssa >> $XOUT 
lslpp -l |grep devices.mca >> $XOUT 
echo "<p><br><br><br><strong>Adaptadores SSA </strong><br><br>" >> $XOUT 
lsdev -Cc adapter -t ssa && lsdev -C -t ssa160 -c adapter | sort  >> $XOUT 
echo "<p><br><br><br><strong>SSA RAID Array</strong><br><br>" >> $XOUT 
/usr/ssa/ssaraid/bin/ssaraid.smit lsdssaraid_cmd_to_exec >> $XOUT 
echo "<p><br><br><br><strong>Relacao SSA Discos Logicos para Fisicos</strong><br><br>" >> $XOUT 
for i in `lsdev -CS1 -t hdisk -sssar -F name`; do echo "$i" >> $XOUT; ssaxlate -l $i >> $XOUT; echo "<br><br>" >> $XOUT; done;  >> $XOUT 
echo "<p><br><br><br><strong>SSA Physical Disks definidos</strong><br><br>" >> $XOUT 
lsdev -C -c pdisk -s ssar -H >> $XOUT 
echo "<p><br><br><br><br><strong>SSA Logical Disks definidos</strong><br><br>" >> $XOUT 
lsdev -C -t hdisk -c disk -s ssar -H >> $XOUT 
echo "<p><BR><br><br><br><br><H3><strong>EMC</strong></H3>" >> $XOUT 
echo "<br><br><strong>Versao Device Driver</strong><br><br>" >> $XOUT 
lslpp -l |grep -i emc >> $XOUT 
lslpp -l |grep -i navi >> $XOUT 
echo "<p><BR><br><br><br><strong>Devices</strong><br><br>" >> $XOUT 
powermt display dev=all >> $XOUT 2>> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_104 - Adaptadores Defined 
#echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
#echo " <A NAME='PI_104'>Adaptadores Defined</A></H2> ">> $XOUT 
#echo "<PRE>" >>$XOUT 
#lsdev -C |grep -i Defined |sort |cat -n >>$XOUT 
#echo "</PRE>" >>$XOUT 
################ PI_105 - Adaptadores Hot Plug 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_105'>Adaptadores Hot Plug</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<p><BR><br><br><br><strong>Adaptadores PCI</strong>" >> $XOUT 
lsslot -c pci >>$XOUT 2>>$XOUT 
echo "<p><BR><br><br><br><strong>Slot Adaptadores</strong>" >> $XOUT 
lsslot -c slot >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_106 - Informa▒▒es LPAR 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_106'>Informa▒▒es LPAR</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<p><BR><br><br><br><strong>Sumario estatistica Hypervisor</strong>" >> $XOUT 
lparstat -h 1 1 >>$XOUT 2>>$XOUT 
echo "<p><BR><br><br><br><strong>Informa▒▒e Parti▒▒o</strong>" >> $XOUT 
lparstat -i >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_107 - CDROM /DVD 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_107'>Informa▒▒es CDROM /DVD</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsdev -C |grep -i cd >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_108 - Tipo de Hardware 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_108'>Tipo de Hardware</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
bootinfo -p >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_109 - Firmware Sysplanar 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_109'>Firmware Sysplanar</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsmcode >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_110 - Vers▒o SNMP 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_110'>Vers▒o SNMP</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
ls -l /usr/sbin/snmpd >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_111 - DUMP 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_111'>DUMP</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<br><br><strong>Localizacao DUMP (primario / secundario)</strong>" >> $XOUT 
sysdumpdev -l >>$XOUT 2>>$XOUT 
echo "<br><br>" >> $XOUT 
echo "<br><br><strong>DUMP gerado</strong>" >> $XOUT 
sysdumpdev -L >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_112 - CPU 32bits/64bits 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_112'>CPU 32bits/64bits</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<br><br><strong>Kernel utilizado</strong>" >> $XOUT 
ls -l /unix >>$XOUT 2>>$XOUT 
ls -l /usr/lib/boot/unix >>$XOUT 2>>$XOUT 
echo "<p><br><br><strong>Links Kernel</strong>" >> $XOUT 
ls -l /usr/lib/boot/unix* >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_113 - HACMP Configuration 4.* 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_113'>HACMP Configuration 4.* </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
echo "<strong>Servicos Ativos</strong><br>" >> $XOUT 
/usr/sbin/cluster/utilities/clshowsrv -a >>$XOUT 
echo "<p><br><br><br><br><strong>Configuracao de Network</strong><br>" >> $XOUT 
/usr/sbin/cluster/utilities/cllsnw >> $XOUT 
echo "<p>" >> $XOUT 
/usr/sbin/cluster/utilities/cllsif >> $XOUT 
echo "<p><br><br><br><br><strong>Configuracao Resource Group</strong><br>" >> $XOUT 
/usr/sbin/cluster/utilities/clshowres >> $XOUT 
echo "<p><br><br><br><br><strong>Status do Cluster</strong><br>" >> $XOUT 
/usr/sbin/cluster/utilities/cldump >> $XOUT 
echo "<p><br><br><br><strong>Log HACMP</strong><br>" >> $XOUT 
echo "--------- /tmp/hacmp.out ---------" >> $XOUT 
echo "<BR>"  >> $XOUT 
cat /tmp/hacmp.out >> $XOUT 2>>$XOUT 
echo "<p><br><br>" >> $XOUT 
echo "--------- /usr/es/adm/cluster.log ---------" >> $XOUT 
echo "<br><br>" >> $XOUT 
cat /usr/adm/cluster.log |grep -i `date |awk '{print $2}'` >> $XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_114 - Clock Processor 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_114'>Clock Processor</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
pmcycles -m >>$XOUT 2>>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_115 - Info Rede 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_115'>Info Rede</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsdev -Cc adapter |grep ent |awk '{print $1}' |while read REDE 
do 
echo "<BR>" >>$XOUT 2>>$XOUT 
echo "$REDE" >>$XOUT 2>>$XOUT 
netstat -v $REDE |grep Media >>$XOUT 2>>$XOUT 
echo "<BR><BR>" >>$XOUT 2>>$XOUT 
done 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<p><br><br><br><strong>Informacoes adaptadores de REDE:</strong><br>" >> $XOUT 
lsdev -Cc adapter |grep ent |awk '{print $1}' |while read REDE 
do 
echo "$REDE" >>$XOUT 2>>$XOUT 
entstat $REDE >>$XOUT 2>>$XOUT 
echo "<BR><BR>" >>$XOUT 2>>$XOUT 
done 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
echo "<p><br><br><br><strong>Informacoes adaptadores ETHERCHANNEL</strong><br>" >> $XOUT 
lsdev -Cc adapter |grep EtherChannel |awk '{print $1}' |while read REDE 
do 
echo "<BR>" >>$XOUT 2>>$XOUT 
echo "Adaptador EtherChannel: $REDE " 
echo "<BR>" >>$XOUT 2>>$XOUT 
entstat -d $REDE >>$XOUT 2>>$XOUT 
done 
echo "</PRE>" >>$XOUT 
################ PI_123 - VMSTAT 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_123'>VMSTAT</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
vmstat -v >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<PRE>" >>$XOUT 
vmstat 5 12 >>$XOUT 
echo "</PRE>" >>$XOUT 
################ PI_124 - Info HBA 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_124'>Info HBA</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsdev -Cc adapter |grep fcs |awk '{print $1}' |while read HBA 
do 
echo "<br><strong> Adaptador: $HBA </strong><br>" >>$XOUT 2>>$XOUT 
fcstat $HBA >>$XOUT 2>>$XOUT 
echo "<br>" >>$XOUT 2>>$XOUT 
done 
echo "</PRE>" >>$XOUT 
 
#################### 
## VIO Server 
#################### 
################ PI_116 - Dispositivos Virtuais 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_116'> Dispositivos Virtuais</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli lsdev -virtual >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_117 - Discos Virtuais 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_117'> Discos Virtuais</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli lsdev -type disk |grep -i virtual >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_118 - Adaptadores virtuais 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_118'> Adaptadores virtuais</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli lsdev -type adapter |grep -i virtual >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_119 - Licen▒a VIO 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_119'> Licen▒a VIO</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli license >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_120 - Todos os dispositivos Virtuais 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_120'> Lista de todas as controladoras virtuais e Mapeamentos </A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli lsmap -all >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_121 - Placas de redes virtuais 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_121'> Lista de todas as placas de redes virtuais SEA</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli lsmap -all -net >> $XOUT 
echo "</PRE>" >>$XOUT 
echo " <LI> Status Link interfaces dos clientes VIO" >> $XOUT 
echo "<PRE>" >>$XOUT 
netstat -cdlistats >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
################ PI_122 - Vers▒o VIO Server 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_122'>Vers▒o VIO Server</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
/usr/ios/cli/ioscli ioslevel >> $XOUT 
echo "</PRE>" >>$XOUT 
 
################ PI_130 - Ifconfig 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_130'>Ifconfig</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
ifconfig -a >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_125 - Info IBM.ManagementServer HMC 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_125'>Info IBM.ManagementServer HMC</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
lsrsrc IBM.ManagementServer >> $XOUT 
echo "</PRE>" >>$XOUT 
################ PI_126 - Uptime 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_126'>Uptime</A></H2> ">> $XOUT 
echo "<PRE>" >>$XOUT 
uptime >> $XOUT 
echo "</PRE>" >>$XOUT 
 
################ PI_127 - Variaveis de Ambiente 
echo " <HR><H2> [<A HREF='#_contents'><B>Indice</B></A>] ">>$XOUT 
echo " <A NAME='PI_127'>Variaveis de Ambiente</A></H2> ">> $XOUT 
echo " <LI> Profile /etc/profile " >> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/profile >> $XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Env - Displays the current environment or sets the environment for the execution of a command." >> $XOUT 
echo "<PRE>" >>$XOUT 
env >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR><br>" >> $XOUT 
echo " <LI> Environment /etc/environment" >> $XOUT 
echo "<PRE>" >>$XOUT 
cat /etc/environment >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
echo " <LI> Printenv - Displays the values of environment variables." >> $XOUT 
echo "<PRE>" >>$XOUT 
printenv >>$XOUT 
echo "</PRE>" >>$XOUT 
echo "<BR>" >> $XOUT 
################ RODAPE ################## 
echo "<BR><HR>">> $XOUT 
echo "<H5> <CENTER> Raio-X - $XVERSION </CENTER> </H5> ">> $XOUT 
echo "<H5> <CENTER>  ▒ Copyright - Service IT Solutions (011)3054-1400  </CENTER> </H5> ">> $XOUT 
echo "</BODY></HTML>">>$XOUT 
kill -9 $ROTATE_PID 
echo " " 
echo "Relat▒rio finalizado com sucesso!!! 
Um arquivo `hostname`.html foi gerado com as informa▒▒es do SERVER. 
Encaminhe a pessoal respons▒vel para que possa ser analisado." 
echo " " 
echo "Pressione <ENTER> para finalizar" 
read ENTER 
 
 
