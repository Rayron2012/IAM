# Segurança deste repositório

Este portfólio pode ser lido por qualquer pessoa: recrutador, colega ou desconhecido. Trate cada commit como publicação.

## O que nunca entra no Git

- Senhas, tokens, client secrets, access keys, connection strings, cookies e exports do Keycloak, do Entra ou da AWS que carreguem segredo.
- Arquivos `.env`, `.pem`, `.key`, `.pfx`, `.p12` e chaves de SSH. O `.gitignore` cobre os casos comuns; ele não substitui a revisão antes do commit.
- Dado real de empresa: nome de servidor, IP interno, print de console corporativo, playbook, número de chamado real, log de SIEM ou de qualquer ferramenta de trabalho.
- Dado pessoal: CPF, RG, nome real de colega, cliente ou usuário, e-mail pessoal ou corporativo, telefone, matrícula real e foto de crachá.
- Planilha de RH, dump de Active Directory, export de usuários do Entra e backup de banco, mesmo que seja “só para testar o script”.

Os CSVs, o SQL e as políticas deste repositório usam a empresa fictícia **LabIAM** e pessoas fictícias (`ana.teste`, `bruno.exemplo` e outras). Não troque esses exemplos por dados verdadeiros.

## Prints e evidências

Antes de salvar uma imagem em `laboratorio/evidencias/`:

- Cubra nome de tenant, ID de assinatura, e-mail, nome de pessoa e qualquer identificador que não seja do laboratório.
- Prefira o tenant de estudo, o domínio `labiam.local` e usuários fictícios.
- Se o print mostrar senha temporária, client secret ou access key, não publique. Gere outro print com o valor oculto.

## Laboratório isolado

- Rode os scripts PowerShell só no domínio de estudo, depois de um snapshot da VM. Os scripts recusam um domínio diferente de `labiam.local`, a menos que você altere o parâmetro de propósito.
- O Keycloak deste repositório usa `start-dev`, sem HTTPS, com usuário inicial `admin`. A porta está presa em `127.0.0.1`. Não mude o bind para `0.0.0.0` e não exponha essa instância na rede.
- A conta da AWS e o tenant do Entra usados aqui são de estudo. Ative alerta de custo e apague o que não estiver usando.
- A senha inicial dos scripts é digitada na hora. Ela não fica no código, no CSV nem no log.

## Se um segredo escapar

Apagar o arquivo no commit seguinte não apaga o histórico. Se uma chave chegar ao Git:

1. Revogue ou gire a credencial na hora (access key na AWS, client secret no Entra ou no Keycloak, senha no AD de laboratório).
2. Só então limpe o histórico, se ainda for necessário.
3. Não conte só com o aviso automático do GitHub.

## Uso de IA

Pode usar IA para rascunhar um script, explicar um erro ou gerar dado fictício. Não cole log de empresa, token, senha nem dado pessoal. Leia o resultado e teste com `-WhatIf` no laboratório antes de confiar.
