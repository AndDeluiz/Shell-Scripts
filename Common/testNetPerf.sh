#!/bin/bash

inputServerList=$1

myHostname=$(hostname)
myName=$(basename $0)
myLogName="${myName%.*}-$(date "+%Y%m%d%H%M%S").log"


exec 1> >(tee ${myLogName}) 2>&1

echo "================================================================================"
echo " Teste de Performance de Rede"
echo "================================================================================"
echo "Executado em: $(date)"
echo "Servidor: $myName"
echo "Aplicativo utilizado para testes: $(iperf3 --version | grep iperf)"
echo "Server Side Command: iperf3 -i 0 -D -s"
echo "Client Side Command: iperf3 -i 0 -w 4M -t 10 -c <iperf3_server>"
echo "--------------------------------------------------------------------------------"

while read SRV
do
   echo "$(date "+%Y-%m-%d %H:%M:%S") INFO: Testando servidor $SRV"
   iperf3 -i 0 -w 4M -t 10 -c $SRV
   echo "--------------------------------------------------------------------------------"
done < ${inputServerList}
