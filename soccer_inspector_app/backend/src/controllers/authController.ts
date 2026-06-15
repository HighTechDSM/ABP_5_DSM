import { Request, Response } from 'express';
import { AuthService } from '../services/authService';

export const AuthController = {
  async register(req: Request, res: Response) {
    try {
      const { name, email, password } = req.body;
      
      console.log('Register attempt:', { name, email });
      
      if (!name || !email || !password) {
        return res.status(400).json({ error: 'Todos os campos são obrigatórios' });
      }
      
      if (password.length < 6) {
        return res.status(400).json({ error: 'A senha deve ter no mínimo 6 caracteres' });
      }
      
      const result = await AuthService.register({ name, email, password });
      console.log('Register success:', { email });
      res.status(201).json(result);
    } catch (error: any) {
      console.error('Register error:', error);
      res.status(400).json({ error: error.message });
    }
  },
  
  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body;
      
      if (!email || !password) {
        return res.status(400).json({ error: 'E-mail e senha são obrigatórios' });
      }
      
      const result = await AuthService.login({ email, password });
      res.json(result);
    } catch (error: any) {
      console.error('Login error:', error);
      res.status(401).json({ error: error.message });
    }
  },
  
  async getProfile(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.userId;
      const user = await AuthService.getUserProfile(userId);
      res.json(user);
    } catch (error: any) {
      console.error('Profile error:', error);
      res.status(404).json({ error: error.message });
    }
  }
};