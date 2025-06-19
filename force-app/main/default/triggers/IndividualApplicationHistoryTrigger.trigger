trigger IndividualApplicationHistoryTrigger on IndividualApplication (after update) {
    
    // Lista para almacenar los registros históricos que se van a insertar
    List<Individual_Applications_History__c> historyRecords = new List<Individual_Applications_History__c>();
    
    // Conjunto para almacenar los nombres de los campos con seguimiento de historial
    Set<String> trackedFieldNames = new Set<String>();
    
    // Mapa para almacenar el API name y Label de cada campo
    Map<String, String> fieldApiToLabelMap = new Map<String, String>();
    
    // Consultar los campos con Track History activado en IndividualApplication
    List<FieldDefinition> trackedFields = [
        SELECT QualifiedApiName, Label
        FROM FieldDefinition 
        WHERE EntityDefinition.QualifiedApiName = 'IndividualApplication' 
        AND IsFieldHistoryTracked = true
    ];
    
    // Rellenar el conjunto y mapa con la información de los campos a seguir
    for (FieldDefinition field : trackedFields) {
        fieldApiToLabelMap.put(field.QualifiedApiName, field.Label);
        trackedFieldNames.add(field.QualifiedApiName); // Añadimos el API Name al conjunto
    }
    
    // Obtener el ID del usuario actual (para saber quién hizo el cambio)
    Id currentUserId = UserInfo.getUserId();
    
    // Iterar sobre los registros modificados
    for (IndividualApplication newRecord : Trigger.new) {
        
        // Obtenemos el valor anterior del registro modificado
        IndividualApplication oldRecord = Trigger.oldMap.get(newRecord.Id);
        
        // Iterar sobre los campos que tienen el historial activado
        for (String fieldApi : trackedFieldNames) {
            
            // Obtener el valor anterior y el nuevo valor para el campo
            Object oldValue = oldRecord.get(fieldApi);
            Object newValue = newRecord.get(fieldApi);
            
            // Solo registrar los cambios si el valor ha cambiado
            if (oldValue != newValue) {
                
                if (oldValue != null && (
                    String.valueOf(oldValue).startsWith('005') ||
                    String.valueOf(oldValue).startsWith('a22') ||
                    String.valueOf(oldValue).startsWith('0vM') ||
                    String.valueOf(oldValue).startsWith('003') ||
                    String.valueOf(oldValue).startsWith('a29') ||
                    String.valueOf(oldValue).startsWith('001'))
                ) {
                    // Determinar el objeto al que pertenece el ID
                    String objectName;
                    if (String.valueOf(oldValue).startsWith('005')) {
                        objectName = 'User';
                    } else if (String.valueOf(oldValue).startsWith('a22')) {
                        objectName = 'Modalidad__c';
                    } else if (String.valueOf(oldValue).startsWith('0vM')) {
                        objectName = 'AcademicTerm';
                    } else if (String.valueOf(oldValue).startsWith('003')) {
                        objectName = 'Contact';
                    } else if (String.valueOf(oldValue).startsWith('a29')) {
                        objectName = 'CC_Programa_por_periodo__c';
                    }else if (String.valueOf(oldValue).startsWith('001')) {
                        objectName = 'Account';
                    }
                    
                    // Realizar consultas dinámicas para oldValue y newValue
                    SObject oldRecordSObj;
                    SObject newRecordSObj;
                    
                    try {
                        if (oldValue != null) {
                            String queryOld = 'SELECT Name FROM ' + objectName + ' WHERE Id = :oldValue LIMIT 1';
                            oldRecordSObj = Database.query(queryOld);
                        }
                        if (newValue != null) {
                            String queryNew = 'SELECT Name FROM ' + objectName + ' WHERE Id = :newValue LIMIT 1';
                            newRecordSObj = Database.query(queryNew);
                        }
                    } catch (Exception e) {
                        // Por si acaso el ID no existe o algo falla
                        System.debug('Error querying dynamic object: ' + e.getMessage());
                    }
                    
                    // Agregar un nuevo registro histórico usando el nombre en vez del ID
                    historyRecords.add(new Individual_Applications_History__c(
                        CC_Individual_Application__c = newRecord.Id,
                    fieldName__c = fieldApi,
                    fieldLabelName__c = fieldApiToLabelMap.get(fieldApi),
                    oldValue__c = oldRecordSObj != null ? String.valueOf(oldRecordSObj.get('Name')) : null,
                    newValue__c = newRecordSObj != null ? String.valueOf(newRecordSObj.get('Name')) : null,
                    modifyBy__c = currentUserId,
                    changedDate__c = System.now()
                        ));
                    
                } else {
                    // Si no es un campo de tipo ID de User/Account
                    historyRecords.add(new Individual_Applications_History__c(
                        CC_Individual_Application__c = newRecord.Id,
                    fieldName__c = fieldApi,
                    fieldLabelName__c = fieldApiToLabelMap.get(fieldApi),
                    oldValue__c = oldValue != null ? String.valueOf(oldValue) : null,
                    newValue__c = newValue != null ? String.valueOf(newValue) : null,
                    modifyBy__c = currentUserId,
                    changedDate__c = System.now()
                        ));
                }
            }
        }
    }
    
    // Si hay registros históricos, insertarlos
    if (!historyRecords.isEmpty()) {
        insert historyRecords;
    }
}