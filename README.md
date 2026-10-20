# Portfólio de estudos em IAM

Laboratório e anotações de **Rayron Soares**, analista de SOC N2 em transição para Identity and Access Management (IAM).

Este repositório registra estudo e prática em ambiente isolado. Não descreve produção, não substitui experiência profissional em IAM e não deve ser lido como lista de projetos entregues em empresa.

## Objetivo

Construir a base técnica para atuar como analista de IAM: a linguagem da área, Active Directory, Microsoft Entra ID, protocolos de SSO, governança de acessos (IGA), acesso privilegiado (PAM), IAM em nuvem, automação e controles de conformidade.

A trilha tem dez fases. Na própria trilha, **júnior apto** significa concluir os itens obrigatórios das fases 1 a 5, e **pleno apto** significa concluir os itens obrigatórios de todas as fases. Esse marco é de estudo. Uma vaga de nível pleno também pede tempo de experiência real em IAM, e este repositório não afirma essa experiência.

## Andamento

O checklist de cada item fica no README da fase, com caixas que o GitHub desenha. Nesta tabela, o status é da fase inteira: troque `☐` por `☑` quando os itens obrigatórios estiverem feitos.

| Fase | Tema | Duração sugerida | Status |
| --- | --- | --- | --- |
| [1. Fundamentos](01-fundamentos/README.md) | AAA, tipos de identidade, menor privilégio, MFA, JML e glossário | 1–2 semanas | ☐ |
| [2. Active Directory e LDAP](02-active-directory/README.md) | Domínio de laboratório, OUs, grupos, GPO, senha e JML | 3–4 semanas | ☐ |
| [3. Microsoft Entra ID](03-microsoft-entra-id/README.md) | Usuários, MFA, Acesso Condicional, SSO, revisões e PIM | 3 semanas | ☐ |
| [4. Protocolos e SSO](04-protocolos-sso/README.md) | SAML, OAuth 2.0, OIDC, JWT, SCIM e Keycloak | 3 semanas | ☐ |
| [5. Governança (IGA)](05-iga/README.md) | JML formal, RBAC, matriz de acesso, SoD e recertificação | 3 semanas | ☐ |
| [6. PAM](06-pam/README.md) | Cofre, rotação, sessão, contas de serviço e just-in-time | 2–3 semanas | ☐ |
| [7. IAM em nuvem](07-cloud-iam/README.md) | AWS IAM e RBAC do Azure, com menor privilégio | 2 semanas | ☐ |
| [8. Automação](08-automacao/README.md) | PowerShell, Microsoft Graph, REST e SQL | 3 semanas | ☐ |
| [9. Conformidade](09-compliance/README.md) | ISO 27001, LGPD, NIST, CIS, Zero Trust e ITIL | 2–3 semanas | ☐ |
| [10. Entrevista e portfólio](10-entrevista-portfolio/README.md) | Documentação, pitch, perguntas e inglês técnico | 2 semanas, e contínuo | ☐ |

Itens opcionais não entram nessa conta. Eles estão marcados dentro de cada fase.

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
├── README.md                 apresentação e andamento
├── SEGURANCA.md              regras antes de qualquer commit
├── docs/trilha-iam.html      trilha interativa (abrir no navegador)
├── 01-fundamentos/           conceitos e glossário
├── 02-active-directory/      lab de AD e LDAP
├── 03-microsoft-entra-id/
├── 04-protocolos-sso/        inclui o compose do Keycloak
├── 05-iga/                   inclui as matrizes de RBAC e SoD
├── 06-pam/
├── 07-cloud-iam/             inclui políticas de exemplo da AWS
├── 08-automacao/             PowerShell de JML e SQL de auditoria
├── 09-compliance/
└── 10-entrevista-portfolio/
```

Cada fase tem um `README.md` com objetivo, checklist tirado da trilha, links gratuitos e um modelo de registro de laboratório: objetivo, ambiente, passos, evidências, o que foi aprendido e uma nota de aplicação em vaga.

Modelos prontos para preencher, todos com dados fictícios e marcados como laboratório:

- [Scripts PowerShell de JML no AD](08-automacao/powershell/README.md)
- [Consultas SQL de auditoria de permissões](08-automacao/sql/README.md)
- [Matriz de acesso (RBAC) e matriz de SoD](05-iga/matrizes/README.md)
- [Keycloak local](04-protocolos-sso/keycloak/README.md)
- [Políticas de exemplo do AWS IAM](07-cloud-iam/aws/README.md)
- [Glossário](01-fundamentos/glossario.md), [pitch](10-entrevista-portfolio/pitch.md) e [perguntas de entrevista](10-entrevista-portfolio/perguntas.md)

A trilha interativa, com quizzes e passo a passo de instalação, está em [`docs/trilha-iam.html`](docs/trilha-iam.html). Abra o arquivo no navegador. O GitHub mostra o código-fonte; o progresso fica só no navegador, em `localStorage`.

## Segurança

Leia [`SEGURANCA.md`](SEGURANCA.md) antes de commitar um laboratório. Resumo: sem segredo, sem dado de empresa, sem dado pessoal real, e print só anonimizado.
