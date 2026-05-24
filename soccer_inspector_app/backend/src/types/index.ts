// backend/src/types/index.ts

// Tipos de Usuário
export interface User {
  id: number;
  name: string;
  email: string;
  password_hash: string;
  created_at: Date;
  updated_at: Date;
}

// Tipos para Dados Extraidos
export interface DadosExtraidos {
  id: number;
  grupos: string;
  athlete: string;
  distance: number;
  session_load: number;
  workload: number;
  sprint_distance: number;
  high_intensity_running: number;
  high_intensity_events: number;
  metres_per_minute: number;
  no_sprint: number;
  top_speed: number;
  raw_top_speed: number;
  accelerations: number;
  decelerations: number;
  minutes_played: number;
  created_at: Date;
}

// Tipo para criação de Dados Extraidos (sem os campos auto-gerados)
export interface DadosExtraidosCreateInput {
  grupos: string;
  athlete: string;
  distance: number;
  session_load: number;
  workload: number;
  sprint_distance: number;
  high_intensity_running: number;
  high_intensity_events: number;
  metres_per_minute: number;
  no_sprint: number;
  top_speed: number;
  raw_top_speed: number;
  accelerations: number;
  decelerations: number;
  minutes_played: number;
}

// Tipo para relação User-DadosExtraidos
export interface UserDadosExtraidos {
  users_id: number;
  d_extraidos_id: number;
}

// Tipos para JogadorStats
export interface JogadorStats {
  nome: string;
  numero: number;
  velocidadeMax: number;
  distancia: number;
  sprints: number;
  posicao: string;
  rendimento: 'otimo' | 'regular' | 'baixo';
  tendencia: number;
  perfil?: string;
  historico: Array<{
    data: string;
    velocidade: number;
    distancia: number;
    valor: number;
  }>;
}

// Tipos para Autenticação
export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
}

export interface AuthResponse {
  token: string;
  user: {
    id: number;
    name: string;
    email: string;
  };
}

// Tipo para Dashboard Stats
export interface DashboardStats {
  resumo: {
    totalJogadores: number;
    otimo: number;
    regular: number;
    baixo: number;
    mediaVelocidade: string;
    mediaDistancia: string;
    totalSprints: number;
  };
  grupos: Record<string, JogadorStats[]>;
  desempenhoUltimoJogo: Array<{
    nome: string;
    valor: number;
  }>;
}

// Tipo para Análise de Grupo
export interface AnaliseGrupo {
  grupo: string;
  total: number;
  otimo: number;
  regular: number;
  baixo: number;
  jogadores: JogadorStats[];
}

// Tipo para Perfil de Jogador
export interface PerfilJogador {
  jogador: JogadorStats;
  tipoPerfil: string;
  substitutos: JogadorStats[];
}

// Tipo para Substituto
export interface Substituto {
  nome: string;
  numero: number;
  posicao: string;
  velocidadeMax: number;
  distancia: number;
  sprints: number;
  perfil: string;
  rendimento: string;
}