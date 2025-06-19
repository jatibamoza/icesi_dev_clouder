trigger campaingOnScholl on Campaign (before insert, before update, after delete) {
    List<Campaign> actualCampaign = new List<Campaign>();

    if (Trigger.isDelete) {
        // Si es una eliminación, trabajar con Trigger.old
        for (Campaign campaign : Trigger.old) {
            if(campaign.CC_Colegio__c != null){
                actualCampaign.add(campaign);
                System.debug('campaign (old) : ' + actualCampaign);
            }
            
        }
    } else {
        // Para inserciones y actualizaciones trabajar con Trigger.new
        for (Campaign campaign : Trigger.new) {
            if(campaign.CC_Colegio__c != null){
                actualCampaign.add(campaign);
                System.debug('campaign (new) : ' + actualCampaign);
            }
        }
    }

    Set<Id> idColegio = new Set<Id>();
        
    // Recopilar los IDs de las cuentas relacionadas a los mercados que se están insertando/actualizando/eliminando
    for (Campaign campania : actualCampaign) {
        idColegio.add(campania.CC_Colegio__c);
    }
    
    // Consultar las cuentas relacionadas
    List<Account> cuentasParaActualizar = new List<Account>();
    List<Account> accountsMap = new List<Account>(
        [SELECT Id, CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c,CC_Update_cuenta__c FROM Account WHERE Id IN :idColegio]
    );

    for(Account acc : accountsMap ){
        if (acc.CC_Update_cuenta__c == true) {
            acc.CC_Update_cuenta__c = false;
        }else{
            acc.CC_Update_cuenta__c = true;
        }
        cuentasParaActualizar.add(acc);
    }

      // Actualizar las cuentas en Salesforce
    if (!cuentasParaActualizar.isEmpty()) {
        update cuentasParaActualizar;
    }

    if (!actualCampaign.isEmpty()) {
       // visitedSchoolCheckClass.visitedSchoolCheckClassfromCampaing(actualCampaign);
    }
}