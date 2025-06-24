@isTest
private class ICS_DataMasterBuilder_tst {
    // Usamos el mismo setup que la prueba del mapper para tener datos consistentes
    @testSetup
    static void makeData() {
        // Paso 1: Consultar los RecordTypes necesarios para la prueba
        // RecordType para la IndividualApplication de Admissions
        RecordType rtIndApp = [SELECT ID FROM RecordType WHERE DeveloperName = 'Admissions' AND SObjectType = 'IndividualApplication' LIMIT 1];
        // RecordType para la Account de Academic_Program
        RecordType rtAcademicProgram = [SELECT ID FROM RecordType WHERE DeveloperName = 'Academic_Program' AND SObjectType = 'Account' LIMIT 1];
        // RecordType para la Account de University_Department
        RecordType rtUniversityDeparment = [SELECT ID FROM RecordType WHERE DeveloperName = 'University_Department' AND SObjectType = 'Account' LIMIT 1];
        // Paso 2: Crear datos relacionados en orden (de padre a hijo)
        // Usamos un usuario para ser el propietario del 'Parent' de la carrera
        User ownerUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            FirstName = 'Test', LastName = 'Owner', Email = 'testowner@test.com',
            Username = 'testowner' + System.currentTimeMillis() + '@test.com',
            Alias = 'town', TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert ownerUser;

        Account uniParent = new Account(
            Name = 'Universidad Principal', 
            NIT__c = '12345-6', 
            RecordTypeId = rtUniversityDeparment.Id);
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            uniParent.OwnerId = ownerUser.Id;
            insert uniParent;
        }

        Account carrera = new Account(
            Name = 'Ingeniería de Sistemas', 
            CC_CODIGO_BANNER__c = 'SYS-001', 
            ParentId = uniParent.Id, 
            RecordTypeId = rtAcademicProgram.Id,
            CC_Pertenece_a_ICESI__c = true,
            Tipo_de_programa__c = 'PRE',
            CC_N_mero_de_registro__c = '123');
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            carrera.OwnerId = ownerUser.Id;
            insert carrera;
        }

        AcademicTerm periodo = new AcademicTerm (
            Name = '2025-I', 
            Codigo_periodo__c = '202510');
        insert periodo;

        // Paso 3: Crear el registro principal de IndividualApplication (el que se procesará)
        IndividualApplication app = new IndividualApplication(
            RecordTypeId = rtIndApp.Id,
            Status = 'Matriculado',
            Carrera_de_mayor_interes__c = carrera.Id,
            CC_Periodo_academico__c = periodo.Id,
            Category = 'Education',
            OwnerId = UserInfo.getUserId()
        );
        insert app;
    }

    @isTest
    static void testBatchExecution() {
        // Construimos el mismo query que usará el batch en producción
        String query = 'SELECT Owner.Name, Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c, Carrera_de_mayor_interes__r.Parent.Name, Carrera_de_mayor_interes__r.Parent.NIT__c, Carrera_de_mayor_interes__r.Parent.Owner.Name, CC_Periodo_academico__r.Name, CC_Periodo_academico__r.Codigo_periodo__c, Status FROM IndividualApplication WHERE Status = \'Matriculado\'';
        String rtDevName = 'IA_EtapasEmbudo';
        Test.startTest();
        // Instanciar y ejecutar el batch
        ICS_DataMasterBuilder_bch batch = new ICS_DataMasterBuilder_bch(query, rtDevName);
        Database.executeBatch(batch,200);
        Test.stopTest();
        // Verificar los resultados
        // Deben haberse creado 5 registros en ICS_DataMaster__c
        List<ICS_DataMaster__c> createdMasters = [SELECT Id FROM ICS_DataMaster__c];
        Assert.areEqual(1, createdMasters.size(), 'El batch debería haber creado 1 registro Data Master.');
    }
    // ** PRE-REQUISITO: Debes tener al menos un registro activo en ICS_QueryMaster__mdt en tu org de pruebas. **
    @isTest
    static void testScheduler() {
        Test.startTest();
        ICS_DataMasterBuilder_sch scheduler = new ICS_DataMasterBuilder_sch();
        String cronExpression = '0 0 1 * * ?'; // Expresión CRON de ejemplo
        System.schedule('Test Data Master Builder Schedule', cronExpression, scheduler);
        Test.stopTest();
        
        List<CronTrigger> triggers = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test Data Master Builder Schedule'];
        System.assertEquals(1, triggers.size(), 'El trabajo programado debería existir.');
        Assert.areEqual(1, triggers.size(), 'El trabajo programado debería existir.');
    }
}