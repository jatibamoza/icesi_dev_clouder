@isTest
public class PagosInscripcionHelperTest {
    
    @testSetup
    static void setupTestData() {
        // Create related CC_Ciudad__c data
        Ciudad__c pais = new Ciudad__c(Name = 'Test pais');
        insert pais;

        Ciudad__c departamento = new Ciudad__c(Name = 'Test dep');
        insert departamento;

        Ciudad__c ciudad = new Ciudad__c(Name = 'Test City');
        insert ciudad;

        // Create related Account data
        Account acc = new Account(
            FirstName = 'Test Account',
            LastName = 'Test LastName',
            PersonMobilePhone = '1234567890',
            PersonEmail = 'test@example.com',
            CC_ACC_N_mero_id__c = '12345',
            CC_Direcci_n__c = '123 Test St',
            Phone = '0987654321',
            Country__c = pais.Id,
            Department__c = departamento.Id,
            City__c = ciudad.Id
        );
        insert acc;

        // Create IndividualApplication record
        IndividualApplication ia = new IndividualApplication(
            Monto_factura__c = 100.0,
            Numero_de_factura__c = 'INV-001',
            Numero_de_factura_matricula__c = 'INV-002',
            Monto_factura_matricula__c = 200.0,
            Monto_procultura__c = 50.0,
            AccountId = acc.Id,
            Category = 'Education'
        );
        insert ia;
    }
    
    @isTest
    static void testGetIndividualApplication() {
        // Retrieve the test IndividualApplication record
        IndividualApplication testIA = [SELECT Id FROM IndividualApplication LIMIT 1];
        
        // Call the method under test
        Test.startTest();
        IndividualApplication result = PagosInscripcionHelper.getIndividualApplication(testIA.Id);
        Test.stopTest();
        
        // Verify the results
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(testIA.Id, result.Id, 'The IDs should match');
    }
    
    @isTest
    static void testGetIndividualApplicationWithNullId() {
        // Call the method with null ID and verify exception
        try {
            Test.startTest();
            PagosInscripcionHelper.getIndividualApplication(null);
            Test.stopTest();
            System.assert(false, 'Exception should have been thrown for null ID');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Record ID cannot be null', e.getMessage(), 'Exception message should match');
        }
    }
    
    @isTest
    static void testGetPais() {
        // Retrieve test IndividualApplication record
        IndividualApplication testIA = [SELECT Id FROM IndividualApplication LIMIT 1];
        
        Test.startTest();
        String result = PagosInscripcionHelper.getpais(testIA.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'The country name should not be null');
    }
    
    @isTest
    static void testGetCiudad() {
        // Retrieve test IndividualApplication record
        IndividualApplication testIA = [SELECT Id FROM IndividualApplication LIMIT 1];
        
        Test.startTest();
        String result = PagosInscripcionHelper.getciudad(testIA.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'The city name should not be null');
    }
    
    @isTest
    static void getmetadata() {
        // Call the method under test
        Test.startTest();
        BotonPago__mdt result = PagosInscripcionHelper.getFormConfig('Inscripcion');
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Metadata should not be null');
    }
    
    @isTest
    static void getmetadatanull() {
        // Call the method with null ID and verify exception
        try {
            Test.startTest();
            PagosInscripcionHelper.getFormConfig(null);
            Test.stopTest();
            System.assert(false, 'Exception should have been thrown for null ID');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Form Type cannot be null', e.getMessage(), 'Exception message should match');
        }
    }
}