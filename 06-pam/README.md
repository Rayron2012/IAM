# Fase 6 — Acesso privilegiado (PAM)

- [ ] Fase não concluída

Duração sugerida na trilha: **2–3 semanas**. Itens obrigatórios: **5**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Entender e praticar como empresas protegem contas de administrador e de serviço: cofre, rotação, gravação de sessão, just-in-time e conta de emergência.

## Checklist

### Conceitos de PAM: cofre, rotação, sessão, JIT

- [ ] Obrigatório.

**Conceito.** O PAM guarda senhas privilegiadas num **cofre** (vault); o usuário não conhece a senha: ele faz **check-out**, usa e devolve. A ferramenta **rotaciona** a senha automaticamente, **grava a sessão** (vídeo e comandos), pode exigir **aprovação dupla** (dual control) e liberar acesso **just-in-time**. “Onboarding de conta” é colocar uma conta privilegiada sob gestão do cofre.

**Como estudar.** Leia o PIM do Entra de novo (PAM na nuvem) e anote como cada conceito aparece no CyberArk (fase seguinte).

**Prática.**

Monte um quadro “Risco → Controle PAM” com 6 linhas (ex.: senha de admin compartilhada → cofre + check-out individual).

**Pronto quando.** Você explica o que acontece desde o pedido de acesso até a rotação da senha depois do uso.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Configurar o PIM](https://learn.microsoft.com/pt-br/entra/id-governance/privileged-identity-management/pim-configure)
- [EN] [Palo Alto Networks (dona da CyberArk): o que é PAM](https://www.paloaltonetworks.com/cyberpedia/what-is-privileged-access-management)

### Contas de serviço, LAPS e conta de emergência

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** **Contas de serviço** rodam aplicações e costumam ter senha que nunca expira e privilégio demais: no AD, o ideal é usar **gMSA** (senha gerenciada automaticamente). O **Windows LAPS** rotaciona a senha do administrador local de cada máquina. A **conta de emergência (break-glass)** fica fora do MFA/Acesso Condicional normal, com senha guardada offline e alerta em qualquer uso.

**Como estudar.** Leia os 3 artigos e implemente o LAPS no lab (o Windows LAPS já vem embutido nas versões atuais do Windows).

**Prática.**

Crie uma gMSA no lab (`Add-KdsRootKey`, `New-ADServiceAccount`) e ative o Windows LAPS para o PC01 por GPO; leia a senha gerada pelo AD.

**Pronto quando.** Você explica por que conta de serviço com senha fixa é risco e como gMSA e LAPS resolvem.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Contas de serviço gerenciadas de grupo (gMSA)](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/group-managed-service-accounts-overview)
- [PT] [Microsoft Learn: Visão geral do Windows LAPS](https://learn.microsoft.com/pt-br/windows-server/identity/laps/laps-overview)
- [PT] [Microsoft Learn: Proteger contas de serviço](https://learn.microsoft.com/pt-br/entra/architecture/secure-service-accounts)

### Treinamentos gratuitos CyberArk

- [ ] Obrigatório.

**Conceito.** A CyberArk é líder em PAM e aparece com frequência em vagas de PAM. Componentes que caem em entrevista: **Vault**, **PVWA** (portal), **CPM** (rotação), **PSM** (sessão isolada e gravada). O produto não é baixável; os cursos introdutórios e de usuário final são gratuitos.

**Como estudar.** Siga o passo a passo de treinamentos (já incluído na fase 5) na parte CyberArk.

**Prática.**

Conclua os cursos gratuitos de introdução e de usuário final e escreva um resumo “Vault, PVWA, CPM, PSM em 1 linha cada”.

**Pronto quando.** Você explica o que é “monitorar o CyberArk” (CPM falhando rotação, PSM fora, cofre sem espaço, contas não gerenciadas).

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: treinamentos gratuitos da SailPoint (IGA) e da CyberArk (PAM)**.

**Recursos gratuitos**

- [EN] [CyberArk University: catálogo](https://training.cyberark.com/learn)
- [EN] [CyberArk Community (cadastro)](https://community.cyberark.com/s/login/)

### Lab PAM open source: Teleport

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** O Teleport Community é gratuito e mostra na prática os conceitos de PAM: acesso via proxy com MFA, papéis (RBAC), **gravação de sessão** e **log de auditoria**. Os nomes mudam de ferramenta para ferramenta, mas os conceitos são os mesmos do CyberArk ou do Senhasegura.

**Como estudar.** Faça primeiro um Teleport Lab no navegador e depois o seu no Docker, seguindo o “Passo a passo”.

**Prática.**

Sessão SSH feita pelo Teleport, gravação assistida, usuário com papel restrito testado e prints no GitHub.

**Pronto quando.** Você mostra uma gravação de sessão e o log de quem acessou.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: laboratório de PAM com Teleport Community (grátis)**.

**Recursos gratuitos**

- [EN] [Teleport Labs (gratuitos, no navegador)](https://goteleport.com/labs/)
- [EN] [Teleport: Deploy Community Edition](https://goteleport.com/docs/get-started/deploy-community/)
- [EN] [JumpServer (alternativa open source)](https://github.com/jumpserver/jumpserver)

### Ferramentas de PAM do mercado BR: Segura (Senhasegura), BeyondTrust, Delinea

- [ ] Obrigatório.

**Conceito.** A **Senhasegura** (hoje com a marca **Segura**) é brasileira e muito comum aqui. BeyondTrust e Delinea (antiga Thycotic/Centrify) completam a lista. Todas fazem cofre, rotação, sessão e JIT. Em entrevista, mostre que você entende os conceitos e consegue aprender qualquer uma.

**Como estudar.** Navegue nos sites oficiais e anote o nome que cada uma dá a cofre, rotação e sessão. Use a tradução do navegador.

**Prática.**

Tabela comparativa “Conceito → CyberArk → Segura → Teleport”.

**Pronto quando.** Você explica um onboarding de conta privilegiada sem citar ferramenta.

**Recursos gratuitos**

- [EN] [Segura (antiga Senhasegura)](https://segura.security/)
- [EN] [Delinea](https://delinea.com/)
- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'senhasegura demonstração PAM português'

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. O que é rotação de senha no PAM?</summary>

A ferramenta troca automaticamente a senha da conta privilegiada (após uso ou em período definido), sem ninguém conhecer a nova.

</details>

<details>
<summary>2. Para que serve a gravação de sessão?</summary>

Para auditoria e investigação: registra o que o admin fez (vídeo e comandos) e inibe abuso.

</details>

<details>
<summary>3. Uma tentativa de login falha em conta admin e a troca de senha de conta de serviço feita pelo cofre: qual é o alerta?</summary>

As tentativas de login não autorizadas em conta admin. A troca de senha pelo cofre é a rotação esperada.

</details>

<details>
<summary>4. O que é uma conta break-glass?</summary>

Conta de emergência, excluída das políticas normais, com senha forte guardada offline, usada só quando o acesso normal falha, e monitorada.

</details>

<details>
<summary>5. gMSA resolve qual problema?</summary>

Contas de serviço com senha fixa e manual: a gMSA tem senha longa trocada automaticamente pelo AD.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 6

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

> Eu explico cofre, rotação e sessão com o laboratório ..., e deixo claro que foi estudo, não operação de uma ferramenta de cliente.
````

[Início](../README.md) · [Fase 5](../05-iga/README.md) · [Fase 7](../07-cloud-iam/README.md)
