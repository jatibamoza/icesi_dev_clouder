/** 
 * @author: jatibamoza
 * @email: javier.tibamoza.cubillos@gmail.com
 * @description: Batch Apex para eleminar ICS_Data_Master__c. Luego en el finish ejecuta el Batch ICS_DataMasterBuilder_bch.
 * 
*/
global class ICS_DataMasterDelete_bch implements Database.Batchable<SObject>{
    global final String query;
    global final String queryDelete;
    global final String recordTypeDevName;
    global List<ICS_DataMaster__c> dataMasterBuffer = new List<ICS_DataMaster__c>();

    global ICS_DataMasterDelete_bch(String sQuery, String sRecordTypeDevName) {
        query = ( sQuery != null) ? sQuery : '';
        recordTypeDevName = ( sRecordTypeDevName != null) ? sRecordTypeDevName : '';
        queryDelete = 'SELECT Id FROM ICS_DataMaster__c WHERE RecordType.DeveloperName =: recordTypeDevName ';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(queryDelete);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        delete scope;
    }

    global void finish(Database.BatchableContext BC) {
        ICS_DataMasterBuilder_bch batch = new ICS_DataMasterBuilder_bch(query, recordTypeDevName );
        Integer scopeSize = 200;
        Database.executeBatch(batch, scopeSize);
    }
}