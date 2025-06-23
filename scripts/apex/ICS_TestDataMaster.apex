/*List<IndividualApplication> lIndividualApplication = [
    SELECT Id, Name,
        Carrera_de_mayor_interes__c, Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c, Carrera_de_mayor_interes__r.Parent.Name, Carrera_de_mayor_interes__r.Parent.NIT__c,Carrera_de_mayor_interes__r.Parent.Owner.Name,
        CC_Periodo_academico__c, CC_Periodo_academico__r.Name, CC_Periodo_academico__r.Codigo_periodo__c,
        Owner.Name
    FROM IndividualApplication 
    WHERE RecordType.DeveloperName = 'Admissions'
    AND Status = 'Matriculado'];

System.debug('##lIndividualApplication: ' + lIndividualApplication.size());*/

List<ICS_QueryMaster__mdt> definitions = [
            SELECT DeveloperName, ICS_Query__c, ICS_RecordTypeDeveloperName__c
            FROM ICS_QueryMaster__mdt 
            WHERE ICS_IsActive__c = true  ];

System.debug('##definitions: ' + definitions.size());

ICS_DataMasterBuilder_bch batch = new ICS_DataMasterBuilder_bch(definitions[0].ICS_Query__c, definitions[0].ICS_RecordTypeDeveloperName__c);
Integer scopeSize = 200;
Database.executeBatch(batch, scopeSize);

//ICS_DataMaster__c dm = ICS_DataMasterMapper_cls.mapDataMaster(lIndividualApplication[0], 'IA_EtapasEmbudo');
//System.debug('##dm: ' + dm);

List<ICS_DataMaster__c> lDataMaster = [
    SELECT Id, Name, ICS_Owner_Name__c, ICS_CarreraMayorInteres_CC_CODIGO_BANNER__c, ICS_CarreraMayorInt_Parent_Owner_Name__c, ICS_CarreraMayorInteres_Parent_Name__c, ICS_CarreraMayorInteres_Parent_NIT__c, ICS_CCPeriodoAcademico_CodigoPeriodo__c, ICS_CCPeriodoAcademico_Name__c
    FROM ICS_DataMaster__c 
    ORDER BY CreatedDate DESC ];
System.debug('##lDataMaster: ' + lDataMaster.size());