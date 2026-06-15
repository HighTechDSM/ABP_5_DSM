import { query } from '../config/database';
import fs from 'fs';
import path from 'path';

export const initDatabase = async () => {
  try {
    const projectRoot = process.cwd();

    const sqlPath = path.join(
      projectRoot,
      'sql',
      'init.sql'
    );

    console.log(' Procurando arquivo SQL em:', sqlPath);

    if (!fs.existsSync(sqlPath)) {
      throw new Error(
        `Arquivo não encontrado: ${sqlPath}`
      );
    }

    const sql = fs.readFileSync(
      sqlPath,
      'utf8'
    );

    console.log(' Executando script SQL...');

    await query(sql);

    console.log(
      '✅ Banco de dados inicializado com sucesso!'
    );
  } catch (error: any) {
    console.error(
      '❌ Erro ao inicializar banco:',
      error.message
    );

    throw error;
  }
};