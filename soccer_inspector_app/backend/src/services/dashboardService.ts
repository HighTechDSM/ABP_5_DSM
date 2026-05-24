// backend/src/services/dashboardService.ts
import { DadosExtraidosModel } from '../models/DadosExtraidos';
import { JogadorService } from './jogadorService';

export const DashboardService = {
  async getDashboardStats(): Promise<any> {
    try {
      const allJogadores = await DadosExtraidosModel.getAllJogadoresStats();
      
      console.log(`Dashboard: Found ${allJogadores.length} jogadores`);
      
      if (!allJogadores || allJogadores.length === 0) {
        return {
          resumo: {
            totalJogadores: 0,
            otimo: 0,
            regular: 0,
            baixo: 0,
            mediaVelocidade: '0',
            mediaDistancia: '0',
            totalSprints: 0
          },
          grupos: {},
          desempenhoUltimoJogo: []
        };
      }
      
      const otimo = allJogadores.filter(j => j.rendimento === 'otimo').length;
      const regular = allJogadores.filter(j => j.rendimento === 'regular').length;
      const baixo = allJogadores.filter(j => j.rendimento === 'baixo').length;
      const total = allJogadores.length;
      
      const somaVelocidade = allJogadores.reduce((sum, j) => sum + (j.velocidadeMax || 0), 0);
      const somaDistancia = allJogadores.reduce((sum, j) => sum + (j.distancia || 0), 0);
      const totalSprints = allJogadores.reduce((sum, j) => sum + (j.sprints || 0), 0);
      
      const mediaVelocidade = total > 0 ? somaVelocidade / total : 0;
      const mediaDistancia = total > 0 ? somaDistancia / total : 0;
      
      const grupos: any = {};
      allJogadores.forEach(j => {
        const posicao = j.posicao || 'Sem posição';
        if (!grupos[posicao]) {
          grupos[posicao] = [];
        }
        grupos[posicao].push(j);
      });
      
      const desempenhoUltimoJogo = allJogadores.map(j => ({
        nome: j.nome,
        valor: j.historico && j.historico.length > 0 ? j.historico[j.historico.length - 1].valor : 50
      }));
      
      return {
        resumo: {
          totalJogadores: total,
          otimo,
          regular,
          baixo,
          mediaVelocidade: mediaVelocidade.toFixed(1),
          mediaDistancia: mediaDistancia.toFixed(1),
          totalSprints
        },
        grupos,
        desempenhoUltimoJogo
      };
    } catch (error) {
      console.error('Error in getDashboardStats:', error);
      throw error;
    }
  },
  
  async getAnalisePorGrupo(grupo: string): Promise<any> {
    try {
      const jogadores = await JogadorService.getJogadoresByGrupo(grupo);
      const total = jogadores.length;
      
      const otimo = jogadores.filter(j => j.rendimento === 'otimo').length;
      const regular = jogadores.filter(j => j.rendimento === 'regular').length;
      const baixo = jogadores.filter(j => j.rendimento === 'baixo').length;
      
      return {
        grupo,
        total,
        otimo,
        regular,
        baixo,
        jogadores
      };
    } catch (error) {
      console.error('Error in getAnalisePorGrupo:', error);
      throw error;
    }
  }
};