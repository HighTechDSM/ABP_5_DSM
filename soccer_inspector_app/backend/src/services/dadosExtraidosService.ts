import { query } from '../config/database';

export const getAllDadosExtraidos = async () => {
  const result = await query(`
    SELECT DISTINCT ON ("Athlete ID") *
    FROM dados_extraidos
    WHERE "Segment Name" = 'Whole Session'
    ORDER BY "Athlete ID", "Start Date" DESC
  `);

  return result.rows;
};

export const getDadosExtraidosById = async (athleteId: number) => {
  const result = await query(
   `
    SELECT *
    FROM dados_extraidos
    WHERE "Segment Name" = 'Whole Session'
      AND "Athlete ID" = $1
    ORDER BY TO_DATE("Start Date", 'DD/MM/YYYY')
    `,
    [athleteId]
  );

  return result.rows;
};

export const getDadosExtraidosByGrupo = async (grupo: string) => {
  const result = await query(
    `
    SELECT DISTINCT ON ("Athlete ID") *
    FROM dados_extraidos
    WHERE "Segment Name" = 'Whole Session'
      AND "Athlete Groups" = $1
    ORDER BY "Athlete ID", "Start Date" DESC
    `,
    [grupo]
  );

  return result.rows;
};

export const getDadosExtraidosByAthlete = async (athleteId: string) => {
  const result = await query(
    `
    SELECT DISTINCT ON ("Athlete ID") *
    FROM dados_extraidos
    WHERE "Segment Name" = 'Whole Session'
      AND CAST("Athlete ID" AS TEXT) ILIKE $1
    ORDER BY "Athlete ID", "Start Date" DESC
    `,
    [`%${athleteId}%`]
  );

  return result.rows;
};

export const getGruposDistinct = async () => {
  const result = await query(`
    SELECT DISTINCT "Athlete Groups"
    FROM dados_extraidos
    ORDER BY "Athlete Groups"
  `);

  return result.rows.map(
    (row: { ['Athlete Groups']: string }) => row['Athlete Groups']
  );
};

export const getEstatisticasResumo = async () => {
  const result = await query(`
    SELECT
      COUNT(DISTINCT "Athlete ID") AS total_atletas,
      COUNT(DISTINCT "Athlete Groups") AS total_grupos,

      AVG(
        NULLIF(
          REPLACE("Distance (m)", ',', '.'),
          ''
        )::numeric
      ) AS media_distancia,

      AVG(
        NULLIF(
          REPLACE("Top Speed (kph)", ',', '.'),
          ''
        )::numeric
      ) AS media_velocidade,

      SUM(
        NULLIF(
          REPLACE("Sprint Distance (m)", ',', '.'),
          ''
        )::numeric
      ) AS total_sprints

    FROM dados_extraidos
  `);

  const row = result.rows[0];

  return {
    totalAtletas: Number(row.total_atletas) || 0,
    totalGrupos: Number(row.total_grupos) || 0,
    mediaDistancia: Number(row.media_distancia) || 0,
    mediaVelocidade: Number(row.media_velocidade) || 0,
    totalSprints: Number(row.total_sprints) || 0,
  };
};