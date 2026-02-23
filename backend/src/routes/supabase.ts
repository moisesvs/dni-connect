import express, { Router } from 'express';
import { requireSupabaseAuth } from '../middleware/supabase';
import { logger } from '../utils/logger';
import type { Request, Response } from 'express';

interface SupabaseRequest extends Request {
  supabase?: any;
  user?: any;
  userId?: string;
}

const router = Router();

/**
 * GET /api/supabase/health
 * Verificar conexión con Supabase
 */
router.get('/health', async (req: SupabaseRequest, res: Response) => {
  try {
    const client = req.supabase?.client;
    if (!client) {
      return res.status(500).json({
        status: 'error',
        message: 'Supabase client not initialized'
      });
    }

    // Intentar consulta simple
    const { data, error } = await client.from('users').select('count', { count: 'exact' }).limit(0);

    if (error) {
      return res.status(500).json({
        status: 'error',
        message: 'Database connection failed',
        error: error.message
      });
    }

    res.json({
      status: 'ok',
      message: 'Supabase connection healthy',
      timestamp: new Date().toISOString()
    });
  } catch (error: any) {
    logger.error('Health check error:', error);
    res.status(500).json({
      status: 'error',
      message: error.message
    });
  }
});

/**
 * POST /api/supabase/auth/signup
 * Registrar nuevo usuario
 */
router.post('/auth/signup', async (req: SupabaseRequest, res: Response) => {
  try {
    const { email, password, metadata } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        error: 'Email and password are required'
      });
    }

    const user = await req.supabase.auth.signUp(email, password, metadata);

    res.status(201).json({
      success: true,
      user,
      message: 'User registered successfully'
    });
  } catch (error: any) {
    logger.error('Signup error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * POST /api/supabase/auth/signin
 * Iniciar sesión
 */
router.post('/auth/signin', async (req: SupabaseRequest, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        error: 'Email and password are required'
      });
    }

    const session = await req.supabase.auth.signIn(email, password);

    res.json({
      success: true,
      session,
      message: 'Signed in successfully'
    });
  } catch (error: any) {
    logger.error('Signin error:', error);
    res.status(401).json({
      error: error.message
    });
  }
});

/**
 * POST /api/supabase/auth/signout
 * Cerrar sesión
 */
router.post('/auth/signout', requireSupabaseAuth, async (req: SupabaseRequest, res: Response) => {
  try {
    await req.supabase.auth.signOut();

    res.json({
      success: true,
      message: 'Signed out successfully'
    });
  } catch (error: any) {
    logger.error('Signout error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * GET /api/supabase/auth/me
 * Obtener usuario actual
 */
router.get('/auth/me', requireSupabaseAuth, async (req: SupabaseRequest, res: Response) => {
  try {
    const user = await req.supabase.auth.getUser();

    res.json({
      success: true,
      user
    });
  } catch (error: any) {
    logger.error('Get user error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * POST /api/supabase/auth/reset-password
 * Solicitar reset de contraseña
 */
router.post('/auth/reset-password', async (req: SupabaseRequest, res: Response) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        error: 'Email is required'
      });
    }

    await req.supabase.auth.resetPassword(email);

    res.json({
      success: true,
      message: 'Password reset email sent'
    });
  } catch (error: any) {
    logger.error('Reset password error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * GET /api/supabase/data/:table
 * Consultar tabla
 */
router.get('/data/:table', requireSupabaseAuth, async (req: SupabaseRequest, res: Response) => {
  try {
    const { table } = req.params;
    const { limit = 10, offset = 0, ...filters } = req.query;

    const data = await req.supabase.db.query(table, {
      filters,
      limit: parseInt(limit as string),
      offset: parseInt(offset as string)
    });

    res.json({
      success: true,
      data,
      count: data?.length || 0
    });
  } catch (error: any) {
    logger.error('Query error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * POST /api/supabase/data/:table
 * Insertar registro
 */
router.post('/data/:table', requireSupabaseAuth, async (req: SupabaseRequest, res: Response) => {
  try {
    const { table } = req.params;
    const data = req.body;

    const result = await req.supabase.db.insert(table, data);

    res.status(201).json({
      success: true,
      data: result
    });
  } catch (error: any) {
    logger.error('Insert error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * PATCH /api/supabase/data/:table/:id
 * Actualizar registro
 */
router.patch('/data/:table/:id', requireSupabaseAuth, async (req: SupabaseRequest, res: Response) => {
  try {
    const { table, id } = req.params;
    const data = req.body;

    const result = await req.supabase.db.update(table, id, data);

    res.json({
      success: true,
      data: result
    });
  } catch (error: any) {
    logger.error('Update error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

/**
 * DELETE /api/supabase/data/:table/:id
 * Eliminar registro
 */
router.delete('/data/:table/:id', requireSupabaseAuth, async (req: SupabaseRequest, res: Response) => {
  try {
    const { table, id } = req.params;

    await req.supabase.db.delete(table, id);

    res.json({
      success: true,
      message: `Record deleted from ${table}`
    });
  } catch (error: any) {
    logger.error('Delete error:', error);
    res.status(400).json({
      error: error.message
    });
  }
});

export default router;
