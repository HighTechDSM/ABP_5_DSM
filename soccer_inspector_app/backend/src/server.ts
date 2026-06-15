import express from "express";
import cors from "cors";
import * as dotenv from "dotenv";
import authRoutes from "./routes/authRoutes";
import jogadorRoutes from "./routes/jogadorRoutes";
import dashboardRoutes from "./routes/dashboardRoutes";
import perfilRoutes from "./routes/perfilRoutes";
import dadosExtraidosRoutes from "./routes/dadosExtraidosRoutes";
import { errorHandler } from "./middleware/errorHandler";
import { initDatabase } from "./scripts/initDb";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Configuração CORS
app.use(
  cors({
    origin: true,
    credentials: true,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allowedHeaders: [
      "Content-Type",
      "Authorization",
      "X-Requested-With",
      "Accept",
    ],
    exposedHeaders: ["Authorization"],
  })
);

// Middleware para logging
app.use((req, res, next) => {
  console.log(
    `${new Date().toISOString()} - ${req.method} ${req.originalUrl}`
  );
  next();
});

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health Check
app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
  });
});

// Rotas
app.use("/api/auth", authRoutes);
app.use("/api/jogadores", jogadorRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/perfis", perfilRoutes);
app.use("/api/dados-extraidos", dadosExtraidosRoutes);

// 404
app.use((req, res) => {
  res.status(404).json({
    error: "Rota não encontrada",
  });
});

// Tratamento global de erros
app.use(errorHandler);

// Inicialização da aplicação
async function startServer() {
  try {
    console.log(" Inicializando banco de dados...");

    await initDatabase();

    console.log(" Banco de dados inicializado");

    app.listen(PORT, () => {
      console.log(` Server running on http://localhost:${PORT}`);
      console.log(` Health: http://localhost:${PORT}/health`);
      console.log(` Auth: http://localhost:${PORT}/api/auth`);
      console.log(` Jogadores: http://localhost:${PORT}/api/jogadores`);
      console.log(` Dashboard: http://localhost:${PORT}/api/dashboard/stats`);
      console.log(` Perfis: http://localhost:${PORT}/api/perfis/posicoes`);
    });
  } catch (error) {
    console.error("❌ Erro ao iniciar aplicação:", error);
    process.exit(1);
  }
}

startServer();

export default app;