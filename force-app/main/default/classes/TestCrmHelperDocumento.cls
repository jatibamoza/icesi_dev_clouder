@isTest
private class TestCrmHelperDocumento {


    @isTest
    static void TestCrmHelperDocumento() {

        recordType rtcuenta = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1];
        Account acc = new Account(
        recordtypeId = rtcuenta .Id,
        CC_ACC_N_mero_id__c = '100000',
        CC_Acc_Tipo_id__c = 'CC',
        FirstName = 'NOMBRE',
        LastName = 'EJEMPLO',
        CC_Pa_s_de_expedici_n__c = 'CO',
        CC_Departamento_de_expedici_n__c = '52',
        CC_Nacionalidad__c = 'CO',
        CC_Pa_s_de_nacimiento__c = 'CO',
        CC_Departamento_nacimiento__c = '52',
        hed__AlternateEmail__pc= 'freg4@example.com',
        CC_N_mero_de_registro__c = '123'
        );
        insert acc;

        IndividualApplication IA = new IndividualApplication(
            AccountId = acc.Id,
            Status = 'Formulario inscripcion',
            Category = 'Education'
         );
         insert IA;

        string nombre = 'CPI01_123_' + IA.Id;
        ContentVersion contentVersion7 = new ContentVersion(
            Title = nombre,
            PathOnClient = 'CPI01_123_' + IA.Id + '.pdf',
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

    }
}