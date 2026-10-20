# Fase 5 — Governança de acessos (IGA)

- [ ] Fase não concluída

Duração sugerida na trilha: **3 semanas**. Itens obrigatórios: **7**. Opcionais: **0**.

Esta pasta começa sem evidência. O checklist abaixo sai da trilha de estudos e fica desmarcado até você fazer o item. Laboratório não é produção.

## Objetivo

Dominar a parte “processo” do IAM, a mais pedida em vagas sem plantão: JML formal, RBAC, matriz de acesso, matriz de SoD, recertificação e reconciliação.

As planilhas de exemplo estão em [matrizes/README.md](matrizes/README.md). A detecção do conflito no SQL está na [fase 8](../08-automacao/sql/README.md).

## Checklist

### Processo JML formal e RH como fonte da verdade

- [ ] Obrigatório.

**Conceito.** Numa empresa madura, o sistema de RH (ex.: SAP SuccessFactors, Senior, TOTVS) é a **fonte autoritativa**: admissão, troca de cargo e desligamento geram eventos que a ferramenta de IGA transforma em criação, alteração e remoção de acessos. Acesso fora do padrão do cargo passa por **solicitação + aprovação** (gestor e dono do sistema) e tudo gera evidência.

**Como estudar.** Leia sobre provisionamento orientado por RH e pacotes de acesso no Entra (conceitos que valem para qualquer ferramenta).

**Prática.**

Escreva um procedimento (POP) de 1 página: “Admissão de colaborador”, com gatilho, SLA (ex.: acessos prontos no D-1), aprovadores, acessos padrão do cargo (birthright) e evidência. Repita para desligamento (ex.: SLA de 4 horas; imediato se for justa causa).

**Pronto quando.** Seus 2 POPs estão no GitHub e você os explica em 2 minutos.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Gerenciamento de direitos (pacotes de acesso)](https://learn.microsoft.com/pt-br/entra/id-governance/entitlement-management-overview)
- [PT] [Microsoft Learn: Fluxos de trabalho do ciclo de vida](https://learn.microsoft.com/pt-br/entra/id-governance/what-are-lifecycle-workflows)

### RBAC, ABAC e papéis de negócio

- [ ] Obrigatório.

**Conceito.** **RBAC**: o acesso é dado ao papel (cargo/função), e a pessoa herda pelo papel. **ABAC**: a decisão usa atributos (departamento, local, horário, classificação do dado). **Role mining** é descobrir papéis analisando quem tem o quê. Excesso de papéis (role explosion) é um problema comum.

**Como estudar.** Leia sobre RBAC no Azure (o conceito é universal) e compare com os grupos do AD que você criou.

**Prática.**

Defina 4 papéis de negócio (Analista Financeiro, Aprovador Financeiro, Analista de RH, Suporte N1) e liste os acessos técnicos de cada um (grupos AD, apps, perfis).

**Pronto quando.** Você explica RBAC x ABAC com um exemplo de cada.

**Recursos gratuitos**

- [PT] [Microsoft Learn: O que é o RBAC do Azure](https://learn.microsoft.com/pt-br/azure/role-based-access-control/overview)
- [EN] [SailPoint Identity University: Identity Security Leader](https://university.sailpoint.com/path/identity-security-leader)

### Prática: matriz de acesso no Excel

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** A **matriz de acesso** (ou matriz de perfis) cruza cargos/papéis com sistemas e perfis: é o documento que diz “quem deve ter o quê”. Ela é a base da admissão automática, da revisão de acessos e da auditoria.

**Como estudar.** Use o seu Excel. Monte em 1 sessão e refine na seguinte.

**Prática.**

Planilha com linhas = cargos (6) e colunas = sistemas/perfis (AD grupos, ERP, CRM, VPN, pasta Financeiro, admin). Use “X” para acesso padrão e “S” para sob solicitação. Adicione uma aba “Dono do sistema” com o aprovador de cada recurso.

**Pronto quando.** Sua matriz está no GitHub (dados fictícios) e responde “o que um novo Analista Financeiro recebe no dia 1?”.

**Recursos gratuitos**

- Pesquisa sugerida, sem link fixo: pesquise no YouTube: 'matriz de acesso RBAC Excel'
- Pesquisa sugerida, sem link fixo: pesquise: 'modelo matriz de perfis de acesso por cargo'

### Prática: matriz de SoD e detecção de conflitos

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** A **matriz de SoD** lista os pares de perfis incompatíveis e o risco de cada par. Na detecção você cruza a matriz com “quem tem o quê” e acha as violações. Quando o conflito é inevitável (empresa pequena), aplica-se um **controle compensatório** (ex.: revisão mensal das transações).

**Como estudar.** Leia sobre pacotes de acesso incompatíveis no Entra (é SoD na prática) e monte no Excel.

**Prática.**

Aba 1: matriz quadrada perfil x perfil com “Conflito Alto/Médio”. Aba 2: lista fictícia de 30 usuários com seus perfis. Aba 3: fórmula (PROCX/CONT.SES) ou tabela dinâmica que marca usuários com pares em conflito. Proponha a correção ou o controle compensatório para cada um.

**Pronto quando.** Sua planilha encontra sozinha os conflitos e você explica “controle compensatório”.

**Recursos gratuitos**

- [PT] [Microsoft Learn: Separação de funções com pacotes incompatíveis](https://learn.microsoft.com/pt-br/entra/id-governance/entitlement-management-access-package-incompatible)

### Campanhas de recertificação (revisão de acessos)

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** A campanha define **escopo** (ex.: acessos ao ERP financeiro), **revisor** (gestor ou dono do sistema), **prazo**, **regra para não respondidos** (revogar ou escalar) e **evidência** final. Frequência típica: trimestral para acessos críticos e privilegiados, semestral ou anual para o resto. O IAM acompanha, cobra e executa as revogações.

**Como estudar.** Releia o item de revisões do Entra e desenhe uma campanha completa, como se fosse o analista responsável.

**Prática.**

Planilha de campanha: 20 linhas (usuário, acesso, gestor, decisão Manter/Revogar, data, comentário) + resumo com % concluído, revogações e pendências. Escreva o e-mail de cobrança para os gestores atrasados.

**Pronto quando.** Você explica o que um auditor pede como evidência de uma recertificação.

**Recursos gratuitos**

- [PT] [Microsoft Learn: O que são revisões de acesso](https://learn.microsoft.com/pt-br/entra/id-governance/access-reviews-overview)

### Reconciliação: contas órfãs e desligados ativos

- [ ] Obrigatório. Tem prática de laboratório.

**Conceito.** **Reconciliação** é comparar o que existe nos sistemas com a fonte da verdade (RH). Achados clássicos: **conta órfã** (sem dono no RH), **desligado com conta ativa**, **conta sem login há 90+ dias** e **acesso fora da matriz**. Ferramentas de IGA fazem isso automaticamente; você vai fazer com SQL/Excel.

**Como estudar.** Use o SQL que você já sabe. O exercício está detalhado no item de SQL da fase 8; aqui, foque no raciocínio.

**Prática.**

Exporte os usuários do lab (`Get-ADUser -Filter * -Properties LastLogonDate,Enabled | Export-Csv contas.csv`), crie um `rh.csv` fictício e cruze no Excel (PROCX) as contas sem correspondente no RH e os desligados ativos.

**Pronto quando.** Você entrega um relatório de achados com recomendação para cada um.

**Recursos gratuitos**

- [PT] [PowerShell Get-ADUser (exportar contas)](https://learn.microsoft.com/pt-br/powershell/module/activedirectory/get-aduser)

### Treinamentos gratuitos SailPoint (conceitos de IGA)

- [ ] Obrigatório.

**Conceito.** SailPoint (IdentityIQ e Identity Security Cloud, antigo IdentityNow) e Saviynt são as ferramentas de IGA mais citadas. Conceitos que se repetem: fontes (sources), contas, entitlements, access profiles, roles, certificações, políticas de SoD e workflows. Os produtos são pagos; os treinamentos introdutórios são gratuitos.

**Como estudar.** Siga o “Passo a passo” abaixo. Faça a trilha Identity Security Leader em 3 a 4 sessões, com a tradução do navegador.

**Prática.**

Trilha Identity Security Leader concluída e um resumo de 1 página “SailPoint x o que fiz no meu lab” no GitHub.

**Pronto quando.** Você explica source, entitlement, access profile e role no vocabulário SailPoint.

Passo a passo de instalação na trilha interativa (`docs/trilha-iam.html`), guia **Passo a passo: treinamentos gratuitos da SailPoint (IGA) e da CyberArk (PAM)**.

**Recursos gratuitos**

- [EN] [SailPoint Identity University](https://university.sailpoint.com/)
- [EN] [Catálogo SailPoint (filtrar por Free)](https://university.sailpoint.com/page/all-courses)

## Autoavaliação

Responda de cabeça. A resposta fica fechada de propósito.

<details>
<summary>1. O que é a “fonte da verdade” no JML?</summary>

O sistema de RH: é dele que vêm admissão, movimentação e desligamento que disparam os acessos.

</details>

<details>
<summary>2. Matriz de acesso x matriz de SoD: diferença?</summary>

A matriz de acesso diz o que cada cargo deve ter; a de SoD diz quais combinações de acessos são proibidas.

</details>

<details>
<summary>3. O que fazer quando o conflito de SoD é inevitável?</summary>

Aceitar formalmente o risco com um controle compensatório (ex.: revisão periódica das transações por um terceiro) e documentar.

</details>

<details>
<summary>4. O que fazer com itens não respondidos numa recertificação?</summary>

Seguir a regra definida na campanha: normalmente revogar ou escalar ao gestor superior, sempre registrando.

</details>

<details>
<summary>5. O que é uma conta órfã?</summary>

Conta ativa sem uma identidade válida (dona) na fonte da verdade, por exemplo de alguém já desligado ou sem registro no RH.

</details>

## Laboratório

Quando fizer um exercício, crie `laboratorio/NN-titulo.md` nesta pasta e cole o modelo. Prints anonimizados ficam em `laboratorio/evidencias/`. Antes de commitar, releia [SEGURANCA.md](../SEGURANCA.md).

### Modelo de registro

````markdown
# Título do exercício

- **Data:**
- **Chamado fictício:** LAB-0000
- **Fase:** 5

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

> Eu montei a matriz de acesso e a de SoD da LabIAM e expliquei um conflito com o controle compensatório ...
````

[Início](../README.md) · [Fase 4](../04-protocolos-sso/README.md) · [Fase 6](../06-pam/README.md)
