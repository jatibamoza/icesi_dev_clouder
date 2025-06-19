public with sharing class PagosInscripcionHelper {
   
    @AuraEnabled(cacheable=true)
    public static IndividualApplication getIndividualApplication( String recordId ){
        IndividualApplication objIA;
        // Ensure the record ID is not null
        if ( recordId == null ) {
            throw new IllegalArgumentException('Record ID cannot be null');
        }
        else{
            // Query the IndividualApplication record by ID
            objIA = [
                SELECT  Id, Monto_factura__c, Numero_de_factura__c,
                        Numero_de_factura_matricula__c, Monto_factura_matricula__c, 
                        Monto_procultura__c, Carrera_de_mayor_interes__r.Tipo_de_programa__c,
                        Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c, Account.FirstName, 
                        Account.LastName, Account.PersonMobilePhone, Account.PersonEmail, 
                        Account.CC_ACC_N_mero_id__c, Account.CC_Direcci_n__c, Account.Phone,
                        toLabel(Account.CC_Acc_Tipo_id__c), Account.Country__r.Name, 
                        Account.City__r.Name,Account.CC_Ciudad_de_residencia__c,Account.CC_Ciudad_residencia_no_aparece__c,Carrera_de_mayor_interes__r.CC_Tipo_nivel_acad_mico_programa__c 
                FROM    IndividualApplication 
                WHERE   Id = :recordId
                LIMIT 1
            ];
            
        }
        
        return objIA;
    }
   
    @AuraEnabled(cacheable=true)
    public static BotonPago__mdt getFormConfig( String formType ){
        BotonPago__mdt objConfig;
        // Ensure the record ID is not null
        if ( formType == null ) {
            throw new IllegalArgumentException('Form Type cannot be null');
        }
        else{
            // Query the IndividualApplication record by ID
            objConfig = [
                SELECT  Id, DeveloperName, From_action__c, url_confirmacion__c, url_respuesta__c,
                        Prueba__c,From_action_matriculas__c,url_confirmacion_matriculas__c,url_respuestaMatriculas__c
                FROM    BotonPago__mdt 
                WHERE   DeveloperName = :formType
                LIMIT 1
            ];
        }
        
        return objConfig;
    }

    @AuraEnabled(cacheable=true)
    public static String getpais( String recordId ){
        Ciudad__c PAIS;
        // Ensure the record ID is not null
        if ( recordId == null ) {
            throw new IllegalArgumentException('Record ID cannot be null');
        }
        else{

            IndividualApplication IA = [ SELECT   Account.Country__c FROM IndividualApplication WHERE Id = :recordId LIMIT 1];

            // Query the IndividualApplication record by ID
            PAIS = [ SELECT Name FROM Ciudad__c WHERE   Id = :IA.Account.Country__c LIMIT 1];
            
        }


        return PAIS.Name;
    }

    @AuraEnabled(cacheable=true)
    public static String getciudad( String recordId ){
        Ciudad__c ciudad;
        String ciudadtext = 'no entro';
        // Ensure the record ID is not null
        if ( recordId == null ) {
            throw new IllegalArgumentException('Record ID cannot be null');
        }
        else{

            IndividualApplication IA = [ SELECT Account.CC_Ciudad_residencia_no_aparece__c,Account.CC_Ciudad_de_residencia__c,Account.City__c FROM IndividualApplication WHERE Id = :recordId LIMIT 1];


            if(IA.Account.CC_Ciudad_residencia_no_aparece__c == true){
                ciudadtext  = IA.Account.CC_Ciudad_de_residencia__c;
            }else{

                 // Query the IndividualApplication record by ID
                ciudad = [ SELECT Name FROM Ciudad__c WHERE   Id = :IA.Account.City__c LIMIT 1];
                ciudadtext  = ciudad.Name;
            }

           
            
        }


        return ciudadtext;
    }

   
}