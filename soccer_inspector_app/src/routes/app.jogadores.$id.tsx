import { createFileRoute, Link, useParams } from "@tanstack/react-router";
import { MobileFrame } from "@/components/MobileFrame";
import { Avatar } from "./app.index";
import { jogadores, rendimentoColor, rendimentoMessage } from "@/lib/mock-data";
import { ArrowLeft, Download, TrendingUp, TrendingDown, Sparkles, Calendar } from "lucide-react";
import { LineChart, Line, ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid, Area, AreaChart } from "recharts";

export const Route = createFileRoute("/app/jogadores/$id")({
  component: AnaliseJogador,
  notFoundComponent: () => <div className="p-6">Jogador não encontrado</div>,
});

function AnaliseJogador() {
  const { id } = useParams({ from: "/app/jogadores/$id" });
  const j = jogadores.find((x) => x.id === id) ?? jogadores[0];
  const cor = rendimentoColor[j.rendimento];
  const ultimo = j.historico[j.historico.length - 1];

  return (
    <MobileFrame>
      <div className="px-5 pt-8 pb-2 flex items-center justify-between">
        <Link to="/app/jogadores" className="size-10 grid place-items-center rounded-xl glass-card">
          <ArrowLeft className="size-4" />
        </Link>
        <h1 className="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Análise</h1>
        <button className="size-10 grid place-items-center rounded-xl glass-card">
          <Download className="size-4" />
        </button>
      </div>

      {/* Player card */}
      <section className="px-5 mt-3">
        <div className="glass-card p-4 relative overflow-hidden">
          <div className="absolute -top-10 -right-10 size-40 rounded-full opacity-30 blur-3xl"
               style={{ background: cor }} />
          <div className="flex items-center gap-3 relative">
            <Avatar numero={j.numero} />
            <div className="flex-1 min-w-0">
              <p className="font-bold truncate">{j.nome}</p>
              <p className="text-xs text-muted-foreground">{j.posicao} · #{j.numero}</p>
            </div>
            <span className="text-[10px] font-bold px-2.5 py-1 rounded-full"
                  style={{ background: `color-mix(in oklab, ${cor} 22%, transparent)`, color: cor }}>
              {j.rendimento}
            </span>
          </div>

          <div className="grid grid-cols-3 gap-3 mt-4 relative">
            <Mini label="Vel. máx" value={j.velocidadeMax} unit="km/h" />
            <Mini label="Distância" value={j.distancia} unit="km" />
            <Mini label="Sprints" value={j.sprints} />
          </div>

          <div className="mt-4 flex items-center gap-2 text-xs relative">
            <Calendar className="size-3.5 text-muted-foreground" />
            <span className="text-muted-foreground">Último jogo {ultimo.data}:</span>
            <span className="font-bold" style={{ color: cor }}>{j.rendimento}</span>
            <span className="ml-auto inline-flex items-center gap-1 font-bold"
                  style={{ color: j.tendencia >= 0 ? "var(--success)" : "var(--destructive)" }}>
              {j.tendencia >= 0 ? <TrendingUp className="size-3.5" /> : <TrendingDown className="size-3.5" />}
              {j.tendencia >= 0 ? "+" : ""}{j.tendencia}%
            </span>
          </div>
        </div>
      </section>

      {/* Gráfico */}
      <section className="px-5 mt-5">
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold">Gráfico de desempenho</h2>
          <span className="text-[10px] text-muted-foreground">últimos 5 jogos</span>
        </div>
        <div className="glass-card p-3 pt-4">
          <div className="h-44 -ml-2">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={j.historico}>
                <defs>
                  <linearGradient id="g1" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="var(--primary)" stopOpacity={0.5} />
                    <stop offset="100%" stopColor="var(--primary)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid stroke="oklch(1 0 0 / 0.06)" vertical={false} />
                <XAxis dataKey="data" stroke="var(--muted-foreground)" fontSize={10} tickLine={false} axisLine={false} />
                <YAxis stroke="var(--muted-foreground)" fontSize={10} tickLine={false} axisLine={false} width={28} />
                <Tooltip contentStyle={{ background: "var(--surface-2)", border: "1px solid var(--border)", borderRadius: 12, fontSize: 12 }} />
                <Area type="monotone" dataKey="valor" stroke="var(--primary)" strokeWidth={2.5} fill="url(#g1)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>

      {/* Tabela histórica */}
      <section className="px-5 mt-5">
        <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-2">
          Em relação aos jogos anteriores
        </h2>
        <div className="glass-card overflow-hidden">
          <div className="grid grid-cols-3 px-3 py-2 text-[10px] uppercase tracking-wider text-muted-foreground font-bold border-b border-border">
            <span>Data</span><span className="text-center">Velocidade</span><span className="text-right">Distância</span>
          </div>
          {[...j.historico].reverse().map((h) => (
            <div key={h.data} className="grid grid-cols-3 px-3 py-2.5 text-xs items-center border-b last:border-0 border-border">
              <span className="font-semibold">{h.data}</span>
              <span className="text-center font-bold" style={{ color: "var(--primary)" }}>{h.velocidade} km/h</span>
              <span className="text-right text-muted-foreground">{h.distancia} km</span>
            </div>
          ))}
        </div>
      </section>

      {/* Indicadores */}
      <section className="px-5 mt-5">
        <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-2">Indicadores</h2>
        <div className="grid grid-cols-3 gap-2">
          <Indicator label="Ótimo" color="var(--success)" />
          <Indicator label="Regular" color="var(--warning)" />
          <Indicator label="Baixo" color="var(--destructive)" />
        </div>
      </section>

      {/* IA */}
      <section className="px-5 mt-5">
        <div className="glass-card p-4 relative overflow-hidden"
             style={{ borderColor: "color-mix(in oklab, var(--primary) 30%, transparent)" }}>
          <div className="flex items-center gap-2 mb-2">
            <div className="size-7 grid place-items-center rounded-lg"
                 style={{ background: "var(--gradient-primary)" }}>
              <Sparkles className="size-3.5" style={{ color: "var(--primary-foreground)" }} />
            </div>
            <h3 className="text-sm font-bold">Relatório de desempenho · IA</h3>
          </div>
          <p className="text-sm leading-relaxed text-muted-foreground">{rendimentoMessage(j.rendimento)}</p>
          <button className="mt-4 w-full inline-flex items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-sm font-semibold transition active:scale-95"
                  style={{ background: "var(--gradient-primary)", color: "var(--primary-foreground)" }}>
            Gerar análise mensal
          </button>
        </div>
      </section>
    </MobileFrame>
  );
}

function Mini({ label, value, unit }: { label: string; value: number | string; unit?: string }) {
  return (
    <div className="rounded-xl px-3 py-2" style={{ background: "var(--surface-2)" }}>
      <p className="text-base font-bold leading-none">{value}{unit && <span className="text-[10px] text-muted-foreground ml-0.5 font-normal">{unit}</span>}</p>
      <p className="text-[10px] text-muted-foreground mt-1">{label}</p>
    </div>
  );
}

function Indicator({ label, color }: { label: string; color: string }) {
  return (
    <div className="glass-card flex items-center gap-2 px-3 py-2">
      <span className="size-3 rounded-md" style={{ background: color }} />
      <span className="text-xs font-semibold">{label}</span>
    </div>
  );
}
