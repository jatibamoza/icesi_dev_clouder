@isTest
public class UpdateOwnerBatchActionTest {
    
    @testSetup
    static void setupData() {
        // Crear usuarios de prueba con un nombre de usuario único
        String uniqueSuffix = String.valueOf(System.currentTimeMillis());
        
        User owner1 = new User(
            Alias = 'test1',
            Email = 'user1_' + uniqueSuffix + '@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'ejemplo111',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            Username = 'user1_' + uniqueSuffix + '@example.com'
        );
        insert owner1;

        User owner2 = new User(
            Alias = 'test2',
            Email = 'user2_' + uniqueSuffix + '@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'ejemplo22222',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            Username = 'user2_' + uniqueSuffix + '@example.com'
        );
        insert owner2;

        // Crear registros de prueba (ejemplo con Account)
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, OwnerId = owner1.Id));
        }
        insert accounts;
    }

    @isTest
    static void testUpdateOwners() {
        // Obtener datos de prueba
        User newOwner = [SELECT Id FROM User WHERE LastName = 'ejemplo22222' LIMIT 1];
        List<Account> accounts = [SELECT Id FROM Account LIMIT 5];

        // Caso normal - debe actualizar los propietarios
        UpdateOwnerBatchAction.Request validReq = new UpdateOwnerBatchAction.Request();
        validReq.recordIds = new List<Id>();
        for (Account acc : accounts) {
            validReq.recordIds.add(acc.Id);
        }
        validReq.newOwnerId = newOwner.Id;
        validReq.sObjectType = 'Account';

        Test.startTest();
        UpdateOwnerBatchAction.updateOwners(new List<UpdateOwnerBatchAction.Request>{ validReq });
    
        // ------------------- Casos de Prueba para `return` y `continue` -------------------

        // Caso `requests == null` (Debe retornar sin hacer nada)
      
        UpdateOwnerBatchAction.updateOwners(null);
       

        // Caso `requests` vacío (Debe retornar sin hacer nada)
       
        UpdateOwnerBatchAction.updateOwners(new List<UpdateOwnerBatchAction.Request>());


        // Caso `recordIds` vacío (Debe continuar sin actualizar)
        UpdateOwnerBatchAction.Request emptyRecordIdsReq = new UpdateOwnerBatchAction.Request();
        emptyRecordIdsReq.recordIds = new List<Id>(); // Vacío
        emptyRecordIdsReq.newOwnerId = newOwner.Id;
        emptyRecordIdsReq.sObjectType = 'Account';

        
        UpdateOwnerBatchAction.updateOwners(new List<UpdateOwnerBatchAction.Request>{ emptyRecordIdsReq });
        


        // Caso `newOwnerId` es `null` (Debe continuar sin actualizar)
        UpdateOwnerBatchAction.Request nullOwnerReq = new UpdateOwnerBatchAction.Request();
        nullOwnerReq.recordIds = validReq.recordIds;
        nullOwnerReq.newOwnerId = null; // Inválido
        nullOwnerReq.sObjectType = 'Account';

        UpdateOwnerBatchAction.updateOwners(new List<UpdateOwnerBatchAction.Request>{ nullOwnerReq });
   

        // Caso `sObjectType` vacío (Debe continuar sin actualizar)
        UpdateOwnerBatchAction.Request emptySObjectTypeReq = new UpdateOwnerBatchAction.Request();
        emptySObjectTypeReq.recordIds = validReq.recordIds;
        emptySObjectTypeReq.newOwnerId = newOwner.Id;
        emptySObjectTypeReq.sObjectType = ''; // Inválido

        
        UpdateOwnerBatchAction.updateOwners(new List<UpdateOwnerBatchAction.Request>{ emptySObjectTypeReq });
        Test.stopTest();
    }
}