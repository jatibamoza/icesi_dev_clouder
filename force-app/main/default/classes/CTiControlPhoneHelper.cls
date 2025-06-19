global class CTiControlPhoneHelper {
    
    webService static Account searchAccountByPhone(String phone) {
        List<Account> accountList = new List<Account>();
        /*
        for (Account account: [SELECT Id, Phone, Name FROM Account WHERE (id = :phone OR Name LIKE :('%' + phone + '%') OR phone LIKE :('%' + phone + '%')) LIMIT 10]){
            accountList.add(account);
        }
        */
        for (Account account: [SELECT Id, Phone, Name FROM Account WHERE (id = :phone OR Name LIKE :(phone) OR phone LIKE :(phone)) LIMIT 10]){
            accountList.add(account);
        }
        if(accountList.size() <= 0) return null;
        return accountList[0];
    }
    
    public static String searchIdByPhone(String phone) {
        List<sObject> combinedResults = new List<sObject>();
        for (Account account: [SELECT Id, Phone, Name FROM Account WHERE (id = :phone OR Name LIKE :(phone) OR phone LIKE :(phone)) LIMIT 10]){
            combinedResults.add(account);
        }
        for (Contact contact: [SELECT Id, Phone, Name FROM Contact WHERE (id = :phone OR Name LIKE :(phone) OR phone LIKE :(phone)) LIMIT 10]){
            combinedResults.add(contact);
        }
        for (Lead lead: [SELECT Id, Phone, Name FROM Lead WHERE (id = :phone OR Name LIKE :(phone) OR phone LIKE :(phone)) LIMIT 10]){
            combinedResults.add(lead);
        }
        
        
        if (combinedResults.isEmpty()) {
            return null;
        }
        return combinedResults[0].Id;
    }


    public class FormattedPhoneResult {
        public String CountryCode;
        public String FormattedPhone;
        public Boolean IsMobile;
        public String Message;
    }

    public static String getFormattedPhone(Id recordId, String phoneNumber) {
        if (recordId == null) {
            return null;
        }
        
        Schema.SObjectType sObjType = recordId.getSObjectType();
        String objectName = sObjType.getDescribe().getName();
        
        String prefixField = '---';
        String mobileField = '';
        String landlineField = '';
        
        if (objectName == 'Account') {
            prefixField = 'CC_Indicativo_telefonico__c';
            mobileField = 'PersonMobilePhone';
            landlineField = 'Phone';
        } else if (objectName == 'Lead') {
            prefixField = 'Indicativo_celular_aspirante__c';
            mobileField = 'MobilePhone';
            landlineField = 'Phone';
        } else if (objectName == 'Contact') {
            prefixField = 'CC_Indicativo_telefonico__c';
            mobileField = 'MobilePhone';
            landlineField = 'Phone';
        } else if (objectName == 'IndividualApplication') {
            prefixField = 'CC_Indicativo_telefonico__c';
            landlineField = 'ApplicantPhone';
            mobileField = 'CC_Mobile__c';
        } else {
            throw new IllegalArgumentException('Objeto no soportado: ' + objectName);
        }
        
        Map<String, Schema.SObjectField> fieldsMap = sObjType.getDescribe().fields.getMap();
        if (!fieldsMap.containsKey(prefixField)) {
            throw new IllegalArgumentException(
                'El campo ' + prefixField + ' no existe en el objeto ' + objectName
            );
        }
        
        
        String soql = 'SELECT ' + prefixField + ', ' + mobileField + ', ' + landlineField +
                      ' FROM ' + objectName +
                      ' WHERE Id = :recordId';
        SObject record = Database.query(soql);
        
        FormattedPhoneResult result = new FormattedPhoneResult();

        result.CountryCode = (String)record.get(prefixField);
        result.CountryCode = result.CountryCode.replaceAll('[^0-9]', '');

        if (String.isBlank(result.CountryCode)) result.CountryCode = '57';
        
        String mobileValue = (String)record.get(mobileField);
        String phoneValue = (String)record.get(landlineField);
        
        result.IsMobile = phoneNumber == mobileValue;
        if (!result.IsMobile && phoneNumber != phoneValue) {
            result.Message = 'No se encontró el número como "Phone" o "Mobile". Se usará por defecto "Mobile"...';
            result.IsMobile = true;
        }



        if (result.CountryCode == '57') {
            if(result.IsMobile) {
                // Colombia & celular => solo 57
                result.FormattedPhone = '57' + phoneNumber;
            }
            else {
                // Colombia & fijo => solo 9
                result.FormattedPhone = '9' + phoneNumber;
            }
        } else {
            // Otros países => 9 + prefijo
            result.FormattedPhone = '9' + result.CountryCode + phoneNumber;
        }

        return JSON.serialize(result);
    }
    
    
    public static void CreateCallTask(String recordId, String peerPhone, String source, String status, String destination, Integer duration, String strDate, String strTime, String direction) {
        
        if(recordId == null || recordId == 'null' || recordId == 'undefined' || recordId == '') {
            recordId = searchIdByPhone(peerPhone);
            if(recordId == null) {
                // Account newAccount = new Account();
                // newAccount.Name = 'Account ' + peerPhone; 
                // newAccount.Phone = peerPhone;
                // insert newAccount;
                // recordId = searchIdByPhone(peerPhone);
            }
        }
        
        // Listas de prefijos válidos para WhoId y WhatId
        Set<String> whoIdPrefixes = new Set<String>{'003', '00Q'}; // Contact, Lead
        Set<String> whatIdPrefixes = new Set<String>{
            '001', // Account
            '006', // Opportunity
            '500', // Case
            '701', // Campaign
            '02i', // Asset
            '800', // Contract
            '801', // Order
            '01t', // Product2
            '501', // Solution
            '0iT' // Individual Application (objeto personalizado de Icesi)
            // Agrega aquí los prefijos de objetos personalizados si es necesario
        };
        
        Task newTask = new Task();
        newTask.TaskSubtype = 'Call';
        if(recordId != null) {
            String prefix = recordId.substring(0, 3);
            // Verificar si el Id es válido para WhoId o WhatId
            if (whoIdPrefixes.contains(prefix)) {
                newTask.WhoId = recordId;
            } else if (whatIdPrefixes.contains(prefix)) {
                newTask.WhatId = recordId;
            } else {
                throw new IllegalArgumentException('El Id proporcionado no es válido para WhoId ni para WhatId.');
            }
        }
        newTask.Subject ='Call';
        newTask.Source__c = source;
        newTask.Status__c = status;
        newTask.Destination__c = destination;
        newTask.ActivityDate = Date.valueOf(strDate);
        String[] strTimeSplit = strTime.split(':');
        Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                            ,Integer.valueOf(strTimeSplit[1]) //min
                                            ,Integer.valueOf(strTimeSplit[2]) //sec
                                            ,0);                              //ms
        newTask.Hora__c = timeChange;
        newTask.Duration__c = duration;
        newTask.UniqueID__c = source;
        newTask.Tipo_de_llamada__c = direction;
        insert newTask;
    }
	
    
    /*  Example:
        String recordId = '00QWC000006Dhbs2AC';
        String peerPhone = '578';
        String source = '578';
        String status = 'ANSWERED';
        String destination = '569';
        Integer duration = 123;
		String strTime = '09:34:30';
		String strDate = '2024-07-06';
		String direction = 'Entrante';
        CTiControlPhoneHelper.CreateCallTask(recordId, peerPhone, source, status, destination, duration, strDate, strTime, direction);
    */


}