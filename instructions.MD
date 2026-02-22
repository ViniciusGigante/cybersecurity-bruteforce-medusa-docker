# 🚀 Guia de Instalação e Acesso

Siga as instruções abaixo para configurar o ambiente e acessar o terminal de ataque.

## 1. Clonagem do Repositório
Abra o terminal em sua máquina e execute:

git clone https://github.com/ViniciusGigante/cybersecurity-bruteforce-medusa-docker.git
cd cybersecurity-bruteforce-medusa-docker

## 2. Inicialização da Infraestrutura
Certifique-se de que o Docker e o Docker Compose estão instalados e rodando. Em seguida, suba os containers:

docker-compose up -d --build

## 3. Acesso ao Terminal do Atacante (Kali Linux)
Com os containers ativos, utilize o comando abaixo para entrar no terminal interativo do Kali Linux. É a partir daqui que todas as ferramentas de auditoria serão executadas:

docker exec -it atacante bash

### Resultado esperado
O usuário deve ver isto ao entrar no terminal do kali-linux:


┌──(root㉿a876981e7690)-[~]
└─# 


## 4. Encerrando o Laboratório
Para sair do container, digite 'exit'. Para remover toda a estrutura de rede e containers criados, execute:

docker-compose down