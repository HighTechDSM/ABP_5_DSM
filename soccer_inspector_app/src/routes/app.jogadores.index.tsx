import { createFileRoute, Link } from "@tanstack/react-router";
import { MobileFrame } from "@/components/MobileFrame";
import { jogadores, rendimentoColor, type Rendimento } from "@/lib/mock-data";
import { Avatar } from "./app.index";
import { Search, ChevronRight } from "lucide-react";
import { useMemo, useState } from "react";

export const Route = createFileRoute("/app/jogadores/")({ component: ListaJogadores });

const filtros: ("Todos" | Rendimento)[] = ["Todos", "Ótimo", "Regular", "Baixo"];

function ListaJogadores() {
  const [q, setQ] = useState("");
  const [filtro, setFiltro] = useState<(typeof filtros)[number]>("Todos");

  const visiveis = useMemo(() =>
    jogadores.filter((j) =>
      (filtro === "Todos" || j.rendimento === filtro) &&
      (j.nome.toLowerCase().includes(q.toLowerCase()) || j.posicao.toLowerCase().includes(q.toLowerCase()))
    ), [q, filtro]);

  return (
    <MobileFrame>
      <div className="px-5 pt-8 pb-3">
        <h1 className="text-xl font-bold">Jogadores</h1>
        <p className="text-sm text-muted-foreground">Selecione um atleta para análise.</p>
      </div>

      <div className="px-5 sticky top-0 z-10 pb-2"
           style={{ background: "linear-gradient(180deg, var(--surface-0) 70%, transparent)" }}>
        <div className="relative">
          <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 size-4 text-muted-foreground" />
          <input value={q} onChange={(e) => setQ(e.target.value)}
                 placeholder="Buscar por nome ou posição"
                 className="w-full rounded-xl bg-input/50 border border-border pl-10 pr-4 py-2.5 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/30" />
        </div>
        <div className="flex gap-1.5 mt-3 overflow-x-auto pb-1 -mx-1 px-1">
          {filtros.map((f) => {
            const active = filtro === f;
            return (
              <button key={f} onClick={() => setFiltro(f)}
                className="text-xs font-semibold px-3 py-1.5 rounded-full whitespace-nowrap transition"
                style={active
                  ? { background: "var(--gradient-primary)", color: "var(--primary-foreground)" }
                  : { background: "var(--surface-2)", color: "var(--muted-foreground)" }}>
                {f}
              </button>
            );
          })}
        </div>
      </div>

      <ul className="px-5 mt-2 space-y-2">
        {visiveis.map((j) => (
          <li key={j.id}>
            <Link to="/app/jogadores/$id" params={{ id: j.id }}
              className="flex items-center gap-3 glass-card px-3 py-3 transition hover:border-primary/40">
              <Avatar numero={j.numero} />
              <div className="flex-1 min-w-0">
                <p className="font-semibold truncate">{j.nome}</p>
                <p className="text-[11px] text-muted-foreground truncate">{j.posicao} · {j.perfil}</p>
                <div className="flex items-center gap-3 mt-1.5">
                  <Stat label="Vel" value={`${j.velocidadeMax} km/h`} />
                  <Stat label="Dist" value={`${j.distancia} km`} />
                </div>
              </div>
              <div className="flex flex-col items-end gap-2">
                <span className="text-[10px] font-bold px-2 py-1 rounded-full"
                      style={{ background: `color-mix(in oklab, ${rendimentoColor[j.rendimento]} 18%, transparent)`, color: rendimentoColor[j.rendimento] }}>
                  {j.rendimento}
                </span>
                <ChevronRight className="size-4 text-muted-foreground" />
              </div>
            </Link>
          </li>
        ))}
        {visiveis.length === 0 && (
          <li className="text-center text-sm text-muted-foreground py-10">Nenhum jogador encontrado.</li>
        )}
      </ul>
    </MobileFrame>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <span className="text-[10px] text-muted-foreground">
      <span className="font-semibold text-foreground/80">{value}</span> {label}
    </span>
  );
}
