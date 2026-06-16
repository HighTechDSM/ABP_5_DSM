import { createFileRoute, Link } from "@tanstack/react-router";
import { BallLogo } from "@/components/BallLogo";
import { ArrowRight, Activity, BrainCircuit, ShieldCheck } from "lucide-react";

export const Route = createFileRoute("/")({
  component: Landing,
  head: () => ({
    meta: [
      { title: "SOCCER Inspector — Análise de desempenho de atletas" },
      { name: "description", content: "App de análise de desempenho físico de jogadores de futebol com IA. Detecte quedas de rendimento e perfis de atletas." },
    ],
  }),
});

function Landing() {
  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-10">
      <div className="max-w-md w-full text-center space-y-8">
        <div className="flex flex-col items-center gap-4">
          <BallLogo size={72} />
          <div>
            <h1 className="text-4xl font-extrabold tracking-tight">
              <span className="text-gradient">SOCCER</span> Inspector
            </h1>
            <p className="mt-2 text-sm text-muted-foreground">
              Análise inteligente de desempenho físico de atletas com IA.
            </p>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-2 text-[11px]">
          {[
            { i: Activity, t: "Rendimento" },
            { i: BrainCircuit, t: "IA preditiva" },
            { i: ShieldCheck, t: "Alertas" },
          ].map(({ i: I, t }) => (
            <div key={t} className="glass-card py-3 flex flex-col items-center gap-1.5">
              <I className="size-5" style={{ color: "var(--primary)" }} />
              <span className="text-muted-foreground font-medium">{t}</span>
            </div>
          ))}
        </div>

        <div className="flex flex-col gap-3">
          <Link to="/login"
            className="group inline-flex items-center justify-center gap-2 rounded-2xl px-5 py-3.5 font-semibold transition-all hover:scale-[1.02] active:scale-95"
            style={{ background: "var(--gradient-primary)", color: "var(--primary-foreground)", boxShadow: "var(--shadow-glow)" }}>
            Entrar no app
            <ArrowRight className="size-4 transition-transform group-hover:translate-x-0.5" />
          </Link>
          <Link to="/cadastro" className="text-sm text-muted-foreground hover:text-foreground transition">
            Não tem conta? <span style={{ color: "var(--primary)" }} className="font-semibold">Cadastre-se</span>
          </Link>
        </div>
      </div>
    </div>
  );
}
