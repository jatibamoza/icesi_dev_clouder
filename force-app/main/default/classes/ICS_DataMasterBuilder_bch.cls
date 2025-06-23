/** 
 * @author: jatibamoza
 * @email: javier.tibamoza.cubillos@gmail.com
 * @description: Batch Apex para construir Data_Master__c a partir de ICS_QueryMaster__mdt.
 * 
*/
global class ICS_DataMasterBuilder_bch implements Database.Batchable<SObject>, Database.Stateful {

    global final String query;
    global final String recordTypeDevName;
    global List<ICS_DataMaster__c> dataMasterBuffer = new List<ICS_DataMaster__c>();

    global ICS_DataMasterBuilder_bch(String sQuery, String sRecordTypeDevName) {
        //Valida que tenga datos el parametro sQuery
        query = ( sQuery != null) ? sQuery : '';
        //Valida que tenga datos el parametro sRecordTypeDevName
        recordTypeDevName = ( sRecordTypeDevName != null) ? sRecordTypeDevName : '';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        
        for (SObject record : scope) {
            //  Mapea cada registro del scope al objeto ICS_DataMaster__c 
            ICS_DataMaster__c dm = ICS_DataMasterMapper_cls.mapDataMaster(record, this.recordTypeDevName);
            // Solo añade a la lista si el mapeo retornó un registro con un RecordTypeId
            if (dm.RecordTypeId != null) {
                dataMasterBuffer.add(dm);
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        // Inserta los registros acumulados en el buffer
        if (!dataMasterBuffer.isEmpty()) {
            insert dataMasterBuffer;
        }
    }
}
