#!/usr/bin/env python3
"""
Generador de datos de ejemplo MiDNI para el notebook de expertise.
Contiene datos sintéticos válidos para testing y aprendizaje.
"""

import json
from datetime import datetime, timedelta
from typing import Dict, List
import random

class MiDNISampleDataGenerator:
    """Generador de datos de ejemplo MiDNI para uso educativo."""
    
    # Letras válidas para DNI según MOD-23
    DNI_LETTERS = "TRWAGMYFPDXBNJZSQVHLCKE"
    
    # Nombres españoles comunes
    SPANISH_NAMES = [
        "Juan", "María", "José", "Antonio", "Isabel", 
        "Francisco", "Carmen", "Manuel", "Rosa", "Carlos",
        "Elena", "Luis", "Pilar", "Jorge", "Beatriz"
    ]
    
    # Apellidos españoles comunes
    SPANISH_SURNAMES = [
        "García", "Martínez", "López", "González", "Rodríguez",
        "Sánchez", "Pérez", "Díaz", "Fernández", "Alcalde",
        "Cruz", "Bernal", "Castro", "Durán", "Espinosa"
    ]
    
    def __init__(self):
        self.samples: List[Dict] = []
    
    def generate_dni_number(self) -> str:
        """Generar número de DNI válido con letra de control."""
        number = random.randint(10000000, 99999999)
        letter_index = number % 23
        letter = self.DNI_LETTERS[letter_index]
        return f"{number:08d}{letter}"
    
    def generate_sample_midni(self, 
                               dni_number: str = None,
                               first_name: str = None,
                               surname: str = None,
                               birth_date: str = None,
                               is_valid: bool = True) -> Dict:
        """Generar un sample de MiDNI válido o inválido."""
        
        # Generar datos aleatorios si no se proporcionan
        if not dni_number:
            dni_number = self.generate_dni_number()
        if not first_name:
            first_name = random.choice(self.SPANISH_NAMES)
        if not surname:
            surname = " ".join(random.sample(self.SPANISH_SURNAMES, 
                                           random.randint(1, 2)))
        if not birth_date:
            # Edad entre 18 y 80 años
            days_ago = random.randint(18*365, 80*365)
            birth_dt = datetime.now() - timedelta(days=days_ago)
            birth_date = birth_dt.strftime("%d%m%y")
        
        # Fecha de emisión (entre 10 años atrás y ahora)
        days_ago_issue = random.randint(0, 10*365)
        issue_date_dt = datetime.now() - timedelta(days=days_ago_issue)
        issue_date = issue_date_dt.strftime("%d%m%y")
        
        # Fecha de expiración (10 años después de emisión)
        expiry_date_dt = issue_date_dt + timedelta(days=10*365)
        expiry_date = expiry_date_dt.strftime("%d%m%y")
        
        gender = random.choice(["M", "F"])
        
        midni = {
            "dni_number": dni_number,
            "given_names": first_name,
            "surname": surname,
            "date_of_birth": birth_date,
            "date_of_issue": issue_date,
            "date_of_expiry": expiry_date,
            "gender": gender,
            "nationality": "ES",
            "document_type": "DNI",
            "mrz_line1": None,  # Se puede llenar después
            "mrz_line2": None,  # Se puede llenar después
            "validity": "VALID" if is_valid else "INVALID",
            "notes": ""
        }
        
        if not is_valid:
            # Introduce defectos aleatorios
            defect = random.choice([
                "expired",
                "malformed_dni",
                "invalid_date",
                "future_birth_date",
                "name_contains_numbers"
            ])
            
            if defect == "expired":
                expiry_date_dt = datetime.now() - timedelta(days=random.randint(1, 365))
                midni["date_of_expiry"] = expiry_date_dt.strftime("%d%m%y")
                midni["notes"] = "Documento expirado"
            
            elif defect == "malformed_dni":
                midni["dni_number"] = "INVALID123XYZ"
                midni["notes"] = "Formato de DNI inválido"
            
            elif defect == "invalid_date":
                midni["date_of_birth"] = "32131999"  # Día 32
                midni["notes"] = "Fecha de nacimiento inválida"
            
            elif defect == "future_birth_date":
                future_dt = datetime.now() + timedelta(days=365)
                midni["date_of_birth"] = future_dt.strftime("%d%m%y")
                midni["notes"] = "Fecha de nacimiento en el futuro"
            
            elif defect == "name_contains_numbers":
                midni["given_names"] = first_name + "123"
                midni["notes"] = "Nombre contiene números"
        
        return midni
    
    def generate_batch(self, 
                      count: int = 10,
                      validity_ratio: float = 0.8) -> List[Dict]:
        """Generar lote de samples MiDNI."""
        batch = []
        
        valid_count = int(count * validity_ratio)
        invalid_count = count - valid_count
        
        for _ in range(valid_count):
            batch.append(self.generate_sample_midni(is_valid=True))
        
        for _ in range(invalid_count):
            batch.append(self.generate_sample_midni(is_valid=False))
        
        random.shuffle(batch)
        return batch
    
    def generate_predefined_samples(self) -> List[Dict]:
        """Generar conjunto predefinido de samples para testing."""
        samples = [
            # 1. Sample válido típico
            {
                "dni_number": "12345678Z",
                "given_names": "Juan Carlos",
                "surname": "García Pérez",
                "date_of_birth": "15041985",
                "date_of_issue": "15042015",
                "date_of_expiry": "15042025",
                "gender": "M",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "VALID",
                "notes": "Documento vigente típico"
            },
            
            # 2. Sample: Documento próximo a expiración
            {
                "dni_number": "87654321A",
                "given_names": "María Elena",
                "surname": "López Sánchez",
                "date_of_birth": "22121960",
                "date_of_issue": "22121995",
                "date_of_expiry": "22121999",  # Próximo a expirar (por ejemplo, 3 meses)
                "gender": "F",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "VALID",
                "notes": "Documento próximo a expiración"
            },
            
            # 3. Sample: Documento expirado
            {
                "dni_number": "11223344B",
                "given_names": "Antonio",
                "surname": "Fernández Díaz",
                "date_of_birth": "03071955",
                "date_of_issue": "03072005",
                "date_of_expiry": "03072015",  # Expirado hace años
                "gender": "M",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "INVALID",
                "notes": "Documento expirado"
            },
            
            # 4. Sample: Formato DNI inválido
            {
                "dni_number": "INVALID123",
                "given_names": "Carlos",
                "surname": "Martínez González",
                "date_of_birth": "18051970",
                "date_of_issue": "18052010",
                "date_of_expiry": "18052020",
                "gender": "M",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "INVALID",
                "notes": "Formato de DNI incorrecto"
            },
            
            # 5. Sample: Fecha de nacimiento inválida
            {
                "dni_number": "55667788C",
                "given_names": "Rosa",
                "surname": "Alcalde Cruz",
                "date_of_birth": "32131975",  # Día 32 (no existe)
                "date_of_issue": "01011995",
                "date_of_expiry": "01012005",
                "gender": "F",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "INVALID",
                "notes": "Fecha de nacimiento inválida"
            },
            
            # 6. Sample: Edad inconsistente
            {
                "dni_number": "99887766D",
                "given_names": "Laura",
                "surname": "Bernal Castro",
                "date_of_birth": "15091999",  # Nació hace poco
                "date_of_issue": "15091999",  # Emitido el mismo día
                "date_of_expiry": "15092009",
                "gender": "F",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "VALID",
                "notes": "Edad muy joven - valida pero inusual"
            },
            
            # 7. Sample: Campo de nombre con números
            {
                "dni_number": "44332211E",
                "given_names": "Juan123",
                "surname": "Pérez López",
                "date_of_birth": "28021968",
                "date_of_issue": "28022008",
                "date_of_expiry": "28022018",
                "gender": "M",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "INVALID",
                "notes": "Nombre contiene números"
            },
            
            # 8. Sample: Documento muy reciente
            {
                "dni_number": "77665544F",
                "given_names": "Miguel",
                "surname": "Espinosa Durán",
                "date_of_birth": "05031992",
                "date_of_issue": "23022026",  # Emitido hace poco (2026)
                "date_of_expiry": "23022036",
                "gender": "M",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "VALID",
                "notes": "Documento reciente"
            },
            
            # 9. Sample: Largo máximo de nombre
            {
                "dni_number": "33221155G",
                "given_names": "Maria del Carmen Francisca Josefa",
                "surname": "García López de la Vega Domínguez",
                "date_of_birth": "12061948",
                "date_of_issue": "12061988",
                "date_of_expiry": "12061998",
                "gender": "F",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "VALID",
                "notes": "Nombres y apellidos muy largos"
            },
            
            # 10. Sample: Documento de menor edad
            {
                "dni_number": "66554433H",
                "given_names": "Diego",
                "surname": "Sánchez Martín",
                "date_of_birth": "14082010",  # Menor de edad
                "date_of_issue": "14082015",
                "date_of_expiry": "14082025",
                "gender": "M",
                "nationality": "ES",
                "document_type": "DNI",
                "validity": "VALID",
                "notes": "Sujeto menor de 18 años"
            }
        ]
        
        return samples


# Función helper para cargar datos en el notebook
def load_midni_samples(sample_type: str = "predefined", 
                       count: int = 10) -> Dict[str, List[Dict]]:
    """
    Cargar datos de ejemplo MiDNI.
    
    Args:
        sample_type: "predefined" (10 samples predefinidos) 
                    o "random" (generar aleatorio)
        count: Número de samples a generar (solo para "random")
    
    Returns:
        Dict con claves:
        - "valid_samples": Samples válidos
        - "invalid_samples": Samples inválidos
        - "all_samples": Todos los samples
    """
    
    generator = MiDNISampleDataGenerator()
    
    if sample_type == "predefined":
        all_samples = generator.generate_predefined_samples()
    else:
        all_samples = generator.generate_batch(count=count)
    
    valid_samples = [s for s in all_samples if s["validity"] == "VALID"]
    invalid_samples = [s for s in all_samples if s["validity"] == "INVALID"]
    
    return {
        "valid_samples": valid_samples,
        "invalid_samples": invalid_samples,
        "all_samples": all_samples,
        "summary": {
            "total": len(all_samples),
            "valid": len(valid_samples),
            "invalid": len(invalid_samples),
            "validity_ratio": len(valid_samples) / len(all_samples) * 100
        }
    }


# Función para exportar a JSON
def export_midni_samples(samples: List[Dict], 
                        filepath: str = "midni_samples.json"):
    """Exportar samples a archivo JSON."""
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(samples, f, indent=2, ensure_ascii=False)
    print(f"✅ Samples exportados a {filepath}")


# Función para importar desde JSON
def import_midni_samples(filepath: str = "midni_samples.json") -> List[Dict]:
    """Importar samples desde archivo JSON."""
    with open(filepath, 'r', encoding='utf-8') as f:
        samples = json.load(f)
    print(f"✅ {len(samples)} samples importados desde {filepath}")
    return samples


# Script de demostración
if __name__ == "__main__":
    print("🔐 MiDNI Sample Data Generator\n")
    
    # Generar samples predefinidos
    data = load_midni_samples(sample_type="predefined")
    
    print(f"📊 Resumen:")
    print(f"  Total: {data['summary']['total']}")
    print(f"  Válidos: {data['summary']['valid']}")
    print(f"  Inválidos: {data['summary']['invalid']}")
    print(f"  Ratio: {data['summary']['validity_ratio']:.1f}%\n")
    
    # Mostrar primer sample
    print("📋 Primer sample válido:")
    first_valid = data['valid_samples'][0]
    for key, value in first_valid.items():
        print(f"  {key}: {value}")
    
    print("\n📋 Primer sample inválido:")
    first_invalid = data['invalid_samples'][0]
    for key, value in first_invalid.items():
        print(f"  {key}: {value}")
    
    # Exportar a JSON
    export_midni_samples(data['all_samples'], 
                        "midni_samples_predefined.json")
    
    # Generar batch aleatorio
    print("\n🎲 Generando 20 samples aleatorios (80% válidos)...")
    random_data = load_midni_samples(sample_type="random", count=20)
    export_midni_samples(random_data['all_samples'], 
                        "midni_samples_random.json")
    
    print("✅ Completado!")
