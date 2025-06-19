trigger Crm_documentoInsertado on ContentDocumentLink (after insert) {
    Set<Id> contentDocIds = new Set<Id>();

    for (ContentDocumentLink cdl : Trigger.new) {
        contentDocIds.add(cdl.ContentDocumentId);
    }

    if (!contentDocIds.isEmpty()) {
        CrmHelperDocumento.procesarDocumentos(new List<Id>(contentDocIds));
    }
}