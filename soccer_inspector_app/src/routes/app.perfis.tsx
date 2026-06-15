import { createFileRoute, Link } from "@tanstack/react-router";
import { MobileFrame } from "@/components/MobileFrame";
import { Avatar } from "./app.index";
import { jogadores } from "@/lib/mock-data";
import { ArrowLeftRight, Info } from "lucide-react";
import { useMemo, useState } from "react";

export const Route = createFileRoute("/app/perfis")({ component: Perfis });

const perfis = ["Todos", "Explosivo", "Alta resistência", "Baixa intensidade", "Alta carga de impacto"] as const;

function Perfis() {
  const [filtro, setFiltro] = useState<(typeof perfis)[number]>("Todos");

  const grupos = useMemo(() => {
    const lista = filtro === "Todos" ? jogadores : jogadores.filter((j) => j.perfil === filtro);
    const map = new Map<string, typeof jogadores>();
    lista.forEach((j) => {
      const arr = map.get(j.posicao) ?? [];
      arr.push(j);
      map.set(j.posicao, arr);
    });
    return Array.from(map.entries());
  }, [filtro]);

  return (
    <MobileFrame>
      <div className="px-5 pt-8 pb-2">
        <h1 className="text-xl font-bold">Perfis de jogadores</h1>
        <p className="text-sm text-muted-foreground">Encontre substitutos compatíveis por posição e perfil.</p>
      </div>

      <div className="px-5 mt-3">
        <div className="glass-card p-3 flex gap-2 items-start"
             style={{ borderColor: "color-mix(in oklab, var(--accent) 30%, transparent)" }}>
          <Info className="size-4 mt-0.5 shrink-0" style={{ color: "var(--accent)" }} />
          <p className="text-[11px] text-muted-foreground leading-relaxed">
            O perfil ajuda a encontrar o melhor substituto da mesma posição. A categoria prioritária é o perfil compatível,
            seguida por velocidade e métricas similares.
          </p>
        </div>
      </div>

      <div className="px-5 mt-3 flex gap-1.5 overflow-x-auto pb-1">
        {perfis.map((p) => {
          const active = filtro === p;
          return (
            <button key={p} onClick={() => setFiltro(p)}
              className="text-xs font-semibold px-3 py-1.5 rounded-full whitespace-nowrap transition"
              style={active
                ? { background: "var(--gradient-primary)", color: "var(--primary-foreground)" }
                : { background: "var(--surface-2)", color: "var(--muted-foreground)" }}>
              {p}
            </button>
          );
        })}
      </div>

      <div className="px-5 mt-4 space-y-5">
        {grupos.map(([posicao, players]) => (
          <section key={posicao}>
            <div className="flex items-center justify-between mb-2">
              <h2 className="text-xs uppercase tracking-widest text-muted-foreground font-semibold">{posicao}</h2>
              {players.length > 1 && (
                <span className="inline-flex items-center gap-1 text-[10px] font-bold" style={{ color: "var(--accent)" }}>
                  <ArrowLeftRight className="size-3" /> {players.length} compatíveis
                </span>
              )}
            </div>

            <div className="space-y-2">
              {players.map((j) => (
                <Link key={j.id} to="/app/jogadores/$id" params={{ id: j.id }}
                  className="flex items-center gap-3 glass-card px-3 py-3 transition hover:border-primary/40">
                  <Avatar numero={j.numero} small />
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-semibold truncate">{j.nome}</p>
                    <p className="text-[11px] text-muted-foreground">{j.perfil}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-bold" style={{ color: "var(--primary)" }}>{j.velocidadeMax}</p>
                    <p className="text-[10px] text-muted-foreground">km/h</p>
                  </div>
                </Link>
              ))}
            </div>
          </section>
        ))}
      </div>
    </MobileFrame>
  );
}
