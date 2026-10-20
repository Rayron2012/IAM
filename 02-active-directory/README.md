# Fase 2 — Active Directory e LDAP

- [ ] Fase não concluída

Duração sugerida na trilha: **3–4 semanas**. Itens obrigatórios: **9**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Montar um domínio de verdade em casa e fazer com as próprias mãos o que você ainda não fez no trabalho: admissão, desligamento, OUs, GPOs e política de senha.

Depois do JML feito na interface, os modelos em PowerShell estão na fase 8: [scripts](../08-automacao/powershell/README.md). Eles esperam o domínio `labiam.local` e as OUs desta fase.

## Checklist

### Montar o lab: VirtualBox + Windows Server + domínio

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** O Active Directory Domain Services (AD DS) é o diretório on-premises mais usado no Brasil. O **controlador de domínio (DC)** guarda usuários, grupos e computadores e autentica todo mundo (Kerberos). Ter um DC em casa é o lab mais valioso que existe para IAM.

**Como estudar.** Siga o “Passo a passo” abaixo com calma: 2 a 3 sessões. Não pule os snapshots.

**Prática.**

Domínio `labiam.local` criado, com snapshot “DC promovido”.

**Pronto quando.** Você entra como `LABIAM\Administrador` e abre o `dsa.msc` mostrando o domínio.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: VirtualBox + Windows Server (avaliação) + Controlador de Domínio**.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Visão geral do AD DS](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)
- [PT] [Microsoft Learn: Instalar o AD DS (nível 100)](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- [PT] [Requisitos de hardware do Windows Server](https://learn.microsoft.com/pt-br/windows-server/get-started/hardware-requirements)

### Unidades Organizacionais (OUs) e delegação

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** OUs são “pastas” do AD que organizam objetos e servem para aplicar GPOs e **delegar administração** (ex.: o suporte do RH pode resetar senha só dos usuários da OU RH). OU não dá permissão de acesso a arquivos: quem faz isso são os grupos.

**Como estudar.** Leia o guia de delegação. Depois crie a estrutura no lab.

**Prática.**

Crie a estrutura `LABIAM > Usuarios > (TI, RH, Financeiro, Desligados)`, `Grupos`, `Computadores`, `ContasServico`. Use o *Assistente de Delegação de Controle* (botão direito na OU RH > Delegar controle) para dar ao grupo `GG-Suporte-RH` o direito de redefinir senhas só nessa OU.

**Pronto quando.** Um usuário do `GG-Suporte-RH` consegue resetar senha na OU RH e **não** consegue na OU TI.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Delegar a administração de OUs](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/plan/delegating-administration-of-account-ous-and-resource-ous)

### Grupos: segurança x distribuição, escopos e AGDLP

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Grupos de **segurança** dão permissão; de **distribuição** são só listas de e-mail. Escopos: Global (membros do próprio domínio), Domain Local (usados para dar permissão em recursos) e Universal (floresta). Boa prática clássica: **AGDLP**: contas em grupos Globais por função, que entram em grupos Domain Local de recurso, que recebem a permissão.

**Como estudar.** Leia sobre grupos de segurança e monte o exemplo AGDLP no lab. É exatamente a “mudança de grupo” que você já fez, só que agora entendendo o desenho.

**Prática.**

Crie a pasta compartilhada `\\DC01\Financeiro`; o grupo `DL-Financeiro-Leitura` recebe Leitura e o grupo `GG-Financeiro` entra no DL. Teste com um usuário do financeiro e com um do RH.

**Pronto quando.** Você explica AGDLP e por que não se dá permissão direto ao usuário.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Grupos de segurança do AD](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/manage/understand-security-groups)
- [PT] [Microsoft Learn: Contas e grupos privilegiados no AD](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/plan/security-best-practices/appendix-b--privileged-accounts-and-groups-in-active-directory)

### GPOs (Diretivas de Grupo)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** GPO é um conjunto de configurações aplicado a usuários/computadores de uma OU (bloquear painel de controle, mapear unidade, papel de parede, política de auditoria). Ordem de aplicação: Local, Site, Domínio, OU (LSDOU); a última vence, salvo “Imposto/Enforced”.

**Como estudar.** Leia a visão geral e use o `gpmc.msc` no lab. Tire snapshot antes.

**Prática.**

Crie a GPO “Bloqueio-Painel-Controle” vinculada à OU Financeiro; no cliente, rode `gpupdate /force` e `gpresult /r` para comprovar que ela foi aplicada.

**Pronto quando.** Você mostra no `gpresult` qual GPO foi aplicada e explica LSDOU.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Visão geral da Política de Grupo](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview)

### Política de senha, bloqueio e FGPP

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** A política de senha padrão do domínio fica na **Default Domain Policy** (tamanho, complexidade, histórico, bloqueio após X tentativas). Para regras diferentes por grupo (ex.: admins com 15+ caracteres) usa-se a **Política de Senha Refinada (FGPP)** pelo Centro Administrativo do AD.

**Como estudar.** Leia os dois artigos e configure no lab. Compare com as recomendações modernas do NIST (senhas longas, sem troca forçada periódica sem motivo).

**Prática.**

Configure: mínimo de 12 caracteres e bloqueio após 5 tentativas no domínio; FGPP de 16 caracteres para o grupo `GG-Admins-TI`. Teste errando a senha e desbloqueie a conta.

**Pronto quando.** Você mostra a FGPP aplicada a um admin (`Get-ADUserResultantPasswordPolicy`) e desbloqueia uma conta.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Política de senha (configurações)](https://learn.microsoft.com/pt-br/previous-versions/windows/it-pro/windows-10/security/threat-protection/security-policy-settings/password-policy)
- [PT] [Microsoft Learn: Políticas de senha refinadas (FGPP)](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/get-started/adac/fine-grained-password-policies)

### JML completo no AD (a sua maior lacuna, agora na prática)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Aqui você executa o ciclo inteiro: **admissão** (criar conta na OU certa com atributos, senha inicial com troca obrigatória e grupos do cargo), **movimentação** (remover os grupos antigos antes de adicionar os novos) e **desligamento** (desabilitar, remover grupos, mover para a OU Desligados, registrar data e chamado, excluir só depois do prazo de retenção).

**Como estudar.** Faça primeiro pela interface (`dsa.msc`) e depois por PowerShell (fase 8). Simule um “chamado” para cada ação: escreva o número fictício do chamado no campo Descrição do usuário.

**Prática.**

Admita 3 pessoas (RH, Financeiro, TI), mova 1 do RH para o Financeiro e desligue 1. Para cada ação, registre num documento: chamado, aprovador, data, o que foi feito e um print (evidência).

**Pronto quando.** Você tem um “dossiê de evidências” de 3 admissões, 1 movimentação e 1 desligamento, e consegue explicar cada passo numa entrevista.

**Recursos gratuitos**

- [PT] [PowerShell New-ADUser (pt-BR)](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/new-aduser)
- [PT] [PowerShell Disable-ADAccount](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/disable-adaccount)
- [PT] [PowerShell Add-ADGroupMember](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/add-adgroupmember)

### LDAP na prática: DN, atributos e consultas

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** LDAP é o protocolo para consultar e alterar diretórios. Todo objeto tem um **DN** (ex.: `CN=Ana Teste,OU=RH,OU=Usuarios,DC=labiam,DC=local`) e atributos (`sAMAccountName`, `mail`, `memberOf`, `userAccountControl`). Aplicações usam LDAP/LDAPS (porta 389/636) para autenticar contra o AD.

**Como estudar.** Leia a introdução do ldap.com com a tradução do navegador e use o `ldp.exe` no DC.

**Prática.**

No DC, abra `ldp.exe` > Conexão > Ligar (bind) > Exibir > Árvore. Depois, no PowerShell: `Get-ADUser -LDAPFilter "(&(objectClass=user)(department=RH))"` e liste quem está no grupo de admins com `Get-ADGroupMember "Domain Admins"`.

**Pronto quando.** Você lê um DN, explica cada parte e escreve um filtro LDAP simples.

**Recursos gratuitos**

- [EN] [LDAP.com: conceitos básicos](https://ldap.com/)
- [PT] [PowerShell Get-ADUser (filtros LDAP)](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/get-aduser)

### Kerberos e NTLM (o que acontece no logon)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** No domínio, o logon usa **Kerberos**: o usuário recebe um TGT do KDC (no DC) e depois tickets de serviço (TGS) para cada recurso. O NTLM é o protocolo antigo, ainda usado como fallback. Do SOC você já conhece os ataques (Kerberoasting, pass-the-hash); aqui o foco é entender o funcionamento normal.

**Como estudar.** Leia a visão geral e rode `klist` no cliente depois de acessar a pasta compartilhada.

**Prática.**

No PC01, rode `klist`, acesse `\\DC01\Financeiro` e rode `klist` de novo para ver o novo ticket do serviço `cifs/DC01`.

**Pronto quando.** Você desenha o fluxo TGT → TGS → serviço e explica por que o relógio fora de sincronia quebra o Kerberos.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Visão geral da autenticação Kerberos](https://learn.microsoft.com/pt-br/windows-server/security/kerberos/kerberos-authentication-overview)

### Auditoria de identidade no AD (eventos que o IAM acompanha)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** IAM e SOC se encontram aqui. Eventos importantes: **4720** (usuário criado), **4722/4725** (habilitado/desabilitado), **4726** (excluído), **4728/4732/4756** (membro adicionado a grupo global/local/universal), **4740** (conta bloqueada), **4624/4625** (logon com sucesso/falha). Eles são a evidência de auditoria do JML.

**Como estudar.** Leia sobre política de auditoria e confira os eventos gerados pelo seu JML no Visualizador de Eventos.

**Prática.**

Ative a auditoria de gerenciamento de contas numa GPO, repita uma admissão e um desligamento e encontre os eventos 4720, 4725 e 4728 no log *Segurança*.

**Pronto quando.** Você mostra o evento que prova quem adicionou um usuário a um grupo e quando.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Políticas básicas de auditoria](https://learn.microsoft.com/pt-br/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/basic-security-audit-policies)
- [PT] [Microsoft Learn: Práticas recomendadas para proteger o AD](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/plan/security-best-practices/best-practices-for-securing-active-directory)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. Qual a diferença entre OU e grupo?</summary>

A OU organiza objetos, recebe GPO e permite delegar administração. O grupo é usado para dar permissões e acessos.

</details>

<details>
<summary>2. Na movimentação de área, o que deve acontecer antes de dar os novos acessos?</summary>

Remover os acessos da área antiga (para evitar acúmulo de privilégios), com aprovação do novo gestor.

</details>

<details>
<summary>3. Quais passos mínimos de um desligamento no AD?</summary>

Desabilitar a conta, resetar a senha, remover grupos (guardando o registro), mover para a OU Desligados, registrar chamado e data, e excluir após o prazo de retenção.

</details>

<details>
<summary>4. O que é FGPP?</summary>

Fine-Grained Password Policy: política de senha diferente para grupos específicos (ex.: admins), configurada no Centro Administrativo do AD.

</details>

<details>
<summary>5. Qual evento mostra que um usuário foi adicionado a um grupo global de segurança?</summary>

4728 (4732 para grupo local e 4756 para universal).

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 2

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

> No domínio labiam.local eu fiz admissão, movimentação e desligamento. A evidência foi o chamado fictício e o evento ...
````

[Início](../README.md) · [Fase 1](../01-fundamentos/README.md) · [Fase 3](../03-microsoft-entra-id/README.md)
