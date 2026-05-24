import { Link, useLocation } from "@tanstack/react-router";
import { Home, Users, BarChart3, UserCircle2 } from "lucide-react";
import type { ReactNode } from "react";

const tabs = [
  { to: "/app", label: "Início", icon: Home },
  { to: "/app/jogadores", label: "Jogadores", icon: Users },
  { to: "/app/dashboard", label: "Dashboard", icon: BarChart3 },
  { to: "/app/perfis", label: "Perfis", icon: UserCircle2 },
] as const;

export function MobileFrame({ children, hideNav = false }: { children: ReactNode; hideNav?: boolean }) {
  const { pathname } = useLocation();

  return (
    <div className="min-h-screen w-full flex items-center justify-center px-4 py-6 sm:py-10">
      <div className="relative w-full max-w-[420px]">
        {/* Phone frame (only visible on larger screens) */}
        <div className="hidden sm:block absolute -inset-3 rounded-[3rem] bg-gradient-to-b from-surface-3 to-surface-1 shadow-[0_30px_80px_-20px_oklch(0_0_0/0.7)]"
             style={{ background: "linear-gradient(180deg, var(--surface-3), var(--surface-1))" }} />
        <div className="relative rounded-[2.25rem] overflow-hidden glow-ring sm:border sm:border-white/10"
             style={{ background: "var(--gradient-pitch)" }}>
          <div className="relative h-[720px] sm:h-[760px] flex flex-col">
            <div className="flex-1 overflow-y-auto pb-24">
              {children}
            </div>
            {!hideNav && (
              <nav className="absolute bottom-0 left-0 right-0 px-3 pb-3">
                <div className="glass-card flex justify-around items-center px-2 py-2 backdrop-blur-xl"
                     style={{ background: "color-mix(in oklab, var(--surface-1) 85%, transparent)" }}>
                  {tabs.map(({ to, label, icon: Icon }) => {
                    const active = pathname === to;
                    return (
                      <Link key={to} to={to}
                        className="flex flex-col items-center gap-1 px-3 py-1.5 rounded-xl transition-all"
                        style={active ? { background: "var(--gradient-primary)", color: "var(--primary-foreground)" } : { color: "var(--muted-foreground)" }}>
                        <Icon className="size-5" strokeWidth={2.2} />
                        <span className="text-[10px] font-semibold tracking-wide">{label}</span>
                      </Link>
                    );
                  })}
                </div>
              </nav>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
