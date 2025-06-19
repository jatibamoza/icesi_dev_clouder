trigger Actualizartrabajobanner on Trabajo__c (after insert, after update, after delete,before insert, before update) {

    // Crear un mapa para almacenar los trabajos más recientes por cuenta
    Map<Id, Trabajo__c> trabajosRecientes = new Map<Id, Trabajo__c>();

    // Crear una lista para almacenar los trabajos que se van a enviar
    List<Trabajo__c> trabajoenviar = new List<Trabajo__c>();

    // Crear un conjunto para almacenar las cuentas para las cuales se harán las consultas
    Set<Id> cuentaIds = new Set<Id>();

    if (Trigger.isInsert   && Trigger.isAfter ) {
        Set<Id> cuentaIds = new Set<Id>();
        List<Trabajo__c> trabajoenviar = new List<Trabajo__c>();
        Map<Id, Trabajo__c> trabajosRecientes = new Map<Id, Trabajo__c>();
        Set<Id> trabajoIdsEnTrigger = new Set<Id>();

        // Recoger las cuentas de los trabajos insertados
        for (Trabajo__c trabajo : Trigger.new) {
            trabajoIdsEnTrigger.add(trabajo.Id);
            if (trabajo.CC_Cuenta__c != null && trabajo.Tipo_de_cuenta_padre1__c == true) {
                cuentaIds.add(trabajo.CC_Cuenta__c);
            }
        }
    
        // Consultar los trabajos existentes más recientes
        List<Trabajo__c> trabajosExistentes = [
            SELECT Id, CC_Cuenta__c, CC_Ano_de_ingreso__c, CC_Desde_el_mes__c,CC_Cuenta__r.CC_ACC_N_mero_id__c
            FROM Trabajo__c
            WHERE CC_Cuenta__c IN :cuentaIds AND CC_Ano_de_ingreso__c != NULL AND CC_Desde_el_mes__c != NULL 
            AND Id NOT IN :trabajoIdsEnTrigger
            ORDER BY CC_Cuenta__c, CC_Ano_de_ingreso__c DESC, CC_Desde_el_mes__c DESC
        ];
    
        // Agrupar los trabajos más recientes por cuenta
        for (Trabajo__c trabajo : trabajosExistentes) {
            if (!trabajosRecientes.containsKey(trabajo.CC_Cuenta__c)) {
                trabajosRecientes.put(trabajo.CC_Cuenta__c, trabajo);
            }
        }
    
        Map<Id, String> cuentasParaCorreo = new Map<Id, String>();
        List<Trabajo__c> cuentasParaDireccion = new List<Trabajo__c>();
        // Evaluar los trabajos insertados
        for (Trabajo__c newJob : Trigger.new) {
            if (newJob.CC_Cuenta__c != null && newJob.Tipo_de_cuenta_padre1__c == true) {
                if (trabajosRecientes.containsKey(newJob.CC_Cuenta__c)) {
                    Trabajo__c trabajoReciente = trabajosRecientes.get(newJob.CC_Cuenta__c);
                    
                    // Comparar fechas para determinar el más reciente
                    if (newJob.CC_Trabajo_actual__c == true || (newJob.CC_Ano_de_ingreso__c > trabajoReciente.CC_Ano_de_ingreso__c || 
                        (newJob.CC_Ano_de_ingreso__c == trabajoReciente.CC_Ano_de_ingreso__c && 
                         newJob.CC_Desde_el_mes__c > trabajoReciente.CC_Desde_el_mes__c))) {

                        trabajoenviar.add(newJob);
                         // Enviar el trabajo más reciente
   
                        System.enqueueJob(new Banner.ActualizatrabajoQueueable(trabajoenviar));
        
                        cuentasParaCorreo.put(newJob.Id, newJob.CC_Correo_Empresarial__c + 'llave' + trabajoReciente.CC_Cuenta__r.CC_ACC_N_mero_id__c + 'llave' + newJob.Id + 'llave' + trabajoReciente.CC_Cuenta__c ); 
                        cuentasParaDireccion.add(newJob);
                        
                    }
                } else {
                    // No hay trabajos previos, enviar es   
                    trabajoenviar.add(newJob);
                    // Verificar cambios en el correo alternativo
                 
                    cuentasParaCorreo.put(newJob.Id, newJob.CC_Correo_Empresarial__c + 'llave' + newJob.CC_Cuenta__r.CC_ACC_N_mero_id__c + 'llave' + newJob.Id + 'llave' + newJob.CC_Cuenta__c); 
                    cuentasParaDireccion.add(newJob);
                    
                }

                 
            }
        }
    
       
        // Encolar las jobs solo si hay cuentas para procesar
        if (!trabajoenviar.isEmpty()) {
            System.enqueueJob(new Banner.ActualizatrabajoQueueable(trabajoenviar));
        }
        // Encolar las jobs solo si hay cuentas para procesar
         if (!cuentasParaCorreo.isEmpty()) {
            System.enqueueJob(new Banner.ActualizarCorreoQueueable(cuentasParaCorreo, 'TR', 'N'));
        }
        if (!cuentasParaDireccion.isEmpty()) {
            // Ahora pasamos cuentasParaDireccion y cuentasConCambios a la Queueable
           System.enqueueJob(new Banner.ActualizadireccionQueueable(null, cuentasParaDireccion,'BU'));
        }

        
    }
    if (Trigger.isUpdate  && Trigger.isAfter) {
        Set<Id> cuentaIds = new Set<Id>();
    
        // Recoger las cuentas relacionadas con los trabajos actualizados
        for (Trabajo__c trabajo : Trigger.new) {
            if (trabajo.CC_Cuenta__c != null && trabajo.Tipo_de_cuenta_padre1__c == true) {
                cuentaIds.add(trabajo.CC_Cuenta__c);
            }
        }
    
        // Obtener los trabajos más recientes de esas cuentas
        Map<Id, Trabajo__c> trabajosRecientes = new Map<Id, Trabajo__c>();
        for (Trabajo__c trabajo : [
            SELECT Id, CC_Cuenta__c, CC_Ano_de_ingreso__c, CC_Desde_el_mes__c,CC_Cuenta__r.CC_ACC_N_mero_id__c
            FROM Trabajo__c
            WHERE CC_Cuenta__c IN :cuentaIds AND ((CC_Ano_de_ingreso__c != NULL AND CC_Desde_el_mes__c != NULL) OR CC_Trabajo_actual__c = true)
            ORDER BY CC_Cuenta__c, CC_Ano_de_ingreso__c DESC, CC_Desde_el_mes__c DESC
        ]) {
            if (!trabajosRecientes.containsKey(trabajo.CC_Cuenta__c)) {
                trabajosRecientes.put(trabajo.CC_Cuenta__c, trabajo);
            }
        }
    
        List<Trabajo__c> trabajoenviar = new List<Trabajo__c>();
        List<String> camposParaVerificar = new List<String>{
            'CC_Empresa_Graduado__c', 'CC_PreSector_de_la_empresa__c', 'CC_Cargo__c', 
            'CC_Trabajo_actual__c', 'CC_A_os_de_experiencia_en_este_trabajo__c', 'CC_Ano_de_ingreso__c',
            'CC_Desde_el_mes__c', 'CC_Area_POS__c', 'CC_Remuneraci_n_laboral__c', 
            'CC_Pre_Nivel_del_cargo__c', 'CC_Tipo_vinculaci_n__c', 'CC_Tama_o_de_la_empresa_Empresa__c',
            'CC_Salario__c','CC_Modalidad_trabajo__c'        
        };
    
        Map<Id, String> cuentasParaCorreo = new Map<Id, String>();
        List<Trabajo__c> cuentasParaDireccion = new List<Trabajo__c>();
        // Recorrer los trabajos nuevos para validar si deben enviarse
        for (Trabajo__c newJob : Trigger.new) {
            if (newJob.CC_Cuenta__c != null && newJob.Tipo_de_cuenta_padre1__c == true) {
                Trabajo__c trabajoReciente = trabajosRecientes.get(newJob.CC_Cuenta__c);

                Boolean esMasReciente = 
                    (trabajoReciente == null) ||
                    (newJob.CC_Ano_de_ingreso__c > trabajoReciente.CC_Ano_de_ingreso__c) ||
                    (newJob.CC_Ano_de_ingreso__c == trabajoReciente.CC_Ano_de_ingreso__c &&
                     newJob.CC_Desde_el_mes__c > trabajoReciente.CC_Desde_el_mes__c) ;
    
           
                if (esMasReciente || newJob.Id == trabajoReciente.Id) {
                    Trabajo__c oldJob = Trigger.oldMap.get(newJob.Id);
                    Boolean huboCambios = false;
    
                    for (String campo : camposParaVerificar) {
                        Object oldValue = oldJob.get(campo);
                        Object newValue = newJob.get(campo);
    
                        if (oldValue != newValue) {
                            huboCambios = true;
                            break;
                        }
                    }
    
                    if (huboCambios) {
                        trabajoenviar.add(newJob);
                    }

                    // Verificar cambios en el correo alternativo
                    if (oldJob.CC_Correo_Empresarial__c != newJob.CC_Correo_Empresarial__c) {
                        cuentasParaCorreo.put(newJob.Id, newJob.CC_Correo_Empresarial__c + 'llave' + trabajoReciente.CC_Cuenta__r.CC_ACC_N_mero_id__c  + 'llave'  + newJob.Id + 'llave' + trabajoReciente.CC_Cuenta__c  ); 
                    }
                 

                    // Verificar cambios en los campos específicos de dirección
                    List<String> camposParaVerificardir = new List<String>{
                        'CC_Pa_s_trabajo__c', 'CC_Departamento_de_donde_trabaja__c', 'CC_Ciudad_donde_trabaja__c', 'CC_Direcci_n_trabajo__c'
                    };

                    Boolean huboCambiosdir = false;  // Bandera para saber si hay cambios en al menos un campo

                    for (String campo : camposParaVerificardir) {
                        if (oldJob.get(campo) != newJob.get(campo)) {
                            huboCambiosdir = true;
                        }
                    }
                    
                    // Agregar la cuenta a la lista de direcciones solo si al menos un campo cambió
                    if (huboCambiosdir) {
                        cuentasParaDireccion.add(newJob);
                    }
                }
            }
        }
    
        // Enviar los trabajos modificados a la Queueable si hay cambios
        if (!trabajoenviar.isEmpty()) {
            System.enqueueJob(new Banner.ActualizatrabajoQueueable(trabajoenviar));
        }
         // Encolar las jobs solo si hay cuentas para procesar
         if (!cuentasParaCorreo.isEmpty()) {
            System.enqueueJob(new Banner.ActualizarCorreoQueueable(cuentasParaCorreo, 'TR', 'N'));
        }
        if (!cuentasParaDireccion.isEmpty()) {
            // Ahora pasamos cuentasParaDireccion y cuentasConCambios a la Queueable
           System.enqueueJob(new Banner.ActualizadireccionQueueable(null, cuentasParaDireccion,'BU'));
        }

      
    }
    
   
    // Bloque para Eliminar
    if (Trigger.isDelete) {
        // Recorrer los trabajos eliminados
        for (Trabajo__c oldJob : Trigger.old) {
            if (oldJob.CC_Cuenta__c != null && oldJob.Tipo_de_cuenta_padre1__c == true) {
                cuentaIds.add(oldJob.CC_Cuenta__c);
            }
        }

        // Realizar una consulta SOQL para obtener los trabajos más recientes para las cuentas relevantes
        List<Trabajo__c> trabajosExistentes = [SELECT Id, CC_Cuenta__c ,CC_Empresa_Graduado__c, CC_PreSector_de_la_empresa__c, CC_Cargo__c, 
            CC_Trabajo_actual__c, CC_A_os_de_experiencia_en_este_trabajo__c, CC_Ano_de_ingreso__c,
            CC_Desde_el_mes__c, CC_Area_POS__c, CC_Remuneraci_n_laboral__c, 
            CC_Pre_Nivel_del_cargo__c, CC_Tipo_vinculaci_n__c, CC_Tama_o_de_la_empresa_Empresa__c,
            CC_Salario__c,CC_Modalidad_trabajo__c,CC_Correo_Empresarial__c,CC_Cuenta__r.CC_ACC_N_mero_id__c  FROM Trabajo__c 
                                                WHERE CC_Cuenta__c IN :cuentaIds AND ((CC_Ano_de_ingreso__c != NULL AND CC_Desde_el_mes__c != NULL) OR CC_Trabajo_actual__c = true)
                                                ORDER BY CC_Cuenta__c, CC_Ano_de_ingreso__c DESC, CC_Desde_el_mes__c DESC];

        // Agrupar los trabajos más recientes por cuenta
        for (Trabajo__c trabajo : trabajosExistentes) {
            if (!trabajosRecientes.containsKey(trabajo.CC_Cuenta__c)) {
                trabajosRecientes.put(trabajo.CC_Cuenta__c, trabajo);
            }
        }

        List<Trabajo__c> cuentasParaDireccion = new List<Trabajo__c>();
        Map<Id, String> cuentasParaCorreo = new Map<Id, String>();
        // Recorrer los trabajos eliminados y asignar el siguiente más reciente
        for (Trabajo__c oldJob : Trigger.old) {

            if (oldJob.CC_Cuenta__c != null && oldJob.Tipo_de_cuenta_padre1__c == true) {
                if (trabajosRecientes.containsKey(oldJob.CC_Cuenta__c)) {
                    Trabajo__c siguienteTrabajo = trabajosRecientes.get(oldJob.CC_Cuenta__c);
                    if (siguienteTrabajo != null && siguienteTrabajo.Id != oldJob.Id) {
                        // Actualizar el siguiente trabajo si es necesario
                        trabajoenviar.add(siguienteTrabajo);

                        
                        cuentasParaCorreo.put(siguienteTrabajo.Id, siguienteTrabajo.CC_Correo_Empresarial__c + 'llave' + siguienteTrabajo.CC_Cuenta__r.CC_ACC_N_mero_id__c  + 'llave'  + siguienteTrabajo.Id + 'llave' + siguienteTrabajo.CC_Cuenta__c  ); 

                        cuentasParaDireccion.add(siguienteTrabajo);
                    }
                }
            }
        }

        // Si hay trabajos para enviar, pasarlos a la Queueable
        if (!trabajoenviar.isEmpty()) {
            System.enqueueJob(new Banner.ActualizatrabajoQueueable(trabajoenviar));
        }
         // Encolar las jobs solo si hay cuentas para procesar
         if (!cuentasParaCorreo.isEmpty()) {
            System.enqueueJob(new Banner.ActualizarCorreoQueueable(cuentasParaCorreo, 'TR', 'N'));
        }
        if (!cuentasParaDireccion.isEmpty()) {
            // Ahora pasamos cuentasParaDireccion y cuentasConCambios a la Queueable
           System.enqueueJob(new Banner.ActualizadireccionQueueable(null, cuentasParaDireccion,'BU'));
        }
   
    }

    if ( Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        AccountTriggerHandler.beforeInsertbannertrabajo(Trigger.new);
    }
}