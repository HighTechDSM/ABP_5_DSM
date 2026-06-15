import { Router } from 'express';
import { JogadorController } from '../controllers/jogadorController';
import { authMiddleware } from '../middleware/authMiddleware';

const router = Router();

// Estatísticas gerais do dashboard
router.get(
  '/estatisticas',
  authMiddleware,
  JogadorController.getEstatisticasGerais
);

router.get(
  '/id/:athleteId/historico',
  authMiddleware,
  JogadorController.getHistoricoJogador
);

// Buscar jogador por Athlete ID
router.get(
  '/id/:athleteId',
  authMiddleware,
  JogadorController.getJogadorById
);

// Buscar jogadores por grupo
router.get(
  '/grupo/:grupo',
  authMiddleware,
  JogadorController.getJogadoresByGrupo
);

router.get('/jogadores/comparar/:id', JogadorController.getComparacao);

// Buscar jogadores por rendimento
router.get(
  '/rendimento/:rendimento',
  authMiddleware,
  JogadorController.getJogadoresByRendimento
);

// Buscar jogadores por perfil
router.get(
  '/perfil/:perfil',
  authMiddleware,
  JogadorController.getJogadoresByPerfil
);

// Listar todos os jogadores
router.get(
  '/',
  authMiddleware,
  JogadorController.getAllJogadores
);

// Buscar jogador pelo nome
// DEVE SER A ÚLTIMA ROTA
router.get(
  '/:athlete',
  authMiddleware,
  JogadorController.getJogadorByAthlete
);

export default router;
