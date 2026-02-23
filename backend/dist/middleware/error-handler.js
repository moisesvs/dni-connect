import { logger } from '../utils/logger.js';
export function errorHandler(err, _req, res, _next) {
    const statusCode = err.statusCode ?? 500;
    const message = statusCode === 500
        ? 'Internal server error'
        : err.message;
    logger.error(`Error ${statusCode}: ${err.message}`, {
        stack: err.stack,
        code: err.code,
    });
    res.status(statusCode).json({
        error: {
            message,
            code: err.code ?? 'INTERNAL_ERROR',
            ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
        },
    });
}
export function createApiError(statusCode, message, code) {
    const error = new Error(message);
    error.statusCode = statusCode;
    error.code = code;
    return error;
}
//# sourceMappingURL=error-handler.js.map