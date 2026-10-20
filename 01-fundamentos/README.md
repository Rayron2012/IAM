# Fase 1 — Fundamentos de identidade

- [ ] Fase não concluída

Duração sugerida na trilha: **1–2 semanas**. Itens obrigatórios: **6**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Entender a linguagem do IAM: quem é quem, como se prova, o que pode acessar e por quanto tempo. Sem isso, nenhuma ferramenta faz sentido.

O glossário para preencher está em [glossario.md](glossario.md). A meta desta fase é 25 termos; a fase 10 pede leitura de cerca de 60. Se um exercício pedir um exemplo do seu dia a dia, descreva o tipo de sistema. Não commite nome de ambiente, de chamado ou de pessoa real.

## Checklist

### AAA: autenticação, autorização e auditoria

- [ ] Obrigatório.

**Conceito.** Autenticação é provar quem você é (senha, MFA). Autorização é decidir o que você pode fazer (permissões, grupos). Auditoria (accounting) é registrar o que foi feito (logs). Muitos materiais incluem antes a **Identificação** (dizer quem você é: o login), formando “IAAA”.

**Como estudar.** Leia o módulo de conceitos do SC-900 e, para cada conceito, escreva um exemplo do seu dia a dia no SOC (ex.: um log 4625 é a auditoria de uma autenticação que falhou).

**Prática.**

Monte uma tabela com 3 colunas (Identificação/Autenticação, Autorização, Auditoria) e preencha com 3 exemplos reais de sistemas que você usa (GLPI, Sentinel, e-mail).

**Pronto quando.** Você explica em 1 minuto, sem ler, a diferença entre autenticar e autorizar.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Conceitos de segurança, conformidade e identidade (trilha SC-900)](https://learn.microsoft.com/pt-br/training/paths/describe-concepts-of-security-compliance-identity/)
- [PT] [Microsoft Learn: Descrever conceitos de identidade](https://learn.microsoft.com/pt-br/training/modules/describe-identity-principles-concepts/)

### Identidade x conta x tipos de identidade

- [ ] Obrigatório.

**Conceito.** Uma **identidade** é a pessoa (ou máquina); uma **conta** é o registro dela num sistema. Uma pessoa pode ter várias contas (AD, SAP, e-mail). Os tipos mais cobrados são: identidade humana (funcionário, terceiro), **identidade de serviço/máquina** (contas de serviço, service principals, managed identities) e **identidade privilegiada** (admins).

**Como estudar.** Leia o módulo sobre tipos de identidade e anote exemplos de cada tipo que você já viu nos incidentes do SOC.

**Prática.**

Desenhe (papel ou draw.io) a identidade “Ana” com 4 contas em sistemas diferentes e mostre o que acontece se ela for desligada e só o AD for bloqueado.

**Pronto quando.** Você sabe explicar o que é uma conta órfã e por que contas de serviço são um risco.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Tipos de identidade e serviços básicos de identidade](https://learn.microsoft.com/pt-br/training/modules/explore-basic-services-identity-types/)
- [PT] [Microsoft Learn: O que é o Microsoft Entra ID](https://learn.microsoft.com/pt-br/entra/fundamentals/what-is-entra)

### Menor privilégio, need-to-know e segregação de funções

- [ ] Obrigatório.

**Conceito.** **Menor privilégio**: cada um recebe só o acesso necessário para a função, pelo tempo necessário. **Need-to-know**: só acessa a informação quem precisa dela para trabalhar. **SoD (segregação de funções)**: a mesma pessoa não pode ter duas permissões que juntas permitem fraude (ex.: cadastrar fornecedor e aprovar pagamento).

**Como estudar.** Leia o artigo da Microsoft sobre modelos administrativos de menor privilégio no AD (é longo: leia só a introdução e a parte sobre grupos privilegiados).

**Prática.**

Liste 5 pares de permissões que configurariam conflito de SoD numa empresa (financeiro, compras, RH, TI).

**Pronto quando.** Você dá 2 exemplos de conflito de SoD e explica o “acesso acumulado” de quem muda de área várias vezes.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Implementar modelos administrativos de menor privilégio](https://learn.microsoft.com/pt-br/windows-server/identity/ad-ds/plan/security-best-practices/implementing-least-privilege-administrative-models)
- [PT] [Microsoft Learn: Conceitos e metodologias de segurança (inclui Zero Trust)](https://learn.microsoft.com/pt-br/training/modules/describe-security-concepts-methodologies/)

### Fatores de autenticação, senhas e MFA

- [ ] Obrigatório.

**Conceito.** Fatores: algo que você **sabe** (senha), **tem** (celular, token, chave FIDO2) e **é** (biometria). MFA combina fatores de categorias diferentes. Métodos resistentes a phishing (FIDO2/passkeys, Windows Hello) são mais fortes que SMS. O NIST 800-63B é a referência mundial para senhas e autenticadores.

**Como estudar.** Leia como o MFA funciona no Entra e o artigo sobre passkeys. Do NIST, leia só o sumário traduzindo com o navegador.

**Prática.**

Classifique 8 métodos (senha, PIN, SMS, app autenticador com número, FIDO2, biometria, certificado, e-mail) do mais fraco ao mais forte e justifique.

**Pronto quando.** Você explica por que SMS é considerado fraco e o que é “MFA resistente a phishing”.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Como funciona o MFA do Microsoft Entra](https://learn.microsoft.com/pt-br/entra/identity/authentication/concept-mfa-howitworks)
- [PT] [Microsoft Learn: Passkeys (FIDO2)](https://learn.microsoft.com/pt-br/entra/identity/authentication/concept-authentication-passkeys-fido2)
- [EN] [NIST SP 800-63B: Autenticação e autenticadores](https://pages.nist.gov/800-63-3/)

### Ciclo de vida de identidade (JML) em visão geral

- [ ] Obrigatório.

**Conceito.** **Joiner** (admissão: criar conta e dar o acesso do cargo), **Mover** (movimentação: tirar acessos antigos e dar novos) e **Leaver** (desligamento: bloquear e remover tudo, no prazo). Em empresa madura, o gatilho vem do **RH (fonte da verdade)** e o processo tem aprovação, SLA e evidência.

**Como estudar.** Leia a visão geral de governança de identidade do Entra e os Lifecycle Workflows. Foque no diagrama de ciclo de vida, não no produto.

**Prática.**

Escreva um fluxograma simples (papel ou draw.io) de admissão, movimentação e desligamento: quem pede, quem aprova, quem executa e qual evidência fica.

**Pronto quando.** Você descreve o JML com as palavras “gatilho do RH”, “aprovação”, “SLA” e “evidência”.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Visão geral do Microsoft Entra ID Governance](https://learn.microsoft.com/pt-br/entra/id-governance/identity-governance-overview)
- [PT] [Microsoft Learn: O que são fluxos de trabalho do ciclo de vida](https://learn.microsoft.com/pt-br/entra/id-governance/what-are-lifecycle-workflows)

### Glossário do mercado (com termos em inglês)

- [ ] Obrigatório.

**Conceito.** As vagas misturam português e inglês. Termos-chave: provisioning/deprovisioning (provisionar/desprovisionar), entitlement (direito de acesso), access request, access review / recertification, birthright access (acesso padrão do cargo), orphan account (conta órfã), privileged account, break-glass (conta de emergência), IdP/SP, federation.

**Como estudar.** Monte um glossário próprio num arquivo do GitHub (você vai criar o repositório na fase 10; até lá, use um bloco de notas). Adicione 2 termos por sessão.

**Prática.**

Glossário com pelo menos 25 termos, cada um com tradução e um exemplo.

**Pronto quando.** Você lê uma vaga de IAM e entende todos os termos sem tradutor.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'o que é IAM gestão de identidades e acessos'
- [EN] [SailPoint Identity University: trilha Identity Security Leader](https://university.sailpoint.com/path/identity-security-leader)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. Um usuário errou a senha 5 vezes e a conta foi bloqueada. Que parte do AAA gerou o bloqueio e qual registrou o evento?</summary>

A política de autenticação (bloqueio de conta) gerou o bloqueio; a auditoria registrou os eventos (ex.: 4625 para falha e 4740 para bloqueio no AD).

</details>

<details>
<summary>2. Qual a diferença entre identidade e conta?</summary>

Identidade é a pessoa ou máquina; conta é o registro dela em cada sistema. Uma identidade pode ter várias contas.

</details>

<details>
<summary>3. Dê um exemplo de conflito de SoD.</summary>

Mesma pessoa podendo cadastrar fornecedor e aprovar o pagamento a ele (ou criar usuário e aprovar o próprio acesso).

</details>

<details>
<summary>4. O que significa JML?</summary>

Joiner, Mover e Leaver: admissão, movimentação e desligamento, o ciclo de vida da identidade.

</details>

<details>
<summary>5. Por que FIDO2 é melhor que SMS?</summary>

É resistente a phishing (a chave valida o domínio do site) e não depende de SIM card, que pode ser clonado (SIM swap).

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 1

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

> No estudo, eu explico autenticação, autorização e auditoria com este exemplo do laboratório: ...
````

[Início](../README.md) · [Fase 2](../02-active-directory/README.md)
