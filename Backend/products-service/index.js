import app from './src/app.js';
import { env } from './src/config/environment.js';

app.listen(env.port, () => {
  console.clear();
  console.log('----------------------------------------------------');
  console.log(`'products service' rodando na porta ${env.port}`);
  console.log('----------------------------------------------------');
});
