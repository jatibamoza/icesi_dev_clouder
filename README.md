# 🔄 Salesforce Data Master Integration

Este proyecto en Salesforce tiene como objetivo centralizar información clave proveniente de múltiples objetos relacionados en un único objeto personalizado llamado `Data_Master__c`, utilizando procesos automáticos con Apex Batch y configuraciones dinámicas en Custom Metadata Types.

## 🧩 Propósito

> Unificar datos desde más de 6 objetos (como Lead, Account, Contact, Opportunity, etc.) en un único dataset, evitando inconsistencias provocadas por el uso de joins en Salesforce Analytics (Recipes), como la duplicación o pérdida de registros.

---

## 📦 Componentes del Proyecto

### 1. Objeto Personalizado: `Data_Master__c`
Contiene los datos centralizados que se usarán en Analytics. Incluye:
- `MasterKey__c`
- `RecordTypeId`
- Campos genéricos: `Nombre__c`, `Estado__c`, `Fecha__c`, etc.

### 2. Custom Metadata Type: `DataMergeDefinition__mdt`
Define la configuración dinámica de extracción y mapeo.

| Campo | Descripción |
|-------|-------------|
| `SOQL__c` | Consulta SOQL para obtener los datos del objeto origen |
| `MasterKeyField__c` | Campo clave a usar como identificador común |
| `RecordType__c` | DeveloperName del tipo de registro para `Data_Master__c` |
| `FieldMappings__c` | Mapeo de campos en formato `Destino=Origen;...` |

### 3. Lógica de Procesamiento

- **Batch Apex**: `Batch_DataMasterBuilder`
    - Ejecuta múltiples SOQL configurados en `DataMergeDefinition__mdt`
    - Mapea y consolida los datos en `Data_Master__c`
- **Helper**: `DataMasterMapper`
    - Convierte dinámicamente cualquier `SObject` a un registro `Data_Master__c` usando los mapeos configurados

---

## ⚙️ Instalación y Despliegue

1. Clona el repositorio en tu entorno de desarrollo
2. Despliega los siguientes componentes en Salesforce:
   - `Data_Master__c`
   - `DataMergeDefinition__mdt`
   - Clases Apex:
     - `Batch_DataMasterBuilder`
     - `DataMasterMapper`
     - `DataMasterMapperTest`
3. Crea entradas en `DataMergeDefinition__mdt` con tus configuraciones personalizadas
4. Ejecuta el batch desde la consola:

```apex
Database.executeBatch(new Batch_DataMasterBuilder(), 1);

🧪 Testing
Ejecuta los test con cobertura:

bash
Copiar
Editar
sfdx force:apex:test:run --classnames DataMasterMapperTest --resultformat human --outputdir test-results
📊 Uso en Salesforce Analytics
Una vez poblado el objeto Data_Master__c, crea un dataset en Data Manager usando "Dataflows" o "Recipes" directamente desde este objeto unificado, evitando joins complejos.

📅 Próximas Mejoras
Manejo de errores y logs en Batch

Soporte para condiciones WHERE dinámicas desde Metadata

Desduplicación inteligente por MasterKey__c

Interfaz de configuración vía Lightning Web Component (LWC)

👨‍💻 Autores
Javier Tibamoza

Proyecto desarrollado con ❤️ para mejorar la calidad de los datos en Salesforce Analytics.


