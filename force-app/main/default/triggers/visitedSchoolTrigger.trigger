trigger visitedSchoolTrigger on CC_Mercado_real__c (after delete, before insert, before update) {
    List<CC_Mercado_real__c> mercadoRealActual = new List<CC_Mercado_real__c>();

    if (Trigger.isDelete) {
        // Si es una eliminación, trabajar con Trigger.old
        for (CC_Mercado_real__c mercado : Trigger.old) {
            if(mercado.CC_Colegio__c != null){
                mercadoRealActual.add(mercado);
                System.debug('mercadoReal (old) : ' + mercadoRealActual);
            }
        }
    } else {
        // Para inserciones y actualizaciones trabajar con Trigger.new
        for (CC_Mercado_real__c mercado : Trigger.new) {
            if(mercado.CC_Colegio__c != null){
                mercadoRealActual.add(mercado);
                System.debug('mercadoReal (new) : ' + mercadoRealActual);
            }
        }
    }
    

    Set<Id> idColegio = new Set<Id>();
        
    // Recopilar los IDs de las cuentas relacionadas a los mercados que se están insertando/actualizando/eliminando
    for (CC_Mercado_real__c mercado : mercadoRealActual) {
        idColegio.add(mercado.CC_Colegio__c);
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




    if (!mercadoRealActual.isEmpty()) {
        //mercadoRealCheckClass.mercadoRealCheckClassfomMercadoreal(mercadoRealActual);
    }
}