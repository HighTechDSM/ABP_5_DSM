import { Request, Response } from 'express';
import {
  getAllDadosExtraidos,
  getDadosExtraidosById,
  getDadosExtraidosByGrupo,
  getDadosExtraidosByAthlete,
  getGruposDistinct,
  getEstatisticasResumo
} from '../services/dadosExtraidosService';

type ApiResponse = {
  success: boolean;
  data?: any;
  message?: string;
  error?: string;
};

export const getAll = async (req: Request, res: Response) => {
  try {
    const { grupo, athlete } = req.query;

    let dados;

    if (grupo && typeof grupo === 'string') {
      dados = await getDadosExtraidosByGrupo(grupo);
    } else if (athlete && typeof athlete === 'string') {
      dados = await getDadosExtraidosByAthlete(athlete);
    } else {
      dados = await getAllDadosExtraidos();
    }

    const response: ApiResponse = {
      success: true,
      data: dados
    };
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to fetch dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const getById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const dados = await getDadosExtraidosById(Number(id));

    if (!dados || dados.length === 0) {
      const response: ApiResponse = {
        success: false,
        error: 'Athlete not found'
      };

      return res.status(404).json(response);
    }

    const response: ApiResponse = {
      success: true,
      data: dados
    };
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to fetch athlete'
    };

    res.status(500).json(response);
  }
};

export const getGrupos = async (_req: Request, res: Response) => {
  try {
    const grupos = await getGruposDistinct();

    const response: ApiResponse = {
      success: true,
      data: grupos
    };
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to fetch grupos'
    };
    res.status(500).json(response);
  }
};

export const getEstatisticas = async (_req: Request, res: Response) => {
  try {
    const estatisticas = await getEstatisticasResumo();

    const response: ApiResponse = {
      success: true,
      data: estatisticas
    };
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to fetch estatisticas'
    };
    res.status(500).json(response);
  }
};