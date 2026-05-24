import { Request, Response } from 'express';
import { 
  getAllDadosExtraidos,
  getDadosExtraidosById,
  getDadosExtraidosByGrupo,
  getDadosExtraidosByAthlete,
  getGruposDistinct,
  createDadosExtraidos,
  updateDadosExtraidos,
  deleteDadosExtraidos,
  associateDadosExtraidosWithUser,
  dissociateDadosExtraidosFromUser,
  getDadosExtraidosByUser,
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
    const userId = (req as any).user?.id;
    const { grupo, athlete } = req.query;
    
    let dados;
    if (grupo && typeof grupo === 'string') {
      dados = await getDadosExtraidosByGrupo(grupo, userId);
    } else if (athlete && typeof athlete === 'string') {
      dados = await getDadosExtraidosByAthlete(athlete, userId);
    } else {
      dados = await getAllDadosExtraidos(userId);
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
    const userId = (req as any).user?.id;
    
    const dados = await getDadosExtraidosById(parseInt(id), userId);
    
    if (!dados) {
      const response: ApiResponse = {
        success: false,
        error: 'Dados extraidos not found'
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
      error: 'Failed to fetch dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const getGrupos = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.id;
    const grupos = await getGruposDistinct(userId);
    
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

export const create = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.id;
    
    const requiredFields = [
      'grupos', 'athlete', 'distance', 'session_load', 'workload',
      'sprint_distance', 'high_intensity_running', 'high_intensity_events',
      'metres_per_minute', 'no_sprint', 'top_speed', 'raw_top_speed',
      'accelerations', 'decelerations', 'minutes_played'
    ];
    
    for (const field of requiredFields) {
      if (req.body[field] === undefined) {
        const response: ApiResponse = {
          success: false,
          error: `Missing required field: ${field}`
        };
        return res.status(400).json(response);
      }
    }
    
    const novoDados = await createDadosExtraidos(req.body);
    
    if (userId) {
      await associateDadosExtraidosWithUser(userId, novoDados.id);
    }
    
    const response: ApiResponse = {
      success: true,
      message: 'Dados extraidos created successfully',
      data: novoDados
    };
    
    res.status(201).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to create dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const update = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const userId = (req as any).user?.id;
    
    const existing = await getDadosExtraidosById(parseInt(id), userId);
    if (!existing) {
      const response: ApiResponse = {
        success: false,
        error: 'Dados extraidos not found'
      };
      return res.status(404).json(response);
    }
    
    const updated = await updateDadosExtraidos(parseInt(id), req.body);
    
    const response: ApiResponse = {
      success: true,
      message: 'Dados extraidos updated successfully',
      data: updated
    };
    
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to update dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const remove = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const userId = (req as any).user?.id;
    
    const existing = await getDadosExtraidosById(parseInt(id), userId);
    if (!existing) {
      const response: ApiResponse = {
        success: false,
        error: 'Dados extraidos not found'
      };
      return res.status(404).json(response);
    }
    
    await deleteDadosExtraidos(parseInt(id));
    
    const response: ApiResponse = {
      success: true,
      message: 'Dados extraidos deleted successfully'
    };
    
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to delete dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const associate = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.id;
    const { dadosId } = req.params;
    
    if (!userId) {
      const response: ApiResponse = {
        success: false,
        error: 'User not authenticated'
      };
      return res.status(401).json(response);
    }
    
    await associateDadosExtraidosWithUser(userId, parseInt(dadosId));
    
    const response: ApiResponse = {
      success: true,
      message: 'Dados extraidos associated with user successfully'
    };
    
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to associate dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const dissociate = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.id;
    const { dadosId } = req.params;
    
    if (!userId) {
      const response: ApiResponse = {
        success: false,
        error: 'User not authenticated'
      };
      return res.status(401).json(response);
    }
    
    await dissociateDadosExtraidosFromUser(userId, parseInt(dadosId));
    
    const response: ApiResponse = {
      success: true,
      message: 'Dados extraidos dissociated from user successfully'
    };
    
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to dissociate dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const getUserDados = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.id;
    
    if (!userId) {
      const response: ApiResponse = {
        success: false,
        error: 'User not authenticated'
      };
      return res.status(401).json(response);
    }
    
    const dados = await getDadosExtraidosByUser(userId);
    
    const response: ApiResponse = {
      success: true,
      data: dados
    };
    
    res.status(200).json(response);
  } catch (error) {
    const response: ApiResponse = {
      success: false,
      error: 'Failed to fetch user dados extraidos'
    };
    res.status(500).json(response);
  }
};

export const getEstatisticas = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.id;
    const estatisticas = await getEstatisticasResumo(userId);
    
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