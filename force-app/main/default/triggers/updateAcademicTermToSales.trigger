trigger updateAcademicTermToSales on AcademicTerm (before update) {
    List<Id> academicTermId = new List<Id>();

    for (AcademicTerm acadeTerm : Trigger.new) {
        AcademicTerm oldAcadeTerm = Trigger.oldMap.get(acadeTerm.Id);

        if (oldAcadeTerm.CC_Periodo_vigente_para_ventas__c == false && 
            acadeTerm.CC_Periodo_vigente_para_ventas__c == true) {
            academicTermId.add(acadeTerm.Id);
        }
    }
    
    if (!academicTermId.isEmpty()) {
        System.debug('academicTermId: ' + academicTermId);

        // se asegura que haya al menos dos elementos antes de crear el batch
        if (academicTermId.size() >= 2) {
            updateAcademicTermBatch batch = new updateAcademicTermBatch(academicTermId);
            Database.executeBatch(batch, 200);
        } else {
            System.debug('Se necesitan al menos dos Academic Terms para ejecutar el batch.');
        }
    }
}