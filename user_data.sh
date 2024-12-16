sh
   #!/bin/bash
   set -e
   # Registrar a execução do script
   LOG_FILE="/var/log/user-data.log"
   exec > >(tee -a "$LOG_FILE" | logger -t user-data) 2>&1
   # Atualiza pacotes
   sudo dnf update -y
   # Instala Docker
   sudo dnf install -y docker
   sudo systemctl start docker
   systemctl enable docker
   # Adicionar o usuário 'ec2-user' ao grupo 'docker'
   sudo usermod -a -G docker ec2-user
   sudo chkconfig docker on
   # Baixa a última versão do Docker Compose 
   sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '\"tag_name\": \"\K.*?(?=\")')" -o /usr/local/bin/docker-compose 
   # Aplica permissões executáveis ao Docker Compose 
   sudo chmod +x /usr/local/bin/docker-compose
   # Instalar o cliente MySQL
   wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
   dnf install -y mysql80-community-release-el9-1.noarch.rpm
   rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
   dnf install -y mysql-community-client
