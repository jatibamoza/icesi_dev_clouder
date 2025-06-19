public class LeadBatchUpdatePeewah implements Database.Batchable<SObject> {
    private Set<Id> leadIds;

    public LeadBatchUpdatePeewah(Set<Id> leadIds) {
        this.leadIds = leadIds;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Codigo_Colegio_Peewah__c, CC_Colegio__c 
            FROM Lead 
            WHERE Id IN :leadIds AND Codigo_Colegio_Peewah__c != null
        ]);
    }

   public void execute(Database.BatchableContext context, List<Lead> leadList) {
        // Obtener los códigos de colegio de los Leads
        Set<String> codigosColegios = new Set<String>();
        for (Lead lead : leadList) {
            codigosColegios.add(lead.Codigo_Colegio_Peewah__c);
        }

        // Consultar los colegios que tienen estos códigos
        Map<String, Id> colegioMap = new Map<String, Id>();
        for (Account colegio : [
            SELECT Id, CC_CODIGO_BANNER__c 
            FROM Account 
            WHERE CC_CODIGO_BANNER__c IN :codigosColegios
        ]) {
            colegioMap.put(colegio.CC_CODIGO_BANNER__c, colegio.Id);
        }

        // Asignar el ID del colegio en el campo lookup del Lead
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead lead : leadList) {
            if (colegioMap.containsKey(lead.Codigo_Colegio_Peewah__c)) {
                   lead.CC_Colegio__c = colegioMap.get(lead.Codigo_Colegio_Peewah__c);
                leadsToUpdate.add(lead);
            }
        }

        // Actualizar los Leads
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Batch Apex finalizado para actualización de Leads');
    }
}