// backend/src/scripts/initDb.ts
import { query } from '../config/database.js';
import fs from 'fs';
import path from 'path';
// Use current working directory as base to avoid import.meta usage in varied tsconfig/module setups
// This assumes the project is run from the repository root (or backend folder).
const projectRoot = process.cwd();
const __dirname = path.join(projectRoot, 'src', 'scripts');

const initDatabase = async () => {
  try {
    // Caminho para o arquivo SQL
    const sqlPath = path.join(__dirname, '../../sql/init.sql');
    
    console.log('Looking for SQL file at:', sqlPath);
    
    // Verifica se o arquivo existe
    if (!fs.existsSync(sqlPath)) {
      throw new Error(`SQL file not found at: ${sqlPath}`);
    }
    
    const sql = fs.readFileSync(sqlPath, 'utf-8');
    
    // Divide as statements (ignorando linhas vazias e comentários)
    const statements = sql
      .split(';')
      .filter(stmt => stmt.trim().length > 0 && !stmt.trim().startsWith('--'));
    
    console.log(`Found ${statements.length} SQL statements to execute`);
    
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i].trim();
      
      // Pula comandos CREATE DATABASE (já deve estar criado)
      if (statement.toUpperCase().startsWith('CREATE DATABASE')) {
        console.log('Skipping CREATE DATABASE statement');
        continue;
      }
      
      // Pula comandos \c (conexão com banco)
      if (statement.startsWith('\\c')) {
        console.log('Skipping \\c statement');
        continue;
      }
      
      try {
        await query(statement);
        console.log(`✅ Executed statement ${i + 1}/${statements.length}`);
      } catch (err) {
        console.error(`❌ Error executing statement ${i + 1}:`, err);
        // Continua com as próximas statements mesmo se uma falhar
      }
    }
    
    console.log('✅ Database initialization completed');
  } catch (error) {
    console.error('❌ Failed to initialize database:', error);
  } finally {
    process.exit();
  }
};

// Executa a inicialização
initDatabase();