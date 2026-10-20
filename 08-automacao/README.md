# Fase 8 — Automação

- [ ] Fase não concluída

Duração sugerida na trilha: **3 semanas**. Itens obrigatórios: **6**. Opcionais: **1**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Fazer em minutos o que levaria horas: JML em massa, relatórios de acesso, consultas de auditoria e chamadas de API, usando IA como ajudante e não como muleta.

Use os modelos desta pasta: [powershell/README.md](powershell/README.md) e [sql/README.md](sql/README.md). O rascunho de script no checklist deixa `-WhatIf` fixo, então ele não cria usuário. No exemplo de REST, a senha `admin` é só a do Keycloak em `127.0.0.1`. Não reutilize essa chamada contra outro host.

## Checklist

### PowerShell do zero

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** PowerShell trabalha com **objetos**, não texto: `Get-` lê, `Set-` altera, `New-` cria, `Remove-` apaga; o pipe `|` passa objetos adiante; `Where-Object` filtra; `Select-Object` escolhe colunas; `Export-Csv` gera relatório. Para IAM, é a linguagem nº 1 em ambiente Microsoft.

**Como estudar.** Faça a série PowerShell 101 (em português), 1 capítulo por sessão, sempre testando no DC do lab.

**Prática.**

Escreva comandos que: listam serviços parados; listam usuários desabilitados do AD; exportam membros de um grupo para CSV.

**Pronto quando.** Você usa `Get-Help` e `Get-Member` para descobrir sozinho como um comando funciona.

**Recursos gratuitos**

- [PT] [Microsoft Learn: PowerShell 101](https://learn.microsoft.com/pt-br/powershell/scripting/learn/ps101/00-introduction)
- [PT] [Microsoft Learn: Instalar o PowerShell no Windows](https://learn.microsoft.com/pt-br/powershell/scripting/install/install-powershell-on-windows)

### JML em massa no AD a partir de CSV

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Admissão e desligamento em massa são tarefas comuns: o RH manda uma planilha e o IAM processa. Um script bom **valida** os dados, tem modo de **teste** (`-WhatIf`), registra **log** e nunca tem senha escrita no código.

**Como estudar.** Use os cmdlets do módulo ActiveDirectory. Sempre tire snapshot e rode primeiro com `-WhatIf`.

**Prática.**

Crie `admissoes.csv` (Nome,Sobrenome,Login,Departamento,Cargo) com 10 pessoas fictícias e um script como:

```powershell
Import-Csv .\admissoes.csv | ForEach-Object {
  $ou = "OU=$($_.Departamento),OU=Usuarios,DC=labiam,DC=local"
  New-ADUser -Name "$($_.Nome) $($_.Sobrenome)" -SamAccountName $_.Login `
    -Department $_.Departamento -Title $_.Cargo -Path $ou `
    -AccountPassword (Read-Host -AsSecureString "Senha inicial") `
    -ChangePasswordAtLogon $true -Enabled $true -WhatIf
}
```

Depois, faça o script de desligamento (desabilitar, tirar grupos, mover OU, gravar log).

**Pronto quando.** Seu script cria 10 usuários na OU certa, desliga 2 e gera um log CSV com data e ação.

**Recursos gratuitos**

- [PT] [Módulo ActiveDirectory (referência)](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/)
- [PT] [New-ADUser](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/new-aduser)

### Microsoft Graph PowerShell (Entra ID)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** O **Microsoft Graph** é a API do Microsoft 365/Entra. O módulo **Microsoft Graph PowerShell** substituiu os antigos módulos AzureAD e MSOnline (descontinuados). Você conecta pedindo só os **escopos** necessários (menor privilégio também no script).

**Como estudar.** Instale o módulo, conecte no seu tenant de lab e explore. Use também o Graph Explorer no navegador.

**Prática.**

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "User.Read.All","Group.Read.All"
Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled |
  Select DisplayName,UserPrincipalName,AccountEnabled | Export-Csv usuarios-entra.csv
```

Gere também a lista de membros do grupo `GG-Financeiro`.

**Pronto quando.** Você tira do Entra um relatório de usuários e grupos sem usar o portal.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Instalar o Microsoft Graph PowerShell](https://learn.microsoft.com/pt-br/powershell/microsoftgraph/installation)
- [PT] [Microsoft Learn: Introdução ao Graph PowerShell](https://learn.microsoft.com/pt-br/powershell/microsoftgraph/get-started)
- [EN] [Graph Explorer](https://developer.microsoft.com/en-us/graph/graph-explorer)

### APIs REST na prática (Keycloak e Graph)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Quase toda integração de IAM é uma API REST: método (GET, POST, PUT, PATCH, DELETE), URL, cabeçalhos (`Authorization: Bearer <token>`), corpo JSON e código de resposta (200, 201, 401 não autenticado, 403 sem permissão, 404). Saber ler isso resolve metade dos chamados de integração.

**Como estudar.** Use o Hoppscotch (navegador, grátis) ou o Postman. Pratique contra o seu Keycloak local.

**Prática.**

No PowerShell, pegue um token admin do Keycloak de lab e liste usuários:

```powershell
$t = Invoke-RestMethod -Method Post http://localhost:8080/realms/master/protocol/openid-connect/token `
  -Body @{client_id="admin-cli"; grant_type="password"; username="admin"; password="admin"}
Invoke-RestMethod http://localhost:8080/admin/realms/labiam/users `
  -Headers @{Authorization = "Bearer $($t.access_token)"}
```

Depois crie um usuário com POST e desative com PUT (`"enabled": false`).

**Pronto quando.** Você explica a diferença entre 401 e 403 e faz um CRUD de usuário pela API.

**Recursos gratuitos**

- [EN] [Hoppscotch (cliente de API no navegador)](https://hoppscotch.io/)
- [EN] [Postman (download)](https://www.postman.com/downloads/)
- [PT] [Microsoft Graph: listar usuários (API)](https://learn.microsoft.com/pt-br/graph/api/user-list)

### SQL para auditoria de permissões

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Você já sabe SQL: agora aplique a IAM. Consultas típicas: desligados com conta ativa, contas órfãs, quem tem acesso privilegiado, conflitos de SoD e contas sem login há 90 dias. Bancos também têm permissões próprias (logins, usuários, roles, GRANT/REVOKE) que entram em auditoria.

**Como estudar.** Use SQLite + DB Browser (grátis, leve) ou o SQL Server Express. Importe CSVs fictícios.

**Prática.**

Tabelas `rh(matricula,nome,status,area)`, `contas(login,matricula,ativa,ultimo_login)`, `acessos(login,perfil)`, `sod(perfil_a,perfil_b)`. Consultas:

```sql
-- desligados com conta ativa
SELECT c.login FROM contas c JOIN rh r ON r.matricula=c.matricula
WHERE r.status='DESLIGADO' AND c.ativa=1;
-- contas órfãs
SELECT c.login FROM contas c LEFT JOIN rh r ON r.matricula=c.matricula
WHERE r.matricula IS NULL;
-- conflitos de SoD
SELECT a1.login, s.perfil_a, s.perfil_b FROM sod s
JOIN acessos a1 ON a1.perfil=s.perfil_a
JOIN acessos a2 ON a2.perfil=s.perfil_b AND a2.login=a1.login;
```

**Pronto quando.** Você roda as 4 consultas, gera um relatório e explica cada achado como faria para um auditor.

**Recursos gratuitos**

- [EN] [DB Browser for SQLite](https://sqlitebrowser.org/)
- [PT] [Microsoft Learn: Permissões do mecanismo de banco de dados](https://learn.microsoft.com/pt-br/sql/relational-databases/security/authentication-access/getting-started-with-database-engine-permissions)
- [PT] [SQL Server Express (download)](https://www.microsoft.com/pt-br/sql-server/sql-server-downloads)

### Python para cruzar listas (opcional)

- [ ] Opcional. Não conta para o marco da fase. Tem prática de laboratório.

**Conceito.** Com Python básico + a biblioteca `csv` (ou pandas) você automatiza a reconciliação RH x AD x Entra e gera relatórios. É um bom diferencial, mas o PowerShell vem antes em ambiente Microsoft.

**Como estudar.** Use o tutorial oficial em português só para relembrar; depois resolva o exercício.

**Prática.**

Script que lê `rh.csv` e `contas.csv` e gera `achados.csv` com órfãs e desligados ativos.

**Pronto quando.** Seu script roda e produz o mesmo resultado das consultas SQL.

**Recursos gratuitos**

- [PT] [Tutorial oficial do Python (pt-BR)](https://docs.python.org/pt-br/3/tutorial/)
- [EN] [Python (download)](https://www.python.org/downloads/)

### IA como assistente de automação (com segurança)

- [ ] Obrigatório.

**Conceito.** Há vagas que já pedem “automação assistida por IA”. Uso bom: pedir um rascunho de script, explicar um erro, revisar uma política JSON, gerar dados fictícios. Uso proibido: colar dados reais, logs da empresa, tokens ou senhas. Você sempre **entende e testa** o que a IA gerou antes de rodar, em lab e com `-WhatIf`.

**Como estudar.** Pratique pedindo à IA scripts para o seu lab e revise linha por linha. Anote no GitHub o que precisou corrigir.

**Prática.**

Peça a uma IA um script de “relatório de usuários sem login há 90 dias” para o AD, encontre pelo menos 1 problema ou melhoria, corrija e documente.

**Pronto quando.** Você explica numa entrevista como usa IA no trabalho sem expor dados.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise: 'boas práticas uso de IA generativa segurança da informação dados sensíveis'

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. O que faz o parâmetro -WhatIf?</summary>

Mostra o que o comando faria, sem executar. É obrigatório testar com ele antes de alterações em massa.

</details>

<details>
<summary>2. Qual módulo substitui AzureAD/MSOnline?</summary>

O Microsoft Graph PowerShell (Connect-MgGraph).

</details>

<details>
<summary>3. API respondeu 403. O que significa?</summary>

Você está autenticado, mas sem permissão para aquela ação (falta escopo ou role). 401 é não autenticado.

</details>

<details>
<summary>4. Escreva a ideia da consulta de contas órfãs.</summary>

LEFT JOIN de contas com RH pela matrícula, filtrando onde o RH é nulo.

</details>

<details>
<summary>5. O que nunca colar numa IA pública?</summary>

Dados pessoais reais, logs da empresa, senhas, tokens e chaves.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 8

## Objetivo

O que este laboratório demonstra.

## Ambiente

- Ferramenta e versão:
- Onde rodou (VM isolada, tenant de estudo ou container em 127.0.0.1):
- Confirmação de que não é produção:

## Passos

1.
2.
3.

## Prints e evidências

| Arquivo | O que mostra, sem dado real |
| --- | --- |
| `evidencias/exemplo.png` | |

## O que aprendi

-

## O que deu errado

-

## Aplicação em vaga

Escreva em primeira pessoa, no passado, só com o que aconteceu no laboratório. Não descreva como trabalho em produção.

> O script de laboratório, com -WhatIf, fez ... e a consulta SQL achou ...
````

[Início](../README.md) · [Fase 7](../07-cloud-iam/README.md) · [Fase 9](../09-compliance/README.md)
