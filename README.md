# 🔄 Salesforce Data Master Integration

Este proyecto en Salesforce tiene como objetivo centralizar información clave proveniente de múltiples objetos relacionados en un único objeto personalizado llamado `ICS_Data_Master__c`, utilizando procesos automáticos con Apex Batch y configuraciones dinámicas en Custom Metadata Types.

## 🧩 Propósito

> Unificar datos desde más de N objetos (como IndividualApplication, Account, User, etc.) en un único dataset, evitando inconsistencias provocadas por el uso de joins en Salesforce Analytics (Recipes), como la duplicación o pérdida de registros.

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
    - Realiza un query de `ICS_QueryMaster__mdt` y recorre los registros activos.
    - Ejecuta el batch `ICS_DataMasterDelete_bch`y por parámetros del constructor se le pasa la info de la custom metadata type.
- **Delete Batch Apex**: `ICS_DataMasterDelete_bch`
    - Elimina la data del objeto `ICS_Data_Master__c` del tipo de registro configurado en `ICS_QueryMaster__mdt`.
    - En el finish ejecuta el Batch `ICS_DataMasterBuilder_bch` con los datos de la custom metadata type.
- **Batch Apex**: `ICS_DataMasterBuilder_bch`
    - Ejecuta el SOQL configurado en `ICS_QueryMaster__mdt` que ingresa desde la clase `ICS_DataMasterBuilder_sch` como parámetro en el constructor de la clase.
    - Llama a la clase `ICS_DataMasterMapper_cls` en el método execute, para mapear campos del query con los campos del objeto `ICS_Data_Master__c`.
- **Helper**: `ICS_DataMasterMapper_cls`
    - Convierte cualquier `SObject` a un registro `ICS_Data_Master__c` mapeando los campos entre el SOQL configurado en la metadata `ICS_QueryMaster__mdt` y el objeto `ICS_Data_Master__c`.

---

## ⚙️ Instalación y Despliegue

1. Clona el repositorio en tu entorno de desarrollo
2. Despliega los siguientes componentes en Salesforce:
   - `ICS_Data_Master__c`
   - `ICS_QueryMaster__mdt`
   - Clases Apex:
     - `ICS_DataMasterBuilder_sch`
     - `ICS_DataMasterDelete_bch`
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
5. Programar el schedule desde la consola:

```apex
String cronExp = '0 0 * * * ?'; // Cada hora en punto
String jobName = 'ICS_DataMasterBuilder_sch';

ICS_DataMasterBuilder_sch job = new ICS_DataMasterBuilder_sch();
System.schedule(jobName, cronExp, job);
```

🧪 Testing
Ejecuta los test con cobertura:

```bash
sf apex test run --class-names ICS_DataMasterBuilder_tst,ICS_DataMasterMapper_tst,ICS_BaseException_tst --result-format human --output-dir test-results --wait 10
```

➕ Agregar una nueva fuente de datos a ICS_DataMaster__c

🔁 Paso a paso: Agregar un nuevo query desde Metadata

Accede a Setup en Salesforce.

Ve a Custom Metadata Types y abre ICS_QueryMaster__mdt.

Crea un nuevo registro con los siguientes campos:

DeveloperName: Nombre identificador del mapeo (por ejemplo, IA_EtapasEmbudo).

ICS_IsActive__c: ✅ true

ICS_Query__c: SOQL a ejecutar. Ejemplo:

```sql
SELECT Id, Name, CreatedDate, Carrera_de_mayor_interes__r.Parent.Owner.Name, ...
FROM IndividualApplication
WHERE RecordType.DeveloperName = 'Admissions'
AND Status = 'Matriculado'
ICS_RecordTypeDeveloperName__c: Mismo valor que DeveloperName (ej: IA_EtapasEmbudo)
```
Guarda los cambios.

🧠 Paso a paso: Modificar ICS_DataMasterMapper_cls
Abre la clase ICS_DataMasterMapper_cls.

Ubica el método:

```apex
public static ICS_DataMaster__c mapDataMaster(SObject sourceRecord, String recordTypeDevName)
```
Agrega una nueva condición if o switch con tu nuevo recordTypeDevName. Ejemplo:

```apex
if (recordTypeDevName == 'IA_EtapasEmbudo') {
    return mappingIAEtapasEmbudo(sourceRecord, recordTypeDevName);
}
```
Crea un nuevo método privado para el mapeo, siguiendo la estructura del anterior:

```apex
private static ICS_DataMaster__c mappingIAEtapasEmbudo(SObject source, String recordType) {
    ICS_DataMaster__c target = new ICS_DataMaster__c();
    target.RecordTypeId = getRecordTypeId(recordType);

    target.ICS_Ejemplo_Nombre__c = (String)getNestedValue(source, 'Owner.Name');
    target.ICS_Ejemplo_Periodo__c = (String)getNestedValue(source, 'CC_Periodo_academico__r.Name');
    // Añadir todos los campos del query aquí

    return target;
}
```
Usa el método helper getNestedValue(SObject, String) que ya está definido en la clase para obtener campos anidados de forma segura.
Para las clases de prueba ICS_DataMasterMapper_tst y ICS_DataMasterBuilder_tst se deben agregar los nuevos campos en los querys. Se agrega los ejemplos.
```apex
//Clase Test ICS_DataMasterMapper_tst
static void testMappingHappyPath() {
        // Obtener los datos creados en el testSetup
        IndividualApplication testApp = [
            SELECT Id, Owner.Name, Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c, Carrera_de_mayor_interes__r.Parent.Name, 
                    Carrera_de_mayor_interes__r.Parent.NIT__c, Carrera_de_mayor_interes__r.Parent.Owner.Name, CC_Periodo_academico__r.Name, 
                    CC_Periodo_academico__r.Codigo_periodo__c, Status //<- Acá se debe agregar el nuevo campo
            FROM IndividualApplication 
            LIMIT 1];


//Clase Test ICS_DataMasterBuilder_tst
 @isTest
    static void testBatchExecution() {
        // Construimos el mismo query que usará el batch en producción
        String query = 'SELECT Owner.Name, Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c, Carrera_de_mayor_interes__r.Parent.Name, Carrera_de_mayor_interes__r.Parent.NIT__c, Carrera_de_mayor_interes__r.Parent.Owner.Name, CC_Periodo_academico__r.Name, CC_Periodo_academico__r.Codigo_periodo__c, Status /*<- Acá se debe agregar el nuevo campo.*/ FROM IndividualApplication WHERE Status = \'Matriculado\'';
```

✅ Recomendaciones
 - Siempre prueba el mapeo con @isTest al agregar una nueva ruta.
 - Usa el campo RecordTypeDeveloperName como clave para decidir el mapeo.
 - Si hay campos personalizados nuevos en ICS_DataMaster__c, recuerda agregarlos también al objeto "ICS_DataMaster__c".
 - Si agregar un campo nuevo debes tambien medificar las test class `ICS_DataMasterBuilder_tst`, `ICS_DataMasterMapper_tst` ajustando los querys para el mapeo.

📊 Uso en Salesforce Analytics

Una vez poblado el objeto ICS_Data_Master__c, crea un dataset en Data Manager usando "Dataflows" o "Recipes" directamente desde este objeto unificado, evitando joins complejos.

📅 Próximas Mejoras

- Manejo de errores y logs en Batch
- Mapeo configurable desde el metadata type 


👨‍💻 Autores
Javier Tibamoza

Proyecto desarrollado con ❤️ para mejorar la calidad de los datos en Salesforce Analytics.


