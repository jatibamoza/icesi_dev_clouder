public with sharing class Controladorciudades {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getpais() {
        List<Map<String, String>> options = new List<Map<String, String>>();
        
        for (Ciudad__c record : [SELECT Id, Name FROM Ciudad__c WHERE CC_Location_type__c = 'Country' ]) {
            Map<String, String> option = new Map<String, String>();
            option.put('value', record.Id);
            option.put('label', record.Name);
            options.add(option);
        }

        return options; 
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getDepartamentos(string codPais) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        system.debug(' pais filtro del departamento' + codPais);
        for (Ciudad__c record : [SELECT Id, Name FROM Ciudad__c WHERE CC_Location_type__c = 'Department' AND Country__c = :codPais]) {
            Map<String, String> option = new Map<String, String>();
            option.put('value', record.Id);
            option.put('label', record.Name);
            options.add(option);
        }

        return options; 
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCiudades(string codDepartamento) {
        List<Map<String, String>> options = new List<Map<String, String>>();
        system.debug('departamento filtro de la ciudad' + codDepartamento);
        for (Ciudad__c record : [SELECT Id, Name FROM Ciudad__c WHERE CC_Departamento__c = :codDepartamento  ]) {
            Map<String, String> option = new Map<String, String>();
            option.put('value', record.Id);
            option.put('label', record.Name);
            options.add(option);
        }

        return options; 
    }
}