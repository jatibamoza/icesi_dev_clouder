public class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newAccounts) {
        Set<String> codigosCiudad     = new Set<String>();
        Set<String> codigosDepto      = new Set<String>();
        Set<String> codigosPais       = new Set<String>();
        Set<String> codigosEmpresa    = new Set<String>();
        Set<String> codigosCampana    = new Set<String>();
        Set<String> codigosPeriodo    = new Set<String>();
        Set<String> codigosPrograma   = new Set<String>();

        for (Account acc : newAccounts) {
            if (acc.AccountSource != 'Peewah evento presencial' && acc.AccountSource != 'Peewah evento virtual') continue;

            if (acc.Ciudad_peewah__c != null)       codigosCiudad.add(acc.Ciudad_peewah__c);
            if (acc.Departamento_peewah__c != null) codigosDepto.add(acc.Departamento_peewah__c);
            if (acc.Pais_peewah__c != null)         codigosPais.add(acc.Pais_peewah__c);
            if (acc.Empresa_peewah__c != null)      codigosEmpresa.add(acc.Empresa_peewah__c);
            if (acc.Evento_peewah__c != null)       codigosCampana.add(acc.Evento_peewah__c);
            if (acc.Periodo_peewah__c != null)      codigosPeriodo.add(acc.Periodo_peewah__c);
            if (acc.Programa_peewah__c != null)     codigosPrograma.add(acc.Programa_peewah__c);
        }

        // Mapas para asignar valores posteriormente
        Map<String, Id> mapaCiudades       = new Map<String, Id>();
        Map<String, Id> mapaDepartamentos  = new Map<String, Id>();
        Map<String, Id> mapaPaises         = new Map<String, Id>();
        Map<String, Id> mapaEmpresa        = new Map<String, Id>();
        Map<String, Id> mapaCampana        = new Map<String, Id>();
        Map<String, Id> mapaPeriodo        = new Map<String, Id>();
        Map<String, Id> mapaPrograma       = new Map<String, Id>();

        // Consultas condicionales
        if (!codigosCiudad.isEmpty() || !codigosDepto.isEmpty() || !codigosPais.isEmpty()) {
            for (Ciudad__c c : [
                SELECT Id, CC_Codigo_pais__c, C_digo_de_departamento__c, C_digo_de_ciudad__c
                FROM Ciudad__c
                WHERE CC_Codigo_pais__c IN :codigosPais
                   OR C_digo_de_departamento__c IN :codigosDepto
                   OR C_digo_de_ciudad__c IN :codigosCiudad
            ]) {
                if (c.C_digo_de_ciudad__c != null)        mapaCiudades.put(c.C_digo_de_ciudad__c, c.Id);
                if (c.C_digo_de_departamento__c != null)  mapaDepartamentos.put(c.C_digo_de_departamento__c, c.Id);
                if (c.CC_Codigo_pais__c != null)          mapaPaises.put(c.CC_Codigo_pais__c, c.Id);
            }
        }

        if (!codigosEmpresa.isEmpty()) {
            for (Account c : [SELECT Id, CC_CODIGO_BANNER__c FROM Account WHERE CC_CODIGO_BANNER__c IN :codigosEmpresa]) {
                if (c.CC_CODIGO_BANNER__c != null) mapaEmpresa.put(c.CC_CODIGO_BANNER__c, c.Id);
            }
        }

        if (!codigosPrograma.isEmpty()) {
            for (Account c : [SELECT Id, CC_CODIGO_BANNER__c FROM Account WHERE CC_CODIGO_BANNER__c IN :codigosPrograma]) {
                if (c.CC_CODIGO_BANNER__c != null) mapaPrograma.put(c.CC_CODIGO_BANNER__c, c.Id);
            }
        }

        if (!codigosPeriodo.isEmpty()) {
            for (AcademicTerm c : [SELECT Id, Codigo_periodo__c FROM AcademicTerm WHERE Codigo_periodo__c IN :codigosPeriodo]) {
                if (c.Codigo_periodo__c != null) mapaPeriodo.put(c.Codigo_periodo__c, c.Id);
            }
        }

        if (!codigosCampana.isEmpty()) {
            for (Campaign c : [SELECT Id, Id_peewah__c FROM Campaign WHERE Id_peewah__c IN :codigosCampana]) {
                if (c.Id_peewah__c != null) mapaCampana.put(c.Id_peewah__c, c.Id);
            }
        }

        // Asignamos los IDs a los registros Account
        for (Account acc : newAccounts) {
            if (acc.AccountSource != 'Peewah evento presencial' && acc.AccountSource != 'Peewah evento virtual') continue;

            if (acc.Ciudad_peewah__c != null) {
                acc.City__c = mapaCiudades.get(acc.Ciudad_peewah__c);
            }
            if (acc.Departamento_peewah__c != null) {
                acc.Department__c = mapaDepartamentos.get(acc.Departamento_peewah__c);
            }
            if (acc.Pais_peewah__c != null) {
                acc.Country__c = mapaPaises.get(acc.Pais_peewah__c);
            }
            if (acc.Empresa_peewah__c != null) {
                acc.CC_Empresa__c = mapaEmpresa.get(acc.Empresa_peewah__c);
            }
            if (acc.Evento_peewah__c != null) {
                acc.CC_Evento_origen__c = mapaCampana.get(acc.Evento_peewah__c); // Cambié el campo para evitar sobrescribir Country__c
            }
            if (acc.Periodo_peewah__c != null) {
                acc.CC_Periodo_acad_mico__c = mapaPeriodo.get(acc.Periodo_peewah__c);
            }
            if (acc.Programa_peewah__c != null) {
                acc.CC_Programa_de_inter_s__c = mapaPrograma.get(acc.Programa_peewah__c);
            }
        }
    }

    public static void beforeInsertbanner(List<Account> newAccounts) {
        Set<String> codigosCiudad     = new Set<String>();
        Set<String> codigosDepto      = new Set<String>();
        Set<String> codigosPais       = new Set<String>();
        Set<String> codigosCiudadnac  = new Set<String>();
        Set<String> codigosDeptonac   = new Set<String>();
        Set<String> codigosPaisnac    = new Set<String>();
     

        for (Account acc : newAccounts) {
            if (acc.Ciudad_residencia_banner__c != null)       codigosCiudad.add(acc.Ciudad_residencia_banner__c);
            if (acc.Pa_s_residencia_banner__c != null) codigosPais.add(acc.Pa_s_residencia_banner__c);
            if (acc.Departamento_residencia_banner__c != null)         codigosDepto.add(acc.Departamento_residencia_banner__c);
            if (acc.Ciudad_nacimiento_banner__c != null)      codigosCiudadnac.add(acc.Ciudad_nacimiento_banner__c);
            if (acc.Departamento_nacimiento_banner__c != null)       codigosDeptonac.add(acc.Departamento_nacimiento_banner__c);
            if (acc.Pa_s_nacimiento_banner__c != null)      codigosPaisnac.add(acc.Pa_s_nacimiento_banner__c);
        }

        // Mapas para asignar valores posteriormente
        Map<String, Id> mapaCiudades       = new Map<String, Id>();
        Map<String, Id> mapaDepartamentos  = new Map<String, Id>();
        Map<String, Id> mapaPaises         = new Map<String, Id>();
        Map<String, Id> mapaCiudadesnac    = new Map<String, Id>();
        Map<String, Id> mapaDepartamentosnac  = new Map<String, Id>();
        Map<String, Id> mapaPaisesnac      = new Map<String, Id>();
   

        // Consultas condicionales
        if (!codigosCiudad.isEmpty() || !codigosDepto.isEmpty() || !codigosPais.isEmpty() || !codigosCiudadnac.isEmpty() || !codigosDeptonac.isEmpty() || !codigosPaisnac.isEmpty()) {
            for (Ciudad__c c : [
                SELECT Id, CC_Codigo_pais__c, C_digo_de_departamento__c, C_digo_de_ciudad__c
                FROM Ciudad__c
                WHERE CC_Codigo_pais__c IN :codigosPais
                   OR C_digo_de_departamento__c IN :codigosDepto
                   OR C_digo_de_ciudad__c IN :codigosCiudad
                   OR C_digo_de_departamento__c IN :codigosDeptonac
                   OR C_digo_de_ciudad__c IN :codigosCiudadnac
                   OR C_digo_de_departamento__c IN :codigosPaisnac
             
            ]) {
                if (c.C_digo_de_ciudad__c != null)        mapaCiudades.put(c.C_digo_de_ciudad__c, c.Id);
                if (c.C_digo_de_departamento__c != null)  mapaDepartamentos.put(c.C_digo_de_departamento__c, c.Id);
                if (c.CC_Codigo_pais__c != null)          mapaPaises.put(c.CC_Codigo_pais__c, c.Id);

                if (c.C_digo_de_ciudad__c != null)        mapaCiudadesnac.put(c.C_digo_de_ciudad__c, c.Id);
                if (c.C_digo_de_departamento__c != null)  mapaDepartamentosnac.put(c.C_digo_de_departamento__c, c.Id);
                if (c.CC_Codigo_pais__c != null)          mapaPaisesnac.put(c.CC_Codigo_pais__c, c.Id);


            }
        }


        // Asignamos los IDs a los registros Account
        for (Account acc : newAccounts) {

            if (acc.Ciudad_residencia_banner__c != null) {
                acc.City__c = mapaCiudades.get(acc.Ciudad_residencia_banner__c);
            }
            if (acc.Departamento_residencia_banner__c != null) {
                acc.Department__c = mapaDepartamentos.get(acc.Departamento_residencia_banner__c);
            }
            if (acc.Pa_s_residencia_banner__c != null) {
                acc.Country__c = mapaPaises.get(acc.Pa_s_residencia_banner__c);
            }

            if (acc.Ciudad_nacimiento_banner__c != null) {
                acc.birthCity__c = mapaCiudadesnac.get(acc.Ciudad_nacimiento_banner__c);
            }
            if (acc.Departamento_nacimiento_banner__c != null) {
                acc.birthDepartment__c = mapaDepartamentosnac.get(acc.Departamento_nacimiento_banner__c);
            }
            if (acc.Pa_s_nacimiento_banner__c != null) {
                acc.birthCountry__c = mapaPaises.get(acc.Pa_s_nacimiento_banner__c);
            }
           
        }
    }

    public static void beforeInsertbannertrabajo(List<Trabajo__c> newAccounts) {
        Set<String> codigosCiudad     = new Set<String>();
        Set<String> codigosDepto      = new Set<String>();
        Set<String> codigosPais       = new Set<String>();
     

        for (Trabajo__c acc : newAccounts) {
            if (acc.Ciudad_banner__c != null)       codigosCiudad.add(acc.Ciudad_banner__c);
            if (acc.Pais_banner__c != null) codigosPais.add(acc.Pais_banner__c);
            if (acc.Departamento_banner__c != null)   codigosDepto.add(acc.Departamento_banner__c);
        }

        // Mapas para asignar valores posteriormente
        Map<String, Id> mapaCiudades       = new Map<String, Id>();
        Map<String, Id> mapaDepartamentos  = new Map<String, Id>();
        Map<String, Id> mapaPaises         = new Map<String, Id>();
   
        // Consultas condicionales
        if (!codigosCiudad.isEmpty() || !codigosDepto.isEmpty() || !codigosPais.isEmpty()) {
            for (Ciudad__c c : [
                SELECT Id, CC_Codigo_pais__c, C_digo_de_departamento__c, C_digo_de_ciudad__c
                FROM Ciudad__c
                WHERE CC_Codigo_pais__c IN :codigosPais
                   OR C_digo_de_departamento__c IN :codigosDepto
                   OR C_digo_de_ciudad__c IN :codigosCiudad
             
            ]) {
                if (c.C_digo_de_ciudad__c != null)        mapaCiudades.put(c.C_digo_de_ciudad__c, c.Id);
                if (c.C_digo_de_departamento__c != null)  mapaDepartamentos.put(c.C_digo_de_departamento__c, c.Id);
                if (c.CC_Codigo_pais__c != null)          mapaPaises.put(c.CC_Codigo_pais__c, c.Id);

            }
        }


        // Asignamos los IDs a los registros Trabajo__c
        for (Trabajo__c acc : newAccounts) {

            if (acc.Ciudad_banner__c != null) {
                acc.CC_Ciudad_donde_trabaja__c = mapaCiudades.get(acc.Ciudad_banner__c);
            }
            if (acc.Departamento_banner__c != null) {
                acc.CC_Departamento_de_donde_trabaja__c = mapaDepartamentos.get(acc.Departamento_banner__c);
            }
            if (acc.Pais_banner__c != null) {
                acc.CC_Pa_s_trabajo__c = mapaPaises.get(acc.Pais_banner__c);
            }

           
        }
    }


    public static void beforeInsertestudios(List<hed__Education_History__c> newAccounts) {
 
        Set<String> codigosuniversidad    = new Set<String>();
        Set<String> codigosPrograma   = new Set<String>();
        Set<String> codigosEnfasis   = new Set<String>();

        for (hed__Education_History__c acc : newAccounts) {
            if (acc.CC_Institucion_Educativa_lok__c != null)  codigosuniversidad.add(acc.CC_Institucion_Educativa_lok__c);
            if (acc.CC_Programa_academico_lok__c != null)     codigosPrograma.add(acc.CC_Programa_academico_lok__c);
            if (acc.Enfasis_en_banner__c != null)     codigosEnfasis.add(acc.Enfasis_en_banner__c);
        }

        Map<String, Id> mapaUniversidad       = new Map<String, Id>();
        Map<String, Id> mapaPrograma       = new Map<String, Id>();
        Map<String, Id> mapaEnfasis       = new Map<String, Id>();

        if (!codigosuniversidad.isEmpty()) {
            for (Account c : [SELECT Id, CC_Codigo_universidad__c FROM Account WHERE CC_Codigo_universidad__c IN :codigosuniversidad]) {
                if (c.CC_Codigo_universidad__c != null) mapaUniversidad.put(c.CC_Codigo_universidad__c, c.Id);
            }
        }

        if (!codigosPrograma.isEmpty()) {
            for (Account c : [SELECT Id, CC_CODIGO_BANNER__c FROM Account WHERE CC_CODIGO_BANNER__c IN :codigosPrograma]) {
                if (c.CC_CODIGO_BANNER__c != null) mapaPrograma.put(c.CC_CODIGO_BANNER__c, c.Id);
            }
        }

        if (!codigosEnfasis.isEmpty()) {
            for (CC_Concentracion__c c : [SELECT Id, CC_Concentraci_n__r.CC_CODIGO_BANNER__c FROM CC_Concentracion__c WHERE CC_Concentraci_n__r.CC_CODIGO_BANNER__c IN :codigosEnfasis]) {
                if (c.CC_Concentraci_n__r.CC_CODIGO_BANNER__c != null) mapaEnfasis.put(c.CC_Concentraci_n__r.CC_CODIGO_BANNER__c, c.Id);
            }
        }


        // Asignamos los IDs a los registros Account
        for (hed__Education_History__c acc : newAccounts) {

            if (acc.CC_Institucion_Educativa_lok__c != null) {
                acc.CC_Instituci_n_Educativa__c = mapaUniversidad.get(acc.CC_Institucion_Educativa_lok__c);
            }
            if (acc.CC_Programa_academico_lok__c != null) {
                acc.Programa_acad_mico_Estudios__c = mapaPrograma.get(acc.CC_Programa_academico_lok__c);
            }

            if (acc.Enfasis_en_banner__c != null) {
                acc.Enfasis_en_1__c = mapaEnfasis.get(acc.Enfasis_en_banner__c);
            }

           
        }
    }
}