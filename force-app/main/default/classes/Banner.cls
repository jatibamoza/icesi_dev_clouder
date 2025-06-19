public with sharing class Banner {

    
    public virtual class DmsUtilsException extends Exception {}

    private static String strToken;

    private static CC_Datos_Banner__mdt wsInfo;
    
    static{wsInfo = [ SELECT clientId__c, clientSecret__c,CC_End_Point__c FROM CC_Datos_Banner__mdt LIMIT 1];}

     /**
    * @description Calls Signio services based on the Path a Boody received. If the Token is null, the call is executed without authentication header.
    * @param strPath Service path
    * @param strBody Http request body
    * @param strRequestType Http request type POST, GET, PUT or DELETE
    * @param strAuthToken Authorization Bearer Token
    * @return String Http response body
    */
    
    public static void CreacionCliente(String Individualapp) {

        IndividualApplication IA = new IndividualApplication();
        IA = [SELECT AccountId,CC_Codigo_periodo__c,Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c,CC_Codigo_de_detalle__c,codigo_acudiente__c,RecordTypeId,CC_Concentraci_n_primer_programa__r.CC_CODIGO_BANNER__c,CC_Segundo_programa_de_inter_s__r.CC_CODIGO_BANNER__c,Porcentaje_de_descuento__c,CC_Beca_empresarial_a_aplicar__c, CC_Pago_confirmado__c FROM IndividualApplication WHERE Id= :Individualapp];

        Account acc = new Account();
        acc = [SELECT CC_ACC_N_mero_id__c ,CC_Acc_Tipo_id__c,FirstName,LastName,CC_Pa_s_de_expedici_n__c,CC_Departamento_de_expedici_n__c,CC_Nacionalidad__c	,CC_Pa_s_de_nacimiento__c,CC_Departamento_nacimiento__c,CC_E_P_S__c,CC_Estrato__c ,CC_Grupo_sanguineo__c,CC_G_nero__c,CC_Etnia__c,CC_Benefeciario_ley_veterano__c,CC_Programa_de_inter_s__r.CC_CODIGO_BANNER__c,CC_Parentesco_del__c	,CC_Puntaje_Global_ICFES_P__c ,CC_N_mero_de_registro__c ,CC_Direcci_n__c,CC_Barrio__c,CC_Datos_adicionales_de_direcci_n__c,PersonEmail,Phone,PersonMobilePhone ,CC_Colegio__r.CC_CODIGO_BANNER__c,CC_Universidad_de_procedencia__c,CC_Universidad_de_procedencia__r.CC_Codigo_universidad__c,CC_Discapacidad__c ,Persona_con_discapacidad__c,CC_Acudiente__c,CC_Programa_que_se_estaba_cursando__r.CC_CODIGO_BANNER__c,CC_Fecha_nacimiento__c,CC_Tipo_de_examen__c,CC_Ciudad_de_expedici_n_documento_Text__c,CC_Ciudad_de_nacimiento_text__c,CC_Ciudad_de_residencia__c,Country__r.CC_Codigo_pais__c,Department__r.C_digo_de_departamento__c ,City__c ,birthCountry__r.CC_Codigo_pais__c,birthDepartment__r.C_digo_de_departamento__c,birthCity__c,IssueContry__r.CC_Codigo_pais__c,IssueDepartment__r.C_digo_de_departamento__c ,IssueCity__c,CC_Indicativo_telefonico__c,CC_Fecha_de_graduacion__c , CC_Fecha_de_grado_de_la_universidad__c,CC_Estado_civil__c,City__r.C_digo_de_ciudad__c,birthCity__r.C_digo_de_ciudad__c,IssueCity__r.C_digo_de_ciudad__c FROM Account WHERE Id= :IA.AccountId];


        RecordType tipo = [SELECT Id,DeveloperName FROM RecordType WHERE Id = :IA.RecordTypeId LIMIT 1];

        List<Account> acuList  =new List<Account>();
        List<hed__Relationship__c> padreList  =new List<hed__Relationship__c>();
        List<hed__Relationship__c> madreList  =new List<hed__Relationship__c>();
        list<Trabajo__c> trabajo  =new  list<Trabajo__c>();
        list<hed__Education_History__c> universidad  =new  list<hed__Education_History__c>();

        if(tipo.DeveloperName != 'Posgrado'){
            
            if(acc.CC_Acudiente__c != null){
                acuList  = [SELECT PersonMobilePhone,CC_Pa_s_cuenta__c,CC_Pa_s_de_residencia_del_acudiente__c,CC_Departamento_de_residencia_del_padre__c,Phone,PersonEmail,FirstName,LastName,CC_Departamento__c ,CC_Ciudad_residencia_acudiente_Text__c ,Department__r.C_digo_de_departamento__c,Country__r.CC_Codigo_pais__c ,City__c,City__r.C_digo_de_ciudad__c FROM Account WHERE id = :acc.CC_Acudiente__c ];
            }
            
            padreList  = [SELECT Cuenta_relacionada__r.FirstName,Cuenta_relacionada__r.LastName,Cuenta_relacionada__r.PersonEmail,Cuenta_relacionada__r.Phone,Cuenta_relacionada__r.PersonMobilePhone FROM hed__Relationship__c WHERE hed__Contact__r.AccountId = :acc.Id AND hed__Type__c = 'Padre'];

            madreList = [SELECT Cuenta_relacionada__r.FirstName,Cuenta_relacionada__r.LastName,Cuenta_relacionada__r.PersonEmail,Cuenta_relacionada__r.Phone,Cuenta_relacionada__r.PersonMobilePhone FROM hed__Relationship__c WHERE hed__Contact__r.AccountId = :acc.Id AND hed__Type__c = 'Madre'];
        }else {
            universidad  = [SELECT CC_Instituci_n_Educativa__r.CC_Codigo_universidad__c,hed__Graduation_Date__c, CC_ProfesinCarrera__r.CC_CODIGO_BANNER__c FROM hed__Education_History__c WHERE hed__Contact__r.AccountId = :acc.Id AND CC_Grado_de_educaci_n__c = 'PR' AND hed__Graduation_Date__c != null ORDER BY hed__Graduation_Date__c DESC LIMIT 1];
          
            trabajo  = [SELECT  CC_Empresa_Graduado__c,CC_PreSector_de_la_empresa__c,CC_Cargo__c,CC_Trabajo_actual__c,CC_A_os_de_experiencia_en_este_trabajo__c,CC_Ano_de_ingreso__c,CC_Desde_el_mes__c ,CC_Area_POS__c,CC_Remuneraci_n_laboral__c,CC_Pre_Nivel_del_cargo__c,CC_Tipo_vinculaci_n__c,CC_Tama_o_de_la_empresa_Empresa__c,CC_Salario__c,CC_Direcci_n_trabajo__c,CC_Pa_s_trabajo__r.CC_Codigo_pais__c,CC_Departamento_trabajo__r.C_digo_de_departamento__c, Ciudad_donde_trabja_text__c,CC_Tel_fono_del_trabajo__c,CC_Correo_Empresarial__c,CC_Employ_Ciudad_no_aparece_en_la_lista__c,CC_Ciudad_trabajo__r.C_digo_de_ciudad__c,CC_Empresa__r.Name,CC_Responsabilidad__c FROM Trabajo__c WHERE CC_Cuenta__c = :acc.Id AND ((CC_Ano_de_ingreso__c != NULL AND CC_Desde_el_mes__c != NULL) OR CC_Trabajo_actual__c = true)];

        }
        //Informacion de la persona
        Map<String, Object> Persona = new Map<String, Object>();

        Persona.put('pAdditionalIdSF', Individualapp); // ID SALESFORCE IA
        Persona.put('pAdditionalIdSFC', acc.Id); // ID SALESFORCE CUENTA
        Persona.put('pAdidCodeSF', 'CS'); // CODIGO SALESFORCE

        if(acc.CC_Benefeciario_ley_veterano__c == 'Si'){
            Persona.put('pHairCode', acc.CC_Parentesco_del__c); // TIPO DE VETENANOS DE LA PERSONA
            Persona.put('pVeraInd',  acc.CC_Benefeciario_ley_veterano__c != 'Si' ? 'Y' : 'N' ); 
        }
        // LEY DE VETERANOS
        if(acc.Persona_con_discapacidad__c == 'Si'){
            Persona.put('pDisaCode', acc.CC_Discapacidad__c); // DISCAPACIDAD DE LA PERSONA
        }
        
        Persona.put('pPhoneNumberTel',  acc.Phone != null ? acc.Phone.replaceAll('[^0-9+]', '').trim() : null); // TELEFONO DE LA PERSONA
        Persona.put('pTeleCodeTel', 'TF'); // TELEFONO DE RESIDENCIA DE LA PERSONA

       
        Persona.put('pPhoneNumberCel', acc.PersonMobilePhone != null ? acc.PersonMobilePhone.replaceAll('[^0-9+]', '').trim() : null); // CELULAR DE LA PERSONA
        Persona.put('pTeleCodeCel', 'CE'); // TIPO DE CELULAR
        Persona.put('pCountryCode', acc.CC_Indicativo_telefonico__c  != null ? acc.CC_Indicativo_telefonico__c.split(': ')[1] : ''); // TIPO DE CELULAR
        Persona.put('pPreferredIndEs',  'Y'); //CORREO PREFERIDO
        Persona.put('pEmailAddressEs', acc.PersonEmail ); // CORRREO DE LA PERSONA
        Persona.put('pEmalCodeEs', 'PE'); // TIPO DE CORREO

        Persona.put('pCntyCodeDir', acc.City__c != null ? acc.City__r.C_digo_de_ciudad__c : '0001'); // CIUDAD DE RESIDENCIA DE LA PERSONA
        
        Persona.put('pCntyNameDir', acc.CC_Ciudad_de_nacimiento_text__c != null ? acc.CC_Ciudad_de_nacimiento_text__c : ''); // CIUDAD DE RESIDENCIA DE LA PERSONA texto 

        Persona.put('pStatCodeDir', acc.Department__r.C_digo_de_departamento__c ); // DEPARTAMENTO DE RESIDENCIA DE LA PERSONA
        Persona.put('pNatnCodeDir', acc.Country__r.CC_Codigo_pais__c); // PAIS DE RESIDENCIA DE LA PERSONA

        Persona.put('pAtypCodeDir', 'MA'); // DATOS ADICIONALES DE LA 
        Persona.put('pStreetLine3',acc.CC_Datos_adicionales_de_direcci_n__c); // DATOS ADICIONALES DE LA DIRECCIÓN
        Persona.put('pStreetLine2',acc.CC_Barrio__c); // BARRIO DE LA PERSONA
        Persona.put('pStreetLine1',acc.CC_Direcci_n__c); // DIRECCION DE LA PERSONA

        Persona.put('pGndrCode', acc.CC_G_nero__c); // GENERO DE LA PERSONA
        if(tipo.DeveloperName == 'Posgrado'){
            Persona.put('pMrtl', acc.CC_Estado_civil__c); // estado civil
        }
        Persona.put('pMediCode', acc.CC_Grupo_sanguineo__c); // TIPO DE SANGRE
        Persona.put('pTestScoreEst', acc.CC_Estrato__c); // ESTRATO DE LA PERSONA
        Persona.put('pTescCodeEst','0003' ); // TIPO ESTRATO DE LA PERSONA
        Persona.put('pMdeqCode', acc.CC_E_P_S__c); // EPS DE LA PERSONA


  
        Persona.put('pCntyNameNac',  acc.CC_Ciudad_de_nacimiento_text__c != null ? acc.CC_Ciudad_de_nacimiento_text__c : '' ); // CIUDAD DE NACIMIENTO TEXTO
        Persona.put('pCntyCodeNac',  acc.birthCity__c != null ? acc.birthCity__r.C_digo_de_ciudad__c : '0001' ); // CIUDAD DE NACIMIENTO
  
        Persona.put('pStatCodeNac', acc.birthDepartment__r.C_digo_de_departamento__c ); // DEPARTAMENTO DE NACIMIENTO
        Persona.put('pNatnCodeNac', acc.birthCountry__r.CC_Codigo_pais__c); // PAIS DE NACIMIENTO
        Persona.put('pAtypCodeNac', 'NA'); // NA siempre

        Persona.put('pNatnCodeNal',  acc.CC_Nacionalidad__c); // PAIS DE NACIONALIDAD
        Persona.put('pAtypCodeNal','NC' ); // NC siempre

        Persona.put('pCntyNameExp',  acc.CC_Ciudad_de_expedici_n_documento_Text__c != null ? acc.CC_Ciudad_de_expedici_n_documento_Text__c : ''); // CIUDAD DE EXPEDICION TEXTO
        Persona.put('pCntyCodeExp',  acc.IssueCity__c != null ? acc.IssueCity__r.C_digo_de_ciudad__c : '0001'); // CIUDAD DE EXPEDICION

        Persona.put('pStatCodeExp',  acc.IssueDepartment__r.C_digo_de_departamento__c ); // DEPARTAMENTO DE EXPEDICIÓN
        Persona.put('pNatnCodeExp', acc.IssueContry__r.CC_Codigo_pais__c); // PAIS DE EXPEDICIÓN
        Persona.put('pAtypCodeExp','EX' ); // ex siempre

        Persona.put('pEthnCode', acc.CC_Etnia__c); // ETNIA DE LA PERSONA

        Persona.put('pBirthDate',  acc.CC_Fecha_nacimiento__c); // Fecha de nacimientos
        Persona.put('pLastName', acc.LastName); // apellidos
        
        List<String> nombresSeparados = NombreCompleto(Acc.FirstName); 
        Persona.put('pMi',  nombresSeparados[1]!= null ? nombresSeparados[1] : ''); // segundo nombre ver si se puede del primer nombre
        Persona.put('pFirstName', nombresSeparados[0]); // primer nombre

        Persona.put('pCitzCode', acc.CC_Acc_Tipo_id__c); // tipo de documento codigo
        Persona.put('pSsn', acc.CC_ACC_N_mero_id__c); // documento de la     persona

       
        Map<String, Object> Programa = new Map<String, Object>();

        if(tipo.DeveloperName == 'Posgrado'){
            Programa.put('secondProgram',  IA.CC_Segundo_programa_de_inter_s__r.CC_CODIGO_BANNER__c != null ?  IA.CC_Segundo_programa_de_inter_s__r.CC_CODIGO_BANNER__c : null); // SEGUNDO PROGRAMA DE INTERES
            Programa.put('concentration',  IA.CC_Concentraci_n_primer_programa__r.CC_CODIGO_BANNER__c != null ?  IA.CC_Concentraci_n_primer_programa__r.CC_CODIGO_BANNER__c : null); // CONCENTRACIÓN PRIMER PROGRAMA
        }
        Programa.put('pTermCodeEntry',  IA.CC_Codigo_periodo__c != null ?  IA.CC_Codigo_periodo__c : null); // PERIODO DE INSCRIPCION DEL PROGRAMA
        Programa.put('pProgram', IA.Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c != null ? IA.Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c : null);//CODIGO DE PROGRAMA QUE SE INCRIBE LA PERSONA


        Map<String, Object> Contenedor = new Map<String, Object>();
        
        if(tipo.DeveloperName == 'Posgrado'){
            Map<String, Object> FINANCIERA = new Map<String, Object>();

          
            FINANCIERA.put('discountPercentage',  IA.Porcentaje_de_descuento__c); 
          
            
            FINANCIERA.put('codeScholarship',  IA.CC_Beca_empresarial_a_aplicar__c); // TIPO DE DOCUMENTO QUE SE ENVIA
            FINANCIERA.put('cohort',  IA.CC_Codigo_periodo__c); 
            FINANCIERA.put('codeDetail',  IA.CC_Codigo_de_detalle__c); 
            Contenedor.put('financialInformation',  FINANCIERA);
        }
        
        if(tipo.DeveloperName != 'Posgrado'){
  
            Map<String, Object> Examenes = new Map<String, Object>();
            if(acc.CC_Tipo_de_examen__c == 'ICFES'){
                Examenes.put('pAdditionalId',  acc.CC_N_mero_de_registro__c); // CODIGO ICFES DEL ESTUDIANTE
                Examenes.put('pAdidCode',  'CI'); // TIPO DE DOCUMENTO QUE SE ENVIA
                Examenes.put('pTestScore',  String.valueOf(acc.CC_Puntaje_Global_ICFES_P__c)); // PUNTAJE ICFES
                Examenes.put('pTescCode',  '0002'); // CODIGO DE EXAMEN (ICFES)
            }
            Contenedor.put('exams',  Examenes);
        }
       
   
    
        Map<String, Object> Academico = new Map<String, Object>();

        hed__Education_History__c uni;

        if(acc.CC_Universidad_de_procedencia__c != null && tipo.DeveloperName != 'Posgrado'){
            
            Academico.put('pDegcCodeUni',  acc.CC_Programa_que_se_estaba_cursando__r.CC_CODIGO_BANNER__c); // PROGRAMA QUE SE ESTABA CURSANDO
            Academico.put('pSbgiCodeUni',  acc.CC_Universidad_de_procedencia__r.CC_Codigo_universidad__c);
        }
         // UNIVERDIDAD DE LA QUE VIENE
        Academico.put('pSbgiCodeCol',  acc.CC_Colegio__r.CC_CODIGO_BANNER__c); // COLEGIO DE DONDE SE GRADUO

        if(tipo.DeveloperName == 'Posgrado' && !universidad.isEmpty()){
            uni = universidad[0];
            Academico.put('pGraduationDate',  uni.hed__Graduation_Date__c ); // 
            Academico.put('pDegcCodeUni',  uni.CC_ProfesinCarrera__r.CC_CODIGO_BANNER__c); // 
            Academico.put('pSbgiCodeUni',  uni.CC_Instituci_n_Educativa__r.CC_Codigo_universidad__c);

        }


        if(tipo.DeveloperName != 'Posgrado'){
            hed__Relationship__c padreObj;
            Map<String, Object> Padre = new Map<String, Object>();
            if(!padreList.isEmpty()){
                padreObj = padreList[0];
                
                // Obtener el número de teléfono
                String rawPhoneNumber = padreObj.Cuenta_relacionada__r.Phone != null 
                ? padreObj.Cuenta_relacionada__r.Phone 
                : padreObj.Cuenta_relacionada__r.PersonMobilePhone;

                // Limpiar el número de teléfono para mantener solo los dígitos
                String cleanPhoneNumber = rawPhoneNumber != null ? rawPhoneNumber.replaceAll('[^0-9]', '') : null;

                // Asignar al mapa
                Padre.put('pPhoneNumber', cleanPhoneNumber);
                Padre.put('pTeleCode', padreObj.Cuenta_relacionada__r.Phone != null ? 'TF':'CE'); // TIPO DE TELFONO debe ser TF o si es un celular CE.
                Padre.put('pAtypCode', 'PA'); // 
                Padre.put('pEmailAddress',  padreObj.Cuenta_relacionada__r.PersonEmail); // DIRECCION DE CORREO
                Padre.put('pEmalCode',  'CP'); // TIPO DE CORREO
                Padre.put('pParentLast',  padreObj.Cuenta_relacionada__r.LastName); // APELLIDOS
                List<String> nombresSeparadosp = NombreCompleto(padreObj.Cuenta_relacionada__r.FirstName); 
                Padre.put('pParentMi',  nombresSeparadosp[1] != null ? nombresSeparadosp[1] : ''); // SEGUNDO NOMBRE
                Padre.put('pParentFirst', nombresSeparadosp[0]); // PRIMER NOMBRE
            
                Padre.put('pReltCode',  'P');   // RELACION CON EL ASPIRANTE

            }

            hed__Relationship__c madreObj;
            Map<String, Object> Madre = new Map<String, Object>();
            if(!madreList.isEmpty()){
                madreObj = madreList[0];

                // Obtener el número de teléfono
                String rawPhoneNumber = madreObj.Cuenta_relacionada__r.Phone != null 
                ? madreObj.Cuenta_relacionada__r.Phone 
                : madreObj.Cuenta_relacionada__r.PersonMobilePhone;

                // Limpiar el número de teléfono para mantener solo los dígitos
                String cleanPhoneNumber = rawPhoneNumber != null ? rawPhoneNumber.replaceAll('[^0-9]', '') : null;

                // Asignar al mapa
                Madre.put('pPhoneNumber', cleanPhoneNumber);

                Madre.put('pTeleCode', madreObj.Cuenta_relacionada__r.Phone != null ? 'TF':'CE'); // TIPO DE TELFONO debe ser TF o si es un celular CE.
                Madre.put('pAtypCode',  'PM'); // 
                Madre.put('pEmailAddress',  madreObj.Cuenta_relacionada__r.PersonEmail); // DIRECCION DE CORREO
                Madre.put('pEmalCode',  'CM'); // TIPO DE CORREO
                Madre.put('pParentLast',  madreObj.Cuenta_relacionada__r.LastName); // APELLIDOS
                List<String> nombresSeparadosm = NombreCompleto(madreObj.Cuenta_relacionada__r.FirstName); 
                Madre.put('pParentMi', nombresSeparadosm[1] != null ? nombresSeparadosm[1] : ''); // SEGUNDO NOMBRE
                Madre.put('pParentFirst',  nombresSeparadosm[0]  ); // PRIMER NOMBRE
            
                Madre.put('pReltCode',  'M');   // RELACION CON EL ASPIRANTE
    
            }

        
            Map<String, Object> acud = new Map<String, Object>();

            Account ac;

            if(!acuList.isEmpty()){
                ac = acuList[0];

                // Obtener el número de teléfono
                String rawPhoneNumber = ac.PersonMobilePhone != null  ? ac.PersonMobilePhone : ac.Phone;

                // Limpiar el número de teléfono para mantener solo los dígitos
                String cleanPhoneNumber = rawPhoneNumber != null ? rawPhoneNumber.replaceAll('[^0-9]', '') : null;

                // Asignar al mapa
                acud.put('pPhoneNumber', cleanPhoneNumber);

                acud.put('pTeleCode',   ac.PersonMobilePhone != null ? 'CE' : 'TF'); // TIPO DE TELFONO debe ser TF o si es un celular CE.

                acud.put('pCntyCode',  ac.City__c != null ?  ac.City__r.C_digo_de_ciudad__c : '0001'); // CIUDAD DE RESIDENCIA
                acud.put('pCntyName',  ac.CC_Ciudad_residencia_acudiente_Text__c != null ? ac.CC_Ciudad_residencia_acudiente_Text__c : ''); // CIUDAD DE RESIDENCIA

                acud.put('pStatCode',  ac.Department__r.C_digo_de_departamento__c ); // DEPARTAMENTO DE RESIDENCIA
                acud.put('pNatnCode',  ac.Country__r.CC_Codigo_pais__c ); // PAIS DE RESIDENCIA
                acud.put('pAtypCode',  'AC'); // 
                acud.put('pEmailAddress', ac.PersonEmail ); // DIRECCION DE CORREO
                acud.put('pEmalCode',  'CA'); // TIPO DE CORREO
                acud.put('pParentLast',  ac.LastName); // APELLIDOS
                List<String> nombresSeparadosa = NombreCompleto(ac.FirstName); 
                acud.put('pParentMi',  nombresSeparadosa[1] != null ? nombresSeparadosa[1] : ''); // SEGUNDO NOMBRE
                acud.put('pParentFirst',  ac.FirstName); // PRIMER NOMBRE
                acud.put('pReltCode',  'A');   // RELACION CON EL ASPIRANTE

               
            }
            Contenedor.put('attendantInformation',  acud);
            Contenedor.put('motherInformation',  Madre);
            Contenedor.put('fatherInformation',  Padre);
        }else{

            Map<String, Object> trabajos = new Map<String, Object>();
            Trabajo__c tr;

            if(!trabajo.isEmpty()){
                tr = trabajo[0];
              
                // Asignar al mapa
                String nombreEmpresa = tr.CC_Empresa__r.Name;
                nombreEmpresa = nombreEmpresa != null ? nombreEmpresa.substring(0, Math.min(35, nombreEmpresa.length())) : '';

                trabajos.put('organizationWork', nombreEmpresa);
                trabajos.put('activityOrganization',   tr.CC_PreSector_de_la_empresa__c); 
                trabajos.put('jobTitle',  tr.CC_Cargo__c); 
                trabajos.put('isWorking',  tr.CC_Trabajo_actual__c == true ? 'SI' : 'NO'); 
                trabajos.put('workExperience',  tr.CC_A_os_de_experiencia_en_este_trabajo__c); 
                trabajos.put('workingFromYear',  tr.CC_Ano_de_ingreso__c ); 
                trabajos.put('workingFromMonth',  tr.CC_Desde_el_mes__c); 
                trabajos.put('area',  tr.CC_Area_POS__c); 
                String remuneracion = null;
                if(tr.CC_Remuneraci_n_laboral__c == true && tr.CC_Trabajo_actual__c ==  true){
                    remuneracion = 'SI';
                }else if(tr.CC_Remuneraci_n_laboral__c == false && tr.CC_Trabajo_actual__c ==  true){
                    remuneracion = 'NO';
                }
                trabajos.put('isRemuneration', remuneracion); 
                trabajos.put('workResponsibility', tr.CC_Responsabilidad__c);  
                trabajos.put('occupationalPosition',  tr.CC_Tipo_vinculaci_n__c ); 
                trabajos.put('employeeNumber',  tr.CC_Tama_o_de_la_empresa_Empresa__c); 
                trabajos.put('averageSalaryPerMonth',  tr.CC_Salario__c ); 

                Map<String, Object> direccion = new Map<String, Object>();
                direccion.put('typeAddress', (tr.CC_Direcci_n_trabajo__c == null && tr.CC_Pa_s_trabajo__r.CC_Codigo_pais__c == null && tr.CC_Departamento_trabajo__r.C_digo_de_departamento__c == null && (tr.CC_Ciudad_trabajo__r.C_digo_de_ciudad__c == null && tr.Ciudad_donde_trabja_text__c != null )) != true ?  'BU' : null ); 
                direccion.put('streetAddress1', tr.CC_Direcci_n_trabajo__c);  
                direccion.put('codeCountry',  tr.CC_Pa_s_trabajo__r.CC_Codigo_pais__c ); 
                direccion.put('codeState',  tr.CC_Departamento_trabajo__r.C_digo_de_departamento__c); 
                direccion.put('codeCity',  tr.CC_Employ_Ciudad_no_aparece_en_la_lista__c == false ? tr.CC_Ciudad_trabajo__r.C_digo_de_ciudad__c :tr.Ciudad_donde_trabja_text__c); 
                
                Map<String, Object> telefono = new Map<String, Object>();
                telefono.put('typePhone', tr.CC_Tel_fono_del_trabajo__c != null ?  'TF' : null); 
                telefono.put('phoneNumber', tr.CC_Tel_fono_del_trabajo__c);  
          
                Map<String, Object> email = new Map<String, Object>();
                email.put('typeEmail',  tr.CC_Correo_Empresarial__c != null ? 'TR'  : null); 
                email.put('emailAddress', tr.CC_Correo_Empresarial__c);  
          
               trabajos.put('addressWork',  direccion);
                trabajos.put('phoneWork',  telefono);
                trabajos.put('emailWork',  email);
                
            }

            Contenedor.put('workSituation',  trabajos);

        }


        Contenedor.put('academicInformation',  Academico);
       
        Contenedor.put('programs',  Programa);
        Contenedor.put('person',  Persona);
      
        String jsonStr = JSON.serialize(Contenedor);
        String jsonRes =   callDms( tipo.DeveloperName != 'Posgrado' ? '/person/create_person' : '/person/create_person/postgraduate', jsonStr, 'POST', getToken() );  

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
        String IDBANNER,MONTO,FACTURA;
        Boolean pagos = false;
        string status = (String) responseMap.get('status');
        string error = (String) responseMap.get('error');
        string message = (String) responseMap.get('message');

        if(status == 'SUCCESS'){
            // Obtener el objeto "data"
            Map<String, Object> dataMap = (Map<String, Object>) responseMap.get('data');
            // Obtener el accessToken
            IDBANNER = (String) dataMap.get('id');
            MONTO = (String) dataMap.get('amount');
            FACTURA = (String) dataMap.get('invoiceNumber');
            pagos = (Boolean) dataMap.get('payments');

        }

        actualizar( Individualapp, jsonStr,IDBANNER,MONTO,FACTURA,status,error,message,pagos); 
        
       
        
    }



    public static void admision(String Individualapp) {

        IndividualApplication IA = new IndividualApplication();
        IA = [SELECT Account.CC_ACC_N_mero_id__c,CC_Codigo_periodo__c, Status,codigo_carrera__c,Causa_de_no_admisi_n__c,Causa_de__c ,AccountId FROM IndividualApplication WHERE Id= :Individualapp];

 
        //Informacion de la persona
        Map<String, Object> adm = new Map<String, Object>();

        adm.put('pSsn', IA.Account.CC_ACC_N_mero_id__c); 
        adm.put('pProgram', IA.codigo_carrera__c); 
        adm.put('pTermCodeEntry',  IA.CC_Codigo_periodo__c); 

        adm.put('pAdditionalIdSFC', IA.AccountId); 
        adm.put('pAdditionalIdSF',  IA.Id); 

        String staduscode ;
        if(IA.Status == 'Comité'){
            staduscode = '15';
        } else if (IA.Status == 'Admitido'){
            staduscode = '35';
        }else if (IA.Status == 'No admitido'){
            staduscode = IA.Causa_de_no_admisi_n__c;
        }else if (IA.Status == 'Desiste'){
            staduscode = IA.Causa_de__c;
        }

        adm.put('pApdcCode', staduscode); 

      
        String jsonStr = JSON.serialize(adm);
        String jsonRes =   callDms( '/admission/decision', jsonStr, 'POST', getToken() );  

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);
        String IDBANNER = '',MONTO = '',FACTURA = '',resultado = '',PROCULTURA = '';
        Boolean pagos = false;
        String respuesta = (String)responseMap.get('status');
        
        string status = (String) responseMap.get('status');
        string error = (String) responseMap.get('error');
        string message = (String) responseMap.get('message');

        if(status == 'SUCCESS' ){
            // Obtener el objeto "data"
            Map<String, Object> dataMap = (Map<String, Object>) responseMap.get('data');
            IDBANNER = (String) dataMap.get('id');
           
            if(staduscode == '35' || staduscode == '40'){
                resultado = (String) dataMap.get('result');
                MONTO = (String) dataMap.get('amount');
                FACTURA = (String) dataMap.get('invoiceNumber'); 
                PROCULTURA = (String) dataMap.get('procultureTax');
                pagos = (Boolean) dataMap.get('payments');
            
            }
          
            actualizarmatricula( Individualapp, jsonStr,IDBANNER,MONTO,FACTURA,resultado,PROCULTURA,status,error,message,pagos); 
           

        }else{
            actualizarmatricula( Individualapp, jsonStr,IDBANNER,MONTO,FACTURA,resultado,PROCULTURA,status,error,message,pagos); 
        }

        
    }

    @future (callout=true)
    public static void actualizar(String Id,string RESULTADO,string IDBANNER,string MONTO,string FACTURA,string status,string error,string message,boolean pagos){
        
  
        IndividualApplication Acc = new IndividualApplication();
        Acc = [SELECT resultado_banner__c,Numero_de_factura__c,Monto_factura__c,Id_banner__c,Status__c,Error__c,Mensaje_error__c,Fecha_envio_integraci_n__c,Reenvio_formulario__c,Pagos_realizados__c  FROM IndividualApplication WHERE Id= :Id];

        Acc.Status__c = status;
        Acc.Error__c = error;
        Acc.Mensaje_error__c =  message;
        Acc.Reenvio_formulario__c = false;

        Acc.resultado_banner__c = RESULTADO;
        if(status == 'SUCCESS' && FACTURA != null && FACTURA != ''){
            Acc.Numero_de_factura__c = FACTURA;
            Acc.Monto_factura__c = MONTO != null ? Decimal.valueOf(MONTO) : null;
            Acc.Id_banner__c =  IDBANNER;
            Acc.Error__c = '';
            Acc.Mensaje_error__c =  '';
            
        }
        // Asignar solo la fecha al campo (sin la parte de hora)
        Acc.Fecha_envio_integraci_n__c = DateTime.now();
        Acc.Pagos_realizados__c = pagos != null ?pagos: false ;
    
        update Acc;
       
    }

    @future (callout=true)
    public static void actualizarmatricula( String Individualapp, String jsonStr, String IDBANNER,String MONTO, String FACTURA,String resultado,String PROCULTURA,String status,String error,String message, Boolean pagos){
        
        IndividualApplication Acc = new IndividualApplication();
        Acc = [SELECT Resultado_matricula__c,Numero_de_factura_matricula__c,Monto_factura_matricula__c,Id_banner_matricula__c ,Monto_procultura__c ,Status_matricula__c,Error_matricula__c,Mensaje_error_matricula__c ,Fecha_envi_integraci_n_matricula__c,Reenvi_decisi_n_admisi_n__c,Pagos_realizados_matricula__c FROM IndividualApplication WHERE Id= :Individualapp];
        

        Acc.Status_matricula__c = status;
        Acc.Error_matricula__c = error;
        Acc.Mensaje_error_matricula__c =  message;
        Acc.Resultado_matricula__c = jsonStr;
        Acc.Reenvi_decisi_n_admisi_n__c = false;

        if(status == 'SUCCESS' && FACTURA != null && FACTURA != ''){
            Acc.Numero_de_factura_matricula__c = FACTURA;
            Acc.Monto_factura_matricula__c =  MONTO != null ? Decimal.valueOf(MONTO) : null;
            Acc.Monto_procultura__c = Decimal.valueOf(PROCULTURA);
            
           
        } 
        Acc.Id_banner_matricula__c =  IDBANNER;
        Acc.Fecha_envi_integraci_n_matricula__c = DateTime.now();
        Acc.Pagos_realizados_matricula__c = pagos != null ?pagos: false;
        
        update Acc;
    }

    
    public static void Documentos(String Individualapp) {

        IndividualApplication info;
        info = [SELECT Id,AccountId, Id_banner__c, CC_Codigo_periodo__c,Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c,Carrera_de_mayor_interes__r.Lista_de_documentos__c  , Account.CC_Acc_Tipo_id__c,RecordTypeId
                FROM IndividualApplication WHERE Id= :Individualapp];

        RecordType tipo = [SELECT Id,DeveloperName FROM RecordType WHERE Id = :info.RecordTypeId LIMIT 1];

        List<ContentDocumentLink> contentDocumentLinks = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :info.AccountId
        ];

        List<Id> contentDocumentIds = new List<Id>();
        for (ContentDocumentLink link : contentDocumentLinks) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        List<ContentVersion> docs = [
            SELECT Id, Title, VersionData, FileExtension,ContentSize,FileType,VersionNumber,VersionDataUrl
            FROM ContentVersion 
            WHERE ContentDocumentId IN :contentDocumentIds AND IsLatest = true ORDER BY CreatedDate DESC
        ];

        Map<String, Object> Persona = new Map<String, Object>();
        List<Object> documentos = new List<Object>();

        Set<String> existingCodes = new Set<String>();

        for (ContentVersion doc : docs) {
            Map<String, Object> documento = new Map<String, Object>();
            documento.put('documentUrl', doc.VersionDataUrl );
            documento.put('documentVersion', doc.VersionNumber );
            documento.put('documentType', doc.FileType );
            documento.put('documentExt', doc.FileExtension );

            STRING identificacion = doc.Title;
            if(doc.Title.contains('documentosdeIdentidad')){
                    identificacion = 'cedula';
            }
            String codigoDocumento = Tipodocumento(identificacion,tipo.DeveloperName).get('cod');
            String codigoDocumentoreas = Tipodocumento(identificacion,tipo.DeveloperName).get('codre');

            Boolean valor= false;
          
            if(tipo.DeveloperName == 'Posgrado' && info.Carrera_de_mayor_interes__r.Lista_de_documentos__c != null ){
        
                String listadoc  = info.Carrera_de_mayor_interes__r.Lista_de_documentos__c;
                // Convertir la Multi-Picklist en una lista separando por ';'
                List<String> listaDocumentos = listadoc.split(';');
                List<Integer> posiciones = new List<Integer>(); // Lista para guardar posiciones

                // Recorrer la lista y encontrar las posiciones del valor buscado
                for (Integer i = 0; i < listaDocumentos.size(); i++) {
                    System.debug(listaDocumentos[i]);
                    System.debug(codigoDocumento);
                    if (listaDocumentos[i] == codigoDocumentoreas) {
                        valor = true;
                        break;
                    }
                }
            }else{
                valor = true;
            }
            // Si el código ya existe en el conjunto, no lo agregamos nuevamente
                      
           
            if (!existingCodes.contains(codigoDocumento) && codigoDocumento != '0' && valor == true) {
                documento.put('documentName', Tipodocumento(identificacion,tipo.DeveloperName).get('nom'));
                documento.put('documentSize', doc.ContentSize);
                documento.put('salesforceDocumentId', doc.Id);
                documento.put('bannerDocumentCode', codigoDocumento);
        
                documentos.add(documento);
                existingCodes.add(codigoDocumento); // Agregamos el código al conjunto
            }
            
        }

        Persona.put('documents', documentos);
        Persona.put('salesforceApplicationId', info.Id); 
        Persona.put('salesforceAccountId', info.AccountId); 
        Persona.put('bannerProgram', info.Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c);
   
        Persona.put('bannerTermCode', info.CC_Codigo_periodo__c); 
        Persona.put('bannerPersonId', info.Id_banner__c);

        String jsonStr = JSON.serialize(Persona);

        String jsonRes =   callDms( '/person/upload_files', jsonStr, 'POST', getToken() ); 

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRes);

        string status = (String) responseMap.get('status');
        string error = (String) responseMap.get('error');
        string message = (String) responseMap.get('message');
        

        actualizarDOCS(Individualapp,jsonStr,status,error,message);
        

    }

    @future (callout=true)
    public static void actualizarDOCS(String Id,string RESULTADO,string status,string error, string message){
        
  
        IndividualApplication Acc = new IndividualApplication();
        Acc = [SELECT Status_documentos__c,Error_documentos__c,Mensaje_error_documentos__c,Fecha_envi_integraci_n_documetnos__c FROM IndividualApplication WHERE Id= :Id];

        Acc.Status_documentos__c = status;
        Acc.Error_documentos__c = error;
        Acc.Mensaje_error_documentos__c =  message;
        Acc.Fecha_envi_integraci_n_documetnos__c =  DateTime.now();

        Acc.Resultado_documentos__c = RESULTADO;
      
       update Acc;
       
    }

   
     // METODO DE ACTUALIZAR EN BANNER LOS CAMPOESTADO CIVIL
    public class ActualizaestadocivilQueueable implements Queueable, Database.AllowsCallouts {
        private List<Account> accounts;

        public ActualizaestadocivilQueueable(List<Account> accounts) {
            this.accounts = accounts;
        }

        public void execute(QueueableContext context) {
            Actualizaestadocivil(accounts);
        }
    }
    
    public static void Actualizaestadocivil(List<Account> accounts) {

        for (Account acc : accounts) {
       
            //String jsonRes =   callDms( '/person/' + acc.CC_ACC_N_mero_id__c + '/maritalStatus/' + acc.CC_Estado_civil__c , null, 'PUT', getToken() ); 
            
        }
        
    }


    // METODO DE ACTUALIZAR EN BANNER LOS CAMPOS DE CORREO DE CUENTAS Y TRABAJOS
    public class ActualizarCorreoQueueable implements Queueable, Database.AllowsCallouts {
        private Map<Id, String> accounts;
        private String tipo;
        private String principal;

        public ActualizarCorreoQueueable(Map<Id, String> accounts, String tipo, String principal) {
            this.accounts = accounts;
            this.tipo = tipo;
            this.principal = principal;
        }

        public void execute(QueueableContext context) {
            Actualizcorreo(accounts, tipo, principal);
        }
    }

    public static void Actualizcorreo(Map<Id, String> cuentasConCorreo, String tipo, String principal) {
        for (Id accId : cuentasConCorreo.keySet()) {
            Map<String, Object> email = new Map<String, Object>();

            System.debug(cuentasConCorreo);
            email.put('typeEmail', tipo);
            email.put('emailAddress', cuentasConCorreo.get(accId).split('llave')[0]); // Se obtiene el correo dinámico
            email.put('principalEmail', principal);
            email.put('accountId', cuentasConCorreo.get(accId).split('llave')[3]);
            email.put('emailObjectId', cuentasConCorreo.get(accId).split('llave')[2]);
          
            String jsonStr = JSON.serialize(email);
            
            //String jsonRes = callDms('/person/email/' + cuentasConCorreo.get(accId).split('llave')[1], jsonStr, 'POST', getToken());
        }
    }



    // METODO DE ACTUALIZAR EN BANNER LOS CAMPOS DE DIRECCIÓN DE CUENTAS Y TRABAJOS
    public class ActualizadireccionQueueable implements Queueable, Database.AllowsCallouts {
        private List<Account> accounts;
        private List<Trabajo__c> Trabajo;
        private String tipo;

        public ActualizadireccionQueueable(List<Account> accounts, List<Trabajo__c> Trabajo,String tipo) {
            this.accounts = accounts;
            this.Trabajo = Trabajo;
            this.tipo = tipo;
        }

        public void execute(QueueableContext context) {
            Actualizadireccion(accounts,Trabajo, tipo);
        }
    }
    public static void Actualizadireccion(List<Account> accounts, List<Trabajo__c> Trabajo, String tipo) {
 
        Map<Id, SObject> objeto = new Map<Id, SObject>(); // Usamos SObject en lugar de Object

        if (accounts != null) {
            Set<Id> accountIds = new Set<Id>();
            for (Account acc : accounts) {
                accountIds.add(acc.Id);
            }
    
            Map<Id, Account> accountMap = new Map<Id, Account>(
                [SELECT Id, Country__r.CC_Codigo_pais__c, 
                        Department__r.C_digo_de_departamento__c,
                        CC_Direcci_n__c, CC_Datos_adicionales_de_direcci_n__c,CC_Ciudad_de_nacimiento_text__c ,
                        CC_Barrio__c, CC_ACC_N_mero_id__c,City__r.C_digo_de_ciudad__c
                 FROM Account 
                 WHERE Id IN :accountIds]
            );

            objeto.putAll(accountMap); // Guardamos el mapa en "objeto"
        } else {
            Set<Id> trIds = new Set<Id>();
            for (Trabajo__c tr : Trabajo) {
                trIds.add(tr.Id);
            }
    
            Map<Id, Trabajo__c> trabajoMap = new Map<Id, Trabajo__c>(
                [SELECT Id, CC_Pa_s_trabajo__r.CC_Codigo_pais__c, 
                        CC_Departamento_trabajo__r.C_digo_de_departamento__c,Ciudad_donde_trabja_text__c ,
                        CC_Direcci_n_trabajo__c,CC_Employ_Ciudad_no_aparece_en_la_lista__c,CC_Cuenta__r.CC_ACC_N_mero_id__c,CC_Ciudad_trabajo__r.C_digo_de_ciudad__c
                 FROM Trabajo__c 
                 WHERE Id IN :trIds]
            );
    
            objeto.putAll(trabajoMap); // Guardamos el mapa en "objeto"
        }
    
  
        for (SObject sObj : objeto.values()) { 
            Map<String, Object> direccion = new Map<String, Object>();
            direccion.put('typeAddress', tipo);
    
            if (sObj instanceOf Account) { 
                Account accData = (Account) sObj; // Hacemos casting a Account
    
                direccion.put('codeCountry', accData.Country__r != null ? accData.Country__r.CC_Codigo_pais__c : null);

                string dep = accData.Department__r != null ? accData.Department__r.C_digo_de_departamento__c : '0';

                if(dep != null && dep.contains('noinf')){
                    dep = '0';
                }

                direccion.put('codeState', dep);
                direccion.put('codeCity', accData.City__r != null ? accData.City__r.C_digo_de_ciudad__c : '0001');
                direccion.put('cityName', accData.CC_Ciudad_de_nacimiento_text__c != null ? accData.CC_Ciudad_de_nacimiento_text__c : '');

                direccion.put('cityName', accData.Id);
                direccion.put('streetAddress1', accData.CC_Direcci_n__c);
                direccion.put('streetAddress2', accData.CC_Datos_adicionales_de_direcci_n__c);
                direccion.put('streetAddress3', accData.CC_Barrio__c);
                direccion.put('accountId', accData.Id);
                direccion.put('addressObjectId', accData.Id);
                
    
                String jsonStr = JSON.serialize(direccion);
                //String jsonRes = callDms('/person/address/' + accData.CC_ACC_N_mero_id__c, jsonStr, 'POST', getToken());
            } 
            
            else if (sObj instanceOf Trabajo__c) { 
                Trabajo__c trData = (Trabajo__c) sObj; // Hacemos casting a Trabajo__c
    
                direccion.put('codeCountry', trData.CC_Pa_s_trabajo__r != null ? trData.CC_Pa_s_trabajo__r.CC_Codigo_pais__c : null);

                string dep = trData.CC_Departamento_trabajo__r != null ? trData.CC_Departamento_trabajo__r.C_digo_de_departamento__c : '0';

                if(dep != null && dep.contains('noinf')){
                    dep = '0';
                }
                direccion.put('codeState', dep);

                direccion.put('cityName', trData.Ciudad_donde_trabja_text__c != null ? trData.Ciudad_donde_trabja_text__c : '');

    
                direccion.put('codeCity', trData.CC_Employ_Ciudad_no_aparece_en_la_lista__c == false ? trData.CC_Ciudad_trabajo__r.C_digo_de_ciudad__c : '0001');

                direccion.put('streetAddress1', trData.CC_Direcci_n_trabajo__c);
                direccion.put('accountId', trData.CC_Cuenta__c);
                direccion.put('addressObjectId', trData.Id);
    
                String jsonStr = JSON.serialize(direccion);
                //String jsonRes = callDms('/person/address/' + trData.CC_Cuenta__r.CC_ACC_N_mero_id__c, jsonStr, 'POST', getToken());
            }
        }
    }
    

     // METODO DE ACTUALIZAR EN BANNER EL CAMPOS DEL OBJETO TRABAJO
    public class ActualizatrabajoQueueable implements Queueable, Database.AllowsCallouts {
        private List<Trabajo__c> trabajos;

        public ActualizatrabajoQueueable(List<Trabajo__c> trabajos) {
            this.trabajos = trabajos;
        }

        public void execute(QueueableContext context) {
            Actualizatrabajo(trabajos);
        }
    }
    public static void Actualizatrabajo(List<Trabajo__c> trabajos) {

        Set<Id> accountIds = new Set<Id>();
    
        for (Trabajo__c tr : trabajos) {

            accountIds.add(tr.CC_Cuenta__c);
        }
        // Consultar los datos de cuenta relacionados con los trabajos
        Map<Id, Account> accountMap = new Map<Id, Account>(
            [SELECT CC_ACC_N_mero_id__c ,CC_Emprendedor__c
            FROM Account 
            WHERE Id IN :accountIds]
        );
    
        // Iterar sobre los trabajos para procesarlos
        for (Trabajo__c tr : trabajos) {

            // Obtener datos de la cuenta
            Account accData = accountMap.get(tr.CC_Cuenta__c);

            if (accData != null) {
    
                // Crear el mapa para almacenar los datos del trabajo
                Map<String, Object> trabajo = new Map<String, Object>();
         
                trabajo.put('occupationalPosition', tr.CC_PreSector_de_la_empresa__c);
                 trabajo.put('isWorking', tr.CC_Trabajo_actual__c == true ? 'S' : 'N');
                 trabajo.put('nameOrganizationWork', tr.CC_Empresa_Graduado__c);
                 trabajo.put('companyActivity', tr.CC_PreSector_de_la_empresa__c);
                 trabajo.put('jobTitle', tr.CC_Cargo__c);
                 trabajo.put('companyLevel', tr.CC_Pre_Nivel_del_cargo__c);
                 trabajo.put('numberEmployees', tr.CC_Tama_o_de_la_empresa_Empresa__c);
                 trabajo.put('averageMonthlySalary', tr.CC_Salario__c);
                 trabajo.put('workModality', tr.CC_Modalidad_trabajo__c);
                 trabajo.put('typeContract', tr.CC_Tipo_vinculaci_n__c);
                 trabajo.put('monthJoiningCompany', tr.CC_Desde_el_mes__c);
                 trabajo.put('yearJoiningCompany', tr.CC_Ano_de_ingreso__c);
                 trabajo.put('workExperience', tr.CC_A_os_de_experiencia_en_este_trabajo__c);

                
                trabajo.put('isRemuneration',  tr.CC_Remuneraci_n_laboral__c == true ? 'SI' : 'NO');
                trabajo.put('jobObjectId', tr.Id);
                trabajo.put('accountId', tr.CC_Cuenta__c);
    
                // Convertir el mapa de trabajo a JSON
                String jsonStr = JSON.serialize(trabajo);
    
                // Llamar al DMS con el ID de la cuenta de la consulta
                //String jsonRes = callDms('/person/job/' + accData.CC_ACC_N_mero_id__c, jsonStr, 'POST', getToken());
            }
        }
    }
    

    // METODO DE ACTUALIZAR EN BANNER EL CAMPOS DEL OBJETO TRABAJO
    public class ActualizaemprendedorQueueable implements Queueable, Database.AllowsCallouts {
        private List<Account> accounts;

        public ActualizaemprendedorQueueable(List<Account> accounts) {
            this.accounts = accounts;
        }

        public void execute(QueueableContext context) {
            Actualizaemprendedor(accounts);
        }
    }
    public static void Actualizaemprendedor(List<Account> accounts) {

    
        // Iterar sobre los trabajos para procesarlos
        for (Account tr : accounts) {

    
            // Crear el mapa para almacenar los datos del trabajo
            Map<String, Object> trabajo = new Map<String, Object>();
        
            trabajo.put('entrepreneur', tr.CC_Emprendedor__c == true ? 'S' : 'N');
            
            // Convertir el mapa de trabajo a JSON
            String jsonStr = JSON.serialize(trabajo);

            // Llamar al DMS con el ID de la cuenta de la consulta
            //String jsonRes = callDms('/person/job/' + tr.CC_ACC_N_mero_id__c, jsonStr, 'POST', getToken());
            
        }
    }

    // METODO DE ACTUALIZAR EN RELACIONES
    public class actualizarelacionesQueueable implements Queueable , Database.AllowsCallouts {
        Map<Id, List<Map<String, String>>> parientenviar;
    
        public actualizarelacionesQueueable(Map<Id, List<Map<String, String>>> parientenviar) {
            this.parientenviar = parientenviar;
        }
    
        public void execute(QueueableContext context) {
            for (Id accId : parientenviar.keySet()) {
                List<Map<String, String>> cambios = parientenviar.get(accId);
    
                for (Map<String, String> cambio : cambios) {
                    actualizarelaciones(cambio); // Enviar solo un Map
                }
            }
        }
    
        
    }
    
    public static void actualizarelaciones(Map<String, String> datos) {
        // Extraer valores del Map
        String nombres = datos.get('FirstName');
        String apellidos = datos.get('LastName');
        String fecha = datos.get('fecha');
        String cuentapadre = datos.get('cuentapadre');
        String cuentahijo = datos.get('cuentahijo');
        String tipo = datos.get('tipo');
        String tipopet = datos.get('tipopet');
        String objeto = datos.get('objeto');
        String cuentaPadrenum = datos.get('cuentaPadrenum');
        String cuentapadrecontactoId = datos.get('cuentapadrecontactoId');
  
            // Procesar datos
            List<String> nombresSeparados = NombreCompleto(nombres); 
        
            Map<String, Object> relacion = new Map<String, Object>();
            relacion.put('typePerson', 'H');
            relacion.put('namePerson', nombresSeparados[0]);
            relacion.put('secondNamePerson', nombresSeparados.size() > 1 ? nombresSeparados[1] : '');
            relacion.put('surnamePerson', apellidos);
            relacion.put('prefixInformation', fecha);
            relacion.put('typeAddress', tipo);
            relacion.put('relationshipObjectId', objeto);
            relacion.put('accountId', cuentapadre); // cuenta del graduado
            relacion.put('contactId', cuentapadrecontactoId); // contacto del greaduado
            relacion.put('secondChildAccountId', cuentahijo); // cuenta del hijo

            String numId = tipopet == 'DELETE' ? cuentaPadrenum + '/'+ objeto : cuentaPadrenum;
            String jsonStr = tipopet != 'DELETE' ? JSON.serialize(relacion) :null;
            if(cuentaPadrenum != null){
                String jsonRes = callDms('/person/relationship/' + numId, jsonStr, tipopet, getToken());
            }
            
            
        
    }

   
    public class ActualizatelefonoQueueable implements Queueable, Database.AllowsCallouts {
        Map<Id, List<Map<String, String>>> cuentasParaContacto;

        public ActualizatelefonoQueueable(Map<Id, List<Map<String, String>>> cuentasParaContacto) {
            this.cuentasParaContacto = cuentasParaContacto;
        }

        public void execute(QueueableContext context) {
            Banner bannerInstance = new Banner(); // 🔹 Instancia para llamar al método no estático
            
            for (Id accId : cuentasParaContacto.keySet()) {
                List<Map<String, String>> cambios = cuentasParaContacto.get(accId);

                for (Map<String, String> cambio : cambios) {
                    String phoneNumber = cambio.get('phoneNumber');
                    String typePhone = cambio.get('typePhone');
                    String countryCode = cambio.get('countryCode');
                    String tipo = cambio.get('tipo');
                    String identifica = cambio.get('identifica');

                    // Llamar al método sin static
                    bannerInstance.Actualizatelefono(accId, phoneNumber, typePhone, countryCode, tipo,identifica);
                }
            }
        }
    }


    public void Actualizatelefono(Id accId, String phoneNumber, String typePhone, String countryCode, String tipo,string identifica) {
        Map<String, Object> telefono = new Map<String, Object>();
        telefono.put('typePhone', typePhone);
        telefono.put('countryCode', countryCode);
        telefono.put('phoneNumber', phoneNumber);
        telefono.put('typeAddressReference', tipo);
        telefono.put('accountId', accId);

        String jsonStr = JSON.serialize(telefono);

        // Llamada a la API
        //String jsonRes = callDms('/person/phone/' + identifica, jsonStr, 'POST', getToken());
    }
    
    

    // METODO DE ACTUALIZAR EN BANNER EL CAMPO BUSCAR TRABAJO
    public class ActualizbuscatrabajoQueueable implements Queueable, Database.AllowsCallouts {
        private List<Account> accounts;
        private string tipo ;

        public ActualizbuscatrabajoQueueable(List<Account> accounts,  string tipo) {
            this.accounts = accounts;
            this.tipo = tipo;
        }

        public void execute(QueueableContext context) {
            Actualizbuscatrabajo(accounts,tipo);
        }
    }

    public static void Actualizbuscatrabajo(List<Account> accounts, String tipo ) {

        for (Account acc : accounts) {
       
            if(tipo == 'busca'){
                //String jsonRes =   callDms( '/person/' + acc.CC_ACC_N_mero_id__c  + '/job/looking/' + acc.CC_Buscando_trabajo__c	 , null, 'PUT', getToken() ); 
            }else if(tipo == 'tratamiento'){
                string a = acc.CC_Autorizaci_n_de_datos__c == true ? 'S' : 'N';
                //String jsonRes =   callDms( '/person/' + acc.CC_ACC_N_mero_id__c  + '/data-processing/' + a	, null, 'PATCH', getToken() ); 

            }
            
        }
        
    }

    // METODO DE ACTUALIZAR EN BANNER EL CAMPO BUSCAR TRABAJO
    public class EmprendedorjoQueueable implements Queueable, Database.AllowsCallouts {
        private List<Account> accounts;

        public EmprendedorjoQueueable(List<Account> accounts) {
            this.accounts = accounts;
        }

        public void execute(QueueableContext context) {
            Emprendedorjob(accounts);
        }
    }

    public static void Emprendedorjob(List<Account> accounts ) {

        for (Account acc : accounts) {
       
            //String jsonRes =   callDms( '/person/' + acc.CC_ACC_N_mero_id__c  + '/job/looking/' + acc.CC_Buscando_trabajo__c	 , null, 'PUT', getToken() ); 
            
        }
        
    }

 
    
       // METODO DE envio de estudios
    public class EstudiosQueueable implements Queueable , Database.AllowsCallouts {
        Map<Id, List<Map<String, String>>> estudiosEnviar;
    
        public EstudiosQueueable(Map<Id, List<Map<String, String>>> estudiosEnviar) {
            this.estudiosEnviar = estudiosEnviar;
        }
    
        public void execute(QueueableContext context) {
            for (Id estu : estudiosEnviar.keySet()) {
                List<Map<String, String>> datos = estudiosEnviar.get(estu);
    
                for (Map<String, String> dato : datos) {
                    Estudios(dato); // Enviar solo un Map
                }
            }
        }
    
        
    }

    public static void Estudios(Map<String, String> datos) {
        // Extraer valores del Map

        String NIVEL = datos.get('tiponivel');
        String universidad = datos.get('universidad');
        String fecha = datos.get('fecha');
        String programa = datos.get('programa');
        String identificacion = datos.get('identificacion');
        String objeto = datos.get('objeto');
        String tipopet = datos.get('tipopet');
        String contactId = datos.get('contactId');
        String accountId = datos.get('accountId');
        String enfasis = datos.get('enfasis');

        Map<String, Object> estudio = new Map<String, Object>();
        estudio.put('educationGoalCode', NIVEL);
        estudio.put('universityCode', universidad);
        estudio.put('degreeCode', enfasis != null ? enfasis : '000000');
        estudio.put('degreeDate', fecha);
        estudio.put('emphasisOn', enfasis);
        estudio.put('academicObjectId', objeto);
        estudio.put('contactId', contactId);
        estudio.put('accountId', accountId);

        String numId = tipopet == 'DELETE' ? identificacion+ '/'+ objeto : identificacion;
        String jsonStr = tipopet != 'DELETE' ? JSON.serialize(estudio) :null;
        String jsonRes = callDms('/person/academic/' + numId, jsonStr, tipopet, getToken()); 
    }

    

       // Genera token de ingreso para petición
    public static String getToken(){
        String accessToken;
        if( strToken == null ){
            
            String parametros = '/auth/token?clientId=' + wsInfo.clientId__c + '&clientSecret=' + wsInfo.clientSecret__c;
            strToken= callDms( parametros,null, 'POST', null );

            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(strToken);
            if(!strToken.contains('ERROR ')){
             Boolean success = responseMap.get('status') == 'SUCCESS';
            
                if (success) {
                    // Obtener el objeto "data"
                    Map<String, Object> dataMap = (Map<String, Object>) responseMap.get('data');
                    // Obtener el accessToken
                    accessToken = (String) dataMap.get('access_token');
    
                } 
            }
        }

        return accessToken;
    }
        
    public static String callDms(String strPath, String strBody, String strRequestType, String strAuthToken) {
        String strEndPoint = wsInfo.CC_End_Point__c;

    
        System.debug( 'METHOD: ' + strRequestType );
        System.debug( 'ENDPOINT: ' + strEndPoint + strPath );
        System.debug( 'BODY: ' + strBody );
        System.debug( 'TOKEN: ' + strAuthToken );

        HttpRequest req = new HttpRequest();
        req.setEndpoint(strEndPoint + strPath);
        req.setMethod(strRequestType);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-type', 'application/json');
   
    
        if (strAuthToken <> null) {
            req.setHeader('Authorization', 'Bearer ' + strAuthToken.replace('"', ''));
        }
        if( strBody <> null ){
            req.setBody( strBody );
        }
    
        req.setTimeout( 120000 );
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug('este es el req ' + req);
        System.debug( response );
        System.debug( response.getBody() );
        System.debug('este es el header: '+ req.getHeader('Authorization'));
        
       /* if (response.getStatusCode() != 200) {
            throw new DmsUtilsException('Error llamando al servicio ' + strPath + ' ERROR ' + response.getStatusCode());
        }*/

    
        return response.getBody();
    }


    private static List<String> NombreCompleto(String NombreCompleto) {
        List<String> nombres = new List<String>();
        List<String> partesNombre = NombreCompleto.split(' ');
    
        // Verificar si hay un solo apellido o dos
        if (partesNombre.size() == 1) {
            nombres.add(partesNombre[0]);
            nombres.add(''); // Si solo hay un apellido, el segundo se establece como cadena vacía
        } else if (partesNombre.size() > 1) {
            nombres.add(partesNombre[0]);
            nombres.add(partesNombre[1]);
          
        }
    
        return nombres;
    }

    public static Map<String, String> Tipodocumento(String Nombre, string tipo) {
        Map<String, String> documento = new Map<String, String>();
    
        String nombrenormal = Nombre.toLowerCase().normalizeSpace().replaceall('[\\p{InCombiningDiacriticalMarks}]', '');    
    
        if(tipo != 'Posgrado'){
            if(nombrenormal.contains('icfes')){
                documento.put('cod', '0002');
                documento.put('nom', 'PRUEBA ICFES O EQUIVALENTE');
                documento.put('codre', 'icfes');
            }
            else if(nombrenormal.contains('cedula')){
                documento.put('cod', '0003');
                documento.put('nom', 'FOTOCOPIA CÉDULA CIUDADANÍA');
                documento.put('codre', 'cedula');
            }
            else if(nombrenormal.contains('servicios')){
                documento.put('cod', '0006');
                documento.put('nom', 'RECIBO DE SERVICIOS PÚBLICOS');
                documento.put('codre', 'servicios');
            }
            else if(nombrenormal.contains('notas')){
                documento.put('cod', '0010');
                documento.put('nom', 'CERTIFICADO NOTAS BACHILLERATO');
                documento.put('codre', 'notas');
            }
            else if(nombrenormal.contains('fotos')){
                documento.put('cod', '0026');
                documento.put('nom', 'FOTOGRAFÍAS RECIENTES');
                documento.put('codre', 'fotos');
            }
            else if(nombrenormal.contains('pago')){
                documento.put('cod', '0035');
                documento.put('nom', 'RECIBO PAGO DE LA INSCRIPCIÓN');
                documento.put('codre', 'pago');
            }
            else {
                documento.put('cod', '0');
                documento.put('nom', '');
                documento.put('codre', '');
            }
        } else {
            if(nombrenormal.contains('cpi01')){
                documento.put('cod', '0035');
                documento.put('nom', 'Documento Constancia de Pago Inscripción');
                documento.put('codre', 'cpi01');
            }
            else if(nombrenormal.contains('ftd34')){
                documento.put('cod', '0026');
                documento.put('nom', 'Foto tipo documento 3x4');
                documento.put('codre', 'ftd34');
            }
            else if(nombrenormal.contains('fdid1')){
                documento.put('cod', '0003');
                documento.put('nom', 'Fotocopia documento de identificación');
                documento.put('codre', 'fdid1');
            }
            else if(nombrenormal.contains('clabr')){
                documento.put('cod', '0027');
                documento.put('nom', 'Carta Laboral');
                documento.put('codre', 'clabr');
            }
            else if(nombrenormal.contains('cnpgr')){
                documento.put('cod', '0019');
                documento.put('nom', 'Certificado Notas Pregrado');
                documento.put('codre', 'cnpgr');
            }
            else if(nombrenormal.contains('ftppr')){
                documento.put('cod', '0024');
                documento.put('nom', 'Fotocopia Titulo Profesional.');
                documento.put('codre', 'ftppr');
            }
            else if(nombrenormal.contains('rsbpr')){
                documento.put('cod', '0002');
                documento.put('nom', 'Resultados Saber Pro.');
                documento.put('codre', 'rsbpr');
            }
            else if(nombrenormal.contains('hvact')){
                documento.put('cod', '0025');
                documento.put('nom', 'Hoja de Vida Actualizada.');
                documento.put('codre', 'hvact');
            }
            else if(nombrenormal.contains('ensay')){
                documento.put('cod', '0033');
                documento.put('nom', 'Ensayo.');
                documento.put('codre', 'ensay');
            }
            else if(nombrenormal.contains('pinve')){
                documento.put('cod', '0056');
                documento.put('nom', 'Propuesta de Investigación.');
                documento.put('codre', 'pinve');
            }
            else if(nombrenormal.contains('crec1')){
                documento.put('cod', '0039');
                documento.put('nom', 'Carta de Recomendacion #1.');
                documento.put('codre', 'crec1');
            }
            else if(nombrenormal.contains('crec2')){
                documento.put('cod', '0040');
                documento.put('nom', 'Carta Recomendación #2.');
                documento.put('codre', 'crec2');
            }
            else if(nombrenormal.contains('otdoc')){
                documento.put('cod', '0055');
                documento.put('nom', 'Otros Documentos.');
                documento.put('codre', 'otdoc');
            }
            else if(nombrenormal.contains('rssoc')){
                documento.put('cod', '0036');
                documento.put('nom', 'Resolución Servicio Social.');
                documento.put('codre', 'rssoc');
            }
            else if(nombrenormal.contains('crreh')){
                documento.put('cod', '0047');
                documento.put('nom', 'Copia de Registro RETHUS.');
                documento.put('codre', 'crreh');
            }
            else if(nombrenormal.contains('fnpgd')){
                documento.put('cod', '0030');
                documento.put('nom', 'Fotocopia Notas posgrado.');
                documento.put('codre', 'fnpgd');
            }
            else if(nombrenormal.contains('ftpgd')){
                documento.put('cod', '0035');
                documento.put('nom', 'Fotocopia Titulo posgrado.');
                documento.put('codre', 'ftpgd');
            }
            else {
                documento.put('cod', '0');
                documento.put('nom', '');
                documento.put('codre', '');
            }
        }
        
    return documento;
    }
    
}