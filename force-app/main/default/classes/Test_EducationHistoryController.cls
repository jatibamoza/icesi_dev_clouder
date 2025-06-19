@isTest
private class Test_EducationHistoryController {
    @isTest
    static void Test_EducationHistoryController() {
    
        
        // Create mock Account

        Ciudad__c ciudad = new Ciudad__c(
            Name = 'ejemplo',
            C_digo_de_ciudad__c = '52356'
        );
        insert ciudad;

        recordType rtpro = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        Account programa = new Account(
            recordtypeId = rtpro.Id,
            Name = 'programa',
            CC_CODIGO_BANNER__c = 'MED',
            CC_N_mero_de_registro__c = '123'

        );
        insert programa;

        recordType rtcursado = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        Account programacursado = new Account(
            recordtypeId = rtcursado.Id,
            Name = 'programacursado',
            CC_CODIGO_BANNER__c = 'OT577',
            CC_N_mero_de_registro__c = '123'

        );
        insert programacursado;


        recordType rtacu = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Acudiente_Padre' LIMIT 1];
        Account acudiente = new Account(
            FirstName = 'ACUD', 
            LastName = 'EJEMPLO', 
            PersonEmail = 'ACUD.@example.com', 
            CC_Pa_s_de_residencia_del_acudiente__c = 'CO', 
            CC_Departamento_de_residencia_del_padre__c = '52',
            CC_Ciudad_de_residencia_del_acudiente__c = ciudad.Id, 
            Phone = '1234509876', 
            PersonMobilePhone = '0987612345', 
            recordtypeId = rtacu.Id,
            hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg.@example.com',
            CC_N_mero_de_registro__c = '123'

        );
        insert acudiente;


        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
        Account acc = new Account(
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '88558',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Barrio__c = 'BARRIO',
        CC_Datos_adicionales_de_direcci_n__c = 'AdiCional',
        PersonEmail = 'ejemplo54@example.com',
        Phone = '1234567890',
        PersonMobilePhone = '0987654321',
        PersonBirthdate = Date.valueOf('2020-05-01'),
        hed__Preferred_Email__pc = 'Alternate Email',
        hed__AlternateEmail__pc= 'freg4@example.com',
        CC_N_mero_de_registro__c = '123'
        );
        insert acc;


        Contact contactCuenta = [SELECT Id FROM Contact WHERE AccountId = :acc.Id LIMIT 1];

        recordType rtuni = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Universidades' LIMIT 1];
        Account univerdidad = new Account(
            recordtypeId = rtuni.Id,
            Name = 'Universidad',
            CC_Codigo_universidad__c = 'U00005',
            CC_N_mero_de_registro__c = '00515'

        );
        insert univerdidad;

        Id ideducation = [
            SELECT Id 
            FROM RecordType 
            WHERE SObjectType = 'hed__Education_History__c'
            LIMIT 1
        ].Id;

        hed__Education_History__c gradouni  = new hed__Education_History__c(
            RecordTypeId = ideducation,
            hed__Graduation_Date__c = Date.valueOf('2020-05-01'),
            CC_Grado_de_educaci_n__c = 'PR',
            hed__Contact__c =   contactCuenta.Id,
            CC_Instituci_n_Educativa__c = univerdidad.Id
        );
          
        insert gradouni;

        hed__Education_History__c gradouni2  = new hed__Education_History__c(
            RecordTypeId = ideducation,
            hed__Graduation_Date__c = Date.valueOf('2020-05-01'),
            CC_Grado_de_educaci_n__c = 'PR',
            hed__Contact__c =   contactCuenta.Id,
            CC_Instituci_n_Educativa__c = univerdidad.Id
        );
          
        insert gradouni2;

        

        Test.startTest();
        List<hed__Education_History__c> histories = EducationHistoryController.getEducationHistories(acc.Id);
        String returnedContactId = EducationHistoryController.getContactId(acc.Id);

        EducationHistoryController.deleteEducationHistory(gradouni2.Id);
        Test.stopTest();

        
    }
}