import { Router } from 'express';
import {
  getAll,
  getById,
  getGrupos,
  getEstatisticas
} from '../controllers/dadosExtraidosController';

const router = Router();

// Consultas dos dados reais importados
router.get('/', getAll);
router.get('/grupos', getGrupos);
router.get('/estatisticas', getEstatisticas);
router.get('/:id', getById);

export default router;