import { createFileRoute } from "@tanstack/react-router";
import { MobileFrame } from "@/components/MobileFrame";
import { jogadores } from "@/lib/mock-data";
import { BarChart, Bar, ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid, RadarChart, PolarGrid, PolarAngleAxis, Radar, PolarRadiusAxis } from "recharts";
import { Activity, AlertTriangle, Trophy, Users } from "lucide-react";

export const Route = createFileRoute("/app/dashboard")({ component: Dashboard });

function Dashboard() {
  const otimo = jogadores.filter((j) => j.rendimento === "Ótimo").length;
  const regular = jogadores.filter((j) => j.rendimento === "Regular").length;
  const baixo = jogadores.filter((j) => j.rendimento === "Baixo").length;

  const barData = jogadores.map((j) => ({
    nome: j.nome.split(" ")[0],
    valor: j.historico[j.historico.length - 1].valor,
  }));

  const radarData = ["02/04", "08/04", "12/04", "16/04", "20/04"].map((data) => {
    const total = jogadores.reduce((s, j) => s + (j.historico.find((h) => h.data === data)?.valor ?? 0), 0);
    return { data, valor: Math.round(total / jogadores.length) };
  });

  return (
    <MobileFrame>
      <div className="px-5 pt-8 pb-3">
        <h1 className="text-xl font-bold">Dashboard geral</h1>
        <p className="text-sm text-muted-foreground">Visão consolidada do elenco.</p>
      </div>

      <section className="px-5 grid grid-cols-2 gap-2.5">
        <KPI icon={Users} label="Atletas" value={jogadores.length} accent="var(--accent)" />
        <KPI icon={Trophy} label="Em ótima forma" value={otimo} accent="var(--success)" />
        <KPI icon={Activity} label="Regulares" value={regular} accent="var(--warning)" />
        <KPI icon={AlertTriangle} label="Em alerta" value={baixo} accent="var(--destructive)" />
      </section>

      <section className="px-5 mt-5">
        <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-2">
          Distribuição de rendimento
        </h2>
        <div className="glass-card p-4">
          <div className="flex items-center gap-2 mb-3">
            <Pill color="var(--success)" label={`Ótimo · ${otimo}`} />
            <Pill color="var(--warning)" label={`Regular · ${regular}`} />
            <Pill color="var(--destructive)" label={`Baixo · ${baixo}`} />
          </div>
          <StackBar otimo={otimo} regular={regular} baixo={baixo} />
        </div>
      </section>

      <section className="px-5 mt-5">
        <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-2">
          Rendimento por atleta (último jogo)
        </h2>
        <div className="glass-card p-3 pt-4">
          <div className="h-48 -ml-2">
            <ResponsiveContainer>
              <BarChart data={barData}>
                <CartesianGrid stroke="oklch(1 0 0 / 0.06)" vertical={false} />
                <XAxis dataKey="nome" stroke="var(--muted-foreground)" fontSize={10} tickLine={false} axisLine={false} />
                <YAxis stroke="var(--muted-foreground)" fontSize={10} tickLine={false} axisLine={false} width={28} />
                <Tooltip cursor={{ fill: "oklch(1 0 0 / 0.04)" }}
                         contentStyle={{ background: "var(--surface-2)", border: "1px solid var(--border)", borderRadius: 12, fontSize: 12 }} />
                <Bar dataKey="valor" fill="var(--primary)" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>

      <section className="px-5 mt-5">
        <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold mb-2">
          Evolução média do elenco
        </h2>
        <div className="glass-card p-3">
          <div className="h-56">
            <ResponsiveContainer>
              <RadarChart data={radarData}>
                <PolarGrid stroke="oklch(1 0 0 / 0.1)" />
                <PolarAngleAxis dataKey="data" tick={{ fill: "var(--muted-foreground)", fontSize: 10 }} />
                <PolarRadiusAxis tick={{ fill: "var(--muted-foreground)", fontSize: 9 }} stroke="oklch(1 0 0 / 0.1)" />
                <Radar dataKey="valor" stroke="var(--primary)" fill="var(--primary)" fillOpacity={0.35} strokeWidth={2} />
              </RadarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>
    </MobileFrame>
  );
}

function KPI({ icon: Icon, label, value, accent }: { icon: any; label: string; value: number; accent: string }) {
  return (
    <div className="glass-card p-3.5">
      <div className="flex items-center justify-between">
        <div className="size-8 grid place-items-center rounded-lg"
             style={{ background: `color-mix(in oklab, ${accent} 18%, transparent)` }}>
          <Icon className="size-4" style={{ color: accent }} />
        </div>
        <span className="text-2xl font-extrabold" style={{ color: accent }}>{value}</span>
      </div>
      <p className="text-xs text-muted-foreground mt-2">{label}</p>
    </div>
  );
}

function Pill({ color, label }: { color: string; label: string }) {
  return (
    <span className="inline-flex items-center gap-1.5 text-[10px] font-bold px-2 py-1 rounded-full"
          style={{ background: `color-mix(in oklab, ${color} 18%, transparent)`, color }}>
      <span className="size-1.5 rounded-full" style={{ background: color }} />
      {label}
    </span>
  );
}

function StackBar({ otimo, regular, baixo }: { otimo: number; regular: number; baixo: number }) {
  const total = otimo + regular + baixo;
  return (
    <div className="flex h-3 rounded-full overflow-hidden" style={{ background: "var(--surface-3)" }}>
      <div style={{ width: `${(otimo / total) * 100}%`, background: "var(--success)" }} />
      <div style={{ width: `${(regular / total) * 100}%`, background: "var(--warning)" }} />
      <div style={{ width: `${(baixo / total) * 100}%`, background: "var(--destructive)" }} />
    </div>
  );
}
