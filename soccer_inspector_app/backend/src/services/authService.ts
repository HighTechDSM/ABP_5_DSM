// backend/src/services/authService.ts
import { UserModel } from '../models/User';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

const SECRET = process.env.JWT_SECRET || 'soccer_stats_hub_secret_key_2024';
const EXPIRES_IN = '7d';

const generateToken = (userId: number, email: string): string => {
  return jwt.sign({ userId, email }, SECRET, { expiresIn: EXPIRES_IN });
};

export const AuthService = {
  async register(userData: { name: string; email: string; password: string }) {
    // Verificar se usuário já existe
    const existingUser = await UserModel.findByEmail(userData.email);
    if (existingUser) {
      throw new Error('Usuário já existe com este e-mail');
    }

    // Criar usuário
    const user = await UserModel.create(userData);
    
    if (!user || !user.id) {
      throw new Error('Erro ao criar usuário');
    }
    
    // Gerar token
    const token = generateToken(user.id, user.email);

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email
      }
    };
  },

  async login(credentials: { email: string; password: string }) {
    // Buscar usuário
    const user = await UserModel.findByEmail(credentials.email);
    if (!user) {
      throw new Error('Credenciais inválidas');
    }

    // Verificar senha
    const isValidPassword = await bcrypt.compare(credentials.password, user.password_hash);
    if (!isValidPassword) {
      throw new Error('Credenciais inválidas');
    }

    // Gerar token
    const token = generateToken(user.id, user.email);

    return {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email
      }
    };
  },

  async getUserProfile(userId: number) {
    const user = await UserModel.findById(userId);
    if (!user) {
      throw new Error('Usuário não encontrado');
    }
    return user;
  }
};