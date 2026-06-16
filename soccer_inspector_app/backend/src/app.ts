// backend/src/app.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/authRoutes';
import jogadorRoutes from './routes/jogadorRoutes';
import dashboardRoutes from './routes/dashboardRoutes';
import perfilRoutes from './routes/perfilRoutes';
import dadosExtraidosRoutes from './routes/dadosExtraidosRoutes';
import { errorHandler } from './middleware/errorHandler';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Configuração CORS para desenvolvimento (permite todas as origens localhost)
const corsOptions = {
  origin: true, // Permite todas as origens em desenvolvimento
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept'],
  exposedHeaders: ['Authorization'],
  optionsSuccessStatus: 200,
};

// Middleware CORS (deve vir antes de tudo)
app.use(cors(corsOptions));

// Middleware para logging de requisições
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path} - Origin: ${req.headers.origin || 'unknown'}`);
  next();
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rotas
app.use('/api/auth', authRoutes);
app.use('/api/jogadores', jogadorRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/perfis', perfilRoutes);
app.use('/api/dados-extraidos', dadosExtraidosRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Error handler
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔗 CORS enabled for all origins`);
});

export default app;