import { Request, Response } from 'express';
import { PerfilService } from '../services/perfilService';

export const PerfilController = {
  async getPerfisPorPosicao(req: Request, res: Response) {
    try {
      const perfis = await PerfilService.getPerfisPorPosicao();
      res.json(perfis);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  },
  
  async encontrarSubstitutos(req: Request, res: Response) {
    try {
      const { posicao, perfil } = req.query;
      
      if (!posicao || !perfil) {
        return res.status(400).json({ error: 'Posição e perfil são obrigatórios' });
      }
      
      const substitutos = await PerfilService.encontrarSubstitutos(
        posicao as string,
        perfil as string
      );
      
      res.json(substitutos);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  },
  
  async getPerfilByJogador(req: Request, res: Response) {
    try {
      const { athlete } = req.params;
      const perfil = await PerfilService.getPerfilByJogador(athlete);
      
      if (!perfil) {
        return res.status(404).json({ error: 'Jogador não encontrado' });
      }
      
      res.json(perfil);
    } catch (error: any) {
      res.status(500).json({ error: error.message });
    }
  }
};