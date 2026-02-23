import type { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger.js';

export interface ApiError extends Error {
  statusCode?: number;
  code?: string;
}

export function errorHandler(
  err: ApiError,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void {
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

export function createApiError(
  statusCode: number,
  message: string,
  code?: string,
): ApiError {
  const error = new Error(message) as ApiError;
  error.statusCode = statusCode;
  error.code = code;
  return error;
}
