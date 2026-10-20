# PowerShell de JML — laboratório

Modelos para a fase 8, usados depois do JML feito na mão na fase 2. Todos os dados são da empresa fictícia **LabIAM**. Rode só num domínio isolado `labiam.local`, depois de um snapshot.

Os scripts recusam outro domínio. A senha inicial é digitada na execução, não fica no CSV e não vai para o log. A primeira execução de cada um deve ser com `-WhatIf`.

## Ordem

No controlador de domínio, em PowerShell aberto **como o script** (não cole com ponto na frente):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
cd C:\lab\08-automacao\powershell

.\Prepara-EstruturaLab.ps1 -WhatIf
.\Prepara-EstruturaLab.ps1

.\Novo-UsuariosLab.ps1 -CaminhoCsv .\usuarios-joiner.csv -WhatIf
.\Novo-UsuariosLab.ps1 -CaminhoCsv .\usuarios-joiner.csv

.\Move-UsuariosLab.ps1 -CaminhoCsv .\usuarios-mover.csv -WhatIf
.\Move-UsuariosLab.ps1 -CaminhoCsv .\usuarios-mover.csv

.\Disable-UsuariosLab.ps1 -CaminhoCsv .\usuarios-leaver.csv -WhatIf
.\Disable-UsuariosLab.ps1 -CaminhoCsv .\usuarios-leaver.csv
```

| Arquivo | Papel |
| --- | --- |
| `Prepara-EstruturaLab.ps1` | Cria OUs e grupos, inclusive o aninhamento AGDLP de exemplo. Não cria usuário. |
| `Novo-UsuariosLab.ps1` | Joiner. Lê o CSV e cria quem ainda não existe. |
| `Move-UsuariosLab.ps1` | Mover. Remove o grupo antigo, adiciona o novo e só então muda a OU. |
| `Disable-UsuariosLab.ps1` | Leaver. Desabilita, tira os grupos, troca a senha sem registrar o valor e move para `OU=Desligados`. Não exclui. |
| `usuarios-*.csv` | Dez admissões, uma movimentação e dois desligamentos, todos fictícios. Separador `;`, para abrir no Excel em português. |

O log cai em `logs/`, que o Git ignora. Não commite esse log se um dia o CSV deixar de ser fictício.

A OU `Comercial` não está no desenho mínimo da fase 2. Ela existe aqui para o CSV de exemplo ter uma quarta área.

O grupo de recurso do Financeiro se chama `DL-FIN-Leitura`, não `DL-Financeiro-Leitura`. O `sAMAccountName` do AD aceita no máximo 20 caracteres, e o nome longo do exercício passa disso. A função é a mesma: grupo domain local que recebe a permissão, com o grupo global dentro.

## O que continua manual na fase 2

Delegação de reset de senha, GPO, pasta compartilhada e FGPP não estão nestes scripts. O grupo `GG-Suporte-RH` e o grupo `GG-Admins-TI` existem vazios para esses exercícios.

## CSV de admissão

`SamAccountName;Nome;Sobrenome;Departamento;Cargo;OU;Grupos;Matricula;Chamado`

A OU `OU=RH` vira `OU=RH,OU=Usuarios,DC=labiam,DC=local`. O e-mail e o UPN são montados como `sam@labiam.local`, de propósito, para o arquivo não carregar e-mail de fora. A matrícula fictícia tem quatro dígitos. Onze dígitos são recusados porque parecem CPF.
