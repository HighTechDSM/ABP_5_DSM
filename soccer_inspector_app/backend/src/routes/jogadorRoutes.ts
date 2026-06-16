// backend/src/routes/jogadorRoutes.ts
import { Router } from 'express';
import { JogadorController } from '../controllers/jogadorController';
import { authMiddleware } from '../middleware/authMiddleware';

const router = Router();

// Rotas específicas DEVEM vir antes das rotas com parâmetros genéricos
// para evitar conflitos (ex: /estatisticas não ser confundido com /:athlete)

// Rota para estatísticas gerais
router.get('/estatisticas', authMiddleware, JogadorController.getEstatisticasGerais);

// Rota para buscar por ID
router.get('/id/:id', authMiddleware, JogadorController.getJogadorById);

// Rota para buscar por grupo
router.get('/grupo/:grupo', authMiddleware, JogadorController.getJogadoresByGrupo);

// Rota para buscar por rendimento
router.get('/rendimento/:rendimento', authMiddleware, JogadorController.getJogadoresByRendimento);

// Rota para buscar por perfil
router.get('/perfil/:perfil', authMiddleware, JogadorController.getJogadoresByPerfil);

// Rota para buscar todos os jogadores
router.get('/', authMiddleware, JogadorController.getAllJogadores);

// Rota para buscar por nome (DEVE SER A ÚLTIMA, pois é genérica)
router.get('/:athlete', authMiddleware, JogadorController.getJogadorByAthlete);

export default router;