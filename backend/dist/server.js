/**
 * Servidor Express — DNI-Connect Backend
 *
 * API REST para:
 * - Verificación de QR MiDNI (ICAO 9303 Pt.13)
 * - Sincronización de datos verificados a Google Cloud
 * - Gestión de sesiones y autenticación
 */
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { verificationRouter } from './routes/verification.js';
import { syncRouter } from './routes/sync.js';
import { authRouter } from './routes/auth.js';
import { errorHandler } from './middleware/error-handler.js';
import { requestLogger } from './middleware/request-logger.js';
import { logger } from './utils/logger.js';
dotenv.config();
const app = express();
const PORT = parseInt(process.env.PORT ?? '3001', 10);
// ─── Seguridad ────────────────────────────────────────────────────────
app.use(helmet());
app.use(cors({
    origin: process.env.CORS_ORIGIN ?? 'http://localhost:5173',
    methods: ['GET', 'POST'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
}));
// Rate limiting global
app.use(rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS ?? '900000', 10), // 15 min
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS ?? '100', 10),
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: 'Too many requests, please try again later' },
}));
// ─── Parseo de body ──────────────────────────────────────────────────
app.use(express.json({ limit: '5mb' }));
app.use(express.raw({ type: 'application/octet-stream', limit: '5mb' }));
// ─── Logging ─────────────────────────────────────────────────────────
app.use(requestLogger);
// ─── Rutas ───────────────────────────────────────────────────────────
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/verify', verificationRouter);
app.use('/api/v1/sync', syncRouter);
// Health check
app.get('/health', (_req, res) => {
    res.json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
    });
});
// ─── Error handler ───────────────────────────────────────────────────
app.use(errorHandler);
// ─── Arranque ────────────────────────────────────────────────────────
app.listen(PORT, () => {
    logger.info(`DNI-Connect Backend running on port ${PORT}`);
    logger.info(`Environment: ${process.env.NODE_ENV ?? 'development'}`);
});
export default app;
//# sourceMappingURL=server.js.map