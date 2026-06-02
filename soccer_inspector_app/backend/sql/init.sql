-- ==========================================
-- TABELA DE USUÁRIOS
-- ==========================================

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- TABELA DE DADOS EXTRAÍDOS
-- ==========================================

CREATE TABLE IF NOT EXISTS dados_extraidos (
    id SERIAL PRIMARY KEY,
    grupos VARCHAR(10) NOT NULL,
    athlete VARCHAR(100) NOT NULL,
    distance INT NOT NULL,
    session_load INT NOT NULL,
    workload NUMERIC(10,2) NOT NULL,
    sprint_distance INT NOT NULL,
    high_intensity_running INT NOT NULL,
    high_intensity_events INT NOT NULL,
    metres_per_minute INT NOT NULL,
    no_sprint INT NOT NULL,
    top_speed NUMERIC(10,2) NOT NULL,
    raw_top_speed NUMERIC(10,2) NOT NULL,
    accelerations INT NOT NULL,
    decelerations INT NOT NULL,
    minutes_played INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- TABELA RELAÇÃO USUÁRIO x DADOS
-- ==========================================

CREATE TABLE IF NOT EXISTS users_d_extraidos (
    users_id INT NOT NULL,
    d_extraidos_id INT NOT NULL,
    PRIMARY KEY (users_id, d_extraidos_id),
    FOREIGN KEY (users_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (d_extraidos_id) REFERENCES dados_extraidos(id) ON DELETE CASCADE
);

-- ==========================================
-- INSERÇÃO DOS DADOS APENAS SE A TABELA
-- ESTIVER VAZIA
-- ==========================================

INSERT INTO dados_extraidos (
    grupos, athlete, distance, session_load, workload,
    sprint_distance, high_intensity_running, high_intensity_events,
    metres_per_minute, no_sprint, top_speed, raw_top_speed,
    accelerations, decelerations, minutes_played
)
SELECT *
FROM (
    VALUES
    ('10s', 'A', 9005, 1764, 8.1, 61, 235, 24, 93, 5, 30.4, 32.3, 84, 89, 97),
    ('10s', 'J', 9726, 1763, 9.2, 83, 528, 41, 100, 6, 30.4, 34.0, 72, 60, 97),
    ('10s', 'K', 7895, 1330, 7.8, 84, 400, 42, 81, 6, 28.2, 31.6, 67, 69, 97),
    ('10s', 'S', 1400, 341, 2.5, 38, 144, 10, 14, 3, 26.9, 29.7, 5, 16, 97),
    ('CBs', 'C', 317, 93, 0.5, 0, 31, 1, 3, 0, 24.1, 26.3, 2, 3, 97),
    ('CBs', 'd', 10199, 1843, 9.0, 30, 236, 20, 105, 2, 26.9, 30.7, 91, 86, 97),
    ('CBs', 'L', 9185, 1240, 8.7, 54, 408, 33, 95, 5, 30.9, 33.7, 80, 74, 97),
    ('CMs', 'An', 173, 21, 0.2, 0, 0, 0, 2, 0, 12.2, 14.5, 1, 1, 97),
    ('CMs', 'G', 10259, 1858, 8.8, 76, 282, 26, 106, 4, 29.9, 34.8, 50, 90, 97),
    ('STs', 'Tr', 10192, 1733, 8.7, 105, 410, 46, 105, 11, 27.7, 30.0, 82, 75, 97),
    ('WBs', 'H', 2357, 430, 3.1, 85, 149, 17, 24, 4, 29.1, 31.7, 18, 26, 97),
    ('WBs', 'O', 2481, 528, 3.3, 62, 191, 21, 26, 6, 26.8, 30.1, 23, 26, 97),
    ('None', 'I', 8622, 1235, 8.9, 80, 139, 17, 89, 5, 29.8, 32.2, 49, 45, 97),
    ('None', 'L', 7348, 1260, 6.5, 39, 215, 21, 76, 4, 29.8, 31.3, 42, 51, 97),
    ('None', 'T', 9265, 1486, 9.6, 135, 412, 38, 96, 8, 29.5, 34.9, 68, 78, 97),
    ('None', 'Trs', 433, 252, 0.5, 0, 30, 2, 4, 0, 22.8, 25.4, 5, 0, 97)
) AS dados(
    grupos, athlete, distance, session_load, workload,
    sprint_distance, high_intensity_running, high_intensity_events,
    metres_per_minute, no_sprint, top_speed, raw_top_speed,
    accelerations, decelerations, minutes_played
)
WHERE NOT EXISTS (
    SELECT 1 FROM dados_extraidos
);

-- ==========================================
-- ÍNDICES
-- ==========================================

CREATE INDEX IF NOT EXISTS idx_dados_grupos
ON dados_extraidos(grupos);

CREATE INDEX IF NOT EXISTS idx_dados_athlete
ON dados_extraidos(athlete);

CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

-- ==========================================
-- TRIGGER DE UPDATED_AT
-- ==========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_users_updated_at ON users;

CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();