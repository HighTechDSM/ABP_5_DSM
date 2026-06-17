import { JogadorService } from './jogadorService';
import { JogadorStats } from '../types/index';

export const PerfilService = {
  async getPerfisPorPosicao(): Promise<any> {
    try {
      const allJogadores = await JogadorService.getAllJogadores();

      const grupos: any = {};

      console.log(
        `Perfis: Encontrados ${allJogadores.length} jogadores`
      );

      for (const jogador of allJogadores) {
        const posicao = jogador.posicao || 'Sem posição';

        if (!grupos[posicao]) {
          grupos[posicao] = [];
        }

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

      console.log(
        `Perfis: ${Object.keys(grupos).length} grupos encontrados`
      );

      return grupos;
    } catch (error) {
      console.error('Error in getPerfisPorPosicao:', error);
      return {};
    }
  },

  async encontrarSubstitutos(
    posicao: string | undefined,
    perfil: string | undefined
  ): Promise<JogadorStats[]> {
    try {
      const jogadores = await JogadorService.getAllJogadores();

      const jogadoresMesmaPosicao = jogadores.filter(
        jogador => jogador.posicao === posicao
      );

      const perfilBuscado = (perfil || '').toLowerCase();

      const substitutos = jogadoresMesmaPosicao.filter(jogador => {
        const velocidadeAlta = jogador.velocidadeMax > 28;

        const bomRendimento =
          jogador.rendimento === 'otimo' ||
          jogador.rendimento === 'regular';

        if (perfilBuscado === 'explosivo') {
          return velocidadeAlta && bomRendimento;
        }

        if (perfilBuscado === 'alta resistência') {
          return jogador.distancia > 9000 && bomRendimento;
        }

        if (perfilBuscado === 'baixa intensidade') {
          return (
            jogador.velocidadeMax < 25 &&
            jogador.distancia < 8000
          );
        }

        if (perfilBuscado === 'equilibrado') {
          return bomRendimento;
        }

        return bomRendimento;
      });

      console.log(
        `Substitutos para ${perfilBuscado} em ${posicao}: ${substitutos.length} encontrados`
      );

      return substitutos;
    } catch (error) {
      console.error('Error in encontrarSubstitutos:', error);
      return [];
    }
  },

  async getPerfilByJogador(
    athleteId: string
  ): Promise<any> {
    try {
      const jogador = await JogadorService.getJogadorById(
        Number(athleteId)
      );

      if (!jogador) {
        return null;
      }

      const substitutos =
        await this.encontrarSubstitutos(
          jogador.posicao,
          jogador.perfil
        );

      return {
        jogador,
        tipoPerfil: jogador.perfil,
        substitutos: substitutos.filter(
          s => s.numero !== jogador.numero
        )
      };
    } catch (error) {
      console.error(
        `Error in getPerfilByJogador for ${athleteId}:`,
        error
      );

      return null;
    }
  }
};