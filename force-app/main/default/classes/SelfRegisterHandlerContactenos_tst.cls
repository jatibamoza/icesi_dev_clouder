@isTest
private class SelfRegisterHandlerContactenos_tst {

    @isTest
    static void testCreateUser() {
        RecordType rt = [Select Id From RecordType Where DeveloperName = 'PersonAccount'];
        // Create test data
        Account testAccount = new Account(FirstName = 'Test', LastName = 'Account', RecordTypeId = rt.Id);
        insert testAccount;

        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Usuario Comunidad Contactenos' LIMIT 1];

        Map<SObjectField, String> registrationAttributes = new Map<SObjectField, String>();
        registrationAttributes.put(User.FirstName, 'TestFirstName');
        registrationAttributes.put(User.LastName, 'TestLastName');
        registrationAttributes.put(User.Email, 'testemail@example.com');
        registrationAttributes.put(User.Username, 'testemail@example.com');

        // Initialize the handler
        SelfRegisterHandlerContactenos handler = new SelfRegisterHandlerContactenos();

        // Test user creation
        Test.startTest();
        Id userId = handler.createUser(testAccount.Id, testProfile.Id, registrationAttributes, null);
        Test.stopTest();

        // Verify the user was created successfully
        User createdUser = [SELECT Id, FirstName, LastName, Email, Username, ProfileId, AccountId FROM User WHERE Id = :userId];
        System.assertNotEquals(null, createdUser);
        System.assertEquals('TestFirstName', createdUser.FirstName);
        System.assertEquals('TestLastName', createdUser.LastName);
        System.assertEquals('testemail@example.com', createdUser.Email);
        System.assertEquals('testemail@example.com', createdUser.Username);
        System.assertEquals(testProfile.Id, createdUser.ProfileId);
        System.assertEquals(testAccount.Id, createdUser.AccountId);
    }

    @isTest
    static void testHandleUnsetRequiredFields() {
        User testUser = new User();

        SelfRegisterHandlerContactenos handler = new SelfRegisterHandlerContactenos();
        
        // Test handling unset required fields
        Test.startTest();
        User resultUser = handler.handleUnsetRequiredFields(testUser);
        Test.stopTest();

        // Verify required fields are set
        System.assertNotEquals(null, resultUser.LastName);
        System.assertNotEquals(null, resultUser.Username);
        System.assertNotEquals(null, resultUser.Email);
        System.assertNotEquals(null, resultUser.Alias);
        System.assertNotEquals(null, resultUser.CommunityNickname);
    }
}