import type { Request, Response, NextFunction } from 'express';
export interface AuthenticatedRequest extends Request {
    userId?: string;
    deviceId?: string;
}
/**
 * Middleware de autenticación JWT.
 * Verifica el token Bearer del header Authorization.
 */
export declare function requireAuth(req: AuthenticatedRequest, _res: Response, next: NextFunction): void;
/**
 * Genera un JWT para un usuario autenticado.
 */
export declare function generateToken(userId: string, deviceId: string): string;
//# sourceMappingURL=auth.d.ts.map