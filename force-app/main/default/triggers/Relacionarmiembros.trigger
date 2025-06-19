trigger Relacionarmiembros on CampaignMember (before insert) {
    Set<String> externalIds = new Set<String>();

    // Recoger todos los IDs externos de campaña de los CampaignMember
    for (CampaignMember cm : Trigger.new) {
        if (cm.Id_peewah__c != null) {
            externalIds.add(cm.Id_peewah__c);
        }
    }

    if (!externalIds.isEmpty()) {
        // Buscar las campañas usando el campo de ID externo
        Map<String, Id> campaignMap = new Map<String, Id>();
        for (Campaign camp : [SELECT Id, Id_peewah__c FROM Campaign WHERE Id_peewah__c IN :externalIds]) {
            campaignMap.put(camp.Id_peewah__c, camp.Id);
        }

        // Asignar el CampaignId correcto a los CampaignMember
        for (CampaignMember cm : Trigger.new) {
            if (cm.Id_peewah__c != null && campaignMap.containsKey(cm.Id_peewah__c)) {
                cm.CampaignId = campaignMap.get(cm.Id_peewah__c);
            }
        }
    }
}