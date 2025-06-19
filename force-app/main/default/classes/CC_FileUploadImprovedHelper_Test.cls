@isTest
public class CC_FileUploadImprovedHelper_Test {

    @TestSetup
    static void makeData(){
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Test'
        );
        insert con;
        
        ContentVersion cv = new ContentVersion(
        	Title = 'Test',
            PathOnClient = 'Test',
            VersionData = EncodingUtil.base64Decode('Test'),
            IsMajorVersion = FALSE
        );
        insert cv;
    }

    @isTest
    public static void get_existing_files(){
        String key = FileUploadImprovedHelper.getKey();

        Contact con = getCon();
        ContentVersion cv = getCV();
        cv.Guest_Record_fileupload__c = FileUploadImprovedHelper.encrypt(con.Id,key);
        update cv;
        
        system.test.startTest();
            FileUploadImprovedHelper.createContentDocLink(new List<String>{cv.Id},key,false);
            List<FileUploadImprovedHelper.objFiles> objFiles = CC_FileUploadImprovedHelper.getExistingFilesByName((String)con.Id, 'Test'); 
        system.test.stopTest();

        system.assertEquals(1, objFiles.size());
    }

    private static ContentVersion getCV(){
        return [SELECT Id, Guest_Record_fileupload__c, ContentDocument.Title, ContentDocumentId, VersionData FROM ContentVersion LIMIT 1];
    }

    private static Contact getCon(){
        return [SELECT Id FROM Contact];
    }
}