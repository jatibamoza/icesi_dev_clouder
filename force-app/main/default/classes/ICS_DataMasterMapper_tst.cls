@isTest
private class ICS_DataMasterMapper_tst {
    //Crea todos los datos necesarios para las pruebas.
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
    static void testMappingHappyPath() {
        // Obtener los datos creados en el testSetup
        IndividualApplication testApp = [
            SELECT Id, Owner.Name, Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c, Carrera_de_mayor_interes__r.Parent.Name, 
                    Carrera_de_mayor_interes__r.Parent.NIT__c, Carrera_de_mayor_interes__r.Parent.Owner.Name, CC_Periodo_academico__r.Name, 
                    CC_Periodo_academico__r.Codigo_periodo__c 
            FROM IndividualApplication 
            LIMIT 1];
        String rtDevName = 'IA_EtapasEmbudo';

        // Ejecutar el método a probar
        Test.startTest();
        ICS_DataMaster__c result = ICS_DataMasterMapper_cls.mapDataMaster(testApp, rtDevName);
        Test.stopTest();

        // Verificar los resultados (Asserts)
        Assert.areNotEqual(null, result, 'El objeto resultante no debería ser nulo.');
        Assert.areEqual(rtDevName, result.getSObjectType().getDescribe().getRecordTypeInfosById().get(result.RecordTypeId).getDeveloperName(), 'El RecordType debe ser el correcto.');
        Assert.areEqual('Universidad Principal', result.ICS_CarreraMayorInteres_Parent_Name__c);
        Assert.areEqual('12345-6', result.ICS_CarreraMayorInteres_Parent_NIT__c);
        Assert.areEqual('Test Owner', result.ICS_CarreraMayorint_Parent_Owner_Name__c);
        Assert.areEqual('SYS-001', result.ICS_CarreraMayorInteres_CC_CODIGO_BANNER__c);
        Assert.areEqual('2025-I', result.ICS_CCPeriodoAcademico_Name__c);
        Assert.areEqual('202510', result.ICS_CCPeriodoAcademico_CodigoPeriodo__c);
    }

    @isTest
    static void testMappingNullPath() {
        Test.startTest();
        ICS_DataMaster__c result = ICS_DataMasterMapper_cls.mapDataMaster(null, 'IA_EtapasEmbudo2');
        Test.stopTest();
    }

    @isTest
    static void testMappingWithNulls() {
        RecordType rtIndApp = [SELECT ID FROM RecordType WHERE DeveloperName = 'Admissions' AND SObjectType = 'IndividualApplication' LIMIT 1];
        // Crear un registro sin relaciones para probar la robustez ante nulos
        IndividualApplication appWithNulls = new IndividualApplication(
            RecordTypeId = rtIndApp.Id,
            Category = 'Education'
        );
        insert appWithNulls;
        
        Test.startTest();
        ICS_DataMaster__c result = ICS_DataMasterMapper_cls.mapDataMaster(appWithNulls, 'IA_EtapasEmbudo');
        Test.stopTest();
        
        Assert.areNotEqual(null, result);
        Assert.areEqual(null, result.ICS_CarreraMayorInteres_Parent_Name__c, 'El campo de relación nula debe resultar en un valor nulo.');
        Assert.areEqual(null, result.ICS_CCPeriodoAcademico_Name__c, 'El campo de relación nula debe resultar en un valor nulo.');
    }

    @isTest
    static void testGetNestedValue() {
        Test.startTest();
        Object obj = ICS_DataMasterMapper_cls.getNestedValue( null, '');
        Assert.isNull(obj, 'El resultado debe ser nulo cuando el SObject es nulo o el campo es una cadena vacía.');
        try{
            Account obj2 = new Account();
            ICS_DataMaster__c result = (ICS_DataMaster__c)ICS_DataMasterMapper_cls.getNestedValue( obj2, 'noescampo');
            Assert.fail('Se esperaba una excepción al intentar acceder a un campo inexistente.');
        }catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains('noescampo'), 'El mensaje de error debe contener el campo inexistente.');            
        }
        Test.stopTest();
    }

    @isTest
    static void testgetRecordTypeId() {
        Test.startTest();
        Id idRecordType = ICS_DataMasterMapper_cls.getRecordTypeId(null);
        Assert.isNull(idRecordType, 'El resultado debe ser nulo cuando el DeveloperName es nulo.');
        try{
            Id idRecordType2 = ICS_DataMasterMapper_cls.getRecordTypeId('noesrecordtype');
            Assert.fail('Se esperaba una excepción al intentar acceder a un RecordType inexistente.');
        }catch(Exception ex){
            Assert.isTrue(ex.getMessage().contains('noesrecordtype'), 'El mensaje de error debe contener el RecordType inexistente.');
        }
        Test.stopTest();
    }
}