/**
 * Constantes globales del sistema DNI-Connect
 */
/** Tiempo máximo de validez de un QR MiDNI: 5 minutos */
export const QR_EXPIRY_MS = 5 * 60 * 1000;
/** URLs de la PKI de la Policía Nacional */
export const PKI_URLS = {
    /** Base URL para descarga de certificados MiDNI */
    CERTIFICATE_BASE: 'http://pki.policia.es/cnp/MiDNI',
    /** Endpoint OCSP para verificación de estado de certificados */
    OCSP_RESPONDER: 'http://ocsp.policia.es',
};
/** Constantes del estándar ICAO 9303 Parte 13 */
export const ICAO_CONSTANTS = {
    /** Magic bytes del Visible Digital Seal */
    VDS_MAGIC: 0xDC,
    /** Versión soportada del VDS */
    VDS_VERSION: 0x03,
    /** Código de país emisor: España */
    ISSUING_COUNTRY: 'ESP',
    /** Tipo de documento: DNI */
    DOCUMENT_TYPE: 'NI',
    /** Tags conocidos en el mensaje VDS (TLV) */
    TAGS: {
        /** Número de documento */
        DOCUMENT_NUMBER: 0x01,
        /** Nombre completo */
        FULL_NAME: 0x02,
        /** Fecha de nacimiento (YYYYMMDD) */
        DATE_OF_BIRTH: 0x03,
        /** Sexo */
        SEX: 0x04,
        /** Nacionalidad */
        NATIONALITY: 0x05,
        /** Fecha de expedición (YYYYMMDD) */
        DATE_OF_ISSUE: 0x06,
        /** Fecha de caducidad (YYYYMMDD) */
        DATE_OF_EXPIRY: 0x07,
        /** Autoridad emisora */
        ISSUING_AUTHORITY: 0x08,
        /** Timestamp de generación del QR (Unix epoch seconds) */
        GENERATION_TIMESTAMP: 0x09,
        /** Foto facial codificada */
        FACIAL_IMAGE: 0x0A,
        /** Domicilio */
        ADDRESS: 0x0B,
        /** Lugar de nacimiento */
        PLACE_OF_BIRTH: 0x0C,
        /** Nombre de los padres */
        PARENTS_NAMES: 0x0D,
    },
    /** Algoritmos de firma soportados */
    SIGNATURE_ALGORITHMS: {
        ECDSA_SHA256: 'SHA-256withECDSA',
        ECDSA_SHA384: 'SHA-384withECDSA',
        ECDSA_SHA512: 'SHA-512withECDSA',
    },
    /** Tamaños de firma por curva */
    SIGNATURE_SIZES: {
        P256: 64,
        P384: 96,
        P521: 132,
    },
    /** Algoritmos PACE soportados para NFC */
    PACE_ALGORITHMS: {
        /** PACE-ECDH-GM-AES-CBC-CMAC-128 */
        ECDH_GM_AES_128: '04007F00070202040202',
        /** PACE-DH-GM-AES-CBC-CMAC-128 */
        DH_GM_AES_128: '04007F00070202040102',
        /** PACE-ECDH-GM-AES-CBC-CMAC-256 */
        ECDH_GM_AES_256: '04007F00070202040204',
    },
    /** File IDs del DNIe */
    FILE_IDS: {
        /** CardAccess - contiene los algoritmos PACE soportados */
        CARD_ACCESS: '011C',
        /** SOD - Security Object Data */
        SOD: '011D',
        /** DG1 - Datos biográficos (MRZ) */
        DG1: '0101',
        /** DG2 - Foto facial */
        DG2: '0102',
        /** DG11 - Datos adicionales (domicilio) */
        DG11: '010B',
        /** DG13 - Datos opcionales */
        DG13: '010D',
        /** DG14 - Security Infos */
        DG14: '010E',
    },
};
//# sourceMappingURL=constants.js.map