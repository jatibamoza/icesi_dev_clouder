public class LeadHandler {
    public static void handleLeadNotifications(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        List<Task> tasksToInsert = new List<Task>();
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : newLeads) {
            // Obtén el propietario anterior desde el campo auxiliar o desde el Trigger.oldMap
            Id lastOwnerId = lead.CC_Ultimo_Propietario__c;
            Id currentOwnerId = lead.OwnerId;
            
            // Si no está en Trigger.oldMap (insert), inicializamos con null
            if (oldLeads != null && oldLeads.containsKey(lead.Id)) {
                lastOwnerId = oldLeads.get(lead.Id).OwnerId;
            }

            // Verifica si el propietario cambió y si la bandera está activa
            if (currentOwnerId != lastOwnerId && lead.CC_Cambio_de_owner__c == true) {
                // Crear la tarea
                Task task = new Task(
                    OwnerId = lead.OwnerId,
                    WhoId = lead.Id,
                    Subject = 'Nuevo lead asignado.',
                    Description = 'Notificación: El propietario del Lead ha cambiado. Verifica los detalles ahora.',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    Created_By__c = 'System'
                );
                tasksToInsert.add(task);

                // Actualizar el campo auxiliar en el lead
                Lead updatedLead = lead.clone(false, true, false);
                updatedLead.CC_Ultimo_Propietario__c = currentOwnerId;
                updatedLead.CC_Cambio_de_owner__c = false;
                leadsToUpdate.add(updatedLead);
            }
        }

        // Inserta las tareas
        if (!tasksToInsert.isEmpty()) {
            try {
                insert tasksToInsert;
            } catch (DmlException e) {
                System.debug('Error al insertar tareas: ' + e.getMessage());
            }
        }

        // Actualiza los leads para registrar el último propietario
        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
            } catch (DmlException e) {
                System.debug('Error al actualizar leads: ' + e.getMessage());
            }
        }
    }
}