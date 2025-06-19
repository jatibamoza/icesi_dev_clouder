public with sharing class mercadoRealCheckClass {

    public static void mercadoRealCheckClassfomCuenta(List<Account> cuentaList) {
     
         // clase que actualiza el check de mercado real cuando el periodo academico de venta 1 y 2 concuerda con el periodo academico de algun mercado real relacionado
        set<Id> idCuentas = new set<Id>();
        set<Id> idperiodo = new set<Id>();

        for(Account cuenta : cuentaList){
            idCuentas.add(cuenta.Id);
            idperiodo.add(cuenta.CC_Periodo_ventas_uno__c);
            idperiodo.add(cuenta.CC_Periodo_ventas_dos__c);
        }

        Map<String, CC_Mercado_real__c> mapMercadoReal = new Map<String, CC_Mercado_real__c>([SELECT Id, CC_Colegio__c,CC_Periodo_academico__c FROM CC_Mercado_real__c WHERE CC_Colegio__c IN :idCuentas and CC_Periodo_academico__c  IN :idperiodo ]);
        
        // clave id del colegio
        Map<String, CC_Mercado_real__c> transformedMapMercadoReal = new Map<String, CC_Mercado_real__c>();
        for (CC_Mercado_real__c record : mapMercadoReal.values()) {
            if (record.CC_Colegio__c != null) {
                transformedMapMercadoReal.put(record.CC_Colegio__c, record);
            }
        }
        List<Account> cuentaActualizada = new List<Account>();
        
        for (Account cuenta : cuentaList) {
          
        
            // Verificar si el mapa contienela cuenta
            if (transformedMapMercadoReal.containsKey(cuenta.id)) {
                cuenta.CC_Mercado_real__c = true; 
                System.debug('Si contiene');
                cuentaActualizada.add(cuenta);
            }else{
                System.debug('No contiene');
               cuenta.CC_Mercado_real__c = false;  
            }
        }

    }
    public static void mercadoRealCheckClassfomMercadoreal(List<CC_Mercado_real__c> mercadorealList) {
     
        // Conjuntos para almacenar los IDs de las cuentas y mercados relacionados
        Set<Id> idColegio = new Set<Id>();
        
        // Recopilar los IDs de las cuentas relacionadas a los mercados que se están insertando/actualizando/eliminando
        for (CC_Mercado_real__c mercado : mercadorealList) {
            idColegio.add(mercado.CC_Colegio__c);
        }
        
        // Consultar las cuentas relacionadas
        Map<Id, Account> accountsMap = new Map<Id, Account>(
            [SELECT Id, CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c FROM Account WHERE Id IN :idColegio]
        );
        
        // Consultar todos los mercados reales relacionados a las cuentas
        Map<Id, List<CC_Mercado_real__c>> mercadosPorCuentaMap = new Map<Id, List<CC_Mercado_real__c>>();
        List<CC_Mercado_real__c> mercadosRelacionados = [
            SELECT Id, CC_Colegio__c, CC_Periodo_academico__c 
            FROM CC_Mercado_real__c 
            WHERE CC_Colegio__c IN :idColegio
        ];
        
        // Agrupar los mercados reales por cuenta (CC_Colegio__c)
        for (CC_Mercado_real__c mercado : mercadosRelacionados) {
            if (!mercadosPorCuentaMap.containsKey(mercado.CC_Colegio__c)) {
                mercadosPorCuentaMap.put(mercado.CC_Colegio__c, new List<CC_Mercado_real__c>());
            }
            mercadosPorCuentaMap.get(mercado.CC_Colegio__c).add(mercado);
        }
        
        // Para cada cuenta, verificar si algún mercado real coincide con el periodo académico
        List<Account> cuentasParaActualizar = new List<Account>();
        for (Id idCuenta : idColegio) {
            Account acc = accountsMap.get(idCuenta);
            
            Boolean mercadoCoincide = false;
            
            // Verificar los mercados de la cuenta (si existen después de la eliminación)
            if (mercadosPorCuentaMap.containsKey(idCuenta)) {
                List<CC_Mercado_real__c> mercadosDeCuenta = mercadosPorCuentaMap.get(idCuenta);
                
                // Verificar si al menos uno de los mercados reales coincide con los periodos académicos de la cuenta
                for (CC_Mercado_real__c mercado : mercadosDeCuenta) {
                    if (acc.CC_Periodo_ventas_uno__c == mercado.CC_Periodo_academico__c || acc.CC_Periodo_ventas_dos__c == mercado.CC_Periodo_academico__c) {
                        mercadoCoincide = true;
                        break;  // No es necesario seguir buscando si ya hay un mercadencontrado
                    }
                }
            }
            
            // Actualizar el campo CC_Mercado_real__c basado en si hay coincidencia
            acc.CC_Mercado_real__c = mercadoCoincide;
            cuentasParaActualizar.add(acc);
        }
        
        // Actualizar las cuentas en Salesforce
        if (!cuentasParaActualizar.isEmpty()) {
            update cuentasParaActualizar;
        }
    }
    
}