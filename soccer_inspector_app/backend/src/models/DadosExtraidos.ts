import { query } from '../config/database';
import { JogadorStats } from '../types';

export const DadosExtraidosModel = {
  calcularPerfil(
  velocidadeMax: number,
  distancia: number,
  sprints: number
): string {

  if (velocidadeMax >= 30) {
    return 'Explosivo';
  }

  if (sprints >= 8) {
    return 'Alta carga de impacto';
  }

  if (distancia >= 8000) {
    return 'Alta resistência';
  }

  return 'Baixa intensidade';
},

  calcularRendimento(
    velocidade: number,
    distancia: number,
    sprints: number
  ): 'otimo' | 'regular' | 'baixo' {
    if (distancia > 8.5 && velocidade > 29) {
      return 'otimo';
    } else if (distancia < 6 || velocidade < 26) {
      return 'baixo';
    }

    return 'regular';
  },

  calcularTendencia(
    historico: Array<{
      data: string;
      velocidade: number;
      distancia: number;
      valor: number;
    }>
  ): number {
    if (historico.length < 2) {
      return 0;
    }

    const primeiroValor = historico[0].valor;
    const ultimoValor = historico[historico.length - 1].valor;

    if (primeiroValor === 0) {
      return 0;
    }

    const variacao =
      ((ultimoValor - primeiroValor) /
        Math.abs(primeiroValor)) *
      100;

    return Math.floor(variacao);
  },

async getAllJogadoresStats(): Promise<JogadorStats[]> {
  const result = await query(`
    SELECT DISTINCT ON ("Athlete ID") *
FROM dados_extraidos
WHERE "Segment Name" = 'Whole Session'
ORDER BY
  "Athlete ID",
  TO_DATE("Start Date",'DD/MM/YYYY') DESC
  `);

    return result.rows.map(row => this.mapJogador(row));
  },

  
async getJogadorStatsById(athleteId: number): Promise<JogadorStats | null> {
  const result = await query(
    `
    SELECT *
    FROM dados_extraidos
    WHERE "Segment Name" = 'Whole Session'
      AND "Athlete ID" = $1
    ORDER BY TO_DATE("Start Date", 'DD/MM/YYYY') ASC
    `,
    [athleteId]
  );

  if (result.rows.length === 0) {
    return null;
  }

const jogador = this.mapJogador(
  result.rows[result.rows.length - 1]
);

const historicoMap = new Map<string, any>();

result.rows.forEach(row => {
  const data = String(row['Start Date'] || '');

  if (!historicoMap.has(data)) {
    historicoMap.set(data, {
      data,
      velocidade:
        Number(
          String(row['Top Speed (kph)'] || '0')
            .replace(',', '.')
        ) || 0,

      distancia:
        Number(
          String(row['Distance (m)'] || '0')
            .replace(',', '.')
        ) || 0,

      valor:
        Number(
          String(row['Workload'] || '0')
            .replace(',', '.')
        ) || 0
    });
  }
});

jogador.historico = Array.from(historicoMap.values());

jogador.tendencia =
  this.calcularTendencia(jogador.historico);

return jogador;
},

async getJogadorStatsByAthlete(athleteId: string): Promise<JogadorStats[]> {
  const result = await query(
    `
    SELECT DISTINCT ON ("Athlete ID") *
FROM dados_extraidos
WHERE "Segment Name" = 'Whole Session'
ORDER BY
  "Athlete ID",
  TO_DATE("Start Date",'DD/MM/YYYY') DESC
    `,
    [`%${athleteId}%`]
  );

    return result.rows.map(row => this.mapJogador(row));
  },

async getJogadoresStatsByGrupo(grupo: string): Promise<JogadorStats[]> {
  const result = await query(
    `
    SELECT DISTINCT ON ("Athlete ID") *
FROM dados_extraidos
WHERE "Segment Name" = 'Whole Session'
ORDER BY
  "Athlete ID",
  TO_DATE("Start Date",'DD/MM/YYYY') DESC
    `,
    [grupo]
  );

    return result.rows.map(row => this.mapJogador(row));
  },

  async getEvolucaoMediaElenco() {
  const result = await query(`
    SELECT
      "Start Date" as data,
      AVG(
        CAST(
          REPLACE(COALESCE("Workload",'0'), ',', '.')
          AS NUMERIC
        )
      ) as media
    FROM dados_extraidos
    WHERE "Segment Name" = 'Whole Session'
    GROUP BY "Start Date"
    ORDER BY TO_DATE("Start Date", 'DD/MM/YYYY')
  `);

  return result.rows.map(row => ({
    data: row.data,
    media: Number(row.media)
  }));
},

  mapJogador(row: any): JogadorStats {
    const velocidade =
      Number(
        String(row['Top Speed (kph)'] || '0')
          .replace(',', '.')
      ) || 0;

    const distancia =
      Number(
        String(row['Distance (m)'] || '0')
          .replace(',', '.')
      ) || 0;

    const sprints =
      Number(
        String(row['No. of Sprints'] || '0')
          .replace(',', '.')
      ) || 0;

    const historico: Array<{
      data: string;
      velocidade: number;
      distancia: number;
      valor: number;
    }> = [
      {
        data: String(row['Start Date'] || ''),
        velocidade,
        distancia,
        valor: row['Workload']
          ? Number(String(row['Workload']).replace(',', '.'))
          : 0
      }
    ];

    return {
      nome: String(row['Athlete ID']),
      numero: Number(row['Athlete ID']),
      posicao: row['Athlete Position'] || '',
      velocidadeMax: velocidade,
      distancia,
      sprints,

      perfil: this.calcularPerfil(
        velocidade,
        distancia,
        sprints
      ),

      rendimento: this.calcularRendimento(
        velocidade,
        distancia,
        sprints
      ),

      tendencia: this.calcularTendencia(historico),

      historico
    };
  }
};