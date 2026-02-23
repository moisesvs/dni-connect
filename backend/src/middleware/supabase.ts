import {
  DatabaseOps,
  AuthOps,
  StorageOps,
  RealtimeOps,
  initializeSupabase,
  getSupabaseClient
} from '../../../.mcp/supabase-client';
import { logger } from '../utils/logger';

/**
 * Middleware de Supabase para Express
 * Inicializa el cliente y lo adjunta a la request
 */
export const supabaseMiddleware = (req: any, res: any, next: any) => {
  try {
    // Inicializar si no está ya hecho
    if (!getSupabaseClient()) {
      initializeSupabase({
        url: process.env.SUPABASE_URL || '',
        key: process.env.SUPABASE_SERVICE_ROLE_KEY || ''
      });
    }

    // Adjuntar al request
    req.supabase = {
      db: DatabaseOps,
      auth: AuthOps,
      storage: StorageOps,
      realtime: RealtimeOps,
      client: getSupabaseClient()
    };

    next();
  } catch (error) {
    logger.error('Error initializing Supabase middleware:', error);
    res.status(500).json({ error: 'Supabase initialization error' });
  }
};

/**
 * Verificar autenticación de Supabase
 */
export const requireSupabaseAuth = async (req: any, res: any, next: any) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({ error: 'No authentication token provided' });
    }

    const client = getSupabaseClient();
    const { data: { user }, error } = await client.auth.getUser(token);

    if (error || !user) {
      return res.status(401).json({ error: 'Invalid or expired token' });
    }

    req.user = user;
    req.userId = user.id;

    next();
  } catch (error) {
    logger.error('Authentication error:', error);
    res.status(500).json({ error: 'Authentication failed' });
  }
};

/**
 * Manejo de errores de Supabase
 */
export const handleSupabaseError = (error: any) => {
  if (error.message.includes('PGRST')) {
    // Error de PostgreSQL
    return {
      status: 400,
      message: 'Database error',
      error: error.message
    };
  }

  if (error.message.includes('JWT')) {
    // Error de autenticación
    return {
      status: 401,
      message: 'Authentication error',
      error: error.message
    };
  }

  if (error.message.includes('Storage')) {
    // Error de almacenamiento
    return {
      status: 400,
      message: 'Storage error',
      error: error.message
    };
  }

  return {
    status: 500,
    message: 'Unknown error',
    error: error.message
  };
};

export default {
  supabaseMiddleware,
  requireSupabaseAuth,
  handleSupabaseError
};
