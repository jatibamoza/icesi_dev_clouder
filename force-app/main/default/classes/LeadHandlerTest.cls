@isTest
public class LeadHandlerTest {
    @isTest
    static void testTriggerIntegration() {
        // Obtener el ID del tipo de registro de la cuenta
        Id academicProgramRecordTypeId = [
            SELECT Id 
            FROM RecordType 
            WHERE SObjectType = 'Account' AND DeveloperName = 'Academic_Program'
            LIMIT 1
        ].Id;

        // Crear la cuenta con los campos requeridos
        Account testAccount = new Account(
            Name = 'Prueba',
            CC_Pertenece_a_ICESI__c = true,
            RecordTypeId = academicProgramRecordTypeId,
            Tipo_de_programa__c = 'PRE' 
        );
        insert testAccount;

        // Obtener usuarios activos
        User user1 = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        User user2 = [SELECT Id FROM User WHERE IsActive = true AND Id != :user1.Id LIMIT 1];

        // Crear un Lead inicial
        Lead lead = new Lead(
            LeadSource = 'Colegio',
            FirstName = 'Test',
            LastName = 'Lead',
            MobilePhone = '3124567895',
            Email = 'prueba@gmail.com',
            CC_Tratamiento_de_Datos__c = true,
            CC_Programa_de_inter_s__c = testAccount.Id,
            CC_Numero_ID__c = '121541546',
            OwnerId = user1.Id
        );
        insert lead;
        System.debug('el propietario del lead sin actualizar es: '+Lead.OwnerId);
        lead.OwnerId = user2.Id;


        Test.startTest();
        update lead; 
        Test.stopTest();
        System.debug('el propietario del lead actualizado es: '+Lead.OwnerId);
        List<Task> tasks = [SELECT Id, Subject FROM Task];
        System.debug('el número de tareas es: '+tasks);
        
        

        
    }
}