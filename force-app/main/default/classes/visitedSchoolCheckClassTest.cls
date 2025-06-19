@isTest
public class visitedSchoolCheckClassTest {

    @testSetup
    static void setupTestData() {
        // Obtener un perfil estándar para el usuario de prueba
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Crear usuario de prueba con correo
        User testUser = new User(
            FirstName = 'Prueba', 
            LastName = 'Salesforce', 
            Email = 'prueba@example.com', 
            Username = 'prueba@example.com.salesforce', 
            Alias = 'prueba', 
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            ProfileId = p.Id, 
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Crear periodos académicos
        List<AcademicTerm> academicTerms = new List<AcademicTerm>{
            new AcademicTerm(Name = 'Periodo A', IsActive = true),
            new AcademicTerm(Name = 'Periodo B', IsActive = true)
        };
        insert academicTerms;

        // Obtener RecordTypes
        RecordType colegioRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Colegios' LIMIT 1];
        RecordType campanaRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Eventos_de_Colegio' LIMIT 1];

        // Crear cuenta de prueba con periodos académicos
        Account acc1 = new Account(
            Name = 'Colegio A',
            CC_Periodo_ventas_uno__c = academicTerms[0].Id,
            CC_Periodo_ventas_dos__c = academicTerms[1].Id,
            RecordTypeId = colegioRT.Id
        );
        insert acc1;
        
        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
        Account accuenta = new Account(
     
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '12345674852',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Direcci_n__c = '123'
    
        );
        insert accuenta;
        
         Contact nuevoContacto = new Contact(
            AccountId = acc1.Id, 
            FirstName = 'Daniela',
            LastName = 'Colegio',
            CC_Tipo_de_rol__c = 'Directivo',
            hed__PreferredPhone__c = 'Celular',
            CC_Celular__c = '1231231233',
            hed__Preferred_Email__c = 'Correo laboral',
            Correo_laboral__c = 'dani@nocorreo.com'
        );

        insert nuevoContacto;
        
        // Crear campañas relacionadas con la cuenta
        List<Campaign> campaigns = new List<Campaign>{
            new Campaign(
                Name = 'Campaña 1',
                CC_Colegio__c = acc1.Id,
                CC_Periodo_acad_mico__c = academicTerms[0].Id,
                RecordTypeId = campanaRT.Id,
                CC_Fecha_inicio_de_evento__c = DateTime.newInstance(2024, 9, 30, 0, 0, 0),
                CC_Fecha_final_del_evento__c = DateTime.newInstance(2024, 10, 5, 23, 59, 59),
                CC_Modalidad__c = 'Presencial',
                CC_Tipo_de_actividad__c = 'Ferias',
                Responsable_1__c = testUser.Id,
                CC_Contacto__c = nuevoContacto.Id
            ),
            new Campaign(
                Name = 'Campaña 2',
                CC_Colegio__c = acc1.Id,
                CC_Periodo_acad_mico__c = academicTerms[0].Id,
                RecordTypeId = campanaRT.Id,
                CC_Fecha_inicio_de_evento__c = DateTime.newInstance(2024, 9, 30, 0, 0, 0),
                CC_Fecha_final_del_evento__c = DateTime.newInstance(2024, 10, 5, 23, 59, 59),
                CC_Modalidad__c = 'Presencial',
                CC_Tipo_de_actividad__c = 'Ferias',
                Responsable_1__c = testUser.Id,
                CC_Contacto__c = nuevoContacto.Id
            )
        };
        insert campaigns;

        // Eliminar una campaña para simular un escenario
        delete campaigns[1];
    }

    @isTest
    static void testVisitedSchoolCheckClassfromCampaign() {
        // Consultar campañas
        List<Campaign> actualCampaigns = [SELECT Id, CC_Colegio__c, CC_Periodo_acad_mico__c FROM Campaign];

        // Ejecutar método de prueba
        visitedSchoolCheckClass.visitedSchoolCheckClassfromCampaing(actualCampaigns);

        // Validar que la cuenta se actualizó
        Account updatedAcc1 = [SELECT Id, CC_Colegio_visitado__c FROM Account WHERE Name = 'Colegio A'];
        System.assertNotEquals(null, updatedAcc1.CC_Colegio_visitado__c, 'La cuenta debe estar marcada como visitada.');
    }

    @isTest
    static void testMercadoRealCheckClassfromCuenta() {
        // Consultar cuentas
        List<Account> cuentas = [SELECT Id, CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c FROM Account];

        // Ejecutar método de prueba
        visitedSchoolCheckClass.mercadoRealCheckClassfomCuenta(cuentas);

        // Validar que la cuenta se actualizó
        Account updatedAcc1 = [SELECT Id, CC_Colegio_visitado__c FROM Account WHERE Name = 'Colegio A'];
        System.assertNotEquals(null, updatedAcc1.CC_Colegio_visitado__c, 'La cuenta debe estar marcada como visitada.');
    }
}