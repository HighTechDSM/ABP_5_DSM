import { query } from '../config/database';
import { DadosExtraidos, DadosExtraidosCreateInput } from '../types/index';

export const getAllDadosExtraidos = async (userId?: number): Promise<DadosExtraidos[]> => {
  let sql = `
    SELECT d.* 
    FROM dados_extraidos d
  `;
  
  const params: unknown[] = [];
  
  if (userId) {
    sql += `
      INNER JOIN users_d_extraidos ude ON d.id = ude.d_extraidos
      WHERE ude.users_id = $1
    `;
    params.push(userId);
  }
  
  sql += ` ORDER BY d.athlete`;
  
  const result = await query(sql, params);
  return result.rows as DadosExtraidos[];
};

export const getDadosExtraidosById = async (id: number, userId?: number): Promise<DadosExtraidos | null> => {
  let sql = `
    SELECT d.* 
    FROM dados_extraidos d
    WHERE d.id = $1
  `;
  
  const params: unknown[] = [id];
  
  if (userId) {
    sql += ` AND EXISTS (
      SELECT 1 FROM users_d_extraidos ude 
      WHERE ude.d_extraidos = d.id AND ude.users_id = $2
    )`;
    params.push(userId);
  }
  
  const result = await query(sql, params);
  
  if (result.rows.length === 0) {
    return null;
  }
  
  return result.rows[0] as DadosExtraidos;
};

export const getDadosExtraidosByGrupo = async (grupo: string, userId?: number): Promise<DadosExtraidos[]> => {
  let sql = `
    SELECT d.* 
    FROM dados_extraidos d
    WHERE d.grupos = $1
  `;
  
  const params: unknown[] = [grupo];
  
  if (userId) {
    sql += ` AND EXISTS (
      SELECT 1 FROM users_d_extraidos ude 
      WHERE ude.d_extraidos = d.id AND ude.users_id = $2
    )`;
    params.push(userId);
  }
  
  sql += ` ORDER BY d.athlete`;
  
  const result = await query(sql, params);
  return result.rows as DadosExtraidos[];
};

export const getDadosExtraidosByAthlete = async (athlete: string, userId?: number): Promise<DadosExtraidos[]> => {
  let sql = `
    SELECT d.* 
    FROM dados_extraidos d
    WHERE d.athlete ILIKE $1
  `;
  
  const params: unknown[] = [`%${athlete}%`];
  
  if (userId) {
    sql += ` AND EXISTS (
      SELECT 1 FROM users_d_extraidos ude 
      WHERE ude.d_extraidos = d.id AND ude.users_id = $2
    )`;
    params.push(userId);
  }
  
  sql += ` ORDER BY d.athlete`;
  
  const result = await query(sql, params);
  return result.rows as DadosExtraidos[];
};

export const getGruposDistinct = async (userId?: number): Promise<string[]> => {
  let sql = `
    SELECT DISTINCT d.grupos 
    FROM dados_extraidos d
  `;
  
  const params: unknown[] = [];
  
  if (userId) {
    sql += `
      INNER JOIN users_d_extraidos ude ON d.id = ude.d_extraidos
      WHERE ude.users_id = $1
    `;
    params.push(userId);
  }
  
  sql += ` ORDER BY d.grupos`;
  
  const result = await query(sql, params);
  return result.rows.map((row: { grupos: string }) => row.grupos);
};

export const createDadosExtraidos = async (data: DadosExtraidosCreateInput): Promise<DadosExtraidos> => {
  const result = await query(
    `INSERT INTO dados_extraidos (
      grupos, athlete, distance, session_load, workload,
      sprint_distance, high_intensity_running, high_intensity_events,
      metres_per_minute, no_sprint, top_speed, raw_top_speed,
      accelerations, decelerations, minutes_played
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
    RETURNING *`,
    [
      data.grupos, data.athlete, data.distance, data.session_load, data.workload,
      data.sprint_distance, data.high_intensity_running, data.high_intensity_events,
      data.metres_per_minute, data.no_sprint, data.top_speed, data.raw_top_speed,
      data.accelerations, data.decelerations, data.minutes_played
    ]
  );
  
  return result.rows[0] as DadosExtraidos;
};

export const updateDadosExtraidos = async (id: number, data: Partial<DadosExtraidosCreateInput>): Promise<DadosExtraidos | null> => {
  const fields: string[] = [];
  const values: unknown[] = [];
  let paramIndex = 1;
  
  const allowedFields = [
    'grupos', 'athlete', 'distance', 'session_load', 'workload',
    'sprint_distance', 'high_intensity_running', 'high_intensity_events',
    'metres_per_minute', 'no_sprint', 'top_speed', 'raw_top_speed',
    'accelerations', 'decelerations', 'minutes_played'
  ];
  
  for (const field of allowedFields) {
    if (data[field as keyof DadosExtraidosCreateInput] !== undefined) {
      fields.push(`${field} = $${paramIndex}`);
      values.push(data[field as keyof DadosExtraidosCreateInput]);
      paramIndex++;
    }
  }
  
  if (fields.length === 0) {
    return null;
  }
  
  values.push(id);
  
  const result = await query(
    `UPDATE dados_extraidos 
     SET ${fields.join(', ')} 
     WHERE id = $${paramIndex} 
     RETURNING *`,
    values
  );
  
  if (result.rows.length === 0) {
    return null;
  }
  
  return result.rows[0] as DadosExtraidos;
};

export const deleteDadosExtraidos = async (id: number): Promise<boolean> => {
  const result = await query('DELETE FROM dados_extraidos WHERE id = $1', [id]);
  return (result.rowCount ?? 0) > 0;
};

export const associateDadosExtraidosWithUser = async (userId: number, dadosExtraidosId: number): Promise<void> => {
  await query(
    `INSERT INTO users_d_extraidos (users_id, d_extraidos) 
     VALUES ($1, $2) 
     ON CONFLICT (users_id, d_extraidos) DO NOTHING`,
    [userId, dadosExtraidosId]
  );
};

export const dissociateDadosExtraidosFromUser = async (userId: number, dadosExtraidosId: number): Promise<void> => {
  await query(
    'DELETE FROM users_d_extraidos WHERE users_id = $1 AND d_extraidos = $2',
    [userId, dadosExtraidosId]
  );
};

export const getDadosExtraidosByUser = async (userId: number): Promise<DadosExtraidos[]> => {
  const result = await query(
    `SELECT d.* 
     FROM dados_extraidos d
     INNER JOIN users_d_extraidos ude ON d.id = ude.d_extraidos
     WHERE ude.users_id = $1
     ORDER BY d.athlete`,
    [userId]
  );
  
  return result.rows as DadosExtraidos[];
};

export const getEstatisticasResumo = async (userId?: number): Promise<{
  totalAtletas: number;
  totalGrupos: number;
  mediaDistancia: number;
  mediaVelocidade: number;
  totalSprints: number;
}> => {
  let sql = `
    SELECT 
      COUNT(DISTINCT d.athlete) as total_atletas,
      COUNT(DISTINCT d.grupos) as total_grupos,
      AVG(d.distance) as media_distancia,
      AVG(d.top_speed) as media_velocidade,
      SUM(d.sprint_distance) as total_sprints
    FROM dados_extraidos d
  `;
  
  const params: unknown[] = [];
  
  if (userId) {
    sql += `
      INNER JOIN users_d_extraidos ude ON d.id = ude.d_extraidos
      WHERE ude.users_id = $1
    `;
    params.push(userId);
  }
  
  const result = await query(sql, params);
  const row = result.rows[0];
  
  return {
    totalAtletas: parseInt(row.total_atletas) || 0,
    totalGrupos: parseInt(row.total_grupos) || 0,
    mediaDistancia: parseFloat(row.media_distancia) || 0,
    mediaVelocidade: parseFloat(row.media_velocidade) || 0,
    totalSprints: parseInt(row.total_sprints) || 0
  };
};