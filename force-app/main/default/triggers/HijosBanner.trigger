trigger HijosBanner on hed__Relationship__c (after insert,before delete) {

    if (Trigger.isInsert) {


        Set<Id> contactIds = new Set<Id>();
        Map<Id, Id> contactToAccountMap = new Map<Id, Id>(); // Relación Contacto -> Cuenta
        Set<Id> cuentasId = new Set<Id>();
        Map<Id, Id> contactToRelationshipMap = new Map<Id, Id>(); // Relación Contacto -> hed__Relationship__c
        Map<Id, Id> contactToRelationshipPadreMap = new Map<Id, Id>(); // Relación Contacto -> hed__Relationship__c
    
        // Recopilar Contact IDs desde los registros del trigger y mapear relaciones
        for (hed__Relationship__c rel : Trigger.new) {
            if (rel.hed__Contact__c != null && rel.Tipo_de_cuenta_padre1__c == true) {
                contactIds.add(rel.hed__Contact__c);
                contactToRelationshipMap.put(rel.hed__Contact__c, rel.Id);
                contactToRelationshipPadreMap.put(rel.hed__Contact__c, rel.hed__RelatedContact__c); // Relacionamos Contact con el Id del trigger
            }
        }
    
        // Obtener cuentas asociadas a los contactos
        if (!contactIds.isEmpty()) {
            for (Contact c : [SELECT Id, AccountId,Account.CC_ACC_N_mero_id__c FROM Contact WHERE Id IN :contactIds]) {
                if (c.AccountId != null) {
                    contactToAccountMap.put(c.Id, c.AccountId);
                    cuentasId.add(c.AccountId);
                }
            }
        }
        
    
        Map<Id, List<Map<String, String>>> parientenviar = new Map<Id, List<Map<String, String>>>();
        // Obtener cuentas tipo "Hij@" 
        if (!cuentasId.isEmpty()) {
            List<Account> hijosAccounts = [
                SELECT Id, Name, CC_Tipo_de_persona__c, FirstName, LastName, CC_Fecha_nacimiento__c,CC_Acudiente__r.CC_ACC_N_mero_id__c
                FROM Account
                WHERE Id IN :cuentasId AND CC_Tipo_de_persona__c = 'Hij@'
            ];
    
            List<Map<String, String>> cambiosACTU = new List<Map<String, String>>();
    
            
            for (Account acc : hijosAccounts) {
                // Buscar el Contact relacionado con esta cuenta y obtener la relación que disparó el trigger
                Id cuentaHijoId = null;
                Id relacionId = null; // ID del hed__Relationship__c que disparó el trigger
                Id cuentaPadreId = null;
                for (Id contactId : contactToAccountMap.keySet()) {
                    if (contactToAccountMap.get(contactId) == acc.Id) {
                        cuentaHijoId = contactToAccountMap.get(contactId);
                        cuentaPadreId = contactToRelationshipPadreMap.get(contactId);  
                        relacionId = contactToRelationshipMap.get(contactId); // Obtenemos el ID del hed__Relationship__c
                        break; // Si ya encontramos la relación, salimos del bucle
                    }
                }
    
                if(acc.CC_Acudiente__r.CC_ACC_N_mero_id__c != null){

                    cambiosACTU.add(new Map<String, String>{
                        'FirstName' => acc.FirstName,
                        'LastName' => acc.LastName,
                        'fecha' => String.valueOf(acc.CC_Fecha_nacimiento__c),
                        'tipopet' => 'POST',  
                        'tipo' => 'AC',
                        'cuentaPadrenum' => acc.CC_Acudiente__r.CC_ACC_N_mero_id__c,
                        'cuentahijo' => cuentaHijoId,
                        'cuentapadrecontactoId' => cuentaPadreId,
                        'cuentapadre' => acc.CC_Acudiente__c != null ? acc.CC_Acudiente__c : 'N/A',// LLEVAR CUENTA PADRES IDSALESFORFCE NO NUMERO DE DOCUMENTO
                        'objeto' => relacionId != null ? String.valueOf(relacionId) : 'N/A' 
                    });
                }

                
                // Si necesitas enviar cambiosACTU en un mapa:
                if (!cambiosACTU.isEmpty()) {
                
                    parientenviar.put(relacionId, cambiosACTU);
                }
            }
    
            
        }
       
        // 6. Enviar los registros a la Queueable
        if (!parientenviar.isEmpty()) {
            System.enqueueJob(new Banner.actualizarelacionesQueueable(parientenviar));
        }


        
    }
    

    if (Trigger.isDelete) {
        Set<Id> contactIds = new Set<Id>();
        Map<Id, Id> contactToRelationshipMap = new Map<Id, Id>(); // Contacto → hed__Relationship__c
        Set<Id> cuentasId = new Set<Id>();

        // Recopilar Contact IDs y mapear relaciones desde el trigger
        for (hed__Relationship__c rel : Trigger.old) {
            if (rel.hed__Contact__c != null && rel.Tipo_de_cuenta_padre1__c == true) {
                contactIds.add(rel.hed__Contact__c);
                contactToRelationshipMap.put(rel.hed__Contact__c, rel.Id); // Relación Contact → hed__Relationship__c
            }
        }

        // Obtener cuentas asociadas a los contactos
        if (!contactIds.isEmpty()) {
            for (Contact c : [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds]) {
                if (c.AccountId != null) {
                    cuentasId.add(c.AccountId);
                }
            }
        }

        // Mapa para almacenar los datos a enviar
        Map<Id, List<Map<String, String>>> parientenviar = new Map<Id, List<Map<String, String>>>();

        // Obtener cuentas tipo "Hij@" 
        if (!cuentasId.isEmpty()) {
            List<Account> hijosAccounts = [
                SELECT Id, CC_Acudiente__r.CC_ACC_N_mero_id__c
                FROM Account
                WHERE Id IN :cuentasId AND CC_Tipo_de_persona__c = 'Hij@'
            ];

            for (Account acc : hijosAccounts) {
                Id relacionId = null;

                // Buscar el Contact relacionado con esta cuenta y obtener la relación que disparó el trigger
                for (Id contactId : contactToRelationshipMap.keySet()) {
                    relacionId = contactToRelationshipMap.get(contactId);
                    break; // Salimos en cuanto encontramos una relación
                }

                List<Map<String, String>> cambiosACTU = new List<Map<String, String>>();
                cambiosACTU.add(new Map<String, String>{
                    'FirstName' => '',
                    'LastName' => '',
                    'fecha' => '',
                    'tipopet' => 'DELETE',
                    'tipo' => 'AC',
                    'cuentahijo' => acc.CC_Acudiente__r != null ? acc.CC_Acudiente__r.CC_ACC_N_mero_id__c : 'N/A',
                    'cuentapadre' => '',
                    'objeto' => relacionId != null ? String.valueOf(relacionId) : 'N/A'
                });

                if (!cambiosACTU.isEmpty()) {
                    parientenviar.put(relacionId, cambiosACTU);
                }
            }
        }

        // Enviar a la Queueable si hay datos
        if (!parientenviar.isEmpty()) {
            System.enqueueJob(new Banner.actualizarelacionesQueueable(parientenviar));
        }


        
    }
    
}