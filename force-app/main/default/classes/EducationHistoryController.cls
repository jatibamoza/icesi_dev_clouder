public with sharing class EducationHistoryController {
    
    @AuraEnabled(cacheable=true)
    public static List<hed__Education_History__c> getEducationHistories(String contactId) {
        return [
            SELECT Id, Name, hed__Contact__c,  toLabel(CC_Grado_de_educaci_n__c), 
                   CC_ProfesinCarrera__c,CC_ProfesinCarrera__r.Name, hed__Graduation_Date__c, 
                   CC_Instituci_n_Educativa__c,CC_Instituci_n_Educativa__r.Name
            FROM hed__Education_History__c
            WHERE hed__Contact__r.AccountId = :contactId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static String getContactId(String contactId) {

        System.debug(contactId);
        contact contact = [
            SELECT id FROM contact WHERE AccountId = :contactId LIMIT 1
        ];
        return contact.id ;
    }

    @AuraEnabled
    public static void deleteEducationHistory(String recordId) {
   
            hed__Education_History__c record = [SELECT Id FROM hed__Education_History__c WHERE Id = :recordId LIMIT 1];
            delete record;
        
    }
}