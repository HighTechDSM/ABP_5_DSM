// src/utils/jwt.ts
import jwt, { SignOptions } from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

const SECRET = process.env.JWT_SECRET || 'soccer_stats_hub_secret_key_2024';
const EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

export const generateToken = (userId: number, email: string): string => {
  const payload = { userId, email };
  const options: SignOptions = { expiresIn: EXPIRES_IN as SignOptions['expiresIn'] };
  return jwt.sign(payload, SECRET, options);
};

export const verifyToken = (token: string): any => {
  try {
    return jwt.verify(token, SECRET);
  } catch (error) {
    console.error('Token verification failed:', error);
    return null;
  }
};