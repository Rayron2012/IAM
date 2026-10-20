# Fase 4 — Protocolos e SSO

- [ ] Fase não concluída

Duração sugerida na trilha: **3 semanas**. Itens obrigatórios: **8**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Entender SAML, OAuth 2.0, OIDC, JWT e SCIM pelo funcionamento (quem conversa com quem, o que vai no token) e praticar tudo no Keycloak, que é grátis.

O compose local, preso em `127.0.0.1`, está em [keycloak/README.md](keycloak/README.md).

## Checklist

### SAML 2.0

- [ ] Obrigatório.

**Conceito.** Padrão em XML para SSO web corporativo. O usuário tenta entrar no app (SP), é redirecionado ao IdP, autentica e volta com uma **asserção SAML assinada** com quem ele é (NameID) e atributos (claims). Elementos-chave: Entity ID, ACS URL, certificado de assinatura e metadados.

**Como estudar.** Leia o protocolo SAML na doc da Microsoft. Depois faça o lab de federação do Keycloak e veja a asserção na extensão SAML-tracer.

**Prática.**

Capture uma asserção SAML no SAML-tracer e identifique: Issuer, NameID, Conditions (validade), AttributeStatement e Signature.

**Pronto quando.** Você desenha o fluxo SP-initiated e cita 3 causas comuns de erro (relógio, certificado, ACS errado).

**Recursos gratuitos**

- [PT] [Microsoft Learn: Protocolo SAML de logon único](https://learn.microsoft.com/pt-br/entra/identity-platform/single-sign-on-saml-protocol)
- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'SAML explicado português SSO'

### OAuth 2.0 (autorização delegada)

- [ ] Obrigatório.

**Conceito.** OAuth 2.0 **não é autenticação**: é um app obtendo um **access token** para acessar uma API em nome do usuário (ou em nome próprio). Fluxos principais: **Authorization Code + PKCE** (apps com usuário) e **Client Credentials** (máquina com máquina). Escopos (scopes) limitam o que o token pode fazer.

**Como estudar.** Leia o fluxo de código de autorização na doc da Microsoft e use o OAuth Debugger com o Keycloak.

**Prática.**

No Keycloak, crie um client `api-relatorios` com *Client authentication* ligado e *Service accounts* ligado; obtenha um token via Client Credentials (fase 8 mostra o comando REST).

**Pronto quando.** Você explica a diferença entre autenticação e autorização delegada, e entre Authorization Code e Client Credentials.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Fluxo de código de autorização OAuth 2.0](https://learn.microsoft.com/pt-br/entra/identity-platform/v2-oauth2-auth-code-flow)
- [PT] [Microsoft Learn: Protocolos OAuth 2.0 e OIDC](https://learn.microsoft.com/pt-br/entra/identity-platform/v2-protocols)
- [EN] [oauth.net: OAuth 2.0](https://oauth.net/2/)

### OpenID Connect (OIDC)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** OIDC é uma camada de **autenticação** em cima do OAuth 2.0. Além do access token, o app recebe um **ID Token** (JWT) dizendo quem é o usuário. É o padrão moderno para login em apps web e mobile (o “Entrar com Google/Microsoft”).

**Como estudar.** Leia a doc de OIDC da Microsoft e o “How it works” da OpenID Foundation. Teste com o app de teste do Keycloak.

**Prática.**

Faça login no keycloak.org/app com o seu realm e, depois, pelo OIDC Debugger; compare o ID Token e o Access Token no jwt.io.

**Pronto quando.** Você diz qual token o app usa para saber quem é o usuário (ID Token) e qual usa para chamar a API (Access Token).

**Recursos gratuitos**

- [PT] [Microsoft Learn: Protocolo OpenID Connect](https://learn.microsoft.com/pt-br/entra/identity-platform/v2-protocols-oidc)
- [EN] [OpenID Foundation: Como o OpenID Connect funciona](https://openid.net/developers/how-connect-works/)
- [EN] [OIDC Debugger (ferramenta online)](https://oidcdebugger.com/)

### JWT: o que tem dentro de um token

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** JWT é um token em 3 partes (cabeçalho.dados.assinatura) codificadas em Base64URL. Claims comuns: `iss` (emissor), `sub` (usuário), `aud` (para quem é), `exp` (expiração), `scope`/`roles`. Ele é **assinado, não criptografado**: qualquer um lê o conteúdo, então nada sensível vai nele.

**Como estudar.** Leia a introdução do jwt.io e a página de tokens da Microsoft.

**Prática.**

Decodifique 2 tokens do seu Keycloak no jwt.io e anote o que significa cada claim. Altere o tempo de vida do token no realm e veja o `exp` mudar.

**Pronto quando.** Você lê um JWT e diz quem emitiu, para quem, até quando vale e que permissões traz.

**Recursos gratuitos**

- [EN] [JWT.io: Introdução ao JWT](https://www.jwt.io/introduction)
- [PT] [Microsoft Learn: Tokens de segurança](https://learn.microsoft.com/pt-br/entra/identity-platform/security-tokens)

### SCIM: provisionamento automático entre sistemas

- [ ] Obrigatório.

**Conceito.** SCIM é uma API REST padrão (JSON) para **criar, atualizar e desativar usuários e grupos** em apps SaaS automaticamente a partir do IdP. É assim que o JML “se espalha” para Slack, Zoom, Salesforce etc. sem ninguém criar conta na mão.

**Como estudar.** Leia a doc de provisionamento do Entra e o site do SCIM. Não precisa implementar; entenda os recursos (/Users, /Groups) e as operações.

**Prática.**

Escreva à mão o JSON de um POST `/Users` e de um PATCH com `"active": false` (desligamento). Compare com o exemplo da doc da Microsoft.

**Pronto quando.** Você explica como o desligamento no RH pode desativar a conta num SaaS em minutos via SCIM.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Provisionamento automático de usuários em apps SaaS](https://learn.microsoft.com/pt-br/entra/identity/app-provisioning/user-provisioning)
- [PT] [Microsoft Learn: SCIM para provisionar usuários e grupos](https://learn.microsoft.com/pt-br/entra/identity/app-provisioning/use-scim-to-provision-users-and-groups)
- [EN] [SCIM: site oficial](https://scim.cloud/)

### Lab Keycloak: instalar, realm, usuários, clients

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Keycloak é o IdP open source mais usado. Conceitos: realm (tenant), client (app), user, group, role (realm role e client role), identity provider (federação) e user federation (conectar ao AD/LDAP).

**Como estudar.** Siga o “Passo a passo” abaixo do começo até o teste OIDC.

**Prática.**

Realm `labiam` com 5 usuários, 2 grupos, realm roles `financeiro-leitura` e `financeiro-aprovador`, e login OIDC funcionando no app de teste.

**Pronto quando.** Você mostra o login funcionando e explica realm, client e role.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: Docker Desktop + Keycloak (OIDC e SAML no seu PC)**.

**Recursos gratuitos**

- [EN] [Keycloak: Getting started com Docker](https://www.keycloak.org/getting-started/getting-started-docker)
- [EN] [Keycloak: Server Administration Guide](https://www.keycloak.org/docs/latest/server_admin/index.html)
- [EN] [Keycloak: app de teste OIDC](https://www.keycloak.org/app/)

### Lab Keycloak: federação SAML e conexão com o AD (LDAP)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Federação é confiar na identidade emitida por outro IdP (empresa parceira, Entra, ADFS). No Keycloak isso é um **Identity Provider**. Já a **User Federation (LDAP)** faz o Keycloak ler os usuários do seu AD, um cenário muito comum.

**Como estudar.** Faça a parte SAML do passo a passo. Bônus: em *User federation > Add LDAP provider*, aponte para o seu DC (exige rede entre o Docker e a VM; se não conseguir, só leia a doc).

**Prática.**

Login no realm `labiam` usando a conta do realm `parceiro` via SAML, com a asserção capturada no SAML-tracer.

**Pronto quando.** Você explica a diferença entre Identity Provider (federação) e User Federation (diretório).

**Recursos gratuitos**

- [EN] [Keycloak: Server Administration Guide (Identity Brokering e LDAP)](https://www.keycloak.org/docs/latest/server_admin/index.html)
- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'Keycloak SAML identity provider tutorial'

### Troubleshooting de SSO (o dia a dia do suporte IAM)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Os chamados de SSO quase sempre caem em poucas causas: **redirect/ACS URL errado**, **certificado expirado ou trocado**, **relógio fora de sincronia** (asserção “ainda não válida”/expirada), **claim/NameID diferente** do que o app espera, usuário **não atribuído** ao app, ou bloqueio de **Acesso Condicional**.

**Como estudar.** Provoque erros de propósito no Keycloak e no SAML Toolkit e anote a mensagem de cada um.

**Prática.**

Crie no GitHub uma tabela “Erro → Causa → Como resolvi” com pelo menos 5 erros provocados no lab.

**Pronto quando.** Diante de um erro de SSO, você sabe em que ordem investigar.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Logs de entrada (códigos de erro)](https://learn.microsoft.com/pt-br/entra/identity/monitoring-health/concept-sign-ins)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. OAuth 2.0 é um protocolo de autenticação?</summary>

Não. É de autorização delegada (obter token para acessar API). A autenticação padronizada em cima dele é o OpenID Connect.

</details>

<details>
<summary>2. Qual fluxo usar para um serviço que chama uma API sem usuário?</summary>

Client Credentials.

</details>

<details>
<summary>3. Um JWT é criptografado?</summary>

Em geral não: é assinado (integridade). Qualquer um pode ler o conteúdo, então não se coloca dado sensível nele.

</details>

<details>
<summary>4. Para que serve o SCIM?</summary>

Para provisionar/desprovisionar usuários e grupos automaticamente em aplicativos, via API REST padrão.

</details>

<details>
<summary>5. O usuário recebe “asserção expirada” ao acessar um app SAML. Primeira suspeita?</summary>

Relógio fora de sincronia entre IdP e SP (ou asserção reaproveitada). Confira NTP e o campo Conditions.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 4

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

> No Keycloak local eu mostrei o fluxo ... e o erro que eu mesmo provoquei foi ..., resolvido ao corrigir ...
````

[Início](../README.md) · [Fase 3](../03-microsoft-entra-id/README.md) · [Fase 5](../05-iga/README.md)
