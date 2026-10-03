-- Dados de demonstração: rebanho, equipe veterinária e histórico de atendimentos realistas.
-- Migration nova (em vez de alterar V5/V6) para não quebrar o checksum do Flyway em bancos já criados.

-- ---------------------------------------------------------------
-- 1. Rebanho: dá nome e raça aos animais de teste
-- ---------------------------------------------------------------
UPDATE agrocare_animals SET nome = 'Mimosa',  especie = 'Bovino · Gir Leiteiro', idade = 5, peso = 545.0 WHERE nome = 'Bovino 1';
UPDATE agrocare_animals SET nome = 'Estrela', especie = 'Bovino · Girolando',    idade = 3, peso = 510.0 WHERE nome = 'Bovino 2';
UPDATE agrocare_animals SET nome = 'Trovão',  especie = 'Bovino · Nelore',       idade = 4, peso = 690.0 WHERE nome = 'Bovino 3';
UPDATE agrocare_animals SET nome = 'Pintada', especie = 'Bovino · Holandesa',    idade = 2, peso = 480.0 WHERE nome = 'Bovino 4';
UPDATE agrocare_animals SET nome = 'Barão',   especie = 'Bovino · Angus',        idade = 6, peso = 760.0 WHERE nome = 'Bovino 5';

INSERT INTO agrocare_animals (id, nome, especie, idade, peso, url_image) VALUES
    (gen_random_uuid(), 'Jabuticaba', 'Bovino · Girolando',    4, 520.0, NULL),
    (gen_random_uuid(), 'Serena',     'Bovino · Holandesa',    5, 610.0, NULL),
    (gen_random_uuid(), 'Caramelo',   'Bovino · Nelore',       3, 480.0, NULL),
    (gen_random_uuid(), 'Princesa',   'Bovino · Gir Leiteiro', 6, 540.0, NULL),
    (gen_random_uuid(), 'Valente',    'Bovino · Brahman',      4, 720.0, NULL),
    (gen_random_uuid(), 'Lua',        'Bovino · Jersey',       3, 410.0, NULL),
    (gen_random_uuid(), 'Fortuna',    'Bovino · Girolando',    7, 565.0, NULL),
    (gen_random_uuid(), 'Rubi',       'Bovino · Senepol',      2, 390.0, NULL),
    (gen_random_uuid(), 'Bonança',    'Bovino · Nelore',       5, 530.0, NULL),
    (gen_random_uuid(), 'Malhada',    'Bovino · Holandesa',    4, 590.0, NULL),
    (gen_random_uuid(), 'Tufão',      'Bovino · Angus',        3, 650.0, NULL),
    (gen_random_uuid(), 'Cereja',     'Bovino · Jersey',       2, 360.0, NULL),
    (gen_random_uuid(), 'Imperador',  'Bovino · Nelore',       6, 880.0, NULL),
    (gen_random_uuid(), 'Esperança',  'Bovino · Gir Leiteiro', 1, 185.0, NULL),
    (gen_random_uuid(), 'Faísca',     'Bovino · Girolando',    1, 160.0, NULL),
    (gen_random_uuid(), 'Pérola',     'Bovino · Guzerá',       5, 505.0, NULL),
    (gen_random_uuid(), 'Sultão',     'Bovino · Brahman',      7, 910.0, NULL),
    (gen_random_uuid(), 'Aurora',     'Bovino · Holandesa',    3, 570.0, NULL),
    (gen_random_uuid(), 'Graúna',     'Bovino · Nelore',       4, 500.0, NULL),
    (gen_random_uuid(), 'Doçura',     'Bovino · Jersey',       6, 425.0, NULL);

-- ---------------------------------------------------------------
-- 2. Equipe veterinária: atualiza os dois existentes e adiciona novos
--    (fotos do randomuser.me; se não carregarem, a tela mostra as iniciais)
-- ---------------------------------------------------------------
UPDATE agrocare_veterinario
SET avatar = 'https://randomuser.me/api/portraits/men/32.jpg',
    phone_number = '64999810231', cmrv = 'CRMV-GO 04512', especializacao_veterinario = 'Clínica Geral'
WHERE email = 'joao.silva@exemplo.com';

UPDATE agrocare_veterinario
SET avatar = 'https://randomuser.me/api/portraits/women/44.jpg',
    phone_number = '64999723418', cmrv = 'CRMV-GO 05873', especializacao_veterinario = 'Nutrição Animal'
WHERE email = 'ana.costa@exemplo.com';

INSERT INTO agrocare_veterinario (id, name, phone_number, email, password, avatar, role, especializacao_veterinario, cmrv) VALUES
    (gen_random_uuid(), 'Dra. Mariana Rocha',      '64998457720', 'mariana.rocha@exemplo.com',  'demo', 'https://randomuser.me/api/portraits/women/68.jpg', 'Veterinário', 'Reprodução Animal',           'CRMV-GO 06120'),
    (gen_random_uuid(), 'Dr. Rafael Mendes',       '64999132245', 'rafael.mendes@exemplo.com',  'demo', 'https://randomuser.me/api/portraits/men/46.jpg',   'Veterinário', 'Cirurgia de Grandes Animais', 'CRMV-GO 03987'),
    (gen_random_uuid(), 'Dra. Beatriz Andrade',    '64998264513', 'beatriz.andrade@exemplo.com','demo', 'https://randomuser.me/api/portraits/women/65.jpg', 'Veterinário', 'Sanidade de Rebanho',         'CRMV-GO 07241'),
    (gen_random_uuid(), 'Dr. Carlos Eduardo Lima', '64999587106', 'carlos.lima@exemplo.com',    'demo', 'https://randomuser.me/api/portraits/men/75.jpg',   'Veterinário', 'Podologia Bovina',            'CRMV-GO 02856'),
    (gen_random_uuid(), 'Dra. Juliana Ferreira',   '64998671294', 'juliana.ferreira@exemplo.com','demo','https://randomuser.me/api/portraits/women/33.jpg', 'Veterinário', 'Reprodução Animal',           'CRMV-GO 06694'),
    (gen_random_uuid(), 'Dr. Pedro Henrique Alves','64999046382', 'pedro.alves@exemplo.com',    'demo', 'https://randomuser.me/api/portraits/men/52.jpg',   'Veterinário', 'Clínica Geral',               'CRMV-GO 05310');

-- ---------------------------------------------------------------
-- 3. Histórico de atendimentos
-- ---------------------------------------------------------------
-- Traz os atendimentos antigos (out/2024) para perto da data atual
UPDATE agrocare_servico
SET data_servico = data_servico + (CURRENT_DATE - DATE '2024-10-20') - 40;

-- Novos atendimentos nos últimos 6 meses, relativos à data em que a migration roda
INSERT INTO agrocare_servico (data_servico, preco_servico, diagnostico, animal_id, veterinario_id)
SELECT CURRENT_DATE - s.dias, s.preco, s.diagnostico, a.id, v.id
FROM (VALUES
    (  1,  95.00, 'Vacinação contra febre aftosa',                        'Esperança',  'beatriz.andrade@exemplo.com'),
    (  2, 320.00, 'Diagnóstico de gestação por ultrassom',                'Serena',     'mariana.rocha@exemplo.com'),
    (  3, 180.00, 'Tratamento de mastite clínica',                        'Malhada',    'joao.silva@exemplo.com'),
    (  5, 260.00, 'Casqueamento corretivo e curativo de casco',           'Imperador',  'carlos.lima@exemplo.com'),
    (  7, 150.00, 'Exame de sangue (hemograma completo)',                 'Valente',    'pedro.alves@exemplo.com'),
    (  9, 410.00, 'Inseminação artificial em tempo fixo (IATF)',          'Princesa',   'juliana.ferreira@exemplo.com'),
    ( 12, 210.00, 'Avaliação nutricional e ajuste de dieta',              'Lua',        'ana.costa@exemplo.com'),
    ( 15,  85.00, 'Vacinação contra brucelose (B19)',                     'Faísca',     'beatriz.andrade@exemplo.com'),
    ( 18, 140.00, 'Vermifugação e controle de carrapatos',                'Graúna',     'pedro.alves@exemplo.com'),
    ( 21, 980.00, 'Cirurgia de correção de hérnia umbilical',             'Rubi',       'rafael.mendes@exemplo.com'),
    ( 25, 230.00, 'Tratamento de tristeza parasitária bovina',            'Tufão',      'joao.silva@exemplo.com'),
    ( 29, 350.00, 'Exame andrológico de touro',                           'Sultão',     'mariana.rocha@exemplo.com'),
    ( 33, 120.00, 'Consulta de rotina e avaliação de escore corporal',    'Doçura',     'ana.costa@exemplo.com'),
    ( 38,  95.00, 'Vacinação contra raiva',                               'Aurora',     'beatriz.andrade@exemplo.com'),
    ( 42, 190.00, 'Tratamento de pneumonia',                              'Cereja',     'pedro.alves@exemplo.com'),
    ( 47, 320.00, 'Diagnóstico de gestação por ultrassom',                'Fortuna',    'juliana.ferreira@exemplo.com'),
    ( 53, 270.00, 'Exame de tuberculose (tuberculinização)',              'Pérola',     'beatriz.andrade@exemplo.com'),
    ( 58, 240.00, 'Casqueamento preventivo',                              'Jabuticaba', 'carlos.lima@exemplo.com'),
    ( 64, 160.00, 'Tratamento de ceratoconjuntivite (olho rosa)',         'Caramelo',   'joao.silva@exemplo.com'),
    ( 70, 410.00, 'Inseminação artificial em tempo fixo (IATF)',          'Estrela',    'mariana.rocha@exemplo.com'),
    ( 77, 650.00, 'Atendimento de parto distócico',                       'Mimosa',     'rafael.mendes@exemplo.com'),
    ( 85, 110.00, 'Vacinação contra clostridioses',                       'Bonança',    'beatriz.andrade@exemplo.com'),
    ( 93, 200.00, 'Avaliação nutricional e suplementação mineral',        'Trovão',     'ana.costa@exemplo.com'),
    (101, 150.00, 'Exame de sangue (hemograma completo)',                 'Pintada',    'pedro.alves@exemplo.com'),
    (112, 180.00, 'Tratamento de diarreia em bezerro',                    'Esperança',  'joao.silva@exemplo.com'),
    (124, 520.00, 'Remoção cirúrgica de papilomas',                       'Barão',      'rafael.mendes@exemplo.com'),
    (137, 140.00, 'Vermifugação e controle de carrapatos',                'Valente',    'pedro.alves@exemplo.com'),
    (151,  95.00, 'Vacinação contra febre aftosa',                        'Imperador',  'beatriz.andrade@exemplo.com'),
    (166, 350.00, 'Exame andrológico de touro',                           'Imperador',  'mariana.rocha@exemplo.com'),
    (178, 120.00, 'Consulta de rotina',                                   'Serena',     'joao.silva@exemplo.com')
) AS s(dias, preco, diagnostico, animal, email)
JOIN agrocare_animals a ON a.nome = s.animal
JOIN agrocare_veterinario v ON v.email = s.email
ORDER BY s.dias;
