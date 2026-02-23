import { logger } from '../utils/logger.js';
export function requestLogger(req, _res, next) {
    logger.info(`${req.method} ${req.path}`, {
        ip: req.ip,
        userAgent: req.get('user-agent'),
    });
    next();
}
//# sourceMappingURL=request-logger.js.map