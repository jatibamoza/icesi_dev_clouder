@isTest
private class TestControladorInceripcion {

    @isTest
    static void testInscripcion() {


        Account programa = new Account(
            recordtypeId = '012ao000000ZxQDAA0',
            Name = 'programa',
            CC_CODIGO_BANNER__c = 'MED',
            Tipo_de_programa__c = 'PRE'

         );
         insert programa;

         AcademicTerm periodo = new AcademicTerm(
            Codigo_periodo__c = '202420',
            Name = 'periodo'
        );
        insert periodo;

        // Create mock Account
        Ciudad__c ciudad = new Ciudad__c(
            Name = 'ejemplo',
            C_digo_de_ciudad__c = '52356'
         );
         insert ciudad;

        Account acc = new Account(
            recordtypeId = '012ao0000009rurAAA',
            CC_ACC_N_mero_id__c = '123456884',
            FirstName = 'NOMBRE',
            LastName = 'EJEMPLO',
            CC_Programa_de_inter_s__c = programa.Id,
            CC_Acc_Tipo_id__c = 'CC',
            CC_Pa_s_cuenta__c = 'CO',
            CC_Departamento__c = '52',
            CC_Ciudad__c = ciudad.Id
        );
        insert acc;
     
    
        IndividualApplication IA = new IndividualApplication(
            AccountId = acc.Id,
            CC_Periodo_academico__c = periodo.Id,
            AppliedDate = Datetime.newInstance(2020, 10, 21, 17, 0, 0),
            Status = 'Iniciar la inscripción',
            Category = 'Education'
            
        );
        insert IA;


        PageReference pageRef = Page.PagosInscripcion; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', IA.Id);
        
        // Inicializa el StandardController con el registro IndividualApplication
        ApexPages.StandardController sc = new ApexPages.StandardController(IA);
        
        // Llama al constructor del controlador
        ControladorPaginaInscipcion controller = new ControladorPaginaInscipcion(sc);
    }
}