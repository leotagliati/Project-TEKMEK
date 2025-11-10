import axios from 'axios';
import { env } from '../config/environment.js';

export async function emitEvent(type, data) {
    try {
        await axios.post(env.eventBusUrl, { type, data });
        console.log(`[EVENTO ENVIADO] ${type}`);
    } catch (err) {
        console.error(`[ERRO] Falha ao enviar evento ${type}:`, err.message);
    }
}
