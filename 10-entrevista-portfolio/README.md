# Fase 10 — Entrevista e portfólio

- [ ] Fase não concluída

Duração sugerida na trilha: **2 semanas (e contínuo)**. Itens obrigatórios: **4**. Opcionais: **1**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Transformar o que você estudou em contratação: portfólio no GitHub, discurso honesto da sua experiência, respostas prontas e inglês técnico mínimo.

Rascunhos vazios: [pitch.md](pitch.md) e [perguntas.md](perguntas.md). Preencha com o que for verdade.

## Checklist

### Portfólio de labs no GitHub

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** Seus labs documentados provam o que você não fez no trabalho, sem precisar mentir. Recrutador técnico abre o GitHub; o ATS lê as palavras-chave do currículo. Os dois se complementam.

**Como estudar.** Siga o “Passo a passo” abaixo. Publique um lab por semana, a partir da fase 2.

**Prática.**

Repositório `lab-iam` com pelo menos 6 pastas documentadas e sem nenhum segredo ou dado real.

**Pronto quando.** Você manda o link para alguém e a pessoa entende o que você fez sem você explicar.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: portfólio de IAM no GitHub (sem vazar nada)**.

**Recursos gratuitos**

- [PT] [GitHub Docs: Criar conta](https://docs.github.com/pt/account-and-profile/how-tos/account-management/creating-an-account-on-github)
- [PT] [GitHub Docs: Hello World](https://docs.github.com/pt/get-started/using-github/hello-world)

### Como contar a sua experiência (com honestidade)

- [ ] Obrigatório.

**Conceito.** Sua história é forte: SOC N2 com bloqueio de contas por playbook no Sentinel/XDR, movimentação de grupos no AD/Entra em funções anteriores, chamados em GLPI/OTRS/Jira, e bagagem em dados e auditoria (SQL, Excel, Power BI). O que falta (admissão, desligamento, IGA, PAM) você diz que **praticou em laboratório** e mostra o GitHub. Nunca diga que fez em produção o que fez no lab.

**Como estudar.** Escreva e grave no celular um pitch de 60 a 90 segundos. Ouça e corte o que for enrolação.

**Prática.**

Pitch escrito: “Hoje sou SOC N2… Na prática já fiz… No meu laboratório implementei… Quero ir para IAM porque gosto de processo…”.

**Pronto quando.** Você fala o pitch sem ler, em menos de 90 segundos, sem afirmar nada que não fez.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'entrevista analista IAM perguntas'

### Perguntas técnicas comuns (treino)

- [ ] Obrigatório.

**Conceito.** Perguntas que mais caem: JML; o que fazer num desligamento urgente; RBAC x ABAC; SoD; SAML x OAuth x OIDC; como funciona o MFA; o que é PAM e rotação; como você faria uma revisão de acessos; como investigaria “usuário não consegue acessar o app”; menor privilégio; conta de serviço; Zero Trust.

**Como estudar.** Use os quizzes desta trilha como base. Responda em voz alta usando a estrutura **Conceito → Exemplo → Como fiz no lab**.

**Prática.**

Documento com 20 perguntas e as suas respostas, revisado depois de cada entrevista real.

**Pronto quando.** Você responde 15 das 20 sem consulta.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise: 'perguntas entrevista IAM analista identidade e acessos'

### Inglês técnico mínimo para IAM

- [ ] Obrigatório.

**Conceito.** Você não precisa conversar para começar no júnior, mas vai ler interface, documentação e logs em inglês. Foque em leitura: verbos de interface (grant, revoke, assign, enable, disable, approve, deny), termos de IAM (entitlement, provisioning, attestation) e mensagens de erro. Algumas vagas pedem conversação; isso é um objetivo de médio prazo.

**Como estudar.** Coloque o console do Keycloak e o portal da AWS em inglês por algumas semanas. Mantenha o glossário da fase 1.

**Prática.**

Glossário com 60 termos e você lendo uma página da documentação do Keycloak sem tradutor.

**Pronto quando.** Você entende mensagens de erro e telas em inglês sem traduzir.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'inglês para TI leitura técnica iniciante'

### Certificações (opcional, só se fizer sentido no seu bolso)

- [ ] Opcional. Não conta para o marco da fase.

**Conceito.** Elas não são obrigatórias para o júnior, mas aparecem como diferencial: **SC-900** (fundamentos de segurança e identidade Microsoft, a mais barata e fácil), **AZ-900** (fundamentos do Azure), **SC-300** (Administrador de Identidade e Acesso, a mais alinhada a IAM, mais difícil) e **Security+** (CompTIA, cara). Os **estudos** no Microsoft Learn são gratuitos; as **provas são pagas** (o preço varia por país; confira no site antes).

**Como estudar.** Se for fazer só uma, faça a SC-300 depois de terminar as fases 2 a 5; se quiser algo rápido e barato antes, a SC-900.

**Prática.**

Faça o “assessment de prática” gratuito da página da certificação e anote os temas com nota baixa.

**Pronto quando.** Você tira 80% ou mais no assessment de prática antes de pagar uma prova.

**Recursos gratuitos**

- [PT] [Microsoft Learn: SC-900](https://learn.microsoft.com/pt-br/credentials/certifications/security-compliance-and-identity-fundamentals/)
- [PT] [Microsoft Learn: SC-300 (Administrador de Identidade e Acesso)](https://learn.microsoft.com/pt-br/credentials/certifications/identity-and-access-administrator/)
- [PT] [Microsoft Learn: guia de estudo da SC-300](https://learn.microsoft.com/pt-br/credentials/certifications/resources/study-guides/sc-300)
- [PT] [Microsoft Learn: AZ-900](https://learn.microsoft.com/pt-br/credentials/certifications/azure-fundamentals/)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. Como falar de admissão/desligamento se você nunca fez em produção?</summary>

“Na prática profissional fiz movimentação de grupos e bloqueio de contas; admissão e desligamento eu implementei no meu laboratório de AD e Entra, documentado no GitHub.”

</details>

<details>
<summary>2. Um usuário diz que não consegue acessar um app com SSO. Por onde começar?</summary>

Confirmar o erro exato e o horário, ver os logs de entrada (falha, MFA, Acesso Condicional), verificar se o usuário está atribuído ao app/grupo e depois a configuração SAML/OIDC (URL, certificado, claims).

</details>

<details>
<summary>3. Qual certificação Microsoft é a mais alinhada a IAM?</summary>

SC-300 (Microsoft Identity and Access Administrator).

</details>

<details>
<summary>4. O que nunca pode aparecer no seu GitHub?</summary>

Segredos (senhas, chaves, tokens) e qualquer dado real de empresa ou pessoa.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 10

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

> Eu conto a experiência profissional e, em separado, o que o laboratório documenta nesta pasta: ...
````

[Início](../README.md) · [Fase 9](../09-compliance/README.md)
