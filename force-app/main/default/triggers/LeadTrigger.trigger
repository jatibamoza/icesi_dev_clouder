trigger LeadTrigger on Lead (after insert, after update) {
    // Llama a la clase de servicio para manejar la lógica.
    if (Trigger.isAfter) {
        LeadHandler.handleLeadNotifications(Trigger.new, Trigger.oldMap);
        List<Id> Leads = new List<Id>();

        for (Lead l : Trigger.new) {
            if(l.Actualizar_CRC__c){
                Leads.add(l.Id);
            }
        }
        
        
        if (!Leads.isEmpty()) {
            // Suponiendo que la cuenta única es la primera de la lista (ajústalo según tu lógica)
          
            System.enqueueJob(new CRCQueueableLead(Leads, null));
        }
    }
}