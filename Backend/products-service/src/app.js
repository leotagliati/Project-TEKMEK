import express from 'express';
import cors from 'cors';
import productRoutes from './routes/productRoutes.js';

const app = express();
app.use(cors());
app.use(express.json());
app.use('/api/products', productRoutes);

app.post('/event', (req, res) => {
    console.log('Evento recebido:', req.body.type);
    res.sendStatus(200);
});

export default app;
