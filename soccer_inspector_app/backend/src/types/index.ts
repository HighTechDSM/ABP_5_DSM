export interface User {
id: number;
name: string;
email: string;
password_hash: string;
created_at: Date;
updated_at: Date;
}

export interface DadosExtraidos {
"Athlete ID": number;
"Athlete Position": string;
"Athlete Groups": string;

"Start Date": string;
"Start Time": string;
"Start Time (s)": string;
"End Time (s)": string;

"Week Start Date": string;
"Month Start Date": string;

"Segment Name": string;

"Duration (mins)": string;
"Session Load": string | null;
"Workload": string | null;
"Workload Volume": string | null;
"Workload Intensity": string | null;

"Distance (m)": string | null;
"Metres per Minute (m)": string | null;
"High Intensity Running (m)": string | null;
"No. of High Intensity Events": string | null;
"Sprint Distance (m)": string | null;

"Raw Top Speed (kph)": string | null;
"No. of Sprints": string | null;
"Top Speed (kph)": string | null;
"Avg Speed (kph)": string | null;

"Accelerations": string | null;
"Decelerations": string | null;

"Percentage of Max Speed": string | null;
"Percentage of Raw Max Speed KPH": string | null;

"90% of Max Speed Events": string | null;
"90% of Max Speed Distance (m)": string | null;
"90% of Max Speed Duration (secs)": string | null;

"90% of Raw Max Speed Events": string | null;
"90% of Raw Max Speed Distance (m)": string | null;
"90% of Raw Max Speed Duration (secs)": string | null;
}

export type DadosExtraidosCreateInput = Partial<DadosExtraidos>;

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

export interface AnaliseGrupo {
grupo: string;
total: number;
otimo: number;
regular: number;
baixo: number;
jogadores: JogadorStats[];
}

export interface PerfilJogador {
jogador: JogadorStats;
tipoPerfil: string;
substitutos: JogadorStats[];
}

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
