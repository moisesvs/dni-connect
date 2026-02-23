import jwt from 'jsonwebtoken';
import { createApiError } from './error-handler.js';
const JWT_SECRET = process.env.JWT_SECRET ?? 'dev-secret-change-me';
/**
 * Middleware de autenticación JWT.
 * Verifica el token Bearer del header Authorization.
 */
export function requireAuth(req, _res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
        next(createApiError(401, 'Authorization token required', 'AUTH_REQUIRED'));
        return;
    }
    const token = authHeader.substring(7);
    try {
        const payload = jwt.verify(token, JWT_SECRET);
        req.userId = payload.userId;
        req.deviceId = payload.deviceId;
        next();
    }
    catch (error) {
        if (error instanceof jwt.TokenExpiredError) {
            next(createApiError(401, 'Token expired', 'TOKEN_EXPIRED'));
        }
        else {
            next(createApiError(401, 'Invalid token', 'INVALID_TOKEN'));
        }
    }
}
/**
 * Genera un JWT para un usuario autenticado.
 */
export function generateToken(userId, deviceId) {
    return jwt.sign({ userId, deviceId, iat: Math.floor(Date.now() / 1000) }, JWT_SECRET || 'your-secret-key', {
        expiresIn: process.env.JWT_EXPIRY ?? '15m',
        algorithm: 'HS256'
    });
}
//# sourceMappingURL=auth.js.map