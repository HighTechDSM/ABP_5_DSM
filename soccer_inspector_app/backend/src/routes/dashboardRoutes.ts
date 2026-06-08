import { Router } from 'express';
import { DashboardController } from '../controllers/dashboardController';
import { authMiddleware } from '../middleware/authMiddleware';

const router = Router();

router.get('/stats', authMiddleware, DashboardController.getDashboardStats);
router.get('/analise/:grupo', authMiddleware, DashboardController.getAnalisePorGrupo);

export default router;