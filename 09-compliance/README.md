# Fase 9 — Conformidade e processo

- [ ] Fase não concluída

Duração sugerida na trilha: **2–3 semanas**. Itens obrigatórios: **6**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Falar a língua de auditoria e processo: os controles de acesso da ISO 27001/27002, LGPD, SOX/ITGC, NIST, CIS, Zero Trust e ITIL com chamados e SLA.

## Checklist

### ISO/IEC 27001 e 27002: controles de acesso

- [ ] Obrigatório.

**Conceito.** A ISO 27001 define o sistema de gestão (SGSI), e o Anexo A (detalhado na 27002:2022) lista os controles. Os de IAM: **5.15** Controle de acesso, **5.16** Gestão de identidade, **5.17** Informações de autenticação, **5.18** Direitos de acesso (inclui revisão periódica), **8.2** Direitos de acesso privilegiado, **8.3** Restrição de acesso à informação e **8.5** Autenticação segura. As normas são **pagas** (ISO/ABNT); estude por resumos e pelos guias gratuitos do governo.

**Como estudar.** Não compre a norma agora. Leia a página oficial (para saber o que é) e use o guia da ANPD e o CIS (gratuitos), que cobrem os mesmos controles.

**Prática.**

Tabela “Controle → O que exige → Evidência que eu mostraria → Qual lab meu cobre” para os 7 controles acima.

**Pronto quando.** Você diz de cabeça qual controle trata de revisão de acessos (5.18) e qual de acesso privilegiado (8.2).

**Recursos gratuitos**

- [EN] [ISO: página oficial da ISO/IEC 27001](https://www.iso.org/standard/27001)
- [PT] [ANPD: Guia de segurança da informação (agentes de pequeno porte)](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-sobre-seguranca-da-informacao-para-agentes-de-tratamento-de-pequeno-porte)
- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'ISO 27001 2022 anexo A controle de acesso 5.15 5.18'

### LGPD aplicada a acessos

- [ ] Obrigatório.

**Conceito.** A LGPD (Lei 13.709/2018) exige medidas de segurança para proteger dados pessoais (art. 46). Em IAM isso significa menor privilégio sobre dados pessoais, rastreabilidade de quem acessou, remoção rápida de acessos de desligados e cuidado com dados de usuários nos próprios sistemas de IAM. A ANPD é o órgão fiscalizador.

**Como estudar.** Faça o curso gratuito da Escola Virtual de Governo (10 h, com certificado) em 5 a 6 sessões e leia o guia de segurança da ANPD.

**Prática.**

Liste 5 controles de IAM que ajudam a cumprir o art. 46 e, para cada um, um exemplo do seu lab.

**Pronto quando.** Certificado do curso da EV.G emitido e você liga LGPD a controle de acesso com exemplos.

**Recursos gratuitos**

- [PT] [Escola Virtual Gov: Introdução à LGPD (gratuito, com certificado)](https://www.escolavirtual.gov.br/curso/153)
- [PT] [ANPD: Guia orientativo de segurança da informação](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-sobre-seguranca-da-informacao-para-agentes-de-tratamento-de-pequeno-porte)
- [PT] [Texto da LGPD (Planalto)](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)

### SOX, ITGC e evidência de auditoria

- [ ] Obrigatório.

**Conceito.** Empresas com ações nos EUA (e muitas multinacionais no Brasil) seguem a **SOX**; os auditores testam os **ITGCs** (controles gerais de TI), em que “gestão de acessos” é um pilar: admissão aprovada, desligamento no prazo, revisão periódica, acesso privilegiado controlado e segregação de funções. Evidência boa é **completa, datada, rastreável e não editável** (chamado + aprovação + log/print).

**Como estudar.** Pesquise o tema e use seus dossiês de evidência da fase 2 como exemplo.

**Prática.**

Monte um “pacote de evidência” de 1 desligamento: chamado, aprovação, print da conta desabilitada com data, evento 4725 e remoção de grupos.

**Pronto quando.** Você explica o que é amostragem na auditoria e por que o desligamento fora do prazo vira “deficiência”.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise: 'ITGC gestão de acessos auditoria SOX o que é'
- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'controles gerais de TI ITGC acesso lógico'

### NIST CSF 2.0 e CIS Controls v8

- [ ] Obrigatório.

**Conceito.** O **NIST CSF 2.0** organiza a segurança em funções (Governar, Identificar, Proteger, Detectar, Responder, Recuperar); IAM fica em **PR.AA** (Gestão de identidade, autenticação e controle de acesso). Os **CIS Controls v8** são práticos: **Controle 5** (gestão de contas) e **Controle 6** (gestão de controle de acesso). Ambos são gratuitos; o NIST CSF tem tradução oficial em português.

**Como estudar.** Leia no PDF em português do NIST CSF a categoria PR.AA. No CIS, leia os controles 5 e 6.

**Prática.**

Mapeie as salvaguardas do CIS 5 e 6 para os seus labs (ex.: 5.3 desabilitar contas inativas → script da fase 8).

**Pronto quando.** Você cita o CIS 5 e 6 e o PR.AA do NIST numa resposta de entrevista.

**Recursos gratuitos**

- [PT] [NIST CSF 2.0 em português (PDF oficial)](https://nvlpubs.nist.gov/nistpubs/CSWP/NIST.CSWP.29.por.pdf)
- [EN] [CIS Controls v8](https://www.cisecurity.org/controls/v8)
- [EN] [CIS Controls: lista](https://www.cisecurity.org/controls/cis-controls-list)

### Zero Trust

- [ ] Obrigatório.

**Conceito.** Zero Trust é “**nunca confie, sempre verifique**”: cada acesso é verificado explicitamente (identidade, dispositivo, contexto), com menor privilégio e presumindo violação. A identidade é o novo perímetro: MFA, Acesso Condicional, PIM e revisão de acessos são a base.

**Como estudar.** Leia a visão geral da Microsoft e a parte de identidade. Para referência, veja o NIST SP 800-207 (EN).

**Prática.**

Escreva 5 frases “Antes (perímetro) → Agora (Zero Trust)” usando o que você configurou no Entra.

**Pronto quando.** Você explica os 3 princípios do Zero Trust com exemplos de IAM.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Visão geral do Zero Trust](https://learn.microsoft.com/pt-br/security/zero-trust/zero-trust-overview)
- [PT] [Microsoft Learn: Zero Trust para identidade](https://learn.microsoft.com/pt-br/security/zero-trust/deploy/identity)
- [EN] [NIST SP 800-207: Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final)

### ITIL: requisição, incidente, mudança e SLA

- [ ] Obrigatório.

**Conceito.** No IAM quase tudo é **requisição de serviço** (pedido de acesso), alguns são **incidentes** (login quebrado) e alterações de configuração são **mudanças** (GMUD, com aprovação e janela). SLA é o prazo acordado; o IAM é medido por ele. Você já usa GLPI, OTRS e Jira: agora é organizar o vocabulário.

**Como estudar.** Faça o curso “Fundamentos de ITIL” da Escola Virtual da Fundação Bradesco (gratuito; procure no catálogo de cursos).

**Prática.**

Classifique 10 chamados fictícios de IAM em requisição, incidente ou mudança, com prioridade e SLA.

**Pronto quando.** Você explica a diferença entre incidente, requisição e mudança e o que é uma GMUD.

**Recursos gratuitos**

- [PT] [Fundação Bradesco: catálogo de cursos gratuitos](https://www.ev.org.br/cursos/)
- Pesquisa sugerida, sem link fixo: pesquise no site ev.org.br: 'Fundamentos de ITIL'

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. Qual controle da ISO 27001:2022 trata de direitos de acesso e sua revisão?</summary>

5.18 Direitos de acesso.

</details>

<details>
<summary>2. Qual artigo da LGPD exige medidas de segurança?</summary>

O art. 46.

</details>

<details>
<summary>3. Quais CIS Controls tratam de contas e acessos?</summary>

Controle 5 (gestão de contas) e Controle 6 (gestão de controle de acesso).

</details>

<details>
<summary>4. Pedido de acesso a uma pasta é incidente ou requisição?</summary>

Requisição de serviço.

</details>

<details>
<summary>5. O que é uma boa evidência de auditoria?</summary>

Completa, datada, rastreável (chamado, aprovação e log) e não editável.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 9

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

> Eu ligo o controle ... à evidência do laboratório ..., que é datada e não tem dado real.
````

[Início](../README.md) · [Fase 8](../08-automacao/README.md) · [Fase 10](../10-entrevista-portfolio/README.md)
