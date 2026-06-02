// backend/src/scripts/initDb.ts
import { query } from '../config/database.js';
import fs from 'fs';
import path from 'path';
// Use current working directory as base to avoid import.meta usage in varied tsconfig/module setups
// This assumes the project is run from the repository root (or backend folder).
const projectRoot = process.cwd();
const __dirname = path.join(projectRoot, 'src', 'scripts');

export const initDatabase = async () => {
  try {
    const projectRoot = process.cwd();

    const sqlPath = path.join(projectRoot, 'sql', 'init.sql');

    console.log('📄 Procurando arquivo SQL em:', sqlPath);

    if (!fs.existsSync(sqlPath)) {
      throw new Error(`Arquivo não encontrado: ${sqlPath}`);
    }

    const sql = fs.readFileSync(sqlPath, 'utf8');

    console.log('🚀 Executando script SQL...');

    await query(sql);

    console.log('✅ Banco de dados inicializado com sucesso!');
  } catch (error: any) {
    console.error('❌ Erro ao inicializar banco:', error.message);
  }
};
