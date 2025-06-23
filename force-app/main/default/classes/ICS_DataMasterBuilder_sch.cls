/** 
 * @author: jatibamoza
 * @email: javier.tibamoza.cubillos@gmail.com
 * @description: Scheduler Apex para ejecutar el Batch ICS_DataMasterBuilder_bch.
 * 
*/
global class ICS_DataMasterBuilder_sch implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        List<ICS_QueryMaster__mdt> definitions = [
            SELECT DeveloperName, ICS_Query__c, ICS_RecordTypeDeveloperName__c
            FROM ICS_QueryMaster__mdt 
            WHERE ICS_IsActive__c = true  ];
        
        for( ICS_QueryMaster__mdt def : definitions) {
            deleteDataMasterRecords(def.ICS_RecordTypeDeveloperName__c);
            ICS_DataMasterBuilder_bch batch = new ICS_DataMasterBuilder_bch(def.ICS_Query__c, def.ICS_RecordTypeDeveloperName__c);
            Integer scopeSize = 200;
            Database.executeBatch(batch, scopeSize);
        }
    }

    private static void deleteDataMasterRecords(String sDeveloperName) {
        // Método para eliminar registros de ICS_DataMaster__c
        List<ICS_DataMaster__c> recordsToDelete = [SELECT Id FROM ICS_DataMaster__c WHERE RecordType.DeveloperName =: sDeveloperName];
        if (!recordsToDelete.isEmpty()) {
            delete recordsToDelete;
        }
    }
}