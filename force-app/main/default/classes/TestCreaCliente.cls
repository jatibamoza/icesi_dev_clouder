@isTest
private class TestCreaCliente {


    @isTest
    static void testCallDms() {
        // Configura el mock

        Test.setMock(HttpCalloutMock.class, new mockHttpCallout());
        CC_Datos_Banner__mdt datos = [SELECT clientId__c, clientSecret__c,CC_End_Point__c FROM CC_Datos_Banner__mdt LIMIT 1];
        
        String resultado = Banner.callDms('/auth/token?clientId=' + datos.clientId__c + '&clientSecret=' + datos.clientSecret__c,null, 'POST', null);
        
    }
    @isTest
    static void testcliente() {
       
         
         // Create mock Account
  
         Ciudad__c ciudad = new Ciudad__c(
            Name = 'ejemplo',
            C_digo_de_ciudad__c = '52356'
         );
         insert ciudad;

         recordType rtcolegio = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Colegios' LIMIT 1];
         Account colegio = new Account(
            recordtypeId = rtcolegio.Id,
            CC_CODIGO_BANNER__c = 'C00002',
            Name = 'colegio',
            CC_N_mero_de_registro__c = '123'

         );
         insert colegio;

         recordType rtuni = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Universidades' LIMIT 1];
         Account univerdidad= new Account(
            recordtypeId = rtuni.Id,
            Name = 'Universidad',
            CC_Codigo_universidad__c = 'U00005',
            CC_N_mero_de_registro__c = '123'

         );
         insert univerdidad;

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
         CC_ACC_N_mero_id__c = '123456',
         CC_Acc_Tipo_id__c = 'CC',
         FirstName = 'NOMBRE',
         LastName = 'EJEMPLO',
         CC_Pa_s_de_expedici_n__c = 'CO',
         CC_Departamento_de_expedici_n__c = '52',
         CC_Ciudad_de_expedici_n__c = ciudad.Id,
         CC_Nacionalidad__c = 'CO',
         CC_Pa_s_de_nacimiento__c = 'CO',
         CC_Departamento_nacimiento__c = '52',
         CC_Ciudad_de_nacimiento__c = ciudad.Id,
         CC_E_P_S__c = '28',
         CC_Estrato__c = '3',
         CC_Grupo_sanguineo__c = 'OP',
         CC_G_nero__c = 'M',
         CC_Etnia__c = 'AF',
         CC_Benefeciario_ley_veterano__c = 'Si',
         CC_Programa_de_inter_s__c = programa.Id ,
         CC_Parentesco_del__c = 'HI',
    
         CC_CODIGO_ICFES__c = 123,
         CC_Pa_s_cuenta__c = 'CO',
         CC_Departamento__c = '52',
         CC_Ciudad__c = ciudad.Id,
         CC_Direcci_n__c = '123',
         CC_Barrio__c = 'BARRIO',
         CC_Datos_adicionales_de_direcci_n__c = 'AdiCional',
         PersonEmail = 'DAN@example.com',
         Phone = '1234567890',
         PersonMobilePhone = '0987654321',
         CC_Colegio__c = colegio.Id,
         CC_Universidad_de_procedencia__c = univerdidad.Id,
         CC_Tipo_de_examen__c = 'ICFES',
     
         CC_Puntaje_Global_ICFES_P__c = '242',
         CC_Acudiente__c = acudiente.Id,
         Persona_con_discapacidad__c = 'Si',
         CC_Discapacidad__c = '45',

         CC_Programa_que_se_estaba_cursando__c = programacursado.Id,
         PersonBirthdate = Date.valueOf('2020-05-01'),
            hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg4@example.com',
            CC_N_mero_de_registro__c = '123'
         );
         insert acc;

        

        AcademicTerm periodo = new AcademicTerm(
            Codigo_periodo__c = '202420',
            Name = 'periodo'
        );
        insert periodo;


       
        Account mamacuen = new Account(
           FirstName = 'ACUD', 
           LastName = 'EJEMPLO', 
           PersonEmail = 'ama.@example.com', 
           CC_Pa_s_de_residencia_del_acudiente__c = 'CO', 
           CC_Departamento_de_residencia_del_padre__c = '52',
           CC_Ciudad_de_residencia_del_acudiente__c = ciudad.Id, 
           Phone = '1234509876', 
           PersonMobilePhone = '0987612345', 
           recordtypeId = rtcuenta .Id,
           hed__Preferred_Email__pc = 'Alternate Email',
           hed__AlternateEmail__pc= 'freg.@example.com',
           CC_N_mero_de_registro__c = '4568541'

        );
        insert mamacuen;

        Account apacuen = new Account(
           FirstName = 'ACUD', 
           LastName = 'EJEMPLO', 
           PersonEmail = 'apa.@example.com', 
           CC_Pa_s_de_residencia_del_acudiente__c = 'CO', 
           CC_Departamento_de_residencia_del_padre__c = '52',
           CC_Ciudad_de_residencia_del_acudiente__c = ciudad.Id, 
           Phone = '1234509876', 
           PersonMobilePhone = '0987612345', 
           recordtypeId = rtcuenta .Id,
           hed__Preferred_Email__pc = 'Alternate Email',
           hed__AlternateEmail__pc= 'freg.@example.com',
           CC_N_mero_de_registro__c = '89489'

        );
        insert apacuen;
        

        Contact contactpapa = [SELECT Id FROM Contact WHERE AccountId = :apacuen.Id LIMIT 1];
        Contact contactmama = [SELECT Id FROM Contact WHERE AccountId = :mamacuen.Id LIMIT 1];      
        
        Contact contacthijo = [SELECT Id FROM Contact WHERE AccountId = :acc.Id LIMIT 1];      
        
        // Crear la relación entre los contactos
        hed__Relationship__c mama = new hed__Relationship__c(
            hed__Contact__c = contactmama.Id,
            hed__RelatedContact__c = contactHijo.Id,
            hed__Type__c = 'Madre'
        );
        insert mama;

          // Crear la relación entre los contactos
          hed__Relationship__c papa = new hed__Relationship__c(
            hed__Contact__c = contactpapa.Id,
            hed__RelatedContact__c = contactHijo.Id,
            hed__Type__c = 'Padre'
        );
        insert papa;
        
         IndividualApplication IA = new IndividualApplication(
            AccountId = acc.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(
                2020, 10, 21, 17, 0, 0
            ),
            Status = 'Pago inscripción',
            Category = 'Education'
         );
         insert IA;
         
         Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockHttpCallout());

        // Llamar al método creacliente
        Banner.CreacionCliente(IA.Id);
        
        Test.stopTest();
        
    }

    @isTest
    static void testclienteposgrado() {
       
         
         // Create mock Account
  
         Ciudad__c ciudad = new Ciudad__c(
            Name = 'ejemplo',
            C_digo_de_ciudad__c = '52356'
         );
         insert ciudad;

         recordType rtcolegio = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Colegios' LIMIT 1];
         Account colegio = new Account(
            recordtypeId = rtcolegio.Id,
            CC_CODIGO_BANNER__c = 'C00002',
            Name = 'colegio',
            CC_N_mero_de_registro__c = '123'

         );
         insert colegio;

         recordType rtuni = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Universidades' LIMIT 1];
         Account univerdidad= new Account(
            recordtypeId = rtuni.Id,
            Name = 'Universidad',
            CC_Codigo_universidad__c = 'U00005',
            CC_N_mero_de_registro__c = '123'

         );
         insert univerdidad;

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
            CC_N_mero_de_registro__c = '123',
            CC_Pertenece_a_ICESI__c = true,
            Tipo_de_programa__c = 'POS'
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
         CC_ACC_N_mero_id__c = '5484651348',
         CC_Acc_Tipo_id__c = 'CC',
         FirstName = 'NOMBRE',
         LastName = 'EJEMPLO',
         CC_Pa_s_de_expedici_n__c = 'CO',
         CC_Departamento_de_expedici_n__c = '52',
         CC_Ciudad_de_expedici_n__c = ciudad.Id,
         CC_Nacionalidad__c = 'CO',
         CC_Pa_s_de_nacimiento__c = 'CO',
         CC_Departamento_nacimiento__c = '52',
         CC_Ciudad_de_nacimiento__c = ciudad.Id,
         CC_E_P_S__c = '28',
         CC_Estrato__c = '3',
         CC_Grupo_sanguineo__c = 'OP',
         CC_G_nero__c = 'M',
         CC_Etnia__c = 'AF',
         CC_Benefeciario_ley_veterano__c = 'Si',
         CC_Programa_de_inter_s__c = programa.Id ,
         CC_Parentesco_del__c = 'HI',
       
         CC_CODIGO_ICFES__c = 123,
         CC_Pa_s_cuenta__c = 'CO',
         CC_Departamento__c = '52',
         CC_Ciudad__c = ciudad.Id,
         CC_Direcci_n__c = '123',
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

         Contact acccontact = [SELECT Id FROM Contact WHERE AccountId = :acc.Id LIMIT 1];

        AcademicTerm periodo = new AcademicTerm(
            Codigo_periodo__c = '202420',
            Name = 'periodo',
            Audiencia__c = 'POS'
        );
        insert periodo;

        RecordType tipo = [SELECT Id, Name, SObjectType FROM RecordType WHERE DeveloperName = 'Posgrado' AND SObjectType = 'IndividualApplication' LIMIT 1];

        IndividualApplication IA = new IndividualApplication(
            RecordTypeId = tipo.Id,
            AccountId = acc.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
            Status = 'Pago inscripción',
            Category = 'Education',
            Carrera_de_mayor_interes__c = programacursado.Id
        );
        insert IA;

           // Crear trabajo
        Trabajo__c trabajo = new Trabajo__c(
            CC_Cuenta__c = acc.Id,
            CC_Ano_de_ingreso__c = '2025',
            CC_Desde_el_mes__c = '05',
            CC_Correo_Empresarial__c = 'hol@gmail.com'
        );

        insert trabajo;

        Id ideducation = [
            SELECT Id 
            FROM RecordType 
            WHERE SObjectType = 'hed__Education_History__c'
            LIMIT 1
        ].Id;

        Contact contactoacc = [SELECT Id FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
        hed__Education_History__c gradouni  = new hed__Education_History__c(
            RecordTypeId = ideducation,
            hed__Graduation_Date__c = Date.valueOf('2020-05-01'),
            CC_Grado_de_educaci_n__c = 'PR',
        
            hed__Contact__c = contactoacc.Id
        );
          
        insert gradouni;


         Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockHttpCallout());

        // Llamar al método creacliente
        Banner.CreacionCliente(IA.Id);
        
        Test.stopTest();
        
    }

    @isTest
    static void testadmision() {
       
  
      
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
            Name = 'periodo'
        );
        insert periodo;

        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
         Account acc = new Account(
         recordtypeId = rtcuenta .Id,
         CC_ACC_N_mero_id__c = '123456888',
         FirstName = 'NOMBRE',
         LastName = 'EJEMPLO',
         CC_Programa_de_inter_s__c = programa.Id ,
         hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg5@example.com',
            CC_N_mero_de_registro__c = '123'
         );
         insert acc;
  
 
         IndividualApplication IA = new IndividualApplication(
            AccountId = acc.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
            Status = 'Pago inscripción',
            Category = 'Education'
         );
         insert IA;

         Account acc2 = new Account(
            recordtypeId = rtcuenta .Id,
            CC_ACC_N_mero_id__c = '123456884',
            FirstName = 'NOMBRE',
            LastName = 'EJEMPLO',
            CC_Programa_de_inter_s__c = programa.Id ,
            hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg6@example.com',
            CC_N_mero_de_registro__c = '123'
        );
        insert acc2;
     
    
        IndividualApplication IA2 = new IndividualApplication(
            AccountId = acc2.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
            Status = 'No admitido',
            Category = 'Education',
            Causa_de_no_admisi_n__c = '45'
        );
        insert IA2;

        Account acc3 = new Account(
            recordtypeId = rtcuenta .Id,
            CC_ACC_N_mero_id__c = '12345688488',
            FirstName = 'NOMBRE',
            LastName = 'EJEMPLO',
            CC_Programa_de_inter_s__c = programa.Id ,
            hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg7@example.com',
            CC_N_mero_de_registro__c = '1234'
        );
        insert acc3;
     
    
        IndividualApplication IA3 = new IndividualApplication(
            AccountId = acc3.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
            Status = 'Desiste',
            Category = 'Education',
            Causa_de__c = '55'
        );
        insert IA3;
         
         Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockHttpCallout());

        // Llamar al método admision comite
        Banner.admision(IA.Id);
         // Llamar al método admision NO ADMITIDO
         Banner.admision(IA2.Id);
          // Llamar al método admision DESISTE
        Banner.admision(IA3.Id);
        
        Test.stopTest();
        
    }

    @isTest
    static void testAdmisionllamada() {
      // Set up test data

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
            Name = 'periodo'
        );
        insert periodo;

        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
         Account acc = new Account(
         recordtypeId = rtcuenta .Id,
         CC_ACC_N_mero_id__c = '123456888',
         FirstName = 'NOMBRE',
         LastName = 'EJEMPLO',
         CC_Programa_de_inter_s__c = programa.Id ,
         hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg5@example.com',
            CC_N_mero_de_registro__c = '123'
         );
         insert acc;
  
 
         IndividualApplication IA = new IndividualApplication(
            AccountId = acc.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
            Status = 'Desiste',
            Category = 'Education',
            Causa_de__c = '25'
         );
         insert IA;

         

      LlamaAdmision.InputVariables inputVar = new LlamaAdmision.InputVariables();
      inputVar.Individualapp = IA.Id;
      List<LlamaAdmision.InputVariables> inputList = new List<LlamaAdmision.InputVariables>{inputVar};

      // Call the method to be tested
      Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
      Test.startTest();
      LlamaAdmision.admision(inputList);
      Test.stopTest();
    }


    @isTest
    static void testFormulariollamada() {
      // Set up test data
      Ciudad__c ciudad = new Ciudad__c(
         Name = 'ejemplo',
         C_digo_de_ciudad__c = '52356'
      );
      insert ciudad;

      recordType rtcolegio = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Colegios' LIMIT 1];
      Account colegio = new Account(
         recordtypeId = rtcolegio.Id,
         CC_CODIGO_BANNER__c = 'C00002',
         Name = 'colegio',
            CC_N_mero_de_registro__c = '123'

      );
      insert colegio;

      recordType rtuni = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Universidades' LIMIT 1];
      Account univerdidad= new Account(
         recordtypeId = rtuni.Id,
         Name = 'Universidad',
         CC_Codigo_universidad__c = 'U00005',
            CC_N_mero_de_registro__c = '123'

      );
      insert univerdidad;

      recordType rtpro = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
      Account programa = new Account(
         recordtypeId = rtpro.Id,
         Name = 'programa',
         CC_CODIGO_BANNER__c = 'MED',
            CC_N_mero_de_registro__c = '123'

      );
      insert programa;

    // Obtener RecordType para 'Academic Program' en Account
        RecordType rtcursado = [
            SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1
        ];

        // Crear cuenta del programa de mayor interés
        Account programacursado = new Account(
            RecordTypeId = rtcursado.Id,
            Name = 'programacursado',
            CC_CODIGO_BANNER__c = 'OT577',
            CC_N_mero_de_registro__c = '123',
            CC_Pertenece_a_ICESI__c = true,
            Tipo_de_programa__c = 'POS' ,  
            Lista_de_documentos__c = 'CPI01;FTD34;FDID1;CLABR;CNPGR;FTPPR;RSBPR;HVACT;ENSAY;PINVE;CREC1;CREC2;OTDOC;RSSOC;CRREH;FNPGD;FTPGD'


        );
        insert programacursado;

        // Crear cuenta del programa de mayor interés
        Account programacursado2 = new Account(
            RecordTypeId = rtcursado.Id,
            Name = 'programacursado',
            CC_CODIGO_BANNER__c = 'OT577',
            CC_N_mero_de_registro__c = '123',
            CC_Pertenece_a_ICESI__c = true,
            Tipo_de_programa__c = 'PRE' 
    
        );
        insert programacursado2;


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
        CC_ACC_N_mero_id__c = '123456',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Pa_s_de_expedici_n__c = 'CO',
        CC_Departamento_de_expedici_n__c = '52',
        CC_Ciudad_de_expedici_n__c = ciudad.Id,
        CC_Nacionalidad__c = 'CO',
        CC_Pa_s_de_nacimiento__c = 'CO',
        CC_Departamento_nacimiento__c = '52',
        CC_Ciudad_de_nacimiento__c = ciudad.Id,
        CC_E_P_S__c = '28',
        CC_Estrato__c = '3',
        CC_Grupo_sanguineo__c = 'OP',
        CC_G_nero__c = 'M',
        CC_Etnia__c = 'AF',
        CC_Benefeciario_ley_veterano__c = 'Si',
        CC_Programa_de_inter_s__c = programa.Id ,
        CC_Parentesco_del__c = 'HI',
        CC_Puntaje_Global_ICFES__c = 300,
        CC_CODIGO_ICFES__c = 123,
        CC_Pa_s_cuenta__c = 'CO',
        CC_Departamento__c = '52',
        CC_Ciudad__c = ciudad.Id,
        CC_Direcci_n__c = '123',
        CC_Barrio__c = 'BARRIO',
        CC_Datos_adicionales_de_direcci_n__c = 'AdiCional',
        PersonEmail = 'DAN@example.com',
        Phone = '1234567890',
        PersonMobilePhone = '0987654321',
        CC_Colegio__c = colegio.Id,
        CC_Universidad_de_procedencia__c = univerdidad.Id,

        CC_Acudiente__c = acudiente.Id,
        Persona_con_discapacidad__c = 'Si',
        CC_Discapacidad__c = '45',
        PersonBirthdate = Date.valueOf('2020-05-01'),
            hed__Preferred_Email__pc = 'Alternate Email',
            hed__AlternateEmail__pc= 'freg4@example.com',
                CC_N_mero_de_registro__c = '123'
        );
        insert acc;



        AcademicTerm periodo = new AcademicTerm(
            Codigo_periodo__c = '202420',
            Name = 'periodo'
        );
        insert periodo;
        
        // Obtener RecordType para 'Admissions' en IndividualApplication
            RecordType rtAdmissions = [
                SELECT Id FROM RecordType WHERE SObjectType = 'IndividualApplication' AND DeveloperName = 'Posgrado' LIMIT 1
            ];
            // Obtener RecordType para 'Admissions' en IndividualApplication
            RecordType rtAdmissions2 = [
                SELECT Id FROM RecordType WHERE SObjectType = 'IndividualApplication' AND DeveloperName = 'Admissions' LIMIT 1
            ];

            // Crear la aplicación individual asignando Carrera_de_mayor_interes__c
            IndividualApplication IA = new IndividualApplication(
                AccountId = acc.Id,
                RecordTypeId = rtAdmissions.Id, // Asegurar que se usa el RecordType correcto
                CC_Periodo_academico__c = periodo.Id,
                AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
                Status = 'Pago inscripción',
                Category = 'Education',
                Carrera_de_mayor_interes__c = programacursado.Id // Asignar correctamente el programa de mayor interés
            );
            insert IA;

            // Crear la aplicación individual asignando Carrera_de_mayor_interes__c
            IndividualApplication IA2 = new IndividualApplication(
                AccountId = acc.Id,
                RecordTypeId = rtAdmissions2.Id, // Asegurar que se usa el RecordType correcto
                CC_Periodo_academico__c = periodo.Id,
                AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
                Status = 'Pago inscripción',
                Category = 'Education',
                Carrera_de_mayor_interes__c = programacursado2.Id // Asignar correctamente el programa de mayor interés
            );
            insert IA2;

        // documentos

            // Crear un documento de prueba relacionado con la cuenta
            ContentVersion contentVersion = new ContentVersion(
                Title = 'cedula',
                PathOnClient = 'cedula.pdf',
                VersionData = Blob.valueOf('Test content'), 
                FirstPublishLocationId = acc.Id
            );
            insert contentVersion;
            
            // Obtener el ContentDocumentId del ContentVersion recién creado
            ContentDocument contentDocument = [
                SELECT Id 
                FROM ContentDocument 
                WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id)
                LIMIT 1
            ];

            // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
            List<ContentDocumentLink> existingLinks = [
                SELECT Id 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :acc.Id 
                AND ContentDocumentId = :contentDocument.Id
            ];
            
            if (existingLinks.isEmpty()) {
                // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
                ContentDocumentLink contentDocumentLink = new ContentDocumentLink(
                    LinkedEntityId = acc.Id,
                    ContentDocumentId = contentDocument.Id,
                    ShareType = 'V'
                );
                insert contentDocumentLink;
            }
        
            
            // Crear un documento de prueba relacionado con la cuenta
            ContentVersion contentVersion2 = new ContentVersion(
                Title = 'icfes',
                PathOnClient = 'icfes.pdf',
                VersionData = Blob.valueOf('Test content'), 
                FirstPublishLocationId = acc.Id
            );
            insert contentVersion2;
            
            // Obtener el ContentDocumentId del ContentVersion recién creado
            ContentDocument contentDocument2 = [
                SELECT Id 
                FROM ContentDocument 
                WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion2.Id)
                LIMIT 1
            ];

            // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
            List<ContentDocumentLink> existingLinks2 = [
                SELECT Id 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :acc.Id 
                AND ContentDocumentId = :contentDocument2.Id
            ];
            
            if (existingLinks2.isEmpty()) {
                // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
                ContentDocumentLink contentDocumentLink2 = new ContentDocumentLink(
                    LinkedEntityId = acc.Id,
                    ContentDocumentId = contentDocument2.Id,
                    ShareType = 'V'
                );
                insert contentDocumentLink2;
            }
        
            // Crear un documento de prueba relacionado con la cuenta
            ContentVersion contentVersion3 = new ContentVersion(
                Title = 'servicios',
                PathOnClient = 'servicios.pdf',
                VersionData = Blob.valueOf('Test content'), 
                FirstPublishLocationId = acc.Id
            );
            insert contentVersion3;
            
            // Obtener el ContentDocumentId del ContentVersion recién creado
            ContentDocument contentDocument3 = [
                SELECT Id 
                FROM ContentDocument 
                WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion3.Id)
                LIMIT 1
            ];

            // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
            List<ContentDocumentLink> existingLinks3 = [
                SELECT Id 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :acc.Id 
                AND ContentDocumentId = :contentDocument3.Id
            ];
            
            if (existingLinks3.isEmpty()) {
                // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
                ContentDocumentLink contentDocumentLink3 = new ContentDocumentLink(
                    LinkedEntityId = acc.Id,
                    ContentDocumentId = contentDocument3.Id,
                    ShareType = 'V'
            );
            insert contentDocumentLink3;
        }
    
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion4 = new ContentVersion(
            Title = 'notas',
            PathOnClient = 'notas.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion4;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument4 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion4.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks4 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument4.Id
        ];
        
        if (existingLinks4.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink4 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument4.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink4;
        }
    
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion5 = new ContentVersion(
            Title = 'fotos',
            PathOnClient = 'fotos.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion5;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument5 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion5.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks5 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument5.Id
        ];
        
        if (existingLinks5.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink5 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument5.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink5;
        }
    
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion6 = new ContentVersion(
            Title = 'pago',
            PathOnClient = 'pago.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion6;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument6 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion6.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks6 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument6.Id
        ];
        
        if (existingLinks6.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink6 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument6.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink6;
        }

        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion7 = new ContentVersion(
            Title = 'CPI01',
            PathOnClient = 'CPI01.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion7;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument7 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion7.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks7 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument7.Id
        ];
        
        if (existingLinks7.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink7 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument7.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink7;
        }
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion8 = new ContentVersion(
            Title = 'FTD34',
            PathOnClient = 'FTD34.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion8;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument8 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion8.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks8 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument8.Id
        ];
        
        if (existingLinks8.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink8 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument8.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink8;
        }
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion9 = new ContentVersion(
            Title = 'PINVE',
            PathOnClient = 'PINVE.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion9;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument9 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion9.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks9 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument9.Id
        ];
        
        if (existingLinks9.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink9 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument9.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink9;
        }
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion10 = new ContentVersion(
            Title = 'FDID1',
            PathOnClient = 'FDID1.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion10;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument10 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion10.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks10 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument10.Id
        ];
        
        if (existingLinks10.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink10 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument10.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink10;
        }
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion11 = new ContentVersion(
            Title = 'CLABR',
            PathOnClient = 'CLABR.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion11;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument11 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion11.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks11 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument11.Id
        ];
        
        if (existingLinks11.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink11 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument11.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink11;
        }
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion12 = new ContentVersion(
            Title = 'CNPGR',
            PathOnClient = 'CNPGR.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion12;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument12 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion12.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks12 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument12.Id
        ];
        
        if (existingLinks12.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink12 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument12.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink12;
        }
      
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion13 = new ContentVersion(
            Title = 'FTPPR',
            PathOnClient = 'FTPPR.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion13;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument13 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion13.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks13 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument13.Id
        ];
        
        if (existingLinks13.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink13 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument13.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink13;
        }
       
        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion14 = new ContentVersion(
            Title = 'HVACT',
            PathOnClient = 'HVACT.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion14;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument14 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion14.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks14 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument14.Id
        ];
        
        if (existingLinks14.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink14 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument14.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink14;
        }
    
          // Crear un documento de prueba relacionado con la cuenta
          ContentVersion contentVersion15 = new ContentVersion(
            Title = 'ENSAY',
            PathOnClient = 'ENSAY.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion15;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument15 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion15.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks15 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument15.Id
        ];
        
        if (existingLinks15.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink15 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument15.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink15;
        }
         // Crear un documento de prueba relacionado con la cuenta
         ContentVersion contentVersion16 = new ContentVersion(
            Title = 'RSBPR',
            PathOnClient = 'RSBPR.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion16;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument16 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion16.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks16 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument16.Id
        ];
        
        if (existingLinks16.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink16 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument16.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink16;
        }

        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion20 = new ContentVersion(
            Title = 'RSSOC',
            PathOnClient = 'RSSOC.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion20;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument20 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion20.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks20 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument20.Id
        ];
        
        if (existingLinks20.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink20 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument20.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink20;
        }

        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion17 = new ContentVersion(
            Title = 'crec1',
            PathOnClient = 'crec1.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion17;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument17 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion17.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks17 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument17.Id
        ];
        
        if (existingLinks17.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink17 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument17.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink17;
        }

        // Crear un documento de prueba relacionado con la cuenta
        ContentVersion contentVersion18 = new ContentVersion(
            Title = 'crec2',
            PathOnClient = 'crec2.pdf',
            VersionData = Blob.valueOf('Test content'), 
            FirstPublishLocationId = acc.Id
        );
        insert contentVersion18;
        
        // Obtener el ContentDocumentId del ContentVersion recién creado
        ContentDocument contentDocument18 = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion18.Id)
            LIMIT 1
        ];

        // Verificar si ya existe el vínculo con la cuenta para evitar duplicados
        List<ContentDocumentLink> existingLinks18 = [
            SELECT Id 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id 
            AND ContentDocumentId = :contentDocument18.Id
        ];
        
        if (existingLinks18.isEmpty()) {
            // Vincular el documento con la cuenta usando ContentDocumentLink si no existe
            ContentDocumentLink contentDocumentLink18 = new ContentDocumentLink(
                LinkedEntityId = acc.Id,
                ContentDocumentId = contentDocument18.Id,
                ShareType = 'V'
            );
            insert contentDocumentLink18;
        }

    

      LlamadoFormulario.InputVariables inputVar = new LlamadoFormulario.InputVariables();
      inputVar.Individualapp = IA.Id;
      List<LlamadoFormulario.InputVariables> inputList = new List<LlamadoFormulario.InputVariables>{inputVar};

      LLamadocumentos.InputVariables inputVar2 = new LLamadocumentos.InputVariables();
      inputVar2.Individualapp = IA.Id;
      List<LLamadocumentos.InputVariables> inputList2 = new List<LLamadocumentos.InputVariables>{inputVar2};



      LlamadoFormulario.InputVariables inputVar3 = new LlamadoFormulario.InputVariables();
      inputVar3.Individualapp = IA2.Id;
      List<LlamadoFormulario.InputVariables> inputList3 = new List<LlamadoFormulario.InputVariables>{inputVar3};

      LLamadocumentos.InputVariables inputVar4 = new LLamadocumentos.InputVariables();
      inputVar4.Individualapp = IA2.Id;
      List<LLamadocumentos.InputVariables> inputList4 = new List<LLamadocumentos.InputVariables>{inputVar4};

      
      List<ContentDocumentLink> contentDocumentLinks = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :acc.Id
        ];



      // Call the method to be tested
      Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
      Test.startTest();
      LlamadoFormulario.CreacionCliente(inputList);
      LLamadocumentos.Documentos(inputList2);
    
      LLamadocumentos.Documentos(inputList4);
      Test.stopTest();
    }

    


}