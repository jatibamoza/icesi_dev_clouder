public class visitedSchoolCheckClass {
        public static void visitedSchoolCheckClassfromCampaing(List<Campaign> actualCampaign) {
            
            // Conjuntos para almacenar los IDs de las cuentas y periodos relacionados
            Set<Id> idSchool = new Set<Id>();
            
            // Recopilar los IDs de las cuentas relacionadas a las campañas
            for (Campaign campaign : actualCampaign) {
                idSchool.add(campaign.CC_Colegio__c);
            }
            
            // Consultar las cuentas relacionadas
            Map<Id, Account> accountsMap = new Map<Id, Account>(
                [SELECT Id, CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c, CC_Colegio_visitado__c 
                FROM Account WHERE Id IN :idSchool]
            );
            
            // Consultar todas las campañas relacionadas a las cuentas
            Map<Id, List<Campaign>> campanasPorCuentaMap = new Map<Id, List<Campaign>>();
            List<Campaign> campanasRelacionadas = [
                SELECT Id, CC_Colegio__c, CC_Periodo_acad_mico__c 
                FROM Campaign 
                WHERE CC_Colegio__c IN :idSchool
            ];
            
            // Agrupar las campañas por cuenta (CC_Colegio__c)
            for (Campaign campaign : campanasRelacionadas) {
                if (!campanasPorCuentaMap.containsKey(campaign.CC_Colegio__c)) {
                    campanasPorCuentaMap.put(campaign.CC_Colegio__c, new List<Campaign>());
                }
                campanasPorCuentaMap.get(campaign.CC_Colegio__c).add(campaign);
            }
            
            // Para cada cuenta, verificar si alguna campaña coincide con el periodo académico
            List<Account> cuentasParaActualizar = new List<Account>();
            for (Id idCuenta : idSchool) {
                Account acc = accountsMap.get(idCuenta);
                
                Boolean campanaCoincide = false;
                
                // Verificar las campañas de la cuenta (si existen después de la eliminación)
                if (campanasPorCuentaMap.containsKey(idCuenta)) {
                    List<Campaign> campanasDeCuenta = campanasPorCuentaMap.get(idCuenta);
                    
                    // Verificar si al menos una campaña coincide con los periodos académicos de la cuenta
                    for (Campaign campaign : campanasDeCuenta) {
                        if (acc.CC_Periodo_ventas_uno__c == campaign.CC_Periodo_acad_mico__c || acc.CC_Periodo_ventas_dos__c == campaign.CC_Periodo_acad_mico__c) {
                            campanaCoincide = true;
                            break;  // No es necesario seguir buscando si ya se encontró una coincidencia
                        }
                    }
                }
                
                // Actualizar el campo CC_Colegio_visitado__c basado en si hay coincidencia
                acc.CC_Colegio_visitado__c = campanaCoincide;
                cuentasParaActualizar.add(acc);
            }
            
            // Actualizar las cuentas en Salesforce
            if (!cuentasParaActualizar.isEmpty()) {
                update cuentasParaActualizar;
            }
        }

        public static void mercadoRealCheckClassfomCuenta(List<Account> cuentaList) {
        
            // clase que actualiza el check de colegio visitado cuando el periodo academico de venta 1 y 2 concuerda con el periodo academico de algun colegio visitado relacionado
        set<Id> idCuentas = new set<Id>();
        set<Id> idperiodo = new set<Id>();

        for(Account cuenta : cuentaList){
            idCuentas.add(cuenta.Id);
            idperiodo.add(cuenta.CC_Periodo_ventas_uno__c);
            idperiodo.add(cuenta.CC_Periodo_ventas_dos__c);
        }

        Map<String, Campaign> mapMercadoReal = new Map<String, Campaign>([SELECT Id, CC_Colegio__c,CC_Periodo_acad_mico__c FROM Campaign WHERE CC_Colegio__c IN :idCuentas and CC_Periodo_acad_mico__c  IN :idperiodo ]);
        
        // clave id del colegio
        Map<String, Campaign> transformedMapMercadoReal = new Map<String, Campaign>();
        for (Campaign record : mapMercadoReal.values()) {
            if (record.CC_Colegio__c != null) {
                transformedMapMercadoReal.put(record.CC_Colegio__c, record);
            }
        }
        List<Account> cuentaActualizada = new List<Account>();
        
        for (Account cuenta : cuentaList) {
            
            // Verificar si el mapa contienela cuenta
            if (transformedMapMercadoReal.containsKey(cuenta.id)) {
                cuenta.CC_Colegio_visitado__c = true; 
               
                cuentaActualizada.add(cuenta);
            }else{
             
                cuenta.CC_Colegio_visitado__c = false;  
            }
        }

    }
    }