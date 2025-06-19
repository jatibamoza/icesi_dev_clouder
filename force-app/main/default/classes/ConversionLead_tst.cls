@isTest
private class ConversionLead_tst {

    @isTest
    static void testlead() {
       

        recordType rtcolegio = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Colegios' LIMIT 1];
        Account colegio = new Account(
            recordtypeId = rtcolegio.Id,
            CC_CODIGO_BANNER__c = 'C00002',
            Name = 'colegio',
                CC_N_mero_de_registro__c = '123'

        );
        insert colegio;
      
        recordType rtpro = [SELECT id FROM recordType WHERE SobjectType = 'Account' AND DeveloperName = 'Academic_Program' LIMIT 1];
        
        Account programa = new Account(
           recordtypeId = rtpro.Id,
           Name = 'programa',
           CC_CODIGO_BANNER__c = 'MED',
           CC_N_mero_de_registro__c = '123',
           CC_Pertenece_a_ICESI__c = true,
           Tipo_de_programa__c = 'PRE' 

        );
        insert programa;

         Lead lead = new Lead(
            FirstName = 'lead',
            LastName = 'apellido',
            CC_Tipo__c = 'Aspirante',
            LeadSource = 'Pauta',
            Status = 'Pendiente por atención',
            MobilePhone = '3164424295',
            Email = 'd@gmail.com',
            CC_Tipo_ID__c = 'CC',
            CC_Numero_ID__c = '00114555',
            CC_Programa_de_inter_s__c = programa.Id,
            CC_Tratamiento_de_Datos__c = true,
            CC_Grado_Aspirante__c = '11',
            CC_Cual_es_ultimo_grado_de_tu_colegio__c = '11',
            CC_Colegio__c = colegio.Id
         );
         insert lead;

         Lead lead2 = new Lead(
            FirstName = 'lead',
            LastName = 'apellido',
            CC_Tipo__c = 'Aspirante',
            LeadSource = 'Pauta',
            Status = 'Pendiente por atención',
            MobilePhone = '3164424295',
            Email = 'd7@gmail.com',
            CC_Tipo_ID__c = 'CC',
            CC_Numero_ID__c = '74184',
            CC_Programa_de_inter_s__c = programa.Id,
            CC_Tratamiento_de_Datos__c = true,
            CC_Grado_Aspirante__c = '11'
            
         );
         insert lead2;
       
       // Crear la lista de variables de entrada para la conversión de Leads
        List<ConvertLeadAction.InputVariables> inputList = new List<ConvertLeadAction.InputVariables>();

        // Crear la primera instancia para el primer Lead
        ConvertLeadAction.InputVariables inputVar1 = new ConvertLeadAction.InputVariables();
        inputVar1.Lead = lead.Id;

        // Crear la segunda instancia para el segundo Lead
        ConvertLeadAction.InputVariables inputVar2 = new ConvertLeadAction.InputVariables();
        inputVar2.Lead = lead2.Id;

        // Agregar ambos Leads a la lista
        inputList.add(inputVar1);
        inputList.add(inputVar2);

        Test.startTest();
        ConvertLeadAction.convertLead(inputList);
        Test.stopTest();
 
        
    }



}