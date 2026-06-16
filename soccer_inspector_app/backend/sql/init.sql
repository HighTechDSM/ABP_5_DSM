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
    "Athlete ID" BIGINT,
    "Athlete Position" TEXT,
    "Athlete Groups" TEXT,

    "Start Date" TEXT,
    "Start Time" TEXT,
    "Start Time (s)" TEXT,
    "End Time (s)" TEXT,
    "Week Start Date" TEXT,
    "Month Start Date" TEXT,

    "Segment Name" TEXT,

    "Duration (mins)" TEXT,
    "Session Load" TEXT,
    "Workload" TEXT,
    "Workload Volume" TEXT,
    "Workload Intensity" TEXT,

    "Distance (m)" TEXT,
    "Metres per Minute (m)" TEXT,
    "High Intensity Running (m)" TEXT,
    "No. of High Intensity Events" TEXT,
    "Sprint Distance (m)" TEXT,

    "Raw Top Speed (kph)" TEXT,
    "No. of Sprints" TEXT,
    "Top Speed (kph)" TEXT,
    "Avg Speed (kph)" TEXT,

    "Accelerations" TEXT,
    "Decelerations" TEXT,

    "Percentage of Max Speed" TEXT,
    "Percentage of Raw Max Speed KPH" TEXT,

    "90% of Max Speed Events" TEXT,
    "90% of Max Speed Distance (m)" TEXT,
    "90% of Max Speed Duration (secs)" TEXT,

    "90% of Raw Max Speed Events" TEXT,
    "90% of Raw Max Speed Distance (m)" TEXT,
    "90% of Raw Max Speed Duration (secs)" TEXT
);

-- ==========================================
-- ÍNDICES
-- ==========================================

CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

CREATE INDEX IF NOT EXISTS idx_dados_athlete_id
ON dados_extraidos("Athlete ID");

CREATE INDEX IF NOT EXISTS idx_dados_athlete_groups
ON dados_extraidos("Athlete Groups");

CREATE INDEX IF NOT EXISTS idx_dados_segment
ON dados_extraidos("Segment Name");

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