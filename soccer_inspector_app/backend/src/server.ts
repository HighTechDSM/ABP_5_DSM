// backend/src/server.ts
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import authRoutes from "./routes/authRoutes";
import jogadorRoutes from "./routes/jogadorRoutes";
import dashboardRoutes from "./routes/dashboardRoutes";
import perfilRoutes from "./routes/perfilRoutes";
import { errorHandler } from "./middleware/errorHandler";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Configuração CORS para desenvolvimento - permite todas as origens
app.use(cors({
  origin: true, // Permite qualquer origem em desenvolvimento
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept'],
  exposedHeaders: ['Authorization'],
}));

// Middleware para logging de requisições
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check
app.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

// Rotas
app.use("/api/auth", authRoutes);
app.use("/api/jogadores", jogadorRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/perfis", perfilRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: "Rota não encontrada" });
});

// Error handler
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`🔐 Auth: http://localhost:${PORT}/api/auth`);
  console.log(`📊 Jogadores: http://localhost:${PORT}/api/jogadores`);
  console.log(`📈 Dashboard: http://localhost:${PORT}/api/dashboard/stats`);
  console.log(`👤 Perfis: http://localhost:${PORT}/api/perfis/posicoes`);
});

export default app;