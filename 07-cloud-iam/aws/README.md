# Políticas de exemplo — AWS IAM

Quatro JSON para ler, colar no simulador de políticas e discutir na fase 7. A conta `111122223333`, a usuária `ana.auditora` e o bucket `labiam-relatorios-exemplo` são nomes de documentação. Não anexe isto numa conta real sem revisar cada ação.

JSON não aceita comentário. A explicação fica aqui.

| Arquivo | O que mostra |
| --- | --- |
| `politica-leitura-bucket-lab.json` | Allow mínimo: listar e ler só o prefixo `relatorios/` de um bucket. Não há `s3:*` nem `Resource: "*"`. |
| `politica-negacao-explicita-lab.json` | Deny explícito de ações que criam usuário, access key ou anexam política. Sozinho, este JSON não concede nada. Um Deny explícito vence um Allow de outra política. |
| `politica-confianca-role-lab.json` | Política de **confiança** de uma role: quem pode assumir, e só com MFA. Não é a política do que a role pode fazer. |
| `politica-auditoria-iam-lab.json` | Leitura de IAM e do Access Analyzer para um perfil de auditoria. Continua ampla em `Resource: "*"`, porque essas ações de leitura em geral não aceitam um ARN estreito. Não inclui `iam:Create*`, `iam:Put*` nem `iam:Attach*`. |

Ordem útil no simulador: a usuária com a política de leitura do bucket consegue `s3:GetObject` naquele prefixo e não consegue `iam:CreateUser`. A política de negação, se anexada junto de um Allow amplo, continua bloqueando a criação de access key.
