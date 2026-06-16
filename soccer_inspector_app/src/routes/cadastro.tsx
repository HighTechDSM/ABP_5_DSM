import { createFileRoute, Link } from "@tanstack/react-router";
import { MobileFrame } from "@/components/MobileFrame";
import { BallLogo } from "@/components/BallLogo";
import { User, Mail, Lock, ArrowRight } from "lucide-react";

export const Route = createFileRoute("/cadastro")({ component: Cadastro });

function Cadastro() {
  return (
    <MobileFrame hideNav>
      <div className="flex flex-col h-full px-7 pt-10 pb-6">
        <div className="flex flex-col items-center text-center gap-3">
          <BallLogo size={56} />
          <h1 className="text-2xl font-bold tracking-tight">Criar conta</h1>
          <p className="text-sm text-muted-foreground">
            Acesse o painel da comissão técnica.
          </p>
        </div>

        <div className="mt-8 flex flex-col gap-4">
          <Field icon={User} placeholder="Seu nome completo" label="Nome completo" />
          <Field icon={Mail} type="email" placeholder="seu@email.com" label="E-mail" />
          <Field icon={Lock} type="password" placeholder="Mínimo 8 caracteres" label="Criar senha" />
        </div>

        <div className="mt-auto pt-8 flex flex-col gap-4">
          <Link to="/app"
            className="inline-flex items-center justify-center gap-2 rounded-2xl px-5 py-3.5 font-semibold transition-all active:scale-95"
            style={{ background: "var(--gradient-primary)", color: "var(--primary-foreground)", boxShadow: "var(--shadow-glow)" }}>
            Cadastrar <ArrowRight className="size-4" />
          </Link>
          <p className="text-center text-sm text-muted-foreground">
            Já tem conta?{" "}
            <Link to="/login" style={{ color: "var(--primary)" }} className="font-semibold">
              Fazer login
            </Link>
          </p>
        </div>
      </div>
    </MobileFrame>
  );
}

function Field({ icon: Icon, label, ...rest }: { icon: any; label: string } & React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <label className="flex flex-col gap-1.5">
      <span className="text-xs font-semibold text-muted-foreground tracking-wide uppercase">{label}</span>
      <span className="relative">
        <Icon className="absolute left-3.5 top-1/2 -translate-y-1/2 size-4 text-muted-foreground" />
        <input
          {...rest}
          className="w-full rounded-xl bg-input/50 border border-border pl-10 pr-4 py-3 text-sm outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/30"
        />
      </span>
    </label>
  );
}
