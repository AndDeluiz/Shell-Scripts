#!/bin/bash
################################################################

rm -f checklist.bash

echo "#!/bin/bash"		> checklist.bash
echo "################################################################" >> checklist.bash
cat echo_zbksh			>> checklist.bash
cat execl_zbksh			>> checklist.bash
cat stdout_zbksh		>> checklist.bash
cat stderr_zbksh		>> checklist.bash
cat csvout_zbksh		>> checklist.bash
cat htmlout_zbksh		>> checklist.bash
cat mkheader_zbksh		>> checklist.bash
cat mkfooter_zbksh		>> checklist.bash
cat tablehead_zbksh		>> checklist.bash
cat configcmd_zbksh		>> checklist.bash
cat usagemsg_verifycmd_zbksh	>> checklist.bash
cat verifycmd_zbksh		>> checklist.bash
cat checklist.zbksh		>> checklist.bash

chmod 755 checklist.bash
