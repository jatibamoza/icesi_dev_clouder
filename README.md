# 🔄 Salesforce Data Master Integration

Este proyecto en Salesforce tiene como objetivo centralizar información clave proveniente de múltiples objetos relacionados en un único objeto personalizado llamado `ICS_Data_Master__c`, utilizando procesos automáticos con Apex Batch y configuraciones dinámicas en Custom Metadata Types.

## 🧩 Propósito

> Unificar datos desde más de 6 objetos (como Lead, Account, Contact, Opportunity, etc.) en un único dataset, evitando inconsistencias provocadas por el uso de joins en Salesforce Analytics (Recipes), como la duplicación o pérdida de registros.

---

## 📦 Componentes del Proyecto

### 1. Objeto Personalizado: `ICS_Data_Master__c`
Contiene los datos centralizados que se usarán en Analytics. Incluye:
- `Objeto_Campos -> De los campos que se importan al objeto Data Master`
- `RecordTypeId`
- Campos genéricos: `ICS_CarreraMayorInteres_Parent_Name__c`, `ICS_CarreraMayorInteres_Parent_NIT__c`, `ICS_CCPeriodoAcademico_Name__c`, etc.

### 2. Custom Metadata Type: `ICS_QueryMaster__mdt`
Define la configuración dinámica de extracción y mapeo.

| Campo | Descripción |
|-------|-------------|
| `ICS_Query__c` | Consulta SOQL para obtener los datos del objeto origen |
| `ICS_RecordTypeDeveloperName__c` | DeveloperName del tipo de registro para `ICS_Data_Master__c` |
| `ICS_IsActive__c` | Activa o Desactiva el Query. |

### 3. Lógica de Procesamiento

- **Schedulable Apex**: `ICS_DataMasterBuilder_sch`
    - Ejecuta múltiples SOQL configurados en `ICS_QueryMaster__mdt`
- **Batch Apex**: `ICS_DataMasterBuilder_bch`
    - Ejecuta el SOQL configurado en `DataMergeDefinition__mdt` que ingresa desde la clase `ICS_DataMasterBuilder_sch` como parámetro en el constructor de la clase.
    - Llama a la clase `ICS_DataMasterMapper_cls` en el método execute.
- **Helper**: `DataMasterMapper`
    - Convierte cualquier `SObject` a un registro `ICS_Data_Master__c`.

---

## ⚙️ Instalación y Despliegue

1. Clona el repositorio en tu entorno de desarrollo
2. Despliega los siguientes componentes en Salesforce:
   - `ICS_Data_Master__c`
   - `ICS_QueryMaster__mdt`
   - Clases Apex:
     - `ICS_DataMasterBuilder_sch`
     - `ICS_DataMasterBuilder_bch`
     - `ICS_DataMasterBuilder_tst`
     - `ICS_DataMasterMapper_cls`
     - `ICS_DataMasterMapper_tst`
     - `ICS_BaseException`
     - `ICS_BaseException_tst`
3. Crea entradas en `ICS_QueryMaster__mdt` con tus configuraciones personalizadas
4. Ejecuta el batch desde la consola:

```apex
List<ICS_QueryMaster__mdt> definitions = [
            SELECT DeveloperName, ICS_Query__c, ICS_RecordTypeDeveloperName__c
            FROM ICS_QueryMaster__mdt 
            WHERE ICS_IsActive__c = true  ];

ICS_DataMasterBuilder_bch batch = new ICS_DataMasterBuilder_bch(definitions[0].ICS_Query__c, definitions[0].ICS_RecordTypeDeveloperName__c);
Integer scopeSize = 200;
Database.executeBatch(batch, scopeSize);
```
5. Programa el schedule desde la consola:

```apex
String cronExp = '0 0 * * * ?'; // Cada hora en punto
String jobName = 'ICS_DataMasterBuilder_sch';

ICS_DataMasterBuilder_sch job = new ICS_DataMasterBuilder_sch();
System.schedule(jobName, cronExp, job);
```

🧪 Testing
Ejecuta los test con cobertura:

bash
sf apex test run --class-names ICS_DataMasterBuilder_tst,ICS_DataMasterMapper_tst,ICS_BaseException_tst --result-format human --output-dir test-results --wait 10

📊 Uso en Salesforce Analytics
Una vez poblado el objeto ICS_Data_Master__c, crea un dataset en Data Manager usando "Dataflows" o "Recipes" directamente desde este objeto unificado, evitando joins complejos.

📅 Próximas Mejoras
Manejo de errores y logs en Batch
Mapeo configurable desde el metadata type 


👨‍💻 Autores
Javier Tibamoza

Proyecto desarrollado con ❤️ para mejorar la calidad de los datos en Salesforce Analytics.


