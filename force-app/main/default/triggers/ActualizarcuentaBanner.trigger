trigger ActualizarcuentaBanner on Account (after update, before insert, before update) {


    if(Trigger.isUpdate && Trigger.isAfter){
        // Listas para almacenar las cuentas que sufrieron cambios
        Map<Id, String> cuentasParaCorreo = new Map<Id, String>();
        List<Account> cuentasParaEstado = new List<Account>();
        List<Account> cuentasParaDireccion = new List<Account>();
        Map<Id, List<Map<String, String>>> cuentasParaContacto = new Map<Id, List<Map<String, String>>>();
        List<Account> cuentasbusca = new List<Account>();
        List<Account> tratamiento = new List<Account>();
        List<Account> emprendedor = new List<Account>();
        Map<Id, List<Map<String, String>>> parientenviar = new Map<Id, List<Map<String, String>>>();
        // Mapa para almacenar los cambios por cuenta
        Map<Id, Map<String, Object>> cuentasConCambios = new Map<Id, Map<String, Object>>();

        // Usar un Set para asegurarse de que cada cuenta se agregue solo una vez
        Set<Id> cuentasProcesadas = new Set<Id>();


        Set<Id> hijos = new Set<Id>();
        for (Account acc : Trigger.new) {
            hijos.add(acc.Id);
        }

        // Consultar el campo relacionado
        Map<Id, Account> hijoscheck = new Map<Id, Account>(
            [SELECT Id, CC_Acudiente__r.CC_Graduado__c FROM Account WHERE Id IN :hijos]
        );
    
        // Solo procesamos cuentas que tengan el RecordType de 'PersonAccount'
        for (Account newAcc : Trigger.new) {

            Account accFromQuery = hijoscheck.get(newAcc.Id);
    
            if (newAcc.CC_Graduado__c != true  && accFromQuery.CC_Acudiente__r.CC_Graduado__c != true) {
                continue;
            }
        

            Account oldAcc = Trigger.oldMap.get(newAcc.Id);
            if(newAcc.CC_Graduado__c == true ){
                // Verificar cambios en los campos específicos de dirección
                List<String> camposParaVerificar = new List<String>{
                    'Country__c', 'Department__c', 'City__c', 'CC_Barrio__c', 'CC_Direcci_n__c', 'CC_Datos_adicionales_de_direcci_n__c'
                };

                Boolean huboCambios = false;  // Bandera para saber si hay cambios en al menos un campo

                for (String campo : camposParaVerificar) {

                    if (oldAcc.get(campo) != newAcc.get(campo)) {
                        huboCambios = true;
                        
                    }
                }
                
                
                // Agregar la cuenta a la lista de direcciones solo si al menos un campo cambió
                if (huboCambios) {
                    cuentasParaDireccion.add(newAcc);
                }
                
                // Lista de cambios para esta cuenta
                List<Map<String, String>> cambios = cuentasParaContacto.get(newAcc.Id);
                if (cambios == null) {
                    cambios = new List<Map<String, String>>();
                }

                

                system.debug( newAcc.Phone);
                system.debug(oldAcc.Phone );
                system.debug( newAcc.PersonMobilePhone);
                system.debug(oldAcc.PersonMobilePhone );
                // Verificar cambios en el teléfono
                if (oldAcc.Phone != newAcc.Phone || oldAcc.CC_Indicativo_telefonico__c != newAcc.CC_Indicativo_telefonico__c) {
                    cambios.add(new Map<String, String>{
                        'phoneNumber' => newAcc.Phone,
                        'typePhone' => 'CE',
                        'countryCode' => newAcc.CC_Indicativo_telefonico__c != null ? newAcc.CC_Indicativo_telefonico__c.split(': ')[1] : null ,
                        'tipo' => 'MA',
                        'identifica' => 'MA',
                        'identifica' => newAcc.CC_ACC_N_mero_id__c
                    });
                }

            
                // Verificar cambios en el celular
                if (oldAcc.PersonMobilePhone != newAcc.PersonMobilePhone || oldAcc.CC_Indicativo_telefonico__c != newAcc.CC_Indicativo_telefonico__c) {
                    cambios.add(new Map<String, String>{
                        'phoneNumber' => newAcc.PersonMobilePhone,
                        'typePhone' => 'OT',
                        'countryCode' => newAcc.CC_Indicativo_telefonico__c != null ? newAcc.CC_Indicativo_telefonico__c.split(': ')[1] : null,
                        'tipo' => 'MA',
                        'identifica' => newAcc.CC_ACC_N_mero_id__c
                    });
                }

                // Si hubo cambios, agregarlos al mapa
                if (!cambios.isEmpty()) {
                    cuentasParaContacto.put(newAcc.Id, cambios);
                }

                // Verificar cambios en el correo alternativo
                if (oldAcc.hed__AlternateEmail__pc != newAcc.hed__AlternateEmail__pc) {
                    cuentasParaCorreo.put(newAcc.Id, newAcc.hed__AlternateEmail__pc + 'llave' + newAcc.CC_ACC_N_mero_id__c + 'llave' + newAcc.Id  + 'llave' + newAcc.Id  ); 
                }
                // Verificar cambios en estado civil
                if (oldAcc.CC_Estado_civil__c != newAcc.CC_Estado_civil__c) {
                    cuentasParaEstado.add(newAcc);
                }
                // Verificar cambios en esta buscando trabajo ?
                if (oldAcc.CC_Buscando_trabajo__c != newAcc.CC_Buscando_trabajo__c) {
                    cuentasbusca.add(newAcc);
                }
                // Verificar cambios en esta buscando trabajo ?
                if (oldAcc.CC_Autorizaci_n_de_datos__c != newAcc.CC_Autorizaci_n_de_datos__c) {
                    tratamiento.add(newAcc);
                }
                // Verificar cambios en esta buscando trabajo ?
                if (oldAcc.CC_Emprendedor__c != newAcc.CC_Emprendedor__c) {
                    emprendedor.add(newAcc);
                }
            


            
            
            }
        
            else {
                
                Set<Id> cuentasActualizadas = new Set<Id>();
                for (Account acc : Trigger.new) {
            
                    if (acc.FirstName != oldAcc.FirstName ||
                        acc.LastName != oldAcc.LastName ||
                        acc.CC_Fecha_nacimiento__c != oldAcc.CC_Fecha_nacimiento__c) {
                        cuentasActualizadas.add(acc.Id);
                    
                    }
                }
                
                

                // Buscar relaciones donde estas cuentas actualizadas son familiares
                Map<Id, List<hed__Relationship__c>> relacionesPorCuenta = new Map<Id, List<hed__Relationship__c>>();
                for (hed__Relationship__c relacion : [
                    SELECT Id, hed__Contact__r.AccountId, hed__RelatedContact__c, Identificacion_cuenta_padre__c
                    FROM hed__Relationship__c 
                    WHERE hed__Contact__r.AccountId IN :cuentasActualizadas AND (hed__Type__c = 'Hija' OR hed__Type__c = 'Hijastra' OR hed__Type__c = 'Hija de crianza' OR hed__Type__c = 'Hijo' OR hed__Type__c = 'Hijastro' OR hed__Type__c = 'Hijo adoptivo')
                ]) {
                    if (!relacionesPorCuenta.containsKey(relacion.hed__Contact__r.AccountId) ) {
                        relacionesPorCuenta.put(relacion.hed__Contact__r.AccountId, new List<hed__Relationship__c>());
                    }
                    relacionesPorCuenta.get(relacion.hed__Contact__r.AccountId).add(relacion);
                }


                for (Id cuentaId : relacionesPorCuenta.keySet()) {
                    Account accActualizado = Trigger.newMap.get(cuentaId);
                    List<hed__Relationship__c> relaciones = relacionesPorCuenta.get(cuentaId);
                    List<Map<String, String>> cambiosACTU = new List<Map<String, String>>();

                    for (hed__Relationship__c rel : relaciones) {
                    
                        cambiosACTU.add(new Map<String, String>{
                            'FirstName' => accActualizado.FirstName,
                            'LastName' => accActualizado.LastName,
                            'fecha' => String.valueOf(accActualizado.CC_Fecha_nacimiento__c),
                            'cuentahijo' => rel.Identificacion_cuenta_padre__c,
                            'objeto' => rel.Id,
                            'cuentapadre' => rel.hed__RelatedContact__c,
                            'tipopet' => 'PUT',
                            'tipo' => 'AC'
                        
                        });
                    }

                    if (!cambiosACTU.isEmpty()) {
                        parientenviar.put(cuentaId, cambiosACTU);
                    }
                }
            }
        
        }

    

        // Encolar las jobs solo si hay cuentas para procesar
        if (!cuentasParaCorreo.isEmpty()) {
            System.enqueueJob(new Banner.ActualizarCorreoQueueable(cuentasParaCorreo, 'OT', 'N'));
        }

        if (!cuentasParaEstado.isEmpty()) {
            System.enqueueJob(new Banner.ActualizaestadocivilQueueable(cuentasParaEstado));
        }

        if (!cuentasParaDireccion.isEmpty()) {
        
        System.enqueueJob(new Banner.ActualizadireccionQueueable(cuentasParaDireccion, null,'MA'));
        }
        
        if (!cuentasParaContacto.isEmpty()) {
            //
        System.enqueueJob(new Banner.ActualizatelefonoQueueable(cuentasParaContacto));
        }

        if (!cuentasbusca.isEmpty()) {
            
        System.enqueueJob(new Banner.ActualizbuscatrabajoQueueable(cuentasbusca,'busca'));
        }

        if (!tratamiento.isEmpty()) {
        
        System.enqueueJob(new Banner.ActualizbuscatrabajoQueueable(tratamiento,'tratamiento'));
        }
        if (!emprendedor.isEmpty()) {
        
            System.enqueueJob(new Banner.ActualizaemprendedorQueueable(emprendedor));
        }

        // Enviar los registros modificados a la Queueable
        if (!parientenviar.isEmpty()) {
            System.enqueueJob(new Banner.actualizarelacionesQueueable(parientenviar));
        }

        List<Id> Accounts = new List<Id>();

        for (Account acc : Trigger.new) {
            if(acc.Actualizar_CRC__c){
                Accounts.add(acc.Id);
            }
            
        }

        if (!Accounts.isEmpty()) {
           
            System.enqueueJob(new CRCQueueableAccount(Accounts, null));
        }

    }

    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.beforeInsert(Trigger.new);
    
    }

    if ( Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        AccountTriggerHandler.beforeInsertbanner(Trigger.new);
    }

}