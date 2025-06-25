/** 
 * @author: jatibamoza
 * @email: javier.tibamoza.cubillos@gmail.com
 * @description: Batch Apex para construir Data_Master__c a partir de ICS_QueryMaster__mdt.
 * 
*/
public class ICS_DataMasterMapper_cls {
    // El método principal 'mapDataMaster' y el helper 'getNestedValue' no necesitan cambios.
    // Los incluyo aquí para tener la clase completa y lista para usar.
    public static ICS_DataMaster__c mapDataMaster(SObject sourceRecord, String recordTypeDevName) {
        if (recordTypeDevName == 'IA_EtapasEmbudo') {
            return mappingIAEtapasEmbudo(sourceRecord, recordTypeDevName);
        }
        return new ICS_DataMaster__c();
    }
    /**
     * @description Realiza el mapeo específico para el tipo de registro "IA Etapas Embudo".
     * Este mapeo está validado y refinado según el query sobre el objeto IndividualApplication.
     * Query de referencia: SELECT format(CreatedDate), Carrera_de_mayor_interes__r.Parent.Owner.Name, ... FROM IndividualApplication ...
     * @param record El SObject de origen, que es un registro de 'IndividualApplication'.
     * @param rtDevName El DeveloperName del RecordType.
     * @return El registro ICS_DataMaster__c con sus campos poblados.
    */
    private static ICS_DataMaster__c mappingIAEtapasEmbudo(SObject record, String rtDevName) {
        ICS_DataMaster__c dm = new ICS_DataMaster__c();
        dm.RecordTypeId = getRecordTypeId(rtDevName);
        // Campos de la relación 'Carrera_de_mayor_interes__r'
        dm.ICS_CarreraMayorInteres_CC_CODIGO_BANNER__c = (String)getNestedValue(record, 'Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c'); //
        dm.ICS_CarreraMayorInteres_Parent_Name__c = (String)getNestedValue(record, 'Carrera_de_mayor_interes__r.Parent.Name'); //
        dm.ICS_CarreraMayorInteres_Parent_NIT__c = (String)getNestedValue(record, 'Carrera_de_mayor_interes__r.Parent.NIT__c'); //
        dm.ICS_CarreraMayorint_Parent_Owner_Name__c = (String)getNestedValue(record, 'Carrera_de_mayor_interes__r.Parent.Owner.Name'); //
        // Campos de la relación 'CC_Periodo_academico__r'
        dm.ICS_CCPeriodoAcademico_CodigoPeriodo__c = (String)getNestedValue(record, 'CC_Periodo_academico__r.Codigo_periodo__c'); //
        dm.ICS_CCPeriodoAcademico_Name__c = (String)getNestedValue(record, 'CC_Periodo_academico__r.Name'); //
        // Campo de la relación 'Owner'
        dm.ICS_Owner_Name__c = (String)getNestedValue(record, 'Owner.Name');
        // Campos de la IA
        dm.ICS_IA_Status__c = (String)getNestedValue(record, 'Status');
        // --- Manejo especial para campos con funciones (ej. format()) ---
        // El query usa format(CreatedDate). Apex le asigna un alias, usualmente 'expr0'.
        // Se recomienda verificar el alias exacto haciendo un System.debug(record) en el batch.
        // Asumimos que el campo destino es de tipo Texto.
        // dm.ICS_Fecha_de_Creacion_Texto__c = (String)record.get('expr0');
        return dm;
    }

    @TestVisible
    private static Object getNestedValue(SObject sObj, String fieldPath) {
        if( sObj == null || String.isBlank(fieldPath) ){
            return null;
        }
        try{
            List<String> fields = fieldPath.split('\\.');
            SObject currentSObject = sObj;
            for( Integer i = 0; i < fields.size() - 1; i++ ){
                if( currentSObject == null ) return null;
                currentSObject = currentSObject.getSObject(fields[i]);
            }
            if(currentSObject == null) return null;
            return currentSObject.get(fields[fields.size() - 1]);
        }catch( Exception e ) {
            throw new ICS_BaseException('Error getting nested value for path: ' + fieldPath + '. Error: ' + e.getMessage());
        }
    }

    @TestVisible
    private static Id getRecordTypeId(String devName) {
        if( String.isBlank(devName) ) return null;
        try {
            return Schema.SObjectType.ICS_DataMaster__c.getRecordTypeInfosByDeveloperName().get(devName).getRecordTypeId();
        }catch( Exception e ) {
            System.debug(LoggingLevel.ERROR, 'Could not find RecordType with DeveloperName: ' + devName + ' on ICS_DataMaster__c');
            throw new ICS_BaseException('Could not find RecordType with DeveloperName: ' + devName + ' on ICS_DataMaster__c');
        }
    }
}