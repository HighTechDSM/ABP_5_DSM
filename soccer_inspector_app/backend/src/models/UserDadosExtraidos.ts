import { query } from '../config/database';
import { UserDadosExtraidos } from '../types/index';

export const UserDadosExtraidosModel = {
  async associate(userId: number, dadosId: number): Promise<void> {
    await query(
      'INSERT INTO users_d_extraidos (users_id, d_extraidos_id) VALUES ($1, $2)',
      [userId, dadosId]
    );
  },

  async removeAssociation(userId: number, dadosId: number): Promise<void> {
    await query(
      'DELETE FROM users_d_extraidos WHERE users_id = $1 AND d_extraidos_id = $2',
      [userId, dadosId]
    );
  },

  async getUserAssociations(userId: number): Promise<UserDadosExtraidos[]> {
    const result = await query(
      'SELECT * FROM users_d_extraidos WHERE users_id = $1',
      [userId]
    );
    return result.rows;
  }
};