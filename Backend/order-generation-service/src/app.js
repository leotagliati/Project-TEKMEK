import express from 'express';
import cors from 'cors';
import ordersRoutes from './routes/ordersRoutes.js';

const app = express();
app.use(cors());
app.use(express.json());
app.use('/api/orders', ordersRoutes);

app.post('/event', (req, res) => {
    console.log('Evento recebido:', req.body.type);
    res.sendStatus(200);
});

export default app;
