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
            ICS_DataMasterDelete_bch batch = new ICS_DataMasterDelete_bch( def.ICS_Query__c, def.ICS_RecordTypeDeveloperName__c);
            Integer scopeSize = 200;
            Database.executeBatch(batch, scopeSize);
        }
    }
}