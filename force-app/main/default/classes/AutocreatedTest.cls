@isTest
private class AutocreatedTest {

    @isTest
    static void testCreateUser1() {
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
        AutocreatedConfigSelfReg1719666026830 handler1 = new AutocreatedConfigSelfReg1719666026830();

        // Test user creation
        Test.startTest();
        Id userId1 = handler1.createUser(testAccount.Id, testProfile.Id, registrationAttributes, null);
        Test.stopTest();
    }
    
    @isTest
    static void testCreateUser2() {
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
        AutocreatedConfigSelfReg1720125305331 handler2 = new AutocreatedConfigSelfReg1720125305331();

        // Test user creation
        Test.startTest();
        Id userId2 = handler2.createUser(testAccount.Id, testProfile.Id, registrationAttributes, null);
        Test.stopTest();
    }

    @isTest
    static void testGenerateRandomPassword() {
        AutocreatedConfigSelfReg1719666026830 handler1 = new AutocreatedConfigSelfReg1719666026830();
        AutocreatedConfigSelfReg1720125305331 handler2 = new AutocreatedConfigSelfReg1720125305331();

        // Test password generation
        Test.startTest();
        String password1 = handler1.generateRandomPassword();
        String password2 = handler2.generateRandomPassword();
        Test.stopTest();
    }

    @isTest
    static void testHandleUnsetRequiredFields() {
        User testUser = new User();

        AutocreatedConfigSelfReg1719666026830 handler1 = new AutocreatedConfigSelfReg1719666026830();
        AutocreatedConfigSelfReg1720125305331 handler2 = new AutocreatedConfigSelfReg1720125305331();
        
        // Test handling unset required fields
        Test.startTest();
        User resultUser1 = handler1.handleUnsetRequiredFields(testUser);
        User resultUser2 = handler2.handleUnsetRequiredFields(testUser);
        Test.stopTest();
    }

    @isTest
    static void testAddMissingPasswordRequirements() {
        AutocreatedConfigSelfReg1719666026830 handler1 = new AutocreatedConfigSelfReg1719666026830();
        AutocreatedConfigSelfReg1720125305331 handler2 = new AutocreatedConfigSelfReg1720125305331();

        // Test adding missing password requirements
        String password = 'abc123';
        Test.startTest();
        String updatedPassword1 = handler1.addMissingPasswordRequirements(password, true, true, true, true);
        String updatedPassword2 = handler2.addMissingPasswordRequirements(password, true, true, true, true);
        Test.stopTest();
    }
}