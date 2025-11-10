import dotenv from 'dotenv';
dotenv.config();

export const env = {
    db: {
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        database: process.env.DB_NAME,
        password: process.env.DB_PASSWORD,
        port: process.env.DB_PORT
    },
    port: process.env.MS_PORT || 3000,
    eventBusUrl: process.env.EVENT_BUS_URL || 'UNDEFINED_URL'
};
