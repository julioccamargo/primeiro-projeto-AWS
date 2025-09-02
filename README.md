# Projeto de Deploy de uma Aplicação WordPress na AWS com IaC

Este é o primeiro projeto prático do meu roadmap de estudos em DevOps, com o objetivo de construir e implantar uma aplicação web dinâmica (WordPress) de forma segura e escalável na AWS, utilizando infraestrutura como código.

---

## 🎯 Objetivo

O desafio era construir uma solução web escalável e segura na AWS, aplicando as melhores práticas de nuvem e Infrastructure as Code (IaC).

---

## 🛠️ Tecnologias Utilizadas

### Serviços AWS
* Amazon EC2 (Elastic Compute Cloud)
* Amazon RDS (Relational Database Service)
* Amazon S3 (Simple Storage Service)
* Amazon CloudFront
* Amazon VPC (incluindo Security Groups)
* Amazon Route 53
* AWS Certificate Manager (ACM)
* AWS IAM (Identity and Access Management)

### Ferramentas e aplicações
* WordPRess
* Terraform

---

## 🚀 Resultado Final

**Por se tratar de um projeto de portfólio para fins de estudo, a infraestrutura foi provisionada, validada e, em seguida, desmontada utilizando terraform destroy para aderir às melhores práticas de gerenciamento de custos na nuvem (FinOps)**

---

## 📂 Arquivos do Projeto

* Guia de execução [**aqui**](https://github.com/julioccamargo/artigos/blob/main/01-como-criar-site-estatico-aws.md)
* Arquivo [**main.tf**](main.tf) usado para IaC

## Desafios enfrentados e aprendizados adquiridos
**Debugging** - Houve um erro na implantação do DB, segue o informativo do passo a passo de como foi

Aplicação Dinâmica com Banco de Dados (DB) --- O MEU DEU ERRADO
Objetivo: Criar um banco de dados gerenciado e conectar a uma aplicação web (WordPress) para permitir conteúdo dinâmico. Serviços Principais: Amazon RDS (Relational Database Service), Amazon EC2.

* Criação do Banco de Dados → Lançar uma instância de banco de dados MySQL usando o serviço Amazon RDS, utilizando o template de Nível Gratuito.
* Configuração das Credenciais → Definir um usuário (padrão: admin), uma senha forte e um "Nome do banco de dados inicial" (usei wordpress_db). Atenção: Anotar a senha pra não vacilar.
* Configuração de Rede e Segurança → Criar um Security Group para o RDS, garantindo que a opção "Acesso Público" estivesse marcada como Não.
* Criação da Regra de Conexão → Utilizada a opção de "Configuração automática de conexão com EC2" fornecida pela AWS durante a criação do RDS. Isso automaticamente criou a regra de entrada no Security Group do RDS (tipo MYSQL/Aurora, porta 3306) permitindo acesso a partir do Security Group da instância EC2.
*Preparação do Servidor (Instalação de PHP e Cliente MySQL) 
    1. Instalar o PHP: Conectar no EC2 via SSH e instalar o PHP e os módulos necessários para o WordPress. sudo yum install -y php php-mysqlnd php-gd
    2. Instalar o Cliente MySQL (Etapa de Debugging): Foi necessário um processo de investigação para instalar a ferramenta de linha de comando mysql.
    3 Identificação do S.O.: O comando cat /etc/os-release revelou que o sistema era o Amazon Linux 2023.
    4 Busca do Pacote: Comandos para versões antigas (yum, amazon-linux-extras) falharam. A solução foi pesquisar o pacote correto com dnf search mariadb. 
    5 Instalação Correta: O pacote foi identificado como mariadb1011-client-utils e instalado com o comando: sudo dnf install mariadb1011-client-utils -y
* Download e Preparação do WordPress → Baixar, descompactar e mover os arquivos do WordPress para o diretório raiz do servidor web. cd /tmp wget https://wordpress.org/latest.tar.gz tar -xzf latest.tar.gz sudo cp -r /tmp/wordpress/* /var/www/html/
* Configuração do wp-config.php → Criar o arquivo de configuração a partir do exemplo e editá-lo com as informações do RDS. cd /var/www/html/ sudo cp wp-config-sample.php wp-config.php sudo nano wp-config.php As 4 linhas críticas foram preenchidas:   DB_NAME, DB_USER, DB_PASSWORD e DB_HOST (com o endpoint do RDS).
* Ajuste de Permissões de Arquivos → Definir o usuário apache como dono dos arquivos para permitir que o WordPress gerencie temas e plugins. sudo chown -R apache:apache /var/www/html/ sudo chmod -R 775 /var/www/html/
* Diagnóstico e Correção Final (Etapa de Debugging) → Após a configuração, o erro "Error establishing a database connection" apareceu.
* Teste de Conexão: A conexão direta com o banco via cliente MySQL (mysql -h [endpoint] -u admin -p) funcionou, provando que a Rede e as Credenciais estavam corretas. Causa: O comando SHOW DATABASES; dentro do banco revelou que o banco wordpress_db não havia sido criado na inicialização do RDS. Solução*: O banco de dados foi criado manualmente com o comando SQL: SQL CREATE DATABASE wordpress_db;
* Finalização da Instalação → Com o banco de dados criado, o acesso ao IP/domínio do site no navegador finalmente exibiu a tela de instalação de 5 minutos do WordPress, que foi preenchida para concluir o processo.

✅ Resultado: Uma aplicação WordPress totalmente funcional, rodando em uma arquitetura de nuvem segura e desacoplada (servidor web + banco de dados gerenciado), com todo o processo de diagnóstico e correção documentado.
