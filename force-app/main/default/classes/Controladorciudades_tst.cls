@isTest
public class Controladorciudades_tst {

    @isTest
    static void testGetPais() {
        // Crear datos de prueba

        RecordType PAIS = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'Country'];
        Ciudad__c country1 = new Ciudad__c(Name = 'Country1', CC_Location_type__c = 'Country',RecordTypeId = PAIS.Id);
        Ciudad__c country2 = new Ciudad__c(Name = 'Country2', CC_Location_type__c = 'Country');
        insert new List<Ciudad__c>{ country1, country2 };

        // Llamar al método y verificar resultados
        Test.startTest();
        List<Map<String, String>> result = Controladorciudades.getpais();
        Test.stopTest();

        System.assertEquals(2, result.size(), 'Debería haber 2 países en la lista');
        System.assertEquals('Country1', result[0].get('label'), 'El primer país debería ser Country1');
        System.assertEquals('Country2', result[1].get('label'), 'El segundo país debería ser Country2');
    }

    @isTest
    static void testGetDepartamentos() {
        // Crear datos de prueba

        RecordType PAIS = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'Country'];
        RecordType DEP = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'Department'];

        Ciudad__c country = new Ciudad__c(Name = 'Country3', CC_Location_type__c = 'Country',RecordTypeId = PAIS.Id);
        insert country;

        Ciudad__c department1 = new Ciudad__c(Name = 'Department1', CC_Location_type__c = 'Department', Country__c = country.Id, RecordTypeId = DEP.Id);
        Ciudad__c department2 = new Ciudad__c(Name = 'Department2', CC_Location_type__c = 'Department', Country__c = country.Id, RecordTypeId = DEP.Id);
        insert new List<Ciudad__c>{ department1, department2 };

        // Llamar al método y verificar resultados
        Test.startTest();
        List<Map<String, String>> result = Controladorciudades.getDepartamentos(country.Id);
        Test.stopTest();

        System.assertEquals(2, result.size(), 'Debería haber 2 departamentos en la lista');
        System.assertEquals('Department1', result[0].get('label'), 'El primer departamento debería ser Department1');
        System.assertEquals('Department2', result[1].get('label'), 'El segundo departamento debería ser Department2');
    }

    @isTest
    static void testGetCiudades() {
        // Crear datos de prueba

        RecordType PAIS = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'Country'];
        RecordType DEP = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'Department'];
        RecordType CIUDAD = [SELECT DeveloperName,Id FROM RecordType WHERE DeveloperName = 'City'];

        Ciudad__c department = new Ciudad__c(Name = 'Department1', CC_Location_type__c = 'Department', RecordTypeId = DEP.Id);
        insert department;

        Ciudad__c city1 = new Ciudad__c(Name = 'City1', CC_Departamento__c = department.Id, RecordTypeId = CIUDAD.Id);
        Ciudad__c city2 = new Ciudad__c(Name = 'City2', CC_Departamento__c = department.Id, RecordTypeId = CIUDAD.Id);
        insert new List<Ciudad__c>{ city1, city2 };

        // Llamar al método y verificar resultados
        Test.startTest();
        List<Map<String, String>> result = Controladorciudades.getCiudades(department.Id);
        Test.stopTest();

        System.assertEquals(2, result.size(), 'Debería haber 2 ciudades en la lista');
        System.assertEquals('City1', result[0].get('label'), 'La primera ciudad debería ser City1');
        System.assertEquals('City2', result[1].get('label'), 'La segunda ciudad debería ser City2');
    }
}