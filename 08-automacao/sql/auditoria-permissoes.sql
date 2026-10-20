-- Consultas de auditoria da LabIAM. Rode depois de esquema-lab.sql.
-- Cada bloco responde um achado clássico de IAM. Leia o comentário antes do SELECT.
-- Conta de serviço sem logon interativo não entra na fila de "inativo há 90 dias":
-- isso é outro controle (dono da conta e rotação), não um usuário esquecido.

-- 1) Desligado no RH com conta ainda habilitada.
SELECT
    c.matricula,
    c.nome,
    c.data_desligamento,
    d.sam_account,
    d.ou
FROM colaboradores_rh AS c
JOIN contas_diretorio AS d
    ON d.matricula = c.matricula
WHERE c.status = 'desligado'
  AND d.habilitada = 1;

-- 2) Conta órfã: existe no diretório e não tem dono no RH.
SELECT
    d.sam_account,
    d.matricula,
    d.habilitada,
    d.ou
FROM contas_diretorio AS d
LEFT JOIN colaboradores_rh AS c
    ON c.matricula = d.matricula
WHERE c.matricula IS NULL;

-- 3) Conta humana habilitada sem logon há 90 dias ou mais.
SELECT
    sam_account,
    matricula,
    ultimo_logon,
    ou
FROM contas_diretorio
WHERE habilitada = 1
  AND ou NOT LIKE '%ContasServico%'
  AND (
        ultimo_logon IS NULL
        OR date(ultimo_logon) < date('now', '-90 days')
  );

-- 4) Quem tem perfil marcado como privilegiado.
SELECT
    a.sam_account,
    c.nome,
    a.sistema,
    a.perfil
FROM atribuicoes AS a
JOIN contas_diretorio AS d
    ON d.sam_account = a.sam_account
LEFT JOIN colaboradores_rh AS c
    ON c.matricula = d.matricula
WHERE a.privilegiado = 1;

-- 5) Conflito de SoD: a mesma conta tem os dois perfis do par.
SELECT
    a1.sam_account,
    s.risco,
    s.descricao,
    a1.perfil AS perfil_a,
    a2.perfil AS perfil_b
FROM sod_conflitos AS s
JOIN atribuicoes AS a1
    ON a1.sistema = s.sistema_a
   AND a1.perfil = s.perfil_a
JOIN atribuicoes AS a2
    ON a2.sam_account = a1.sam_account
   AND a2.sistema = s.sistema_b
   AND a2.perfil = s.perfil_b
   AND a2.id <> a1.id;

-- 6) Acesso que sobrou em conta de pessoa já desligada.
SELECT
    c.nome,
    c.status,
    c.data_desligamento,
    d.sam_account,
    d.habilitada,
    a.sistema,
    a.perfil
FROM colaboradores_rh AS c
JOIN contas_diretorio AS d
    ON d.matricula = c.matricula
LEFT JOIN atribuicoes AS a
    ON a.sam_account = d.sam_account
WHERE c.status = 'desligado';
