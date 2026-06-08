import { Request, Response } from 'express';
import { DashboardService } from '../services/dashboardService';

export const DashboardController = {
  async getDashboardStats(req: Request, res: Response) {
    try {
      const stats = await DashboardService.getDashboardStats();
      res.json(stats);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  },
  
  async getAnalisePorGrupo(req: Request, res: Response) {
    try {
      const { grupo } = req.params;
      const analise = await DashboardService.getAnalisePorGrupo(grupo);
      res.json(analise);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
};