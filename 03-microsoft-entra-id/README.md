# Fase 3 — Microsoft Entra ID

- [ ] Fase não concluída

Duração sugerida na trilha: **3 semanas**. Itens obrigatórios: **9**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Levar o que você aprendeu no AD para a nuvem: usuários e grupos no Entra, MFA, acesso condicional, SSO de aplicativos, revisões de acesso e PIM.

## Checklist

### Conseguir um tenant de estudo (sem usar o da empresa)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Tenant é a “instância” do Entra ID de uma organização. Para estudar você precisa do seu próprio. O plano **Free** não custa nada; P1 e P2 são pagos, mas têm avaliação temporária.

**Como estudar.** Siga o “Passo a passo” abaixo. Ele explica a situação real do sandbox M365, que hoje tem acesso restrito.

**Prática.**

Tenant criado, admin de lab com MFA, orçamento de US$ 1 com alerta.

**Pronto quando.** Você entra no entra.microsoft.com com o `admin.lab` usando MFA.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: conseguir um tenant do Microsoft Entra ID para estudar**.

**Recursos gratuitos**

- [PT] [Conta gratuita do Azure (página oficial)](https://azure.microsoft.com/pt-br/pricing/purchase-options/azure-account)
- [PT] [Microsoft Learn: Licenciamento do Microsoft Entra (Free x P1 x P2)](https://learn.microsoft.com/pt-br/entra/fundamentals/licensing)
- [PT] [Microsoft Learn: Limite de gastos do Azure](https://learn.microsoft.com/pt-br/azure/cost-management-billing/manage/spending-limit)

### Usuários, grupos e funções administrativas no Entra

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** No Entra existem usuários membros e convidados (B2B), grupos de segurança e Microsoft 365, e **funções de diretório** (Administrador Global, Administrador de Usuários, Administrador de Suporte Técnico…). Menor privilégio aqui é não dar Administrador Global para quem só reseta senha.

**Como estudar.** Leia os 2 guias e repita no Entra o mesmo desenho de áreas do seu AD.

**Prática.**

Crie 6 usuários, 3 grupos de segurança e dê a um usuário a função “Administrador de Suporte Técnico” (Helpdesk Administrator). Teste o que ele consegue e o que não consegue fazer.

**Pronto quando.** Você explica a diferença entre um grupo e uma função administrativa no Entra.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Criar ou excluir usuários](https://learn.microsoft.com/pt-br/entra/fundamentals/how-to-create-delete-users)
- [PT] [Microsoft Learn: Gerenciar grupos](https://learn.microsoft.com/pt-br/entra/fundamentals/how-to-manage-groups)

### MFA e Padrões de Segurança

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Os **Padrões de Segurança** (security defaults) ligam o MFA para todos de graça, no plano Free. É o mínimo para qualquer tenant. O MFA “por usuário” é legado; o caminho moderno é Padrões de Segurança ou Acesso Condicional.

**Como estudar.** Leia sobre padrões de segurança e ative no lab (passo 9 do guia).

**Prática.**

Ative os Padrões de Segurança e registre MFA em 2 usuários de teste. Veja o registro em *Entra ID > Métodos de autenticação*.

**Pronto quando.** Você explica quando usar Padrões de Segurança e quando usar Acesso Condicional.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Padrões de segurança](https://learn.microsoft.com/pt-br/entra/fundamentals/security-defaults)
- [PT] [Microsoft Learn: Como o MFA funciona](https://learn.microsoft.com/pt-br/entra/identity/authentication/concept-mfa-howitworks)

### Acesso Condicional (com avaliação P1/P2)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Acesso Condicional são regras “**se** (usuário, app, local, dispositivo, risco) **então** (exigir MFA, bloquear, exigir dispositivo em conformidade)”. É o coração do Zero Trust no Microsoft 365. Exige licença P1; boas práticas: **modo Somente relatório** primeiro e **excluir a conta de emergência**.

**Como estudar.** Leia a visão geral e o modelo de política “exigir MFA”. Ative a avaliação só quando for fazer este item, para aproveitar os 30 dias.

**Prática.**

Crie 2 políticas em Somente relatório: (1) exigir MFA para todos, exceto breakglass; (2) bloquear login de fora do Brasil (Locais nomeados). Analise os logs de entrada e depois ative a 1.

**Pronto quando.** Você explica por que nunca se cria uma política de bloqueio sem excluir a conta de emergência.

**Recursos gratuitos**

- [PT] [Microsoft Learn: O que é o Acesso Condicional](https://learn.microsoft.com/pt-br/entra/identity/conditional-access/overview)
- [PT] [Microsoft Learn: Política exigindo MFA para todos](https://learn.microsoft.com/pt-br/entra/identity/conditional-access/policy-all-users-mfa-strength)
- [PT] [Microsoft Learn: Modo somente relatório](https://learn.microsoft.com/pt-br/entra/identity/conditional-access/concept-conditional-access-report-only)

### SSO de aplicativo empresarial (SAML) no Entra

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** No Entra, cada app integrado vira um **Aplicativo empresarial**. Com SSO SAML, o Entra é o IdP e o app é o SP: o usuário entra uma vez e acessa o app sem nova senha. A Microsoft tem um app de teste, o **Microsoft Entra SAML Toolkit**, feito para treinar isso.

**Como estudar.** Siga o tutorial oficial do SAML Toolkit. Faça com calma: é o lab que mais se parece com chamados reais de integração.

**Prática.**

Configure o SAML Toolkit, atribua só ao grupo `GG-Financeiro` e teste com um usuário do grupo e outro de fora (este deve ser negado).

**Pronto quando.** Você explica Identifier (Entity ID), Reply URL (ACS), certificado e claims.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Tutorial do Microsoft Entra SAML Toolkit](https://learn.microsoft.com/pt-br/entra/identity/saas-apps/saml-toolkit-tutorial)
- [PT] [Microsoft Learn: O que é logon único (SSO)](https://learn.microsoft.com/pt-br/entra/identity/enterprise-apps/what-is-single-sign-on)
- [PT] [Microsoft Learn: Adicionar aplicativo empresarial](https://learn.microsoft.com/pt-br/entra/identity/enterprise-apps/add-application-portal)

### Revisões de acesso (recertificação) no Entra

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Revisão de acesso é pedir periodicamente ao gestor (ou ao próprio usuário) que confirme se cada pessoa ainda precisa daquele acesso; o que não for aprovado é removido. É o que as vagas chamam de **recertificação** e o que os auditores pedem como evidência. No Entra exige P2 / ID Governance.

**Como estudar.** Leia a visão geral e crie uma revisão no período da avaliação P2.

**Prática.**

Crie uma revisão do grupo `GG-Financeiro` com o admin como revisor, negue 1 pessoa, aplique os resultados e baixe o histórico como evidência.

**Pronto quando.** Você explica o ciclo da recertificação: escopo, revisor, prazo, decisão, aplicação e evidência.

**Recursos gratuitos**

- [PT] [Microsoft Learn: O que são revisões de acesso](https://learn.microsoft.com/pt-br/entra/id-governance/access-reviews-overview)
- [PT] [Microsoft Learn: Criar uma revisão de acesso](https://learn.microsoft.com/pt-br/entra/id-governance/create-access-review)

### PIM: acesso privilegiado just-in-time

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** O **Privileged Identity Management** transforma funções de admin em “elegíveis”: a pessoa ativa a função só quando precisa, por algumas horas, com justificativa, MFA e, se quiser, aprovação. É PAM aplicado às funções da nuvem.

**Como estudar.** Leia o guia e configure durante a avaliação P2.

**Prática.**

Torne um usuário **elegível** a Administrador de Usuários por no máximo 2 horas com justificativa; ative a função com ele e veja o registro na auditoria do PIM.

**Pronto quando.** Você explica “elegível x ativo” e “just-in-time”.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Configurar o PIM](https://learn.microsoft.com/pt-br/entra/id-governance/privileged-identity-management/pim-configure)
- [PT] [Microsoft Learn: Contas de acesso de emergência](https://learn.microsoft.com/pt-br/entra/identity/role-based-access-control/security-emergency-access)

### Identidade híbrida: AD + Entra (conceito)

- [ ] Obrigatório.

**Conceito.** A maioria das empresas brasileiras tem AD on-premises sincronizado com o Entra pelo **Microsoft Entra Connect** (ou Cloud Sync). Métodos de autenticação: sincronização de hash de senha (PHS), autenticação de passagem (PTA) ou federação (ADFS). É fonte comum de chamados: “alterei no AD e não refletiu na nuvem”.

**Como estudar.** Leia o conceito. Instalar o Connect no lab é opcional, porque exige DC acessível e tenant juntos.

**Prática.**

Desenhe o fluxo: usuário criado no AD → sincronização (ciclo de cerca de 30 min) → aparece no Entra → recebe licença e grupos.

**Pronto quando.** Você explica por que, em ambiente híbrido, a mudança é feita no AD e não no Entra.

**Recursos gratuitos**

- [PT] [Microsoft Learn: O que é o Microsoft Entra Connect](https://learn.microsoft.com/pt-br/entra/identity/hybrid/connect/whatis-azure-ad-connect)

### Logs de entrada e auditoria no Entra

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Os **logs de entrada** mostram cada login (sucesso, falha, MFA, política de Acesso Condicional aplicada). Os **logs de auditoria** mostram mudanças (usuário criado, grupo alterado). Você já usa isso no Sentinel; no IAM eles servem para troubleshooting e evidência.

**Como estudar.** Leia o conceito e investigue os seus próprios logins do lab.

**Prática.**

Encontre um login com falha de MFA e um bloqueado por Acesso Condicional; leia o código de erro e a política responsável.

**Pronto quando.** Diante de um “não consigo logar”, você sabe onde olhar e o que procurar.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Logs de entrada](https://learn.microsoft.com/pt-br/entra/identity/monitoring-health/concept-sign-ins)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. Quais licenças exigem Acesso Condicional, PIM e Revisões de acesso?</summary>

Acesso Condicional: Entra ID P1. PIM e Revisões de acesso: P2 (ou Entra ID Governance).

</details>

<details>
<summary>2. Por que criar a política em “Somente relatório” primeiro?</summary>

Para ver o impacto nos logs sem bloquear ninguém, evitando trancar usuários ou o próprio admin.

</details>

<details>
<summary>3. No SSO SAML com o Entra, quem é o IdP e quem é o SP?</summary>

O Entra ID é o IdP (provedor de identidade); o aplicativo é o SP (provedor de serviço).

</details>

<details>
<summary>4. O que o PIM resolve?</summary>

Privilégio permanente: com o PIM o admin só fica ativo quando precisa, por tempo limitado, com MFA, justificativa e auditoria.

</details>

<details>
<summary>5. Num ambiente híbrido, onde alterar o departamento de um usuário sincronizado?</summary>

No AD on-premises (fonte); o Entra Connect sincroniza para a nuvem.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 3

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

> No tenant de estudo eu configurei ... e conferi o resultado nos logs de entrada, sem usar tenant de empresa.
````

[Início](../README.md) · [Fase 2](../02-active-directory/README.md) · [Fase 4](../04-protocolos-sso/README.md)
