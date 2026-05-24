// backend/src/config/database.ts
import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'admin',
  database: process.env.DB_NAME || 'soccer_stats_hub',
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000, // Aumentado para 5 segundos
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
});

// Testar conexão ao iniciar
pool.connect((err, client, release) => {
  if (err) {
    console.error('Error connecting to database:', err.message);
  } else {
    console.log('✅ Database connected successfully');
    release();
  }
});

export const query = (text: string, params?: any[]) => {
  console.log('Executing query:', text.substring(0, 100));
  return pool.query(text, params);
};

export default pool;