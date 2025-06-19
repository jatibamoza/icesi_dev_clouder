public with sharing class updateAcademicTermBatch implements Database.Batchable<SObject> {
    
    private Id firstAcademicTermId;
    private Id secondAcademicTermId;
    
    public updateAcademicTermBatch(List<Id> academicTermListId) {
        if (!academicTermListId.isEmpty()) {
            this.firstAcademicTermId = academicTermListId[0];
            if (academicTermListId.size() > 1) {
                this.secondAcademicTermId = academicTermListId[1];
            }
        }

    }


    public Database.QueryLocator start(Database.BatchableContext bc) {
        // System.debug('Init the batrch');
        RecordType colegioRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Colegios' LIMIT 1];
        return Database.getQueryLocator([
            SELECT Id, CC_Periodo_acad_mico__c, CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c
            FROM Account 
            WHERE RecordTypeId = :colegioRecordType.Id
        ]);

    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account cole : scope) {
            if (firstAcademicTermId != null && cole.CC_Periodo_ventas_uno__c != firstAcademicTermId) {
                cole.CC_Periodo_ventas_uno__c = firstAcademicTermId;
            }
            if (secondAcademicTermId != null && cole.CC_Periodo_ventas_dos__c != secondAcademicTermId) {
                cole.CC_Periodo_ventas_dos__c = secondAcademicTermId;
            }
        }
        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        // System.debug('Actualización de cuentas completada.');
    }
}