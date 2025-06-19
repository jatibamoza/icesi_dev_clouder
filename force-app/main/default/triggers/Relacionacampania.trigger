trigger Relacionacampania on CampaignMember (before insert) {
    
    // Creamos una lista de CampaignMember para almacenar aquellos que tienen Id_peewah__c
    List<String> peewahIds = new List<String>();
    List<String> cuentasIds = new List<String>();
    Map<String, Id> campaignMap = new Map<String, Id>();
    Map<String, Id> cuentaMap = new Map<String, Id>();
    
    // Recorremos los CampaignMembers en Trigger.new para recoger los Id_peewah__c no nulos
    for(CampaignMember acc : Trigger.new) {
        if (acc.Id_peewah__c != null) {
            peewahIds.add(acc.Id_peewah__c);
            cuentasIds.add(acc.Cuenta_peewah__c);
        }
    }

    // Solo ejecutamos la consulta si existen Id_peewah__c
    if (!peewahIds.isEmpty()) {
        // Realizamos la consulta en el objeto Campaign para encontrar campañas con esos Id_peewah__c
        for (Campaign camp : [SELECT Id, Id_peewah__c FROM Campaign WHERE Id_peewah__c IN :peewahIds]) {
            campaignMap.put(camp.Id_peewah__c, camp.Id);
        }

        for (Contact cuenta : [SELECT Id,Account.CC_ACC_N_mero_id__c FROM Contact WHERE Account.CC_ACC_N_mero_id__c IN :cuentasIds]) {
            cuentaMap.put(cuenta.Account.CC_ACC_N_mero_id__c, cuenta.Id);
        }

        // Asignamos la campaña correspondiente a cada CampaignMember
        for(CampaignMember acc : Trigger.new) {
            if (acc.Id_peewah__c != null && campaignMap.containsKey(acc.Id_peewah__c)) {
                acc.CampaignId = campaignMap.get(acc.Id_peewah__c);
            }
            if (acc.Cuenta_peewah__c != null && cuentaMap.containsKey(acc.Cuenta_peewah__c)) {
                acc.ContactId = cuentaMap.get(acc.Cuenta_peewah__c);
            }
        }
    }
}