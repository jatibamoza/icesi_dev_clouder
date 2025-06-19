@isTest
private class IndividualApplicationHistoryTriggerTest {

    
    @isTest
    static void testFieldChangesCreateHistoryRecords() {

        // Crear un usuario de prueba para las relaciones Lookup(User)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
    

        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
        Account acc = new Account(
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '5484651348',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Pa_s_de_expedici_n__c = 'CO',
        CC_Barrio__c = 'BARRIO',
        CC_Datos_adicionales_de_direcci_n__c = 'AdiCional',
        PersonEmail = 'ejemplo54@example.com',
        Phone = '1234567890',
        PersonBirthdate = Date.valueOf('2020-05-01'),
           hed__Preferred_Email__pc = 'Alternate Email',
           hed__AlternateEmail__pc= 'freg4@example.com',
           CC_N_mero_de_registro__c = '123'
        );
        insert acc ;

        recordType rtpro = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        Account programa = new Account(
           recordtypeId = rtpro.Id,
           Name = 'programa',
           CC_CODIGO_BANNER__c = 'MED',
           CC_N_mero_de_registro__c = '123'

        );
        insert programa;

        AcademicTerm periodo = new AcademicTerm(
            Codigo_periodo__c = '202420',
            Name = 'periodo',
           Audiencia__c = 'PRE'
          
        );
        insert periodo;
        // Crear un registro de IndividualApplication
        IndividualApplication testApp = new IndividualApplication(
            CC_Modalidad__c = 'PRE',
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(Date.valueOf('2025-02-24'), Time.newInstance(0, 0, 0, 0)),
            CC_Origen_aplicacion__c = 'Landing Sombrilla - POS',
            AccountId = acc.Id,
            Category = 'Education',
            Status = 'Pago inscripción'
        );
        insert testApp;

        // Guardar el estado inicial
        String oldStatus = testApp.Status;

        // Nuevo valor para disparar el trigger
        String newStatus = 'Comité';

        // Capturar el ID del usuario que ejecuta la prueba
        Id currentUserId = UserInfo.getUserId();

        // Modificar un campo con Track History activado
        testApp.Status = newStatus;
        update testApp;
        


    }
	
    // Cuando se cambia es un usuario
    @isTest
    static void testFieldChangesCreateHistoryRecordsChangeUser() {

        // Crear un usuario de prueba para las relaciones Lookup(User)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUserOwner1 = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser1@example.com',
            Username = 'testuser1@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUserOwner1;
        
        User testUserOwner2 = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser2@example.com',
            Username = 'testuser2@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUserOwner2;
    

        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
        Account acc = new Account(
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '5484651348',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Pa_s_de_expedici_n__c = 'CO',
        CC_Barrio__c = 'BARRIO',
        CC_Datos_adicionales_de_direcci_n__c = 'AdiCional',
        PersonEmail = 'ejemplo54@example.com',
        Phone = '1234567890',
        PersonBirthdate = Date.valueOf('2020-05-01'),
           hed__Preferred_Email__pc = 'Alternate Email',
           hed__AlternateEmail__pc= 'freg4@example.com',
           CC_N_mero_de_registro__c = '123'
        );
        insert acc ;

        recordType rtpro = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        Account programa = new Account(
           recordtypeId = rtpro.Id,
           Name = 'programa',
           CC_CODIGO_BANNER__c = 'MED',
           CC_N_mero_de_registro__c = '123'

        );
        insert programa;

        AcademicTerm periodo = new AcademicTerm(
            Codigo_periodo__c = '202420',
            Name = 'periodo',
           Audiencia__c = 'PRE'
          
        );
        insert periodo;
        // Crear un registro de IndividualApplication
        IndividualApplication testApp = new IndividualApplication(
            CC_Modalidad__c = 'PRE',
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(Date.valueOf('2025-02-24'), Time.newInstance(0, 0, 0, 0)),
            CC_Origen_aplicacion__c = 'Landing Sombrilla - POS',
            AccountId = acc.Id,
            Category = 'Education',
            Status = 'Pago inscripción',
            OwnerId = testUserOwner1.Id
        );
        insert testApp;

        // Guardar el estado inicial
        Id oldOwner = testApp.OwnerId;

        // Nuevo valor para disparar el trigger
        String newOwner = testUserOwner2.Id;

        // Capturar el ID del usuario que ejecuta la prueba
        Id currentUserId = UserInfo.getUserId();

        // Modificar un campo con Track History activado
        testApp.OwnerId = newOwner;
        update testApp;
        


    }
    
    
    
}