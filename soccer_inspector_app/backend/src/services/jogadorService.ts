// backend/src/services/jogadorService.ts
import { DadosExtraidosModel } from '../models/DadosExtraidos';
import { JogadorStats } from '../types/index';

export const JogadorService = {
  async getAllJogadores(): Promise<JogadorStats[]> {
    try {
      const allJogadores = await DadosExtraidosModel.getAllJogadoresStats();
      
      // Adicionar perfil a cada jogador baseado nos dados reais
      const jogadoresComPerfil = allJogadores.map(jogador => ({
        ...jogador,
        perfil: DadosExtraidosModel.calcularPerfil(
          jogador.velocidadeMax, 
          jogador.distancia, 
          jogador.sprints
        )
      }));
      
      console.log(`[JogadorService] Retornando ${jogadoresComPerfil.length} jogadores do banco`);
      return jogadoresComPerfil;
    } catch (error) {
      console.error('[JogadorService] Error in getAllJogadores:', error);
      return [];
    }
  },

  async getJogadorById(id: number): Promise<JogadorStats | null> {
    try {
      const jogador = await DadosExtraidosModel.getJogadorStatsById(id);
      if (!jogador) {
        console.log(`[JogadorService] Jogador com ID ${id} não encontrado`);
        return null;
      }
      
      return {
        ...jogador,
        perfil: DadosExtraidosModel.calcularPerfil(
          jogador.velocidadeMax, 
          jogador.distancia, 
          jogador.sprints
        )
      };
    } catch (error) {
      console.error(`[JogadorService] Error in getJogadorById for ID ${id}:`, error);
      return null;
    }
  },

  async getJogadorByAthlete(athlete: string): Promise<JogadorStats | null> {
    try {
      // Buscar todos os atletas com o mesmo nome
      const jogadores = await DadosExtraidosModel.getJogadorStatsByAthlete(athlete);
      
      if (jogadores.length === 0) {
        console.log(`[JogadorService] Jogador ${athlete} não encontrado`);
        return null;
      }
      
      // Se houver múltiplos jogadores com o mesmo nome, retorna o primeiro
      // (mas na lista de jogadores todos aparecerão com seus respectivos IDs)
      const jogador = jogadores[0];
      
      return {
        ...jogador,
        perfil: DadosExtraidosModel.calcularPerfil(
          jogador.velocidadeMax, 
          jogador.distancia, 
          jogador.sprints
        )
      };
    } catch (error) {
      console.error(`[JogadorService] Error in getJogadorByAthlete for ${athlete}:`, error);
      return null;
    }
  },

  async getJogadoresByGrupo(grupo: string): Promise<JogadorStats[]> {
    try {
      const stats = await DadosExtraidosModel.getJogadoresStatsByGrupo(grupo);
      
      const jogadoresComPerfil = stats.map(jogador => ({
        ...jogador,
        perfil: DadosExtraidosModel.calcularPerfil(
          jogador.velocidadeMax, 
          jogador.distancia, 
          jogador.sprints
        )
      }));
      
      console.log(`[JogadorService] Grupo ${grupo}: ${jogadoresComPerfil.length} jogadores encontrados`);
      return jogadoresComPerfil;
    } catch (error) {
      console.error(`[JogadorService] Error in getJogadoresByGrupo for ${grupo}:`, error);
      return [];
    }
  },

  async getJogadoresByRendimento(rendimento: string): Promise<JogadorStats[]> {
    try {
      const allJogadores = await this.getAllJogadores();
      const filtrados = allJogadores.filter(j => j.rendimento === rendimento);
      
      console.log(`[JogadorService] Rendimento ${rendimento}: ${filtrados.length} jogadores encontrados`);
      return filtrados;
    } catch (error) {
      console.error(`[JogadorService] Error in getJogadoresByRendimento for ${rendimento}:`, error);
      return [];
    }
  },

  async getJogadoresByPerfil(perfil: string): Promise<JogadorStats[]> {
    try {
      const allJogadores = await this.getAllJogadores();
      const filtrados = allJogadores.filter(j => j.perfil === perfil);
      
      console.log(`[JogadorService] Perfil ${perfil}: ${filtrados.length} jogadores encontrados`);
      return filtrados;
    } catch (error) {
      console.error(`[JogadorService] Error in getJogadoresByPerfil for ${perfil}:`, error);
      return [];
    }
  },

  async getEstatisticasGerais(): Promise<{
    total: number;
    mediaVelocidade: number;
    mediaDistancia: number;
    totalSprints: number;
    otimos: number;
    regulares: number;
    baixos: number;
  }> {
    try {
      const allJogadores = await this.getAllJogadores();
      const total = allJogadores.length;
      
      const somaVelocidade = allJogadores.reduce((sum, j) => sum + j.velocidadeMax, 0);
      const somaDistancia = allJogadores.reduce((sum, j) => sum + j.distancia, 0);
      const totalSprints = allJogadores.reduce((sum, j) => sum + j.sprints, 0);
      
      const otimos = allJogadores.filter(j => j.rendimento === 'otimo').length;
      const regulares = allJogadores.filter(j => j.rendimento === 'regular').length;
      const baixos = allJogadores.filter(j => j.rendimento === 'baixo').length;
      
      return {
        total,
        mediaVelocidade: total > 0 ? somaVelocidade / total : 0,
        mediaDistancia: total > 0 ? somaDistancia / total : 0,
        totalSprints,
        otimos,
        regulares,
        baixos
      };
    } catch (error) {
      console.error('[JogadorService] Error in getEstatisticasGerais:', error);
      return {
        total: 0,
        mediaVelocidade: 0,
        mediaDistancia: 0,
        totalSprints: 0,
        otimos: 0,
        regulares: 0,
        baixos: 0
      };
    }
  }
};