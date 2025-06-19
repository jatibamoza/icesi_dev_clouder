@isTest
private class TestActualizaBanner {

    @isTest
    static void Test_actualizacuenta() {
    
        
        // Create mock Account

        Ciudad__c pais = new Ciudad__c(
            Name = 'pais',
            CC_Codigo_pais__c = '1454'
        );
        Ciudad__c pais2 = new Ciudad__c(
            Name = 'pais',
            CC_Codigo_pais__c = '1848'
        );
        insert pais2;
        Ciudad__c departamento = new Ciudad__c(
            Name = 'departamento',
            C_digo_de_departamento__c = '1475'
        );
        Ciudad__c departamento2 = new Ciudad__c(
            Name = 'departamento',
            C_digo_de_departamento__c = '5845615'
        );
        insert departamento2;
        Ciudad__c ciudad = new Ciudad__c(
            Name = 'ciudad',
            C_digo_de_ciudad__c = '789'
        );
        insert ciudad;
        Ciudad__c ciudad2 = new Ciudad__c(
            Name = 'ciudad',
            C_digo_de_ciudad__c = '8992'
        );
        insert ciudad2;

        recordType rtcolegio = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Colegios' LIMIT 1];
        Account colegio = new Account(
            recordtypeId = rtcolegio.Id,
            CC_CODIGO_BANNER__c = 'C00002',
            Name = 'colegio',
            CC_N_mero_de_registro__c = '145'

        );
        insert colegio;

        recordType rtuni = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Universidades' LIMIT 1];
        Account univerdidad= new Account(
            recordtypeId = rtuni.Id,
            Name = 'Universidad',
            CC_Codigo_universidad__c = 'U00005',
            CC_N_mero_de_registro__c = '00515'

        );
        insert univerdidad;

        recordType rtpro = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        Account programa = new Account(
            recordtypeId = rtpro.Id,
            Name = 'programa',
            CC_CODIGO_BANNER__c = 'MED',
            CC_N_mero_de_registro__c = '8413'

        );
        insert programa;

        recordType rtcursado = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        Account programacursado = new Account(
            recordtypeId = rtcursado.Id,
            Name = 'programacursado',
            CC_CODIGO_BANNER__c = 'OT577',
            CC_N_mero_de_registro__c = '489415'

        );
        insert programacursado;

        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
        Account acc = new Account(
        CC_Graduado__c = true,
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '12345674852',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',

        Country__c = pais.Id,
        Department__c = departamento.Id,
        City__c = ciudad.Id,
        CC_Direcci_n__c = '123',
        CC_Barrio__c = 'BARRIO',
        CC_Datos_adicionales_de_direcci_n__c = 'AdiCional',
        PersonEmail = 'DAN@example.com',
        Phone = '1234567890',
        PersonMobilePhone = '0987654321',
        PersonBirthdate = Date.valueOf('2020-05-01'),
        hed__Preferred_Email__pc = 'Alternate Email',
        hed__AlternateEmail__pc= 'freg4@example.com',
        CC_N_mero_de_registro__c = '123',
        CC_Autorizaci_n_de_datos__c = false
        );
        insert acc;

        
        acc.Country__c = pais2.Id;
        acc.Department__c = departamento2.Id;
        acc.City__c = ciudad2.Id;
        acc.CC_Barrio__c = 'otro barrio';
        acc.CC_Direcci_n__c =  'otra direccion';
        acc.CC_Datos_adicionales_de_direcci_n__c =  'otro complemento dirección';
        acc.hed__AlternateEmail__pc= 'cambio@example.com';
        acc.Phone= '56416527';
        acc.CC_Indicativo_telefonico__c = 'USA: +1';
        acc.CC_Estado_civil__c = '1';
        acc.CC_Autorizaci_n_de_datos__c = true;
        acc.CC_Emprendedor__c = true;

        update acc;  // Actualizar la cuenta en Salesforce
        
        Account acc2 = new Account(
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '514451',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Acudiente__c = acc.Id,
        CC_Fecha_nacimiento__c = Date.valueOf('2020-05-01'),
        CC_Tipo_de_persona__c = 'Hij@'
 
        );
        insert acc2;

    Account acc3 = new Account(
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '47752',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Acudiente__c = acc.Id,
        CC_Fecha_nacimiento__c = Date.valueOf('2020-05-01'),
        CC_Tipo_de_persona__c = 'Hij@'
    
    );
    insert acc3;

        Contact contactAcudiente = [SELECT Id FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
        Contact contactHijo = [SELECT Id FROM Contact WHERE AccountId = :acc2.Id LIMIT 1];
        Contact contactHijo2 = [SELECT Id FROM Contact WHERE AccountId = :acc3.Id LIMIT 1];      
        
        // Crear la relación entre los contactos
        hed__Relationship__c hijo = new hed__Relationship__c(
            hed__Contact__c = contactAcudiente.Id,
            hed__RelatedContact__c = contactHijo.Id,
            hed__Type__c = 'Hijo'
        );
        insert hijo;

        // Crear la relación entre los contactos
        hed__Relationship__c hijo2 = new hed__Relationship__c(
            hed__Contact__c = contactAcudiente.Id,
            hed__RelatedContact__c = contactHijo2.Id,
            hed__Type__c = 'Hijo'
        );
        insert hijo2;

        delete hijo2;
        delete acc3;
   
        acc2.FirstName = 'NOMBRE';
        acc2.LastName = 'EJEMPLO';
        acc2.CC_Fecha_nacimiento__c = Date.valueOf('2020-05-02');

        update acc2;  // Actualizar la cuenta en Salesforce

       

         // Crear trabajo
         Trabajo__c trabajo = new Trabajo__c(
            CC_Cuenta__c = acc.Id,
            CC_Ano_de_ingreso__c = '2025',
            CC_Desde_el_mes__c = '05',
            CC_Correo_Empresarial__c = 'uno@gmail.com'
        );
        insert trabajo;

           // Crear trabajo
        Trabajo__c trabajo2 = new Trabajo__c(
            CC_Cuenta__c = acc.Id,
            CC_Ano_de_ingreso__c = '2025',
            CC_Desde_el_mes__c = '06',
            CC_Correo_Empresarial__c = 'dos@gmail.com'
        );
        insert trabajo2;

        // actualizar trabajo
        trabajo2.CC_Ano_de_ingreso__c = '2026';
        trabajo2.CC_Desde_el_mes__c = '08';
        update trabajo2;


        delete trabajo;

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
            hed__Contact__c =   contactAcudiente.Id,
            CC_Instituci_n_Educativa__c = univerdidad.Id
        );
          
        insert gradouni;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockHttpCallout());


        
        Test.stopTest();

    }
}