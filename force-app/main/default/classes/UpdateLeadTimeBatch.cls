global class UpdateLeadTimeBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // Consulta SQL que tomará todos los Leads de la base de datos
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Status, CC_Duraci_n_del_estado__c, CC_Tiempo_en_pendiente_por_atenci_n__c, CC_Tiempo_en_bajo_Contactado__c, CC_Tiempo_en_medio_Respuesta__c, CC_Tiempo_en_Alto_Interesado__c FROM Lead WHERE Status != \'Convertido\' AND Status != \'Descartado\'');
    }

    // Método para procesar un grupo de registros
    global void execute(Database.BatchableContext bc, List<Lead> leadList) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leadList) {
            // Actualizar el campo "Tiempo en el estado" según el estado actual
            if (lead.Status == 'Pendiente por atención') {
                lead.CC_Tiempo_en_pendiente_por_atenci_n__c = lead.CC_Duraci_n_del_estado__c;
            } else if (lead.Status == 'Bajo - contacto') {
                lead.CC_Tiempo_en_bajo_Contactado__c = lead.CC_Duraci_n_del_estado__c;
            } else if (lead.Status == 'Medio (respuesta)') {
                lead.CC_Tiempo_en_medio_Respuesta__c = lead.CC_Duraci_n_del_estado__c;
            } else if (lead.Status == 'Alto interesado') {
                lead.CC_Tiempo_en_Alto_Interesado__c = lead.CC_Duraci_n_del_estado__c;
            }
            leadsToUpdate.add(lead);
        }

        // Actualizar los registros en la base de datos
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    // Método que se ejecuta al finalizar el batch
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch de actualización de tiempo completado');
    }
}