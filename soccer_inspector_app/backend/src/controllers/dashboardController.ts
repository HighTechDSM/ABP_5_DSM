import { Request, Response } from 'express';
import { DashboardService } from '../services/dashboardService';
import { JogadorService } from '../services/jogadorService';

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
  },
async getEvolucaoElenco(req: Request, res: Response) {
  try {
    const dados =
      await JogadorService.getEvolucaoMediaElenco();

    return res.status(200).json(dados);

  } catch (error: any) {
    return res.status(500).json({
      error: error.message
    });
  }
 }
};