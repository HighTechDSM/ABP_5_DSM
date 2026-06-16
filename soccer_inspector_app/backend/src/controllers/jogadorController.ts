import { Request, Response } from 'express';
import { JogadorService } from '../services/jogadorService';

export const JogadorController = {
  async getAllJogadores(req: Request, res: Response) {
    try {
      console.log('[JogadorController] GET /api/jogadores - Buscando todos os jogadores');

      const jogadores = await JogadorService.getAllJogadores();

      console.log(`[JogadorController] Retornando ${jogadores.length} jogadores`);

      return res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getAllJogadores:', error);

      return res.status(500).json({
        error: 'Erro ao buscar jogadores',
        message: error.message
      });
    }
  },

async getJogadorById(req: Request, res: Response) {
  try {

    const { athleteId } = req.params;

    if (!athleteId) {
      return res.status(400).json({
        error: 'ID não informado'
      });
    }

    console.log(
      `[JogadorController] Buscando atleta por ID=${athleteId}`
    );

    const jogador = await JogadorService.getJogadorById( Number(athleteId));

    if (!jogador) {
      return res.status(404).json({
        error: `Jogador ${athleteId} não encontrado`
      });
    }

    return res.status(200).json(jogador);

  } catch (error: any) {
    console.error(
      '[JogadorController] Error in getJogadorById:',
      error
    );

    return res.status(500).json({
      error: 'Erro ao buscar jogador',
      message: error.message
    });
  }
},

async getComparacao(req: Request, res: Response) {
  try {
    const id = Number(req.params.id);

    const resultado = await JogadorService.compararJogador(id);

    return res.json(resultado);
  } catch (error: any) {
    return res.status(500).json({ error: error.message });
  }
},

async getHistoricoJogador(req: Request, res: Response) {
  try {
    const athleteId = Number(req.params.athleteId);

  } catch (error: any) {
    return res.status(500).json({
      error: error.message
    });
  }
},

  async getJogadorByAthlete(req: Request, res: Response) {
    try {
      const { athlete } = req.params;

      if (!athlete?.trim()) {
        return res.status(400).json({
          error: 'Nome do atleta é obrigatório'
        });
      }

      console.log(
        `[JogadorController] GET /api/jogadores/${athlete} - Buscando jogador por nome`
      );

      const jogador = await JogadorService.getJogadorByAthlete(athlete);

      if (!jogador) {
        return res.status(404).json({
          error: `Jogador ${athlete} não encontrado`
        });
      }

      return res.status(200).json(jogador);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadorByAthlete:', error);

      return res.status(500).json({
        error: 'Erro ao buscar jogador',
        message: error.message
      });
    }
  },

  async getJogadoresByGrupo(req: Request, res: Response) {
    try {
      const { grupo } = req.params;

      if (!grupo?.trim()) {
        return res.status(400).json({
          error: 'Grupo é obrigatório'
        });
      }

      console.log(
        `[JogadorController] GET /api/jogadores/grupo/${grupo}`
      );

      const jogadores = await JogadorService.getJogadoresByGrupo(grupo);

      return res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadoresByGrupo:', error);

      return res.status(500).json({
        error: 'Erro ao buscar jogadores por grupo',
        message: error.message
      });
    }
  },

  async getJogadoresByRendimento(req: Request, res: Response) {
    try {
      const { rendimento } = req.params;

      const validos = ['otimo', 'regular', 'baixo'];

      if (!validos.includes(rendimento)) {
        return res.status(400).json({
          error: 'Rendimento inválido. Use: otimo, regular, baixo'
        });
      }

      console.log(
        `[JogadorController] GET /api/jogadores/rendimento/${rendimento}`
      );

      const jogadores =
        await JogadorService.getJogadoresByRendimento(rendimento);

      return res.status(200).json(jogadores);
    } catch (error: any) {
      console.error(
        '[JogadorController] Error in getJogadoresByRendimento:',
        error
      );

      return res.status(500).json({
        error: 'Erro ao buscar jogadores por rendimento',
        message: error.message
      });
    }
  },

  async getJogadoresByPerfil(req: Request, res: Response) {
    try {
      const { perfil } = req.params;

      const validos = [
        'Explosivo',
        'Alta resistência',
        'Baixa intensidade',
        'Alta carga de impacto'
      ];

      if (!validos.includes(perfil)) {
        return res.status(400).json({
          error: 'Perfil inválido'
        });
      }

      console.log(
        `[JogadorController] GET /api/jogadores/perfil/${perfil}`
      );

      const jogadores = await JogadorService.getJogadoresByPerfil(perfil);

      return res.status(200).json(jogadores);
    } catch (error: any) {
      console.error('[JogadorController] Error in getJogadoresByPerfil:', error);

      return res.status(500).json({
        error: 'Erro ao buscar jogadores por perfil',
        message: error.message
      });
    }
  },

  async getEstatisticasGerais(req: Request, res: Response) {
    try {
      console.log('[JogadorController] GET /api/jogadores/estatisticas');

      const estatisticas =
        await JogadorService.getEstatisticasGerais();

      return res.status(200).json(estatisticas);
    } catch (error: any) {
      console.error(
        '[JogadorController] Error in getEstatisticasGerais:',
        error
      );

      return res.status(500).json({
        error: 'Erro ao buscar estatísticas gerais',
        message: error.message
      });
    }
  }
};