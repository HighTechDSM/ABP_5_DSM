// backend/src/routes/dadosExtraidosRoutes.ts
import { Router } from 'express';
import { 
  getAll,
  getById,
  getGrupos,
  create,
  update,
  remove,
  associate,
  dissociate,
  getUserDados,
  getEstatisticas
} from '../controllers/dadosExtraidosController';
import { authMiddleware } from '../middleware/authMiddleware';

const router = Router();

// Rotas públicas
router.get('/', getAll);
router.get('/grupos', getGrupos);
router.get('/estatisticas', getEstatisticas);
router.get('/user', authMiddleware, getUserDados);
router.get('/:id', getById);

// Rotas protegidas (requerem autenticação)
router.post('/', authMiddleware, create);
router.put('/:id', authMiddleware, update);
router.delete('/:id', authMiddleware, remove);
router.post('/:dadosId/associate', authMiddleware, associate);
router.delete('/:dadosId/dissociate', authMiddleware, dissociate);

export default router;