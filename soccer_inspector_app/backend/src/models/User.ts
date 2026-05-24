// backend/src/models/User.ts
import { query } from '../config/database';
import bcrypt from 'bcrypt';

export interface User {
  id: number;
  name: string;
  email: string;
  password_hash: string;
  created_at: Date;
  updated_at: Date;
}

const SALT_ROUNDS = 10;

export const UserModel = {
  async create(userData: { name: string; email: string; password: string }): Promise<User> {
    const { name, email, password } = userData;
    const password_hash = await bcrypt.hash(password, SALT_ROUNDS);
    
    console.log('Creating user:', { name, email });
    
    const result = await query(
      'INSERT INTO users (name, email, password_hash) VALUES ($1, $2, $3) RETURNING id, name, email, created_at, updated_at',
      [name, email, password_hash]
    );
    
    console.log('User created:', result.rows[0]);
    
    return result.rows[0];
  },

  async findByEmail(email: string): Promise<User | null> {
    const result = await query('SELECT * FROM users WHERE email = $1', [email]);
    return result.rows[0] || null;
  },

  async findById(id: number): Promise<Omit<User, 'password_hash'> | null> {
    const result = await query('SELECT id, name, email, created_at, updated_at FROM users WHERE id = $1', [id]);
    return result.rows[0] || null;
  }
};