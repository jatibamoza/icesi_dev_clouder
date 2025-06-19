public without sharing class CC_FileUploadImprovedHelper{

    @AuraEnabled
    public static List<FileUploadImprovedHelper.objFiles> getExistingFilesByName(String recordId, String fileName){
        Boolean isStandardUser = UserInfo.getUserType() == 'Standard';
        Map<Id,FileUploadImprovedHelper.objFiles> objFiles = new Map<Id,FileUploadImprovedHelper.objFiles>();
        for(ContentDocumentLink link : [SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE LinkedEntityId = :recordId]){
            FileUploadImprovedHelper.objFiles files = new FileUploadImprovedHelper.objFiles();
            if( link.ContentDocument.Title.equalsIgnoreCase( fileName ) ){
            files.name = link.ContentDocument.Title +'.'+ link.ContentDocument.FileExtension;
            if(isStandardUser){
                files.documentId = link.ContentDocumentId;
            }
            objFiles.put(link.ContentDocumentId,files);
        }
        }
        for(ContentVersion vers : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :objFiles.keyset() AND IsLatest = TRUE]){
            objFiles.get(vers.ContentDocumentId).contentVersionId = vers.Id;
        }
        return objFiles.values();
    }
}