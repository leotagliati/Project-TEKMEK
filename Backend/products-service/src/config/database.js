import { Pool } from 'pg';
import { env } from './environment.js';

export const pool = new Pool(env.db);

pool.connect((err, client, release) => {
  if (err) {
    console.error('Erro ao conectar ao PostgreSQL:', err.stack);
  } else {
    console.log('Conectado ao PostgreSQL com sucesso');
    release();
  }
});
