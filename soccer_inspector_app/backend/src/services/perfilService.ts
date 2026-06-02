// backend/src/services/perfilService.ts
import { JogadorService } from './jogadorService';
import { JogadorStats } from '../types/index';

export const PerfilService = {
  async getPerfisPorPosicao(): Promise<any> {
    try {
      const allJogadores = await JogadorService.getAllJogadores();
      const grupos: any = {};
      
      console.log(`Perfis: Encontrados ${allJogadores.length} jogadores`);
      
      for (const jogador of allJogadores) {
        const posicao = jogador.posicao || 'Sem posição';
        if (!grupos[posicao]) {
          grupos[posicao] = [];
        }
        
        // Adiciona informações completas do jogador
        grupos[posicao].push({
          nome: jogador.nome,
          numero: jogador.numero,
          posicao: jogador.posicao,
          velocidadeMax: jogador.velocidadeMax,
          distancia: jogador.distancia,
          sprints: jogador.sprints,
          rendimento: jogador.rendimento,
          tendencia: jogador.tendencia,
          perfil: jogador.perfil,
          historico: jogador.historico
        });
      }
      
      console.log(`Perfis: ${Object.keys(grupos).length} grupos encontrados`);
      return grupos;
    } catch (error) {
      console.error('Error in getPerfisPorPosicao:', error);
      return {};
    }
  },
  
  async encontrarSubstitutos(posicao: string | undefined, perfil: string | undefined): Promise<JogadorStats[]> {
    try {
      const grupo = posicao ?? 'Sem posição';
      const perfilBuscado = perfil ?? '';
      const jogadoresPosicao = await JogadorService.getJogadoresByGrupo(grupo);
      
      // Filtra jogadores com perfil similar
      const substitutos = jogadoresPosicao.filter(j => {
        const velocidadeAlta = j.velocidadeMax > 28;
        const bomRendimento = j.rendimento === 'otimo' || j.rendimento === 'regular';
        
        if (perfilBuscado === 'Explosivo') {
          return velocidadeAlta && bomRendimento;
        } else if (perfilBuscado === 'Alta resistência') {
          return j.distancia > 9 && bomRendimento;
        } else if (perfilBuscado === 'Alta carga de impacto') {
          return j.sprints > 20 && bomRendimento;
        } else if (perfilBuscado === 'Baixa intensidade') {
          return j.velocidadeMax < 25 && j.distancia < 8;
        }
        return bomRendimento;
      });
      
      console.log(`Substitutos para ${perfilBuscado} em ${grupo}: ${substitutos.length} encontrados`);
      return substitutos;
    } catch (error) {
      console.error('Error in encontrarSubstitutos:', error);
      return [];
    }
  },
  
  async getPerfilByJogador(athlete: string): Promise<any> {
    try {
      const jogador = await JogadorService.getJogadorById(Number(athlete));
      if (!jogador) return null;
      
      const substitutos = await this.encontrarSubstitutos(jogador.posicao, jogador.perfil);
      
      return {
        jogador,
        tipoPerfil: jogador.perfil,
        substitutos: substitutos.filter(s => s.nome !== athlete)
      };
    } catch (error) {
      console.error(`Error in getPerfilByJogador for ${athlete}:`, error);
      return null;
    }
  }
};