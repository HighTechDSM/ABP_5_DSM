// backend/src/controllers/jogadorController.ts
import { Request, Response } from 'express';
import { JogadorService } from '../services/jogadorService';

export const JogadorController = {
  async getAllJogadores(req: Request, res: Response) {
    try {
      console.log('[JogadorController] GET /api/jogadores - Buscando todos os jogadores');
      const jogadores = await JogadorService.getAllJogadores();
      
      console.log(`[JogadorController] Retornando ${jogadores.length} jogadores`);
      res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getAllJogadores:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar jogadores',
        message: error.message 
      });
    }
  },
  
  async getJogadorById(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const jogadorId = parseInt(id);
      
      if (isNaN(jogadorId)) {
        return res.status(400).json({ error: 'ID inválido' });
      }
      
      console.log(`[JogadorController] GET /api/jogadores/id/${jogadorId} - Buscando jogador por ID`);
      
      const jogador = await JogadorService.getJogadorById(jogadorId);
      
      if (!jogador) {
        return res.status(404).json({ error: `Jogador com ID ${jogadorId} não encontrado` });
      }
      
      res.status(200).json(jogador);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadorById:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar jogador',
        message: error.message 
      });
    }
  },
  
  async getJogadorByAthlete(req: Request, res: Response) {
    try {
      const { athlete } = req.params;
      
      if (!athlete || athlete.trim() === '') {
        return res.status(400).json({ error: 'Nome do atleta é obrigatório' });
      }
      
      console.log(`[JogadorController] GET /api/jogadores/${athlete} - Buscando jogador por nome`);
      
      const jogador = await JogadorService.getJogadorByAthlete(athlete);
      
      if (!jogador) {
        return res.status(404).json({ error: `Jogador ${athlete} não encontrado` });
      }
      
      res.status(200).json(jogador);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadorByAthlete:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar jogador',
        message: error.message 
      });
    }
  },
  
  async getJogadoresByGrupo(req: Request, res: Response) {
    try {
      const { grupo } = req.params;
      
      if (!grupo || grupo.trim() === '') {
        return res.status(400).json({ error: 'Grupo é obrigatório' });
      }
      
      console.log(`[JogadorController] GET /api/jogadores/grupo/${grupo} - Buscando jogadores por grupo`);
      
      const jogadores = await JogadorService.getJogadoresByGrupo(grupo);
      
      res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadoresByGrupo:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar jogadores por grupo',
        message: error.message 
      });
    }
  },
  
  async getJogadoresByRendimento(req: Request, res: Response) {
    try {
      const { rendimento } = req.params;
      
      const rendimentosValidos = ['otimo', 'regular', 'baixo'];
      if (!rendimentosValidos.includes(rendimento)) {
        return res.status(400).json({ error: 'Rendimento inválido. Use: otimo, regular, baixo' });
      }
      
      console.log(`[JogadorController] GET /api/jogadores/rendimento/${rendimento} - Buscando jogadores por rendimento`);
      
      const jogadores = await JogadorService.getJogadoresByRendimento(rendimento);
      
      res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadoresByRendimento:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar jogadores por rendimento',
        message: error.message 
      });
    }
  },
  
  async getJogadoresByPerfil(req: Request, res: Response) {
    try {
      const { perfil } = req.params;
      
      const perfisValidos = ['Explosivo', 'Alta resistência', 'Baixa intensidade', 'Alta carga de impacto'];
      if (!perfisValidos.includes(perfil)) {
        return res.status(400).json({ error: 'Perfil inválido' });
      }
      
      console.log(`[JogadorController] GET /api/jogadores/perfil/${perfil} - Buscando jogadores por perfil`);
      
      const jogadores = await JogadorService.getJogadoresByPerfil(perfil);
      
      res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadoresByPerfil:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar jogadores por perfil',
        message: error.message 
      });
    }
  },
  
  async getEstatisticasGerais(req: Request, res: Response) {
    try {
      console.log('[JogadorController] GET /api/jogadores/estatisticas - Buscando estatísticas gerais');
      
      const estatisticas = await JogadorService.getEstatisticasGerais();
      
      res.status(200).json(estatisticas);
    } catch (error: any) {
      console.error('[JogadorController] Error in getEstatisticasGerais:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar estatísticas gerais',
        message: error.message 
      });
    }
  }
};