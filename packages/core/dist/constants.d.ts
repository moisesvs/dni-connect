/**
 * Constantes globales del sistema DNI-Connect
 */
/** Tiempo máximo de validez de un QR MiDNI: 5 minutos */
export declare const QR_EXPIRY_MS: number;
/** URLs de la PKI de la Policía Nacional */
export declare const PKI_URLS: {
    /** Base URL para descarga de certificados MiDNI */
    readonly CERTIFICATE_BASE: "http://pki.policia.es/cnp/MiDNI";
    /** Endpoint OCSP para verificación de estado de certificados */
    readonly OCSP_RESPONDER: "http://ocsp.policia.es";
};
/** Constantes del estándar ICAO 9303 Parte 13 */
export declare const ICAO_CONSTANTS: {
    /** Magic bytes del Visible Digital Seal */
    readonly VDS_MAGIC: 220;
    /** Versión soportada del VDS */
    readonly VDS_VERSION: 3;
    /** Código de país emisor: España */
    readonly ISSUING_COUNTRY: "ESP";
    /** Tipo de documento: DNI */
    readonly DOCUMENT_TYPE: "NI";
    /** Tags conocidos en el mensaje VDS (TLV) */
    readonly TAGS: {
        /** Número de documento */
        readonly DOCUMENT_NUMBER: 1;
        /** Nombre completo */
        readonly FULL_NAME: 2;
        /** Fecha de nacimiento (YYYYMMDD) */
        readonly DATE_OF_BIRTH: 3;
        /** Sexo */
        readonly SEX: 4;
        /** Nacionalidad */
        readonly NATIONALITY: 5;
        /** Fecha de expedición (YYYYMMDD) */
        readonly DATE_OF_ISSUE: 6;
        /** Fecha de caducidad (YYYYMMDD) */
        readonly DATE_OF_EXPIRY: 7;
        /** Autoridad emisora */
        readonly ISSUING_AUTHORITY: 8;
        /** Timestamp de generación del QR (Unix epoch seconds) */
        readonly GENERATION_TIMESTAMP: 9;
        /** Foto facial codificada */
        readonly FACIAL_IMAGE: 10;
        /** Domicilio */
        readonly ADDRESS: 11;
        /** Lugar de nacimiento */
        readonly PLACE_OF_BIRTH: 12;
        /** Nombre de los padres */
        readonly PARENTS_NAMES: 13;
    };
    /** Algoritmos de firma soportados */
    readonly SIGNATURE_ALGORITHMS: {
        readonly ECDSA_SHA256: "SHA-256withECDSA";
        readonly ECDSA_SHA384: "SHA-384withECDSA";
        readonly ECDSA_SHA512: "SHA-512withECDSA";
    };
    /** Tamaños de firma por curva */
    readonly SIGNATURE_SIZES: {
        readonly P256: 64;
        readonly P384: 96;
        readonly P521: 132;
    };
    /** Algoritmos PACE soportados para NFC */
    readonly PACE_ALGORITHMS: {
        /** PACE-ECDH-GM-AES-CBC-CMAC-128 */
        readonly ECDH_GM_AES_128: "04007F00070202040202";
        /** PACE-DH-GM-AES-CBC-CMAC-128 */
        readonly DH_GM_AES_128: "04007F00070202040102";
        /** PACE-ECDH-GM-AES-CBC-CMAC-256 */
        readonly ECDH_GM_AES_256: "04007F00070202040204";
    };
    /** File IDs del DNIe */
    readonly FILE_IDS: {
        /** CardAccess - contiene los algoritmos PACE soportados */
        readonly CARD_ACCESS: "011C";
        /** SOD - Security Object Data */
        readonly SOD: "011D";
        /** DG1 - Datos biográficos (MRZ) */
        readonly DG1: "0101";
        /** DG2 - Foto facial */
        readonly DG2: "0102";
        /** DG11 - Datos adicionales (domicilio) */
        readonly DG11: "010B";
        /** DG13 - Datos opcionales */
        readonly DG13: "010D";
        /** DG14 - Security Infos */
        readonly DG14: "010E";
    };
};
//# sourceMappingURL=constants.d.ts.map