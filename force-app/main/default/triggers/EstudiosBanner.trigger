trigger EstudiosBanner on hed__Education_History__c (after update,after insert,before insert, before update, before delete) {

    Set<Id> estudiosIds = new Set<Id>();

    Map<Id, List<Map<String, String>>> estudiosEnviar = new Map<Id, List<Map<String, String>>>();
    String tipoPet = '';
    
    if ( Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        for (hed__Education_History__c estudio : Trigger.new) {
            if (estudio.Tipo_de_cuenta_padre1__c == true && (Trigger.isInsert || Trigger.oldMap.get(estudio.Id).CC_Instituci_n_Educativa__c != estudio.CC_Instituci_n_Educativa__c || Trigger.oldMap.get(estudio.Id).Programa_acad_mico_Estudios__c != estudio.Programa_acad_mico_Estudios__c || Trigger.oldMap.get(estudio.Id).hed__Graduation_Date__c != estudio.hed__Graduation_Date__c|| Trigger.oldMap.get(estudio.Id).CC_Grado_de_educaci_n__c != estudio.CC_Grado_de_educaci_n__c) ){
                estudiosIds.add(estudio.Id);
            }
        }
        tipoPet = Trigger.isInsert ? 'POST' : 'PUT';

        
    }

    if ( Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        AccountTriggerHandler.beforeInsertestudios(Trigger.new);
    }
    
    
    
    if (Trigger.isDelete) {
        for (hed__Education_History__c estudio : Trigger.old) {
            if (estudio.Tipo_de_cuenta_padre1__c == true) {
                estudiosIds.add(estudio.Id);
            }
        }
        tipoPet = 'DELETE';
    }
    
    
    if (!estudiosIds.isEmpty()) {
        for (hed__Education_History__c estudio : [
                SELECT Id, hed__Contact__c, hed__Graduation_Date__c,CC_Grado_de_educaci_n__c,
                    CC_Instituci_n_Educativa__r.CC_Codigo_universidad__c,
                    Programa_acad_mico_Estudios__r.CC_CODIGO_BANNER__c,
                    hed__Contact__r.Account.CC_ACC_N_mero_id__c,
                    hed__Contact__r.Account.Id,Enfasis_en_1__r.CC_Concentraci_n__r.CC_CODIGO_BANNER__c
                FROM hed__Education_History__c
                WHERE Id IN :estudiosIds AND hed__Contact__r.Account.CC_Graduado__c = true
            ]) {
            
            string nivel = estudio.CC_Grado_de_educaci_n__c != null ? estudio.CC_Grado_de_educaci_n__c : '';
            if(estudio.CC_Grado_de_educaci_n__c == 'Especialista'){
                nivel = 'ES';
            }else if(estudio.CC_Grado_de_educaci_n__c == 'Magister'){
                nivel = 'MA';
            }else if(estudio.CC_Grado_de_educaci_n__c == 'Doctor'){
                nivel = 'DO';
            }else if(estudio.CC_Grado_de_educaci_n__c == 'Posdoctor'){
                nivel = 'PS';
            }
            
            List<Map<String, String>> cambios = new List<Map<String, String>>();
            cambios.add(new Map<String, String>{
                'tiponivel' => nivel,
                'universidad' => tipoPet == 'DELETE' ? '' : estudio.CC_Instituci_n_Educativa__r.CC_Codigo_universidad__c,
                'fecha' => tipoPet == 'DELETE' ? '' : String.valueOf(estudio.hed__Graduation_Date__c),
                'programa' => tipoPet == 'DELETE' ? '' : estudio.Programa_acad_mico_Estudios__r.CC_CODIGO_BANNER__c,
                'identificacion' => estudio.hed__Contact__r.Account.CC_ACC_N_mero_id__c,
                'contactId' => estudio.hed__Contact__c,
                'accountId' => estudio.hed__Contact__r.Account.Id,
                'objeto' => estudio.Id, 
                'tipopet' => tipoPet,
                'enfasis' => tipoPet == 'DELETE' ? '' : estudio.Enfasis_en_1__r.CC_Concentraci_n__r.CC_CODIGO_BANNER__c
            });
            estudiosEnviar.put(estudio.Id, cambios);
        }
    }
    
    if (!estudiosEnviar.isEmpty()) {
         System.enqueueJob(new Banner.EstudiosQueueable(estudiosEnviar));
    }
}