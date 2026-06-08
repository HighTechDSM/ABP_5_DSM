export function BallLogo({ size = 40, glow = true }: { size?: number; glow?: boolean }) {
  return (
    <div
      className="relative inline-flex items-center justify-center rounded-2xl"
      style={{
        width: size,
        height: size,
        background: "var(--gradient-primary)",
        boxShadow: glow ? "var(--shadow-glow)" : undefined,
      }}
    >
      <svg viewBox="0 0 24 24" width={size * 0.6} height={size * 0.6} fill="none" stroke="currentColor"
           strokeWidth="1.8" style={{ color: "var(--primary-foreground)" }}>
        <circle cx="12" cy="12" r="9" />
        <path d="M12 3l3 4-1.5 4.5L9 13l-2-3 2-4z M12 21l-3-4 1.5-4.5L15 11l2 3-2 4z M3 12l4-1 3 3-1 4-3-2z M21 12l-4 1-3-3 1-4 3 2z" />
      </svg>
    </div>
  );
}
