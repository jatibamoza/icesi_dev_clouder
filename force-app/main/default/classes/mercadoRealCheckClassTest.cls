@isTest
public class mercadoRealCheckClassTest {

    @testSetup
    static void testinicio() {

        // Crear  periodos académicos
        AcademicTerm pAcad1 = new AcademicTerm(Name = 'Periodo A', IsActive	= true,Codigo_periodo__c = '85');
        AcademicTerm pAcad2 = new AcademicTerm(Name = 'Periodo A', IsActive	= true,Codigo_periodo__c = '86');
        insert new List<AcademicTerm>{ pAcad1, pAcad2 };
        // Crear cuentas de prueba con periodos académicos
        RecordType colegio = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Colegios'];
        Account acc1 = new Account(Name = 'Colegio A', CC_Periodo_ventas_uno__c = pAcad1.Id, CC_Periodo_ventas_dos__c = pAcad2.Id, RecordTypeId = colegio.Id);
        Account acc2 = new Account(Name = 'Colegio B', CC_Periodo_ventas_uno__c = pAcad1.Id, CC_Periodo_ventas_dos__c = pAcad2.Id , RecordTypeId = colegio.Id);
        insert new List<Account>{ acc1, acc2 };

        // Crear mercados reales relacionados con las cuentas
        CC_Mercado_real__c mercado1 = new CC_Mercado_real__c(CC_Colegio__c = acc1.Id, CC_Periodo_academico__c = pAcad1.Id);
        CC_Mercado_real__c mercado2 = new CC_Mercado_real__c(CC_Colegio__c = acc2.Id, CC_Periodo_academico__c = pAcad2.Id);
        insert new List<CC_Mercado_real__c>{ mercado1, mercado2 };

        delete mercado2;
    }

    @isTest
    static void testMercadoRealCheckClassfomCuenta() {
        // Consultar las cuentas de prueba
        List<Account> cuentaList = [SELECT Id, CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c FROM Account];

        // Ejecutar el método
        mercadoRealCheckClass.mercadoRealCheckClassfomCuenta(cuentaList);

        // Verificar que las cuentas fueron actualizadas correctamente
        Account updatedAcc1 = [SELECT Id, CC_Mercado_real__c FROM Account WHERE Name = 'Colegio A'];
        Account updatedAcc2 = [SELECT Id, CC_Mercado_real__c FROM Account WHERE Name = 'Colegio B'];
    }

    @isTest
    static void testMercadoRealCheckClassfomMercadoreal() {
        // Consultar los mercados reales de prueba
        List<CC_Mercado_real__c> mercadorealList = [SELECT Id, CC_Colegio__c, CC_Periodo_academico__c FROM CC_Mercado_real__c];

        // Ejecutar el método
        mercadoRealCheckClass.mercadoRealCheckClassfomMercadoreal(mercadorealList);

        // Verificar que las cuentas fueron actualizadas correctamente
        Account updatedAcc1 = [SELECT Id, CC_Mercado_real__c FROM Account WHERE Name = 'Colegio A'];
        Account updatedAcc2 = [SELECT Id, CC_Mercado_real__c FROM Account WHERE Name = 'Colegio B'];

    }
}