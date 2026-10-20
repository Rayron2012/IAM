# Fase 7 — IAM em nuvem

- [ ] Fase não concluída

Duração sugerida na trilha: **2 semanas**. Itens obrigatórios: **4**. Opcionais: **2**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Aplicar menor privilégio na nuvem: usuários, grupos, roles e políticas na AWS (que você já conhece um pouco) e o RBAC do Azure, sem gastar nada.

Os JSON de menor privilégio estão em [aws/README.md](aws/README.md). São exemplos para o simulador, com nomes fictícios.

## Checklist

### Conta AWS segura e sem custo

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** A conta AWS tem um **usuário raiz** com poder total, que não deve ser usado no dia a dia. O primeiro trabalho de IAM em qualquer conta é: MFA no root, orçamento com alerta e um usuário admin separado.

**Como estudar.** Siga o “Passo a passo” abaixo, que explica o modelo atual (Plano Gratuito com créditos).

**Prática.**

Conta no Plano Gratuito, root com MFA, orçamento de gasto zero e usuário `admin.lab` com MFA.

**Pronto quando.** Você entra no console com o `admin.lab` (não com o root) e vê o custo em US$ 0,00.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: AWS sem sustos (plano gratuito, MFA, orçamento e usuário admin)**.

**Recursos gratuitos**

- [PT] [AWS: Nível gratuito](https://aws.amazon.com/pt/free/)
- [PT] [AWS: FAQ do Nível gratuito](https://aws.amazon.com/pt/free/free-tier-faqs/)
- [PT] [AWS: Usuário raiz](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_root-user.html)

### Usuários, grupos e políticas (JSON)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Na AWS, o acesso é dado por **políticas JSON** com `Effect`, `Action`, `Resource` e `Condition`. Regra de ouro: um **Deny** explícito sempre vence; o que não está permitido está negado. Políticas gerenciadas pela AWS são práticas, mas as próprias (customer managed) permitem menor privilégio.

**Como estudar.** Leia a introdução, as boas práticas e os elementos de política.

**Prática.**

Crie o grupo `Auditores` (ReadOnlyAccess), a usuária `ana.auditora` e uma política própria que só permite listar buckets S3. Teste tentando criar um bucket (deve falhar).

**Pronto quando.** Você lê uma política JSON e diz o que ela permite e nega.

**Recursos gratuitos**

- [PT] [AWS IAM: O que é o IAM](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/introduction.html)
- [PT] [AWS IAM: Boas práticas de segurança](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/best-practices.html)
- [PT] [AWS IAM: Elementos de política JSON](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/reference_policies_elements.html)

### Roles (funções) e acesso temporário

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Uma **role** não tem senha: ela é **assumida** e gera credenciais temporárias. É o jeito certo de dar acesso a serviços (EC2, Lambda), a outras contas e a admins (troca de função). Tem 2 partes: a **política de confiança** (quem pode assumir) e a **política de permissões** (o que pode fazer).

**Como estudar.** Leia sobre roles e o tutorial de role para usuário.

**Prática.**

Crie a role `LeituraFinanceiro` que a `ana.auditora` pode assumir, use *Trocar função* no console e veja no CloudTrail (histórico de eventos, gratuito) o evento `AssumeRole`.

**Pronto quando.** Você explica política de confiança x política de permissões.

**Recursos gratuitos**

- [PT] [AWS IAM: Roles](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_roles.html)
- [PT] [AWS IAM: Criar role para um usuário](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_roles_create_for-user.html)

### Simulador de políticas e Access Analyzer

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** O **simulador de políticas** testa “esse usuário pode fazer essa ação?” sem executar nada. O **IAM Access Analyzer** encontra recursos compartilhados com fora da conta e valida políticas. São as ferramentas de auditoria de permissões na AWS.

**Como estudar.** Leia sobre teste de políticas e sobre o Access Analyzer. Atenção ao aviso de custo no guia AWS.

**Prática.**

No simulador, prove que a `ana.auditora` pode `s3:ListAllMyBuckets` e não pode `iam:CreateUser`. Crie um analisador de **Acesso externo** (gratuito) e veja os achados.

**Pronto quando.** Você mostra um print do simulador com Allowed e Denied e explica por quê.

**Recursos gratuitos**

- [PT] [AWS IAM: Testar políticas com o simulador](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies_testing-policies.html)
- [PT] [AWS IAM: O que é o Access Analyzer](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/what-is-access-analyzer.html)
- [EN] [Simulador de políticas (abre com login)](https://policysim.aws.amazon.com/)

### IAM Identity Center (SSO para várias contas AWS)

- [ ] Opcional. Não conta para o marco da fase. Tem prática de laboratório.

**Conceito.** O **IAM Identity Center** é o SSO da AWS: usuários (ou um IdP externo como o Entra) recebem **conjuntos de permissões** por conta. É o modelo recomendado pela AWS no lugar de usuários IAM com senha. Ele é gratuito.

**Como estudar.** Leia o “O que é” e o getting started.

**Prática.**

Crie o conjunto de permissões `SomenteLeitura` e atribua a um usuário do Identity Center; entre pelo portal de acesso.

**Pronto quando.** Você explica a diferença entre um usuário IAM e um usuário do Identity Center.

**Recursos gratuitos**

- [PT] [AWS: O que é o IAM Identity Center](https://docs.aws.amazon.com/pt_br/singlesignon/latest/userguide/what-is.html)
- [PT] [AWS: Introdução ao Identity Center](https://docs.aws.amazon.com/pt_br/singlesignon/latest/userguide/getting-started.html)

### RBAC do Azure (escopos e funções)

- [ ] Opcional. Não conta para o marco da fase. Tem prática de laboratório.

**Conceito.** No Azure, permissões sobre recursos são dadas por **atribuição de função** = quem (usuário/grupo/identidade gerenciada) + função (Leitor, Colaborador, Proprietário…) + **escopo** (grupo de gerenciamento, assinatura, grupo de recursos, recurso). Não confunda com as funções de diretório do Entra.

**Como estudar.** Leia a visão geral e faça uma atribuição no portal (grátis; não crie recursos pagos).

**Prática.**

Crie um grupo de recursos vazio `rg-lab-iam` e dê a função **Leitor** ao grupo `GG-Financeiro` só nele. Depois exclua o grupo de recursos.

**Pronto quando.** Você explica escopo e herança no RBAC do Azure.

**Recursos gratuitos**

- [PT] [Microsoft Learn: RBAC do Azure](https://learn.microsoft.com/pt-br/azure/role-based-access-control/overview)
- [PT] [Microsoft Learn: Atribuir funções pelo portal](https://learn.microsoft.com/pt-br/azure/role-based-access-control/role-assignments-portal)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. Na AWS, se uma política permite e outra nega a mesma ação, o que vale?</summary>

O Deny explícito sempre vence.

</details>

<details>
<summary>2. Por que usar role em vez de access key fixa?</summary>

Porque a role gera credenciais temporárias que expiram sozinhas, sem segredo de longo prazo para vazar.

</details>

<details>
<summary>3. Quais as 3 primeiras ações numa conta AWS nova?</summary>

MFA no root, orçamento/alertas de custo e criar um usuário admin separado (de preferência pelo Identity Center), deixando de usar o root.

</details>

<details>
<summary>4. No Azure, o que é o escopo de uma atribuição de função?</summary>

O nível onde ela vale (grupo de gerenciamento, assinatura, grupo de recursos ou recurso), herdando para baixo.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 7

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

> Na conta de estudo eu li a política JSON e mostrei no simulador o que era Allow e o que era Deny: ...
````

[Início](../README.md) · [Fase 6](../06-pam/README.md) · [Fase 8](../08-automacao/README.md)
