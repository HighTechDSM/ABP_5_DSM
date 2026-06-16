import { Router } from 'express';
import { PerfilController } from '../controllers/perfilController';
import { authMiddleware } from '../middleware/authMiddleware';

const router = Router();

router.get('/posicoes', authMiddleware, PerfilController.getPerfisPorPosicao);
router.get('/substitutos', authMiddleware, PerfilController.encontrarSubstitutos);
router.get('/:athlete', authMiddleware, PerfilController.getPerfilByJogador);

export default router;