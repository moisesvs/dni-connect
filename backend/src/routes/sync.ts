/**
 * Ruta de sincronización con Google Cloud
 *
 * Almacena los datos verificados en Firestore y/o GCS
 * de forma segura y cifrada.
 */

import { Router } from 'express';
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';
import { requireAuth, type AuthenticatedRequest } from '../middleware/auth.js';
import { createApiError } from '../middleware/error-handler.js';
import { logger } from '../utils/logger.js';
import type { SyncPayload } from '@dni-connect/core';

export const syncRouter = Router();

// Todas las rutas de sync requieren autenticación
syncRouter.use(requireAuth);

const syncSchema = z.object({
  verificationType: z.enum(['qr', 'nfc']),
  dniData: z.object({
    documentNumber: z.string(),
    fullName: z.string(),
    dateOfBirth: z.string(),
    sex: z.enum(['M', 'F']),
    nationality: z.string(),
    dateOfIssue: z.string(),
    dateOfExpiry: z.string(),
    issuingAuthority: z.string(),
    address: z.string().optional(),
    facialImageBase64: z.string().optional(),
    placeOfBirth: z.string().optional(),
    parentsNames: z.string().optional(),
  }),
  verificationValid: z.boolean(),
});

/**
 * POST /api/v1/sync
 *
 * Sincroniza datos verificados del DNI a Google Cloud.
 *
 * Los datos se almacenan cifrados en Firestore y los documentos
 * asociados (foto) se almacenan en GCS.
 */
syncRouter.post('/', async (req: AuthenticatedRequest, res, next) => {
  try {
    const parsed = syncSchema.safeParse(req.body);
    if (!parsed.success) {
      throw createApiError(400, 'Invalid sync payload', 'VALIDATION_ERROR');
    }

    const verificationId = uuidv4();
    const payload: SyncPayload = {
      verificationId,
      verificationType: parsed.data.verificationType,
      verifiedAt: Date.now(),
      dniData: parsed.data.dniData,
      integrityHash: await computeIntegrityHash(parsed.data.dniData),
      deviceId: req.deviceId ?? 'unknown',
      verificationValid: parsed.data.verificationValid,
    };

    // Almacenar en Firestore
    await storeInFirestore(payload);

    // Si hay foto, almacenar en GCS
    if (parsed.data.dniData.facialImageBase64) {
      await storeImageInGCS(
        verificationId,
        parsed.data.dniData.facialImageBase64,
      );
    }

    logger.info('Data synced successfully', {
      verificationId,
      type: payload.verificationType,
      deviceId: payload.deviceId,
    });

    res.json({
      success: true,
      verificationId,
      syncedAt: payload.verifiedAt,
    });
  } catch (error) {
    next(error);
  }
});

/**
 * GET /api/v1/sync/history
 *
 * Obtiene el historial de verificaciones sincronizadas.
 */
syncRouter.get('/history', async (req: AuthenticatedRequest, res, next) => {
  try {
    const userId = req.userId;
    // En producción: consultar Firestore filtrando por userId
    // Por ahora devolvemos un array vacío
    logger.info('History requested', { userId });

    res.json({
      verifications: [],
      total: 0,
    });
  } catch (error) {
    next(error);
  }
});

// ─── Helpers ────────────────────────────────────────────────────────

/**
 * Almacena un payload de verificación en Firestore.
 * En producción: usar @google-cloud/firestore con cifrado.
 */
async function storeInFirestore(payload: SyncPayload): Promise<void> {
  // En producción:
  // const firestore = new Firestore();
  // const collection = process.env.FIRESTORE_COLLECTION ?? 'verifications';
  // await firestore.collection(collection).doc(payload.verificationId).set({
  //   ...payload,
  //   dniData: encrypt(JSON.stringify(payload.dniData)), // AES-256-GCM
  //   createdAt: FieldValue.serverTimestamp(),
  // });

  logger.info('Firestore storage (mock)', {
    verificationId: payload.verificationId,
  });
}

/**
 * Almacena una imagen facial en Google Cloud Storage.
 */
async function storeImageInGCS(
  verificationId: string,
  base64Image: string,
): Promise<void> {
  // En producción:
  // const storage = new Storage();
  // const bucket = storage.bucket(process.env.GCS_BUCKET ?? 'dni-connect-documents');
  // const file = bucket.file(`facial/${verificationId}.jpg`);
  // const imageBuffer = Buffer.from(base64Image, 'base64');
  // await file.save(imageBuffer, {
  //   contentType: 'image/jpeg',
  //   metadata: {
  //     cacheControl: 'no-cache',
  //     metadata: { verificationId, encrypted: 'true' },
  //   },
  // });

  logger.info('GCS image storage (mock)', { verificationId });
}

/**
 * Calcula un hash de integridad de los datos del DNI.
 */
async function computeIntegrityHash(data: Record<string, unknown>): Promise<string> {
  const json = JSON.stringify(data, Object.keys(data).sort());
  const encoder = new TextEncoder();
  const hashBuffer = await crypto.subtle.digest('SHA-256', encoder.encode(json));
  return Array.from(new Uint8Array(hashBuffer))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('');
}
