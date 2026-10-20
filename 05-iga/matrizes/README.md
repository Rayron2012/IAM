# Matrizes de acesso e de SoD — laboratório

Dois CSVs da empresa fictícia **LabIAM**, no formato que o Excel em português abre (separador `;` e UTF-8 com BOM). São ponto de partida da fase 5, não uma matriz de empresa real.

| Arquivo | O que é |
| --- | --- |
| `matriz-acesso-rbac.csv` | Cargo × sistema × perfil. Diz o que cada papel deve ter, e se isso é acesso padrão do cargo. |
| `matriz-sod.csv` | Pares de perfis que não podem ficar na mesma pessoa, o risco e um controle compensatório quando a separação não couber. |

No Excel: Dados > De Texto/CSV, se as colunas não se separarem sozinhas. Escolha o delimitador ponto e vírgula.

A consulta de SoD em [`../../08-automacao/sql/auditoria-permissoes.sql`](../../08-automacao/sql/auditoria-permissoes.sql) usa o mesmo par do ERP (cadastrar fornecedor × aprovar pagamento) para você ver a matriz virar achado.

Quando for a sua vez, duplique a linha e troque o exemplo. Não cole cargo, sistema ou nome de pessoa de um ambiente real.
