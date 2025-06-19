public with sharing class CRC {

    
    public virtual class DmsUtilsException extends Exception {}

    private static String strToken;

    private static CRC__mdt wsInfo;
    
    static{wsInfo = [ SELECT Token__c, URL__c FROM CRC__mdt LIMIT 1];}

     /**
    * @description Calls Signio services based on the Path a Boody received. If the Token is null, the call is executed without authentication header.
    * @param strPath Service path
    * @param strBody Http request body
    * @param strRequestType Http request type POST, GET, PUT or DELETE
    * @param strAuthToken Authorization Bearer Token
    * @return String Http response body
    */

   
    public static void CRCcuentas(List<Id> accountIds , String cuentaunica) {
 
        system.debug(cuentaunica + accountIds);
        List<Account> accounts = [
            SELECT Id, PersonEmail, Phone, PersonMobilePhone 
            FROM Account 
            WHERE Id IN :accountIds OR Id = :cuentaunica
        ];

        List<String> correos = new List<String>();
        List<String> telefonos = new List<String>();
        Map<String, List<Id>> emailToAccountIds = new Map<String, List<Id>>();
        Map<String, List<Id>> cellAccountIds = new Map<String, List<Id>>();
        Map<String, List<Id>> phoneToAccountIds = new Map<String, List<Id>>();

        Map<Id, Map<String, Object>> accountsToUpdate = new Map<Id, Map<String, Object>>();

        
        for (Account acc : accounts) {
            if (acc.PersonEmail != null) {
                correos.add(acc.PersonEmail);
                if (!emailToAccountIds.containsKey(acc.PersonEmail)) {
                    emailToAccountIds.put(acc.PersonEmail, new List<Id>());
                }
                emailToAccountIds.get(acc.PersonEmail).add(acc.Id);
            }
            if (acc.PersonMobilePhone != null) {
                telefonos.add(acc.PersonMobilePhone);
                if (!phoneToAccountIds.containsKey(acc.PersonMobilePhone)) {
                    phoneToAccountIds.put(acc.PersonMobilePhone, new List<Id>());
                }
                phoneToAccountIds.get(acc.PersonMobilePhone).add(acc.Id);
            }
            if (acc.Phone != null) {
                telefonos.add(acc.Phone);
                if (!cellAccountIds.containsKey(acc.Phone)) {
                    cellAccountIds.put(acc.Phone, new List<Id>());
                }
                cellAccountIds.get(acc.Phone).add(acc.Id);
            }

            if (!accountsToUpdate.containsKey(acc.Id)) {
                accountsToUpdate.put(acc.Id, new Map<String, Object>());
            }
            
            accountsToUpdate.get(acc.Id).put('CC_Fecha_de_consulta_Crc__c', DateTime.now());
        }

  
        // Correos
        if (!correos.isEmpty()) {
            Map<String, Object> jsonMapEmail = new Map<String, Object>{
                'type' => 'COR',
                'keys' => correos
            };
            String jsonEmail = JSON.serialize(jsonMapEmail);
            String jsonResEmail = callDms('validarExcluidos', jsonEmail, 'POST', wsInfo.Token__c);

            if (jsonResEmail != null) {
                List<Object> resList = (List<Object>) JSON.deserializeUntyped(jsonResEmail);
                for (Object obj : resList) {
                    Map<String, Object> res = (Map<String, Object>) obj;
                    String correo = String.valueOf(res.get('llave'));
                    if (emailToAccountIds.containsKey(correo)) {
                        List<Id> accIds = emailToAccountIds.get(correo);
                        Map<String, Object> opciones = (Map<String, Object>) res.get('opcionesContacto');
                        if (opciones != null ) {
                            for (Id accId : accIds) {
                                if (!accountsToUpdate.containsKey(accId)) {
                                    accountsToUpdate.put(accId, new Map<String, Object>());
                                }
                                accountsToUpdate.get(accId).put('CC_CRC_Correo_electr_nico__c', opciones.get('correo_electronico') == true ? false : true);

                                accountsToUpdate.get(accId).put('CC_CRC_Correo_electr_nico_Aplicaci_n__c', opciones.get('aplicacion') == true ? false : true);
                            }
                        }
                    }
                }
            }
        }

        // Teléfonos celulares
        if (!telefonos.isEmpty()) {
            Map<String, Object> jsonMapTel = new Map<String, Object>{
                'type' => 'TEL',
                'keys' => telefonos
            };
            String jsonPhone = JSON.serialize(jsonMapTel);
            String jsonResPhone = callDms('validarExcluidos', jsonPhone, 'POST', wsInfo.Token__c);

            if (jsonResPhone != null) {
                List<Object> resList = (List<Object>) JSON.deserializeUntyped(jsonResPhone);
                for (Object obj : resList) {
                    Map<String, Object> res = (Map<String, Object>) obj;
                    String telefono = String.valueOf(res.get('llave'));
                    if (phoneToAccountIds.containsKey(telefono)) {
                        List<Id> accIds = phoneToAccountIds.get(telefono);
                        Map<String, Object> opciones = (Map<String, Object>) res.get('opcionesContacto');
                        String tipo = String.valueOf(res.get('tipo'));
                        if (opciones != null ) {
                            for (Id accId : accIds) {
                                if (!accountsToUpdate.containsKey(accId)) {
                                    accountsToUpdate.put(accId, new Map<String, Object>());
                                }

                                if(tipo == 'Móvil'){
                                    accountsToUpdate.get(accId).put('CC_CRC_SMS__c', opciones.get('sms') == true ? false : true);
                                    accountsToUpdate.get(accId).put('CC_CRC_WhatsApp__c', opciones.get('aplicacion') == true ? false : true);
                                    accountsToUpdate.get(accId).put('CC_CRC_Llamada_Celular__c', opciones.get('llamada') == true ? false : true);
                                    accountsToUpdate.get(accId).put('tipo', tipo);
                                }else {
                                    accountsToUpdate.get(accId).put('CC_CRC_Llamada_Fijo__c', opciones.get('llamada') == true ? false : true);
                                    accountsToUpdate.get(accId).put('CC_CRC_aplicacion_Fijo__c', opciones.get('aplicacion') == true ? false : true);   
                                    accountsToUpdate.get(accId).put('tipo', tipo);
                                }

                                
                            }
                        }
                    }
                }
            }
        }

        

        if (!accountsToUpdate.isEmpty()) {
            actualizar(JSON.serialize(accountsToUpdate));
        }
    }

    public static void CRClead(List<Id> leadIds,string leadunico) {
       
        
        List<Lead> Leads = [
            SELECT Id, Email, Phone, MobilePhone 
            FROM Lead 
            WHERE Id IN :leadIds OR  Id = :leadunico
        ];

        List<String> correos = new List<String>();
        List<String> telefonos = new List<String>();
        Map<String, List<Id>> emailToleadIds = new Map<String, List<Id>>();
        Map<String, List<Id>> phoneToleadIds = new Map<String, List<Id>>();


        Map<Id, Map<String, Object>> LeadsToUpdate = new Map<Id, Map<String, Object>>();

        for (Lead acc : Leads) {
            if (acc.Email != null) {
                correos.add(acc.Email);
                if (!emailToleadIds.containsKey(acc.Email)) {
                    emailToleadIds.put(acc.Email, new List<Id>());
                }
                emailToleadIds.get(acc.Email).add(acc.Id);
            }
            if (acc.MobilePhone != null) {
                telefonos.add(acc.MobilePhone);
                if (!phoneToleadIds.containsKey(acc.MobilePhone)) {
                    phoneToleadIds.put(acc.MobilePhone, new List<Id>());
                }
                phoneToleadIds.get(acc.MobilePhone).add(acc.Id);
            }
            if (acc.Phone != null) {
                telefonos.add(acc.Phone);
                if (!phoneToleadIds.containsKey(acc.Phone)) {
                    phoneToleadIds.put(acc.Phone, new List<Id>());
                }
                phoneToleadIds.get(acc.Phone).add(acc.Id);
            }

            if (!LeadsToUpdate.containsKey(acc.Id)) {
                LeadsToUpdate.put(acc.Id, new Map<String, Object>());
            }
            
            LeadsToUpdate.get(acc.Id).put('CC_Fecha_de_consulta_Crc__c', DateTime.now());
        }

        

        // Correos
        if (!correos.isEmpty()) {
            Map<String, Object> jsonMapEmail = new Map<String, Object>{
                'type' => 'COR',
                'keys' => correos
            };
            String jsonEmail = JSON.serialize(jsonMapEmail);
            String jsonResEmail = callDms('validarExcluidos', jsonEmail, 'POST', wsInfo.Token__c);

            if (jsonResEmail != null) {
                List<Object> resList = (List<Object>) JSON.deserializeUntyped(jsonResEmail);
                for (Object obj : resList) {
                    Map<String, Object> res = (Map<String, Object>) obj;
                    String correo = String.valueOf(res.get('llave'));
                    if (emailToleadIds.containsKey(correo)) {
                        List<Id> leadIdsemail = emailToLeadIds.get(correo);
                        Map<String, Object> opciones = (Map<String, Object>) res.get('opcionesContacto');
                        
                        if (opciones != null ) {
                            for (Id LeadId : leadIdsemail) {
                                if (!LeadsToUpdate.containsKey(LeadId)) {
                                    LeadsToUpdate.put(LeadId, new Map<String, Object>());
                                }
                                LeadsToUpdate.get(LeadId).put('CC_CRC_Correo_electr_nico__c', opciones.get('correo_electronico') == true ? false : true);
                                LeadsToUpdate.get(LeadId).put('CC_CRC_Correo_electr_nico_Aplicaci_n__c', opciones.get('aplicacion') == true ? false : true);

                               
                            }
                        }
                    }
                }
            }
        }

        // Teléfonos
        if (!telefonos.isEmpty()) {
            Map<String, Object> jsonMapTel = new Map<String, Object>{
                'type' => 'TEL',
                'keys' => telefonos
            };
            String jsonPhone = JSON.serialize(jsonMapTel);
            String jsonResPhone = callDms('validarExcluidos', jsonPhone, 'POST', wsInfo.Token__c);

            if (jsonResPhone != null) {
                List<Object> resList = (List<Object>) JSON.deserializeUntyped(jsonResPhone);
                for (Object obj : resList) {
                    Map<String, Object> res = (Map<String, Object>) obj;
                    String telefono = String.valueOf(res.get('llave'));
                    if (phoneToleadIds.containsKey(telefono)) {
                        List<Id> leadIdspfone = phoneToleadIds.get(telefono);
                        Map<String, Object> opciones = (Map<String, Object>) res.get('opcionesContacto');
                        String tipo = String.valueOf(res.get('tipo'));
                        if (opciones != null ) {
                            for (Id LeadId : leadIdspfone) {
                                if (!LeadsToUpdate.containsKey(LeadId)) {
                                    LeadsToUpdate.put(LeadId, new Map<String, Object>());
                                }
                               
                                LeadsToUpdate.get(LeadId).put('CC_CRC_SMS__c', opciones.get('sms') == true ? false : true);
                                LeadsToUpdate.get(LeadId).put('CC_CRC_WhatsApp__c', opciones.get('aplicacion') == true ? false : true);
                                LeadsToUpdate.get(LeadId).put('CC_CRC_Llamada_Celular__c', opciones.get('llamada') == true ? false : true);

                                if(tipo == 'Móvil'){
                                    LeadsToUpdate.get(LeadId).put('CC_CRC_SMS__c', opciones.get('sms') == true ? false : true);
                                    LeadsToUpdate.get(LeadId).put('CC_CRC_WhatsApp__c', opciones.get('aplicacion') == true ? false : true);
                                    LeadsToUpdate.get(LeadId).put('CC_CRC_Llamada_Celular__c', opciones.get('llamada') == true ? false : true);
    
                                    LeadsToUpdate.get(LeadId).put('tipo', tipo);
                                }else {
                                    LeadsToUpdate.get(LeadId).put('CC_CRC_aplicacion_Fijo__c', opciones.get('aplicacion') == true ? false : true);
                                    LeadsToUpdate.get(LeadId).put('CC_CRC_Llamada_Fijo__c', opciones.get('llamada') == true ? false : true);
    
                                    LeadsToUpdate.get(LeadId).put('tipo', tipo);
                                }

                                
                            }
                        }
                    }
                }
            }

            
        }

       
        if (!LeadsToUpdate.isEmpty()) {
            actualizarlead(JSON.serialize(LeadsToUpdate));
        }
    }

    @future (callout=true)
    public static void actualizar(String serializedAccounts) {
        Map<String, Object> rawMap = (Map<String, Object>) JSON.deserializeUntyped(serializedAccounts);
        List<Account> accountsToUpdate = new List<Account>();

        for (String accId : rawMap.keySet()) {
            Map<String, Object> accFields = (Map<String, Object>) rawMap.get(accId);
            Account acc = new Account(Id = Id.valueOf(accId));

            if (accFields.containsKey('CC_CRC_Correo_electr_nico__c')) {
                acc.CC_CRC_Correo_electr_nico__c = (Boolean) accFields.get('CC_CRC_Correo_electr_nico__c');
            }
            if (accFields.containsKey('CC_CRC_Correo_electr_nico_Aplicaci_n__c')) {
                acc.CC_CRC_Correo_electr_nico_Aplicaci_n__c = (Boolean) accFields.get('CC_CRC_Correo_electr_nico_Aplicaci_n__c');
            }
            if (accFields.containsKey('CC_CRC_SMS__c')) {
                acc.CC_CRC_SMS__c = (Boolean) accFields.get('CC_CRC_SMS__c');
            }
            if (accFields.containsKey('CC_CRC_WhatsApp__c')) {
                acc.CC_CRC_WhatsApp__c = (Boolean) accFields.get('CC_CRC_WhatsApp__c');
            }
            if (accFields.containsKey('CC_CRC_Llamada_Celular__c')) {
                acc.CC_CRC_Llamada_Celular__c = (Boolean) accFields.get('CC_CRC_Llamada_Celular__c');
            }

            if (accFields.containsKey('CC_CRC_Llamada_Fijo__c')) {
                acc.CC_CRC_Llamada_Fijo__c = (Boolean) accFields.get('CC_CRC_Llamada_Fijo__c');
            }

            if (accFields.containsKey('CC_CRC_Llamada_Fijo__c')) {
                acc.CC_CRC_aplicacion_Fijo__c = (Boolean) accFields.get('CC_CRC_aplicacion_Fijo__c');
            }


            acc.CC_Fecha_de_consulta_Crc__c = DateTime.now();
            acc.Actualizar_CRC__c = false;
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {

           
            update accountsToUpdate;
        }
    }
    

    @future (callout=true)
    public static void actualizarlead(String serializedLeads) {
        Map<String, Object> rawMap = (Map<String, Object>) JSON.deserializeUntyped(serializedLeads);
        List<Lead> LeadsToUpdate = new List<Lead>();

        for (String leadId : rawMap.keySet()) {
            Map<String, Object> accFields = (Map<String, Object>) rawMap.get(leadId);
            Lead acc = new Lead(Id = Id.valueOf(leadId));

            if (accFields.containsKey('CC_CRC_Correo_electr_nico__c')) {
                acc.CC_CRC_Correo_electr_nico__c = (Boolean) accFields.get('CC_CRC_Correo_electr_nico__c');
            }
            if (accFields.containsKey('CC_CRC_Correo_electr_nico_Aplicaci_n__c')) {
                acc.CC_CRC_Correo_electr_nico_Aplicaci_n__c = (Boolean) accFields.get('CC_CRC_Correo_electr_nico_Aplicaci_n__c');
            }
            if (accFields.containsKey('CC_CRC_SMS__c')) {
                acc.CC_CRC_SMS__c = (Boolean) accFields.get('CC_CRC_SMS__c');
            }
            if (accFields.containsKey('CC_CRC_WhatsApp__c')) {
                acc.CC_CRC_WhatsApp__c = (Boolean) accFields.get('CC_CRC_WhatsApp__c');
            }
            if (accFields.containsKey('CC_CRC_Llamada_Celular__c')) {
                acc.CC_CRC_Llamada_Celular__c = (Boolean) accFields.get('CC_CRC_Llamada_Celular__c');
            }

            if (accFields.containsKey('CC_CRC_Llamada_Fijo__c')) {
                acc.CC_CRC_Llamada_Fijo__c = (Boolean) accFields.get('CC_CRC_Llamada_Fijo__c');
            }

            if (accFields.containsKey('CC_CRC_Llamada_Fijo__c')) {
                acc.CC_CRC_aplicacion_Fijo__c = (Boolean) accFields.get('CC_CRC_aplicacion_Fijo__c');
            }


            acc.Actualizar_CRC__c = false;
            acc.CC_Fecha_de_consulta_Crc__c = DateTime.now();
        
            LeadsToUpdate.add(acc);
        }

        if (!LeadsToUpdate.isEmpty()) {
            update LeadsToUpdate;
        }
    }

    
    public static String callDms(String strPath, String strBody, String strRequestType, String strAuthToken) {
        String strEndPoint = wsInfo.URL__c;

    
        System.debug( 'METHOD: ' + strRequestType );
        System.debug( 'ENDPOINT: ' + strEndPoint + strPath );
        System.debug( 'BODY: ' + strBody );
        System.debug( 'TOKEN: ' + strAuthToken );

        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndPoint + strPath);
        req.setMethod(strRequestType);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-type', 'application/json');
   
    
        if (strAuthToken <> null) {
            req.setHeader('Authorization', 'Bearer ' + strAuthToken.replace('"', ''));
        }
        if( strBody <> null ){
            req.setBody( strBody );
        }
    
        req.setTimeout( 120000 );
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug('este es el req ' + req);
        System.debug( response );
        System.debug( response.getBody() );
        System.debug('este es el header: '+ req.getHeader('Authorization'));
        
       /* if (response.getStatusCode() != 200) {
            throw new DmsUtilsException('Error llamando al servicio ' + strPath + ' ERROR ' + response.getStatusCode());
        }*/

    
        return response.getBody();
    }
    


    
}