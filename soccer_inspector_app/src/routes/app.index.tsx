import { createFileRoute, Link } from "@tanstack/react-router";
import { MobileFrame } from "@/components/MobileFrame";
import { BallLogo } from "@/components/BallLogo";
import { jogadores, rendimentoColor } from "@/lib/mock-data";
import { Bell, TrendingUp, TrendingDown, AlertTriangle, ArrowRight, Activity, Zap, Route as RouteIcon } from "lucide-react";

export const Route = createFileRoute("/app/")({ component: AppHome });

function AppHome() {
  const alertas = jogadores.filter((j) => j.rendimento === "Baixo");
  const destaque = jogadores.find((j) => j.tendencia === Math.max(...jogadores.map((x) => x.tendencia)))!;
  const totalSprints = jogadores.reduce((s, j) => s + j.sprints, 0);
  const distMedia = (jogadores.reduce((s, j) => s + j.distancia, 0) / jogadores.length).toFixed(1);
  const velMedia = (jogadores.reduce((s, j) => s + j.velocidadeMax, 0) / jogadores.length).toFixed(1);

  return (
    <MobileFrame>
      <div className="px-5 pt-8 pb-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <BallLogo size={42} />
            <div>
              <p className="text-[11px] uppercase tracking-widest text-muted-foreground font-semibold">Boa noite</p>
              <h1 className="text-lg font-bold leading-tight">Comissão técnica</h1>
            </div>
          </div>
          <button className="relative size-10 grid place-items-center rounded-xl glass-card">
            <Bell className="size-4" />
            <span className="absolute top-2 right-2 size-2 rounded-full" style={{ background: "var(--destructive)" }} />
          </button>
        </div>
      </div>

      <section className="px-5">
        <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-2">Resumo da rodada</h2>
        <div className="grid grid-cols-3 gap-2.5">
          <Stat icon={Zap} label="Vel. méd." value={`${velMedia}`} unit="km/h" />
          <Stat icon={RouteIcon} label="Dist. méd." value={`${distMedia}`} unit="km" />
          <Stat icon={Activity} label="Sprints" value={`${totalSprints}`} unit="total" />
        </div>
      </section>

      {alertas.length > 0 && (
        <section className="px-5 mt-5">
          <div className="glass-card p-4 flex gap-3 items-start" style={{ borderColor: "color-mix(in oklab, var(--destructive) 40%, transparent)" }}>
            <div className="size-9 grid place-items-center rounded-xl shrink-0" style={{ background: "color-mix(in oklab, var(--destructive) 18%, transparent)" }}>
              <AlertTriangle className="size-4" style={{ color: "var(--destructive)" }} />
            </div>
            <div className="flex-1">
              <p className="text-sm font-semibold">{alertas.length} jogador{alertas.length > 1 ? "es" : ""} abaixo do padrão</p>
              <p className="text-xs text-muted-foreground mt-0.5">
                {alertas.map((a) => a.nome.split(" ")[0]).join(", ")} apresentam queda de rendimento.
              </p>
              <Link to="/app/jogadores" className="inline-flex items-center gap-1 mt-2 text-xs font-semibold" style={{ color: "var(--primary)" }}>
                Investigar <ArrowRight className="size-3" />
              </Link>
            </div>
          </div>
        </section>
      )}

      <section className="px-5 mt-5">
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold">Destaque do dia</h2>
        </div>
        <Link to="/app/jogadores/$id" params={{ id: destaque.id }}
              className="block glass-card p-4 transition hover:border-primary/40">
          <div className="flex items-center gap-3">
            <Avatar numero={destaque.numero} />
            <div className="flex-1 min-w-0">
              <p className="font-semibold truncate">{destaque.nome}</p>
              <p className="text-xs text-muted-foreground">{destaque.posicao} · {destaque.perfil}</p>
            </div>
            <div className="text-right">
              <div className="inline-flex items-center gap-1 text-xs font-bold" style={{ color: "var(--success)" }}>
                <TrendingUp className="size-3.5" /> +{destaque.tendencia}%
              </div>
              <p className="text-[10px] text-muted-foreground mt-0.5">vs. média</p>
            </div>
          </div>
        </Link>
      </section>

      <section className="px-5 mt-5">
        <div className="flex items-center justify-between mb-2">
          <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold">Atletas em destaque</h2>
          <Link to="/app/jogadores" className="text-xs font-semibold" style={{ color: "var(--primary)" }}>Ver todos</Link>
        </div>
        <ul className="space-y-2">
          {jogadores.slice(0, 4).map((j) => (
            <li key={j.id}>
              <Link to="/app/jogadores/$id" params={{ id: j.id }}
                className="flex items-center gap-3 glass-card px-3 py-2.5 transition hover:border-primary/40">
                <Avatar numero={j.numero} small />
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-semibold truncate">{j.nome}</p>
                  <p className="text-[11px] text-muted-foreground">{j.posicao}</p>
                </div>
                <span className="text-[10px] font-bold px-2 py-1 rounded-full"
                      style={{ background: `color-mix(in oklab, ${rendimentoColor[j.rendimento]} 18%, transparent)`, color: rendimentoColor[j.rendimento] }}>
                  {j.rendimento}
                </span>
                {j.tendencia >= 0
                  ? <TrendingUp className="size-3.5" style={{ color: "var(--success)" }} />
                  : <TrendingDown className="size-3.5" style={{ color: "var(--destructive)" }} />}
              </Link>
            </li>
          ))}
        </ul>
      </section>
    </MobileFrame>
  );
}

function Stat({ icon: Icon, label, value, unit }: { icon: any; label: string; value: string; unit: string }) {
  return (
    <div className="glass-card p-3">
      <Icon className="size-4 mb-1.5" style={{ color: "var(--primary)" }} />
      <p className="text-lg font-bold leading-none">{value}<span className="text-[10px] text-muted-foreground font-normal ml-0.5">{unit}</span></p>
      <p className="text-[10px] text-muted-foreground mt-1">{label}</p>
    </div>
  );
}

export function Avatar({ numero, small = false }: { numero: number; small?: boolean }) {
  const size = small ? 36 : 44;
  return (
    <div className="grid place-items-center rounded-xl font-extrabold shrink-0"
         style={{
           width: size, height: size,
           background: "var(--gradient-primary)",
           color: "var(--primary-foreground)",
           fontSize: small ? 14 : 17,
           boxShadow: "0 6px 18px -6px color-mix(in oklab, var(--primary) 60%, transparent)",
         }}>
      {numero}
    </div>
  );
}
