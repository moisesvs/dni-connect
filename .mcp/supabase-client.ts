/**
 * Supabase MCP Client
 * Integración con Supabase para DNI-Connect
 */

import { createClient } from '@supabase/supabase-js';
import type { SupabaseClient } from '@supabase/supabase-js';

interface SupabaseConfig {
  url: string;
  key: string;
}

let supabaseClient: SupabaseClient | null = null;

/**
 * Inicializar cliente de Supabase
 */
export function initializeSupabase(config: SupabaseConfig): SupabaseClient {
  if (!config.url || !config.key) {
    throw new Error('SUPABASE_URL y SUPABASE_KEY son requeridos');
  }

  supabaseClient = createClient(config.url, config.key, {
    auth: {
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: true
    }
  });

  return supabaseClient;
}

/**
 * Obtener cliente de Supabase
 */
export function getSupabaseClient(): SupabaseClient {
  if (!supabaseClient) {
    throw new Error('Supabase no está inicializado. Llama a initializeSupabase primero.');
  }
  return supabaseClient;
}

/**
 * Operaciones de Base de Datos
 */
export const DatabaseOps = {
  /**
   * Consultar datos
   */
  async query(table: string, options?: any) {
    const client = getSupabaseClient();
    let query = client.from(table).select('*');
    
    if (options?.filters) {
      Object.entries(options.filters).forEach(([key, value]) => {
        query = query.eq(key, value);
      });
    }
    
    if (options?.limit) {
      query = query.limit(options.limit);
    }

    const { data, error } = await query;
    if (error) throw error;
    return data;
  },

  /**
   * Insertar datos
   */
  async insert(table: string, data: any) {
    const client = getSupabaseClient();
    const { data: result, error } = await client.from(table).insert([data]).select();
    if (error) throw error;
    return result;
  },

  /**
   * Actualizar datos
   */
  async update(table: string, id: string, data: any) {
    const client = getSupabaseClient();
    const { data: result, error } = await client
      .from(table)
      .update(data)
      .eq('id', id)
      .select();
    if (error) throw error;
    return result;
  },

  /**
   * Eliminar datos
   */
  async delete(table: string, id: string) {
    const client = getSupabaseClient();
    const { error } = await client.from(table).delete().eq('id', id);
    if (error) throw error;
    return { success: true };
  }
};

/**
 * Operaciones de Autenticación
 */
export const AuthOps = {
  /**
   * Registrar nuevo usuario
   */
  async signUp(email: string, password: string, metadata?: any) {
    const client = getSupabaseClient();
    const { data, error } = await client.auth.signUp({
      email,
      password,
      options: { data: metadata }
    });
    if (error) throw error;
    return data;
  },

  /**
   * Iniciar sesión
   */
  async signIn(email: string, password: string) {
    const client = getSupabaseClient();
    const { data, error } = await client.auth.signInWithPassword({
      email,
      password
    });
    if (error) throw error;
    return data;
  },

  /**
   * Cerrar sesión
   */
  async signOut() {
    const client = getSupabaseClient();
    const { error } = await client.auth.signOut();
    if (error) throw error;
    return { success: true };
  },

  /**
   * Obtener usuario actual
   */
  async getUser() {
    const client = getSupabaseClient();
    const { data: { user }, error } = await client.auth.getUser();
    if (error) throw error;
    return user;
  },

  /**
   * Resetear contraseña
   */
  async resetPassword(email: string) {
    const client = getSupabaseClient();
    const { data, error } = await client.auth.resetPasswordForEmail(email, {
      redirectTo: `${process.env.SUPABASE_REDIRECT_URL || 'http://localhost:3000'}/reset-password`
    });
    if (error) throw error;
    return data;
  }
};

/**
 * Operaciones de Storage
 */
export const StorageOps = {
  /**
   * Subir archivo
   */
  async upload(bucket: string, path: string, file: File | Buffer) {
    const client = getSupabaseClient();
    const { data, error } = await client.storage
      .from(bucket)
      .upload(path, file);
    if (error) throw error;
    return data;
  },

  /**
   * Descargar archivo
   */
  async download(bucket: string, path: string) {
    const client = getSupabaseClient();
    const { data, error } = await client.storage
      .from(bucket)
      .download(path);
    if (error) throw error;
    return data;
  },

  /**
   * Listar archivos
   */
  async list(bucket: string, path?: string) {
    const client = getSupabaseClient();
    const { data, error } = await client.storage
      .from(bucket)
      .list(path);
    if (error) throw error;
    return data;
  },

  /**
   * Eliminar archivo
   */
  async delete(bucket: string, path: string) {
    const client = getSupabaseClient();
    const { data, error } = await client.storage
      .from(bucket)
      .remove([path]);
    if (error) throw error;
    return data;
  }
};

/**
 * Suscripciones en Tiempo Real
 */
export const RealtimeOps = {
  /**
   * Suscribirse a cambios en tabla
   */
  subscribe(table: string, callback: (payload: any) => void) {
    const client = getSupabaseClient();
    return client
      .channel(`public:${table}`)
      .on(
        'postgres_changes',
        { event: '*', schema: 'public', table },
        callback
      )
      .subscribe();
  },

  /**
   * Desuscribirse
   */
  unsubscribe(subscription: any) {
    return subscription.unsubscribe();
  }
};

export default {
  initializeSupabase,
  getSupabaseClient,
  DatabaseOps,
  AuthOps,
  StorageOps,
  RealtimeOps
};
