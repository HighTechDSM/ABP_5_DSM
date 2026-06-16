export type Rendimento = "Ótimo" | "Regular" | "Baixo";

export type Jogador = {
  id: string;
  nome: string;
  numero: number;
  posicao: string;
  perfil: "Alta resistência" | "Explosivo" | "Baixa intensidade" | "Alta carga de impacto";
  rendimento: Rendimento;
  velocidadeMax: number; // km/h
  distancia: number; // km
  sprints: number;
  tendencia: number; // % vs media
  historico: { data: string; velocidade: number; distancia: number; valor: number }[];
};

export const jogadores: Jogador[] = [
  {
    id: "10",
    nome: "Lucas Andrade",
    numero: 10,
    posicao: "Centro-Avante",
    perfil: "Explosivo",
    rendimento: "Ótimo",
    velocidadeMax: 32.4,
    distancia: 11.2,
    sprints: 28,
    tendencia: 8,
    historico: [
      { data: "02/04", velocidade: 13.3, distancia: 9.8, valor: 13 },
      { data: "08/04", velocidade: 10.0, distancia: 8.5, valor: 10 },
      { data: "12/04", velocidade: 14.4, distancia: 10.6, valor: 14 },
      { data: "16/04", velocidade: 12.0, distancia: 9.4, valor: 12 },
      { data: "20/04", velocidade: 15.0, distancia: 11.2, valor: 15 },
    ],
  },
  {
    id: "07",
    nome: "Rafael Souza",
    numero: 7,
    posicao: "Ponta Direita",
    perfil: "Explosivo",
    rendimento: "Regular",
    velocidadeMax: 30.1,
    distancia: 10.4,
    sprints: 22,
    tendencia: -3,
    historico: [
      { data: "02/04", velocidade: 14.1, distancia: 10.2, valor: 12 },
      { data: "08/04", velocidade: 13.0, distancia: 10.0, valor: 11 },
      { data: "12/04", velocidade: 12.4, distancia: 9.8, valor: 11 },
      { data: "16/04", velocidade: 11.6, distancia: 9.5, valor: 10 },
      { data: "20/04", velocidade: 12.1, distancia: 9.9, valor: 11 },
    ],
  },
  {
    id: "05",
    nome: "Diego Martins",
    numero: 5,
    posicao: "Volante",
    perfil: "Alta resistência",
    rendimento: "Ótimo",
    velocidadeMax: 28.7,
    distancia: 12.6,
    sprints: 19,
    tendencia: 5,
    historico: [
      { data: "02/04", velocidade: 12.5, distancia: 11.8, valor: 13 },
      { data: "08/04", velocidade: 13.2, distancia: 12.1, valor: 14 },
      { data: "12/04", velocidade: 12.8, distancia: 12.4, valor: 13 },
      { data: "16/04", velocidade: 13.6, distancia: 12.7, valor: 14 },
      { data: "20/04", velocidade: 14.0, distancia: 12.6, valor: 15 },
    ],
  },
  {
    id: "09",
    nome: "Bruno Carvalho",
    numero: 9,
    posicao: "Centro-Avante",
    perfil: "Alta carga de impacto",
    rendimento: "Baixo",
    velocidadeMax: 27.2,
    distancia: 8.9,
    sprints: 14,
    tendencia: -12,
    historico: [
      { data: "02/04", velocidade: 13.0, distancia: 10.4, valor: 12 },
      { data: "08/04", velocidade: 11.8, distancia: 9.6, valor: 10 },
      { data: "12/04", velocidade: 10.5, distancia: 9.0, valor: 9 },
      { data: "16/04", velocidade: 9.8, distancia: 8.5, valor: 8 },
      { data: "20/04", velocidade: 9.2, distancia: 8.9, valor: 7 },
    ],
  },
  {
    id: "04",
    nome: "Pedro Henrique",
    numero: 4,
    posicao: "Zagueiro",
    perfil: "Alta resistência",
    rendimento: "Regular",
    velocidadeMax: 26.4,
    distancia: 10.8,
    sprints: 11,
    tendencia: 1,
    historico: [
      { data: "02/04", velocidade: 11.0, distancia: 10.2, valor: 11 },
      { data: "08/04", velocidade: 11.4, distancia: 10.5, valor: 12 },
      { data: "12/04", velocidade: 10.8, distancia: 10.6, valor: 11 },
      { data: "16/04", velocidade: 11.2, distancia: 10.7, valor: 12 },
      { data: "20/04", velocidade: 11.6, distancia: 10.8, valor: 12 },
    ],
  },
  {
    id: "11",
    nome: "Gabriel Lima",
    numero: 11,
    posicao: "Ponta Esquerda",
    perfil: "Explosivo",
    rendimento: "Ótimo",
    velocidadeMax: 33.1,
    distancia: 10.9,
    sprints: 31,
    tendencia: 11,
    historico: [
      { data: "02/04", velocidade: 13.8, distancia: 10.2, valor: 13 },
      { data: "08/04", velocidade: 14.4, distancia: 10.5, valor: 14 },
      { data: "12/04", velocidade: 14.9, distancia: 10.7, valor: 15 },
      { data: "16/04", velocidade: 15.2, distancia: 10.8, valor: 15 },
      { data: "20/04", velocidade: 15.7, distancia: 10.9, valor: 16 },
    ],
  },
  {
    id: "08",
    nome: "Matheus Rocha",
    numero: 8,
    posicao: "Meia",
    perfil: "Baixa intensidade",
    rendimento: "Regular",
    velocidadeMax: 25.8,
    distancia: 9.7,
    sprints: 9,
    tendencia: -1,
    historico: [
      { data: "02/04", velocidade: 10.5, distancia: 9.5, valor: 10 },
      { data: "08/04", velocidade: 10.2, distancia: 9.4, valor: 10 },
      { data: "12/04", velocidade: 10.8, distancia: 9.6, valor: 11 },
      { data: "16/04", velocidade: 10.0, distancia: 9.3, valor: 9 },
      { data: "20/04", velocidade: 10.4, distancia: 9.7, valor: 10 },
    ],
  },
];

export const rendimentoColor: Record<Rendimento, string> = {
  "Ótimo": "var(--success)",
  "Regular": "var(--warning)",
  "Baixo": "var(--destructive)",
};

export function rendimentoMessage(r: Rendimento): string {
  if (r === "Ótimo")
    return "De acordo com os jogos anteriores, o jogador está indo bem atualmente! Manter a rotina de treino, condicionamento físico e boa alimentação.";
  if (r === "Regular")
    return "O rendimento está estável nos últimos jogos. Verifique aspectos que podem melhorar: condicionamento físico, indícios de baixa de saúde e diálogo com o técnico em busca de melhores resultados.";
  return "O rendimento diminuiu mais vezes entre os últimos jogos. Verificar situação atual de saúde do jogador (mental e física) ou rever o método de treino atual.";
}
