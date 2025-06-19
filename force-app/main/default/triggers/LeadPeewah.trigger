trigger LeadPeewah on Lead (after insert, after update) {
    Set<Id> leadIdsToUpdate = new Set<Id>();

    for (Lead lead : Trigger.new) {
        // Verifica si el campo específico tiene un valor y si cambió
        if (lead.Codigo_colegio_peewah__c != null && 
            (Trigger.isInsert || lead.Codigo_colegio_peewah__c != Trigger.oldMap.get(lead.Id).Codigo_colegio_peewah__c)) {
            leadIdsToUpdate.add(lead.Id);
        }
    }

    // Si hay Leads para actualizar, ejecuta el Batch
    if (!leadIdsToUpdate.isEmpty()) {
        LeadBatchUpdatePeewah batch = new LeadBatchUpdatePeewah(leadIdsToUpdate);
        Database.executeBatch(batch, 200); // Se ejecuta inmediatamente con lotes de 200 registros
    }
}