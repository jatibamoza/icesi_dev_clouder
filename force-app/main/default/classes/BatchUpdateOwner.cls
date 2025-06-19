public class BatchUpdateOwner implements Database.Batchable<SObject> {
    
    private Set<Id> recordIds;
    private Id newOwnerId;
    private String sObjectType;

    // Constructor que recibe los IDs, el nuevo propietario y el tipo de objeto
    public BatchUpdateOwner(Set<Id> recordIds, Id newOwnerId, String sObjectType) {
        this.recordIds = recordIds;
        this.newOwnerId = newOwnerId;
        this.sObjectType = sObjectType;
    }

    // Consulta dinámica usando el objeto recibido
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Convertir Set<Id> en List<String> para evitar errores
        List<String> idList = new List<String>();
        for (Id recordId : recordIds) {
            idList.add('\'' + String.escapeSingleQuotes(recordId) + '\'');
        }
    
        // Construir la consulta de forma segura
        String query = 'SELECT Id FROM ' + sObjectType + ' WHERE Id IN (' + String.join(idList, ',') + ')';
    
        // Ejecutar la consulta dinámica
        return Database.getQueryLocator(query);
    }
    

    // Método para actualizar el propietario en lotes
    public void execute(Database.BatchableContext BC, List<SObject> records) {
        List<SObject> recordsToUpdate = new List<SObject>();
    
        for (SObject record : records) {
            record.put('CC_Owner_cambiado_masivamente__c', true);
            if (sObjectType != 'Lead') {
                
                record.put('OwnerId', newOwnerId);
            }else{
                record.put('CC_Reclutador_auxiliar__c', newOwnerId);
            }
            
            recordsToUpdate.add(record);
        }
    
        // Usamos Database.update con allOrNone = false para que no falle todo si un registro tiene error
        Database.SaveResult[] results = Database.update(recordsToUpdate, false);
    
        // Manejo de errores (opcional, para registrar fallos)
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                System.debug('Error al actualizar el registro: ' + recordsToUpdate[i].Id);
                for (Database.Error err : results[i].getErrors()) {
                    System.debug('Mensaje de error: ' + err.getMessage());
                }
            }
        }
    }
    
    // Método final
    public void finish(Database.BatchableContext BC) {
        System.debug('Batch Update Owner Finalizado');
    }
}