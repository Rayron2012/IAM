# Portfólio de estudos em IAM

Laboratório e anotações de **Rayron Soares**, analista de SOC N2 em transição para Identity and Access Management (IAM).

Este repositório registra estudo e prática em ambiente isolado. Não descreve produção, não substitui experiência profissional em IAM e não deve ser lido como lista de projetos entregues em empresa.

## Objetivo

Construir a base técnica para atuar como analista de IAM: a linguagem da área, Active Directory, Microsoft Entra ID, protocolos de SSO, governança de acessos (IGA), e, como diferencial, acesso privilegiado (PAM), IAM em nuvem, automação e controles de conformidade.

A trilha tem dez fases, na ordem que já está nas pastas e em [`docs/trilha-iam.html`](docs/trilha-iam.html). **Júnior apto** é concluir os itens obrigatórios das fases 1 a 5. Esse conjunto é a única fonte da barra de 0 a 100%. As fases 6 a 10 são diferenciais e têm contador separado. Na trilha, concluir os obrigatórios de todas as fases é o marco de base técnica mais ampla (pleno apto). Uma vaga de nível pleno também pede tempo de experiência real em IAM, e este repositório não afirma essa experiência.

## Comece aqui

A ordem é a das pastas `01` a `05` e dos itens da trilha interativa. Cada semana abaixo usa a duração já sugerida na fase (a fase 2 entra com 4 semanas, o topo do intervalo de 3–4). O ritmo da trilha continua o mesmo: cerca de 3–4 sessões por semana, com uma folga. Se uma semana estourar, a seguinte espera. A ordem dos itens não muda.

Os modelos que já estão no repositório entram no ponto em que a fase pede: domínio `labiam.local`, Keycloak em `127.0.0.1`, matrizes da LabIAM. Empresa, tenant, UPN, OID, segredo e log reais ficam de fora. Veja [`SEGURANCA.md`](SEGURANCA.md).

| Semanas | Fase | O que fazer, na ordem dos ids da trilha |
| --- | --- | --- |
| 1 | [1. Fundamentos](01-fundamentos/README.md) | Linguagem: `f1-aaa`, `f1-ident`, `f1-priv`, `f1-auth`. Glossário em [glossario.md](01-fundamentos/glossario.md), dois termos por sessão. |
| 2 | [1. Fundamentos](01-fundamentos/README.md) | JML em visão geral e glossário de 25 termos: `f1-ciclo`, `f1-glossario`. |
| 3 | [2. Active Directory](02-active-directory/README.md) | Domínio `labiam.local`: `f2-lab`. Snapshot antes de promover o DC. |
| 4 | [2. Active Directory](02-active-directory/README.md) | OUs, delegação e AGDLP: `f2-ou`, `f2-grupos`. |
| 5 | [2. Active Directory](02-active-directory/README.md) | GPO, senha e FGPP: `f2-gpo`, `f2-senha`. |
| 6 | [2. Active Directory](02-active-directory/README.md) | JML no `dsa.msc` e o que o logon deixa de rastro: `f2-jml`, `f2-ldap`, `f2-kerb`, `f2-audit`. Os scripts em [08-automacao/powershell](08-automacao/powershell/README.md) esperam este domínio e entram na fase 8, depois da interface. Se a semana 6 não couber, ela empurra a seguinte. |
| 7 | [3. Entra ID](03-microsoft-entra-id/README.md) | Tenant de estudo, usuários e MFA (Padrões de Segurança): `f3-tenant`, `f3-users`, `f3-mfa`. |
| 8 | [3. Entra ID](03-microsoft-entra-id/README.md) | Acesso Condicional em modo relatório e SSO SAML de aplicativo: `f3-ca`, `f3-sso`. |
| 9 | [3. Entra ID](03-microsoft-entra-id/README.md) | Revisões, PIM, híbrido (conceito) e logs de entrada do tenant de estudo: `f3-reviews`, `f3-pim`, `f3-hybrid`, `f3-logs`. |
| 10 | [4. Protocolos e SSO](04-protocolos-sso/README.md) | SAML, OAuth 2.0, OIDC e JWT: `f4-saml`, `f4-oauth`, `f4-oidc`, `f4-jwt`. |
| 11 | [4. Protocolos e SSO](04-protocolos-sso/README.md) | SCIM no papel e Keycloak local (realm `labiam`, bind `127.0.0.1`): `f4-scim`, `f4-keycloak`. Compose em [keycloak](04-protocolos-sso/keycloak/README.md). |
| 12 | [4. Protocolos e SSO](04-protocolos-sso/README.md) | Federação SAML no Keycloak e troubleshooting: `f4-keycloak-saml`, `f4-federation`. |
| 13 | [5. IGA](05-iga/README.md) | POPs de JML (RH como fonte da verdade) e papéis: `f5-jml-proc`, `f5-rbac`. |
| 14 | [5. IGA](05-iga/README.md) | Matriz de acesso, matriz de SoD e evidência: `f5-matriz`, `f5-sod`. Planilhas em [matrizes](05-iga/matrizes/README.md). |
| 15 | [5. IGA](05-iga/README.md) | Campanha de recertificação, reconciliação e vocabulário SailPoint: `f5-recert`, `f5-orfas`, `f5-sailpoint`. |

As semanas 13 a 15 repartem os sete itens obrigatórios que a fase 5 já tem (duração sugerida de 3 semanas). A consulta SQL de SoD em [08-automacao/sql](08-automacao/sql/README.md) usa o mesmo par da matriz e fica para a fase 8.

### Depois da meta júnior

As pastas 06 a 10 continuam na ordem da trilha e **não entram** na porcentagem júnior: PAM, IAM em nuvem (políticas de exemplo já em [07-cloud-iam/aws](07-cloud-iam/aws/README.md)), automação, conformidade, entrevista e portfólio. A duração sugerida de cada uma está no README da fase.

## Andamento

<!-- PROGRESSO:INICIO -->
A barra **júnior** soma os pesos dos itens obrigatórios das fases 1 a 5.
O peso padrão de cada obrigatório é 1. Itens opcionais têm peso 0 e ficam de fora.
As fases 6 a 10 formam o contador de **diferenciais** e não movem a porcentagem júnior.

![Meta júnior: 0% (0 de 39)](docs/progresso-junior.svg)

`░░░░░░░░░░░░░░░░░░░░` **0%** júnior (0/39 na soma dos pesos)

![Diferenciais: 0% (0 de 25)](docs/progresso-diferenciais.svg)

`░░░░░░░░░░░░░░░░░░░░` **0%** diferenciais (0/25 na soma dos pesos), fora da meta júnior

100% na barra júnior é o marco **júnior apto**: todos os obrigatórios das fases 1 a 5.
Concluir também os obrigatórios das fases 6 a 10 é o marco de base técnica mais ampla (pleno apto na trilha).

### Trilha júnior (fases 1 a 5)

| Fase | Duração sugerida | Peso feito | Status |
| --- | --- | --- | --- |
| [1. Fundamentos de identidade](01-fundamentos/README.md) | 1–2 semanas | 0/6 | ☐ |
| [2. Active Directory e LDAP no seu laboratório](02-active-directory/README.md) | 3–4 semanas | 0/9 | ☐ |
| [3. Microsoft Entra ID e identidade em nuvem](03-microsoft-entra-id/README.md) | 3 semanas | 0/9 | ☐ |
| [4. Protocolos de autenticação e SSO](04-protocolos-sso/README.md) | 3 semanas | 0/8 | ☐ |
| [5. Governança de acessos (IGA)](05-iga/README.md) | 3 semanas | 0/7 | ☐ |

### Diferenciais (fases 6 a 10)

| Fase | Duração sugerida | Peso feito | Status |
| --- | --- | --- | --- |
| [6. Acesso privilegiado (PAM)](06-pam/README.md) | 2–3 semanas | 0/5 | ☐ |
| [7. IAM em nuvem (AWS e Azure)](07-cloud-iam/README.md) | 2 semanas | 0/4 | ☐ |
| [8. Automação: PowerShell, APIs, SQL e IA](08-automacao/README.md) | 3 semanas | 0/6 | ☐ |
| [9. Normas, compliance e processo](09-compliance/README.md) | 2–3 semanas | 0/6 | ☐ |
| [10. Entrevista, portfólio e certificações](10-entrevista-portfolio/README.md) | 2 semanas (e contínuo) | 0/4 | ☐ |

Gerado por `scripts/atualizar-progresso.py` a partir de `curriculum/progress.yml`.
<!-- PROGRESSO:FIM -->

## Como marcar um item e subir a porcentagem

A fonte da barra publicada no GitHub é [`curriculum/progress.yml`](curriculum/progress.yml). A caixa no README da fase e o selo em `docs/` são gerados a partir desse arquivo.

1. Abra `curriculum/progress.yml` e, no item (o `id` é o mesmo da trilha, por exemplo `f2-jml`), troque `done: false` por `done: true`.
2. Deixe `id`, `titulo`, `peso` e a ordem como estão. O peso padrão do obrigatório é 1. Item opcional permanece com peso 0.
3. Rode `python3 scripts/atualizar-progresso.py`. O script recalcula a barra, regrava `docs/progresso-junior.svg` e `docs/progresso-diferenciais.svg`, e marca a caixa correspondente no README da fase.
4. Na trilha interativa, marque o mesmo id se quiser ver a barra local. Esse progresso fica no navegador (`localStorage`) e não altera o YAML.

Marcar só a caixa no README, sem o `done: true`, não muda a porcentagem do GitHub. Para conferir se algo ficou para trás: `python3 scripts/atualizar-progresso.py --check`.

## O que já trago e o que este repositório constrói

**Base profissional, fora deste repositório:** operação de SOC N2, leitura de evento de autenticação, bloqueio de conta em resposta a incidente e atendimento de chamado. Empregadores e ambientes reais não aparecem aqui.

**Mapa do que vou estudar e registrar neste repositório, à medida que cada fase for preenchida:**

- Identidade: autenticação, autorização, auditoria, MFA e ciclo Joiner-Mover-Leaver
- Diretório: Active Directory, LDAP, Kerberos, OU, grupo (AGDLP), GPO e política de senha
- Nuvem Microsoft: Entra ID, Acesso Condicional, revisão de acesso, PIM e identidade híbrida
- Protocolos: SAML 2.0, OAuth 2.0, OpenID Connect, JWT, SCIM e Keycloak
- Governança: RBAC, ABAC, matriz de acesso, SoD, recertificação e reconciliação
- PAM: cofre, rotação, gravação de sessão, just-in-time, conta de serviço, LAPS e gMSA
- Nuvem pública: políticas e roles na AWS, RBAC no Azure
- Automação: PowerShell, Microsoft Graph, API REST e SQL
- Conformidade: ISO/IEC 27001 e 27002, LGPD, SOX/ITGC, NIST CSF 2.0, CIS Controls, Zero Trust e ITIL

Enquanto o checklist estiver desmarcado, o tema está no plano, não no currículo de produção.

## Ferramentas previstas para o laboratório

| Uso | Ferramenta |
| --- | --- |
| Diretório local | Windows Server em avaliação, AD DS, VirtualBox |
| Identidade Microsoft | Tenant de estudo do Microsoft Entra ID |
| SSO open source | Keycloak em Docker, só em `127.0.0.1` |
| PAM de estudo | Teleport Community e treinamentos gratuitos de mercado |
| Nuvem | Conta AWS de estudo e assinatura Azure de estudo |
| Automação | PowerShell, Microsoft Graph, SQLite ou SQL Server Express |
| Planilha | Excel, ou outro editor de CSV |
| Versão | Git e GitHub |

## Como o repositório está organizado

```text
.
├── README.md                 apresentação, roadmap e barra júnior
├── SEGURANCA.md              regras antes de qualquer commit
├── curriculum/progress.yml   itens, pesos e o que já foi concluído
├── scripts/atualizar-progresso.py
├── docs/trilha-iam.html      trilha interativa (abrir no navegador)
├── docs/progresso-junior.svg selo da meta júnior, gerado pelo script
├── docs/progresso-diferenciais.svg
├── 01-fundamentos/           conceitos e glossário
├── 02-active-directory/      lab de AD e LDAP
├── 03-microsoft-entra-id/
├── 04-protocolos-sso/        inclui o compose do Keycloak
├── 05-iga/                   inclui as matrizes de RBAC e SoD
├── 06-pam/                   diferencial
├── 07-cloud-iam/             diferencial; inclui políticas de exemplo da AWS
├── 08-automacao/             diferencial; PowerShell de JML e SQL de auditoria
├── 09-compliance/            diferencial
└── 10-entrevista-portfolio/  diferencial
```

Cada fase tem um `README.md` com objetivo, checklist tirado da trilha, links gratuitos e um modelo de registro de laboratório: objetivo, ambiente, passos, evidências, o que foi aprendido e uma nota de aplicação em vaga. O id de cada caixa (`f1-aaa`, `f2-jml` e os demais) é o mesmo do YAML e da trilha.

Modelos prontos para preencher, todos com dados fictícios e marcados como laboratório:

- [Scripts PowerShell de JML no AD](08-automacao/powershell/README.md)
- [Consultas SQL de auditoria de permissões](08-automacao/sql/README.md)
- [Matriz de acesso (RBAC) e matriz de SoD](05-iga/matrizes/README.md)
- [Keycloak local](04-protocolos-sso/keycloak/README.md)
- [Políticas de exemplo do AWS IAM](07-cloud-iam/aws/README.md)
- [Glossário](01-fundamentos/glossario.md), [pitch](10-entrevista-portfolio/pitch.md) e [perguntas de entrevista](10-entrevista-portfolio/perguntas.md)

A trilha interativa, com quizzes e passo a passo de instalação, está em [`docs/trilha-iam.html`](docs/trilha-iam.html). Abra o arquivo no navegador. O GitHub mostra o código-fonte. A barra dessa página também separa a meta júnior (fases 1 a 5) dos diferenciais (fases 6 a 10). O progresso dela fica só no navegador, em `localStorage`. A porcentagem deste README sai do YAML.

## Segurança

Leia [`SEGURANCA.md`](SEGURANCA.md) antes de commitar um laboratório. Resumo: sem segredo, sem dado de empresa, sem dado pessoal real, sem artefato de laboratório real ou multi-cloud, e print só anonimizado com placeholders da LabIAM.
