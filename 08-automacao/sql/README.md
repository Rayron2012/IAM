# SQL de auditoria — laboratório

Esquema e consultas da empresa fictícia **LabIAM**. Servem para a fase 8 e para o raciocínio de reconciliação da fase 5. Não há dado real.

O arquivo de banco `labiam.db` fica de fora do Git.

## Como rodar

Com o [DB Browser for SQLite](https://sqlitebrowser.org/): crie um banco vazio, execute `esquema-lab.sql` e depois `auditoria-permissoes.sql`.

No terminal, se o `sqlite3` estiver instalado:

```bash
sqlite3 labiam.db < esquema-lab.sql
sqlite3 -header -column labiam.db < auditoria-permissoes.sql
```

## O que cada consulta deve achar

| Consulta | Achado esperado neste exemplo |
| --- | --- |
| Desligado com conta ativa | `bruno.exemplo` (Bruno Exemplo, matrícula 1002) |
| Conta órfã | `conta.orfa` e `svc.integracao.lab` |
| Sem logon há 90 dias | `heitor.teste` |
| Perfil privilegiado | `diego.ficticio` e `svc.integracao.lab` |
| Conflito de SoD | `elena.modelo` cadastra fornecedor e aprova pagamento |
| Acesso de desligado | Bruno ainda tem perfil; Fábio está desabilitado e sem perfil |

`fabio.lab` é o desligamento feito certo: conta desabilitada, na OU de desligados, sem perfil. Ele não deve aparecer na fila de conta ativa.

A conta `svc.integracao.lab` não entra na fila de inatividade. Conta de serviço sem logon interativo pede outro controle: dono nomeado e senha rotacionada. O comentário no SQL explica o filtro.

As datas de logon e de desligamento são calculadas a partir de hoje, para o exemplo de 90 dias continuar válido.
