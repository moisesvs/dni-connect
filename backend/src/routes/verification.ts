/**
 * Ruta de verificación de QR MiDNI
 *
 * Recibe los bytes del QR escaneado, ejecuta el flujo completo
 * de verificación ICAO 9303 Pt.13 y devuelve el resultado.
 */

import { Router } from 'express';
import { z } from 'zod';
import { IcaoVerifier } from '@dni-connect/core';
import { createApiError } from '../middleware/error-handler.js';
import { logger } from '../utils/logger.js';

export const verificationRouter = Router();

const verifyQrSchema = z.object({
  /** Datos del QR en base64 */
  qrData: z.string().min(1).max(10000),
});

/**
 * POST /api/v1/verify/qr
 *
 * Verifica un código QR MiDNI.
 *
 * Body: { qrData: string (base64) }
 * Response: QrVerificationResult
 */
verificationRouter.post('/qr', async (req, res, next) => {
  try {
    const parsed = verifyQrSchema.safeParse(req.body);
    if (!parsed.success) {
      throw createApiError(400, 'Invalid QR data format', 'INVALID_INPUT');
    }

    const { qrData } = parsed.data;

    // Decodificar base64 a bytes
    let rawBytes: Uint8Array;
    try {
      const binaryString = atob(qrData);
      rawBytes = new Uint8Array(binaryString.length);
      for (let i = 0; i < binaryString.length; i++) {
        rawBytes[i] = binaryString.charCodeAt(i);
      }
    } catch {
      throw createApiError(400, 'Invalid base64 encoding', 'INVALID_BASE64');
    }

    logger.info('Starting QR verification', {
      dataLength: rawBytes.length,
    });

    // Ejecutar verificación completa
    const verifier = new IcaoVerifier({
      onStepUpdate: (step) => {
        logger.info(`Verification step: ${step.name} → ${step.status}`, {
          message: step.message,
        });
      },
    });

    const result = await verifier.verify(rawBytes);

    if (result.valid) {
      logger.info('QR verification successful', {
        documentNumber: result.data?.documentNumber,
        remainingValidity: result.remainingValiditySeconds,
      });
    } else {
      logger.warn('QR verification failed', {
        error: result.error,
        errorCode: result.errorCode,
      });
    }

    // Responder con el resultado
    res.json({
      success: result.valid,
      data: result.valid ? result.data : undefined,
      verification: {
        steps: result.steps,
        qrGeneratedAt: result.qrGeneratedAt,
        remainingValiditySeconds: result.remainingValiditySeconds,
      },
      error: result.valid ? undefined : {
        message: result.error,
        code: result.errorCode,
      },
    });
  } catch (error) {
    next(error);
  }
});

/**
 * POST /api/v1/verify/qr/raw
 *
 * Recibe los bytes crudos del QR (application/octet-stream).
 */
verificationRouter.post('/qr/raw', async (req, res, next) => {
  try {
    if (!Buffer.isBuffer(req.body) && !(req.body instanceof Uint8Array)) {
      throw createApiError(400, 'Expected binary data', 'INVALID_CONTENT_TYPE');
    }

    const rawBytes = new Uint8Array(req.body);

    const verifier = new IcaoVerifier();
    const result = await verifier.verify(rawBytes);

    res.json({
      success: result.valid,
      data: result.valid ? result.data : undefined,
      error: result.valid ? undefined : {
        message: result.error,
        code: result.errorCode,
      },
    });
  } catch (error) {
    next(error);
  }
});

/**
 * GET /api/v1/verify/status
 *
 * Devuelve el estado del servicio de verificación.
 */
verificationRouter.get('/status', (_req, res) => {
  res.json({
    service: 'verification',
    status: 'operational',
    capabilities: {
      qr: true,
      nfc: false, // NFC solo en apps móviles
    },
    pki: {
      url: 'http://pki.policia.es/cnp/MiDNI',
      ocsp: 'http://ocsp.policia.es',
    },
  });
});
