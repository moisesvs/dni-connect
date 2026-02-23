/**
 * Ruta de autenticación
 *
 * Genera tokens JWT para acceso a la API.
 * En producción, integrar con Firebase Auth o proveedor SSO.
 */
import { Router } from 'express';
import { z } from 'zod';
import { generateToken } from '../middleware/auth.js';
import { createApiError } from '../middleware/error-handler.js';
export const authRouter = Router();
const loginSchema = z.object({
    deviceId: z.string().min(1).max(256),
    // En producción: añadir email, password, o token de Firebase
});
/**
 * POST /api/v1/auth/token
 *
 * Genera un token de acceso para el dispositivo.
 */
authRouter.post('/token', (req, res, next) => {
    try {
        const parsed = loginSchema.safeParse(req.body);
        if (!parsed.success) {
            throw createApiError(400, 'Invalid request body', 'VALIDATION_ERROR');
        }
        const { deviceId } = parsed.data;
        // En producción: validar credenciales contra Firebase Auth
        // Por ahora, generar token directamente
        const userId = `user_${Date.now()}`; // Placeholder
        const token = generateToken(userId, deviceId);
        res.json({
            token,
            expiresIn: process.env.JWT_EXPIRY ?? '15m',
            userId,
        });
    }
    catch (error) {
        next(error);
    }
});
//# sourceMappingURL=auth.js.map