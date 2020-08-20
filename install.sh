#!/bin/sh
# Install apel parser
PXE_URL="http://152.84.101.190"

# Apel instructions:
#
# Apel client, parsers and depencies (https://apel.github.io/downloads/)
# Instalation from github was required because el7 version of argo-ms (dependency for apel-ssm) wasn't submited to el7, UMD nor CMD at this moment (11-21-2019)

yum install -y http://rpm-repo.argo.grnet.gr/ARGO/prod/centos7/argo-ams-library-0.4.2-1.el7.noarch.rpm \
               https://github.com/apel/ssm/releases/download/2.4.1-1/apel-ssm-2.4.1-1.el7.noarch.rpm

yum install -y https://github.com/apel/apel/releases/download/1.8.2-1/apel-client-1.8.2-1.el7.noarch.rpm \
               https://github.com/apel/apel/releases/download/1.8.2-1/apel-lib-1.8.2-1.el7.noarch.rpm \
               https://github.com/apel/apel/releases/download/1.8.2-1/apel-parsers-1.8.2-1.el7.noarch.rpm

yum install -y   htcondor-ce-apel

# Parser config file
wget -O - $PXE_URL/config/files/apelparser-ce.cfg >  /etc/apel/parser.cfg
wget -O - $PXE_URL/config/files/apelparser-batch.cfg >  /etc/apel/parser.cfg

# Crontab accounting script
echo '#!/bin/bash' > /root/accounting.sh
echo "/usr/share/condor-ce/condor_blah.sh    # Make the blah file (CE/Security data)" >> /root/accounting.sh
echo "/usr/share/condor-ce/condor_batch.sh      # Make the batch file (batch system job run times)" >> /root/accounting.sh
echo "/usr/bin/apelparser                # Read the blah and batch files in" >> /root/accounting.sh

# exec
chmod +x /root/accounting.sh

# Crontab entrie
echo "0 0   *       /root/accounting.sh" > /etc/cron.d/accounting

# On apelclient machine (cream-ce.cat.cbpf.br)
#    GRANT ALL PRIVILEGES ON apelclient.* TO 'apel'@'batch01.fqdn' IDENTIFIED BY 'password';
#    FLUSH PRIVILEGES;
#    GRANT ALL PRIVILEGES ON apelclient.* TO 'apel'@'batch02.fqdn IDENTIFIED BY 'password';
#    FLUSH PRIVILEGES;
#   SELECT User, Host FROM mysql.user;
