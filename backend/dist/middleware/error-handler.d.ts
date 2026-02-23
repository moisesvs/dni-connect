import type { Request, Response, NextFunction } from 'express';
export interface ApiError extends Error {
    statusCode?: number;
    code?: string;
}
export declare function errorHandler(err: ApiError, _req: Request, res: Response, _next: NextFunction): void;
export declare function createApiError(statusCode: number, message: string, code?: string): ApiError;
//# sourceMappingURL=error-handler.d.ts.map