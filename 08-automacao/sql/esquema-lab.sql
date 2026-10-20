-- Esquema fictício da empresa LabIAM, só para treinar auditoria de permissões.
-- Não representa um banco real. Não importe dado de empresa aqui.
-- Testado em SQLite. No DB Browser: Arquivo > Importar > Banco de dados SQL.
-- No terminal: sqlite3 labiam.db < esquema-lab.sql

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS atribuicoes;
DROP TABLE IF EXISTS sod_conflitos;
DROP TABLE IF EXISTS contas_diretorio;
DROP TABLE IF EXISTS colaboradores_rh;

CREATE TABLE colaboradores_rh (
    matricula TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    cargo TEXT NOT NULL,
    departamento TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('ativo', 'desligado')),
    data_desligamento TEXT
);

CREATE TABLE contas_diretorio (
    sam_account TEXT PRIMARY KEY,
    matricula TEXT,
    habilitada INTEGER NOT NULL CHECK (habilitada IN (0, 1)),
    ultimo_logon TEXT,
    ou TEXT NOT NULL
);

CREATE TABLE atribuicoes (
    id INTEGER PRIMARY KEY,
    sam_account TEXT NOT NULL,
    sistema TEXT NOT NULL,
    perfil TEXT NOT NULL,
    privilegiado INTEGER NOT NULL CHECK (privilegiado IN (0, 1)),
    FOREIGN KEY (sam_account) REFERENCES contas_diretorio (sam_account)
);

CREATE TABLE sod_conflitos (
    id INTEGER PRIMARY KEY,
    sistema_a TEXT NOT NULL,
    perfil_a TEXT NOT NULL,
    sistema_b TEXT NOT NULL,
    perfil_b TEXT NOT NULL,
    risco TEXT NOT NULL,
    descricao TEXT NOT NULL
);

-- Datas relativas a "hoje" para o achado de 90 dias continuar válido
-- quando o arquivo for aberto daqui a alguns meses.
INSERT INTO colaboradores_rh (matricula, nome, cargo, departamento, status, data_desligamento) VALUES
('1001', 'Ana Teste', 'Analista de RH', 'RH', 'ativo', NULL),
('1002', 'Bruno Exemplo', 'Analista Financeiro', 'Financeiro', 'desligado', date('now', '-40 days')),
('1003', 'Carla Demonstracao', 'Analista de Suporte', 'TI', 'ativo', NULL),
('1004', 'Diego Ficticio', 'Coordenador Financeiro', 'Financeiro', 'ativo', NULL),
('1005', 'Elena Modelo', 'Analista Financeiro', 'Financeiro', 'ativo', NULL),
('1006', 'Fabio Laboratorio', 'Assistente de RH', 'RH', 'desligado', date('now', '-50 days')),
('1007', 'Gabriela Exemplo', 'Analista de Suporte', 'TI', 'ativo', NULL),
('1008', 'Heitor Teste', 'Assistente Financeiro', 'Financeiro', 'ativo', NULL),
('1009', 'Iris Modelo', 'Analista Comercial', 'Comercial', 'ativo', NULL),
('1010', 'Joao Lab', 'Estagiario de Suporte', 'TI', 'ativo', NULL);

INSERT INTO contas_diretorio (sam_account, matricula, habilitada, ultimo_logon, ou) VALUES
('ana.teste', '1001', 1, date('now', '-2 days'), 'OU=RH,OU=Usuarios,DC=labiam,DC=local'),
('bruno.exemplo', '1002', 1, date('now', '-1 days'), 'OU=Financeiro,OU=Usuarios,DC=labiam,DC=local'),
('carla.demo', '1003', 1, date('now', '-3 days'), 'OU=TI,OU=Usuarios,DC=labiam,DC=local'),
('diego.ficticio', '1004', 1, date('now', '-4 days'), 'OU=Financeiro,OU=Usuarios,DC=labiam,DC=local'),
('elena.modelo', '1005', 1, date('now', '-5 days'), 'OU=Financeiro,OU=Usuarios,DC=labiam,DC=local'),
('fabio.lab', '1006', 0, date('now', '-50 days'), 'OU=Desligados,OU=Usuarios,DC=labiam,DC=local'),
('gabriela.exemplo', '1007', 1, date('now', '-6 days'), 'OU=TI,OU=Usuarios,DC=labiam,DC=local'),
('heitor.teste', '1008', 1, date('now', '-120 days'), 'OU=Financeiro,OU=Usuarios,DC=labiam,DC=local'),
('iris.modelo', '1009', 1, date('now', '-7 days'), 'OU=Comercial,OU=Usuarios,DC=labiam,DC=local'),
('joao.lab', '1010', 1, date('now', '-8 days'), 'OU=TI,OU=Usuarios,DC=labiam,DC=local'),
('conta.orfa', NULL, 1, date('now', '-9 days'), 'OU=Usuarios,DC=labiam,DC=local'),
('svc.integracao.lab', NULL, 1, NULL, 'OU=ContasServico,DC=labiam,DC=local');

INSERT INTO atribuicoes (sam_account, sistema, perfil, privilegiado) VALUES
('ana.teste', 'ERP LabIAM', 'Consultar colaboradores', 0),
('bruno.exemplo', 'ERP LabIAM', 'Consultar financeiro', 0),
('diego.ficticio', 'ERP LabIAM', 'Administrador financeiro', 1),
('elena.modelo', 'ERP LabIAM', 'Cadastrar fornecedor', 0),
('elena.modelo', 'ERP LabIAM', 'Aprovar pagamento', 0),
('carla.demo', 'AD LabIAM', 'Resetar senha da OU Usuarios', 0),
('svc.integracao.lab', 'ERP LabIAM', 'Conta de servico de integracao', 1);

INSERT INTO sod_conflitos (sistema_a, perfil_a, sistema_b, perfil_b, risco, descricao) VALUES
(
    'ERP LabIAM',
    'Cadastrar fornecedor',
    'ERP LabIAM',
    'Aprovar pagamento',
    'alto',
    'A mesma pessoa pode criar um fornecedor e autorizar o pagamento a ele.'
);
