@isTest
public class updateAcademicTermBatchTest {

    @testSetup
    static void setupTestData() {
        // Crear periodos académicos de prueba
        AcademicTerm academicTerm1 = new AcademicTerm(
            Name = 'Periodo 1', 
            IsActive = true,
            CC_Periodo_vigente_para_ventas__c = false,
             Codigo_periodo__c = '8452'
        );
        AcademicTerm academicTerm2 = new AcademicTerm(
            Name = 'Periodo 2', 
            IsActive = true,
            CC_Periodo_vigente_para_ventas__c = false,
            Codigo_periodo__c = '885'
        );
        insert new List<AcademicTerm>{ academicTerm1, academicTerm2 };

        // Obtener el Record Type existente para Colegios
        RecordType colegioRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Colegios' LIMIT 1];

        // Crear cuentas de prueba
        Account acc1 = new Account(
            Name = 'Colegio A', 
            RecordTypeId = colegioRecordType.Id,
            CC_Periodo_ventas_uno__c = null,
            CC_Periodo_ventas_dos__c = null
        );
        Account acc2 = new Account(
            Name = 'Colegio B', 
            RecordTypeId = colegioRecordType.Id,
            CC_Periodo_ventas_uno__c = null,
            CC_Periodo_ventas_dos__c = null
        );
        insert new List<Account>{ acc1, acc2 };
    }

    @isTest
    static void testTriggerAndBatchUpdate() {
        // Obtener los periodos académicos creados en setup
        List<AcademicTerm> academicTerms = [SELECT Id FROM AcademicTerm];
        List<Id> academicTermIds = new List<Id>{ academicTerms[0].Id, academicTerms[1].Id };

        // Actualizar los registros para activar el trigger
        academicTerms[0].CC_Periodo_vigente_para_ventas__c = true;  // Activar el primero
        academicTerms[1].CC_Periodo_vigente_para_ventas__c = true;  // Activar el segundo

        Test.startTest();
        update academicTerms;  // Llamar a DML para disparar el trigger
        Test.stopTest();

        // Verificar que las cuentas han sido actualizadas correctamente
        Account updatedAcc1 = [SELECT CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c FROM Account WHERE Name = 'Colegio A'];
        Account updatedAcc2 = [SELECT CC_Periodo_ventas_uno__c, CC_Periodo_ventas_dos__c FROM Account WHERE Name = 'Colegio B'];

        // Verificar que los campos se han actualizado correctamente
        System.assertEquals(academicTermIds[0], updatedAcc1.CC_Periodo_ventas_uno__c, 'El periodo académico uno del Colegio A no se actualizó correctamente.');
        System.assertEquals(academicTermIds[1], updatedAcc1.CC_Periodo_ventas_dos__c, 'El periodo académico dos del Colegio A no se actualizó correctamente.');

        // Verificar que los campos se han establecido en el Colegio B
        System.assertEquals(academicTermIds[0], updatedAcc2.CC_Periodo_ventas_uno__c, 'El periodo académico uno del Colegio B no se actualizó correctamente.');
        System.assertEquals(academicTermIds[1], updatedAcc2.CC_Periodo_ventas_dos__c, 'El periodo académico dos del Colegio B no se actualizó correctamente.');
    }
}