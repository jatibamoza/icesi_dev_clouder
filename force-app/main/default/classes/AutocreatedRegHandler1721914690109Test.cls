@isTest
public class AutocreatedRegHandler1721914690109Test {

    @isTest
    static void testCreateUser_NoUserFound() {

        // Arrange
        Auth.UserData data = new Auth.UserData( 'testId', 'testFirst', 'testLast', 'testFirst testLast', 
                                                'testuse8888r@example.org', null, 'testuse8888r@example.org', 
                                                'en_US', 'facebook', null, new Map<String, String>{'language' => 'en_US'} );

        // Act & Assert
        try {
            AutocreatedRegHandler1721914690109 handler = new AutocreatedRegHandler1721914690109();
            handler.createUser(null, data);
            System.assert(false, 'Expected exception not thrown');
        } catch (AutocreatedRegHandler1721914690109.RegistrationException e) {
            System.assertEquals('User not found', e.getMessage());
        }
    }

    @isTest
    static void testCreateUser_OneUserFound() {
        // Arrange
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@email.com',
            Username = 'testusercustomreghandler@test.com',
            FederationIdentifier = 'testuse8888r@example.org',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Auth.UserData data = new Auth.UserData( 'testId', 'testFirst', 'testLast', 'testFirst testLast', 
                                                'testuse8888r@example.org', null, 'testuse8888r@example.org', 
                                                'en_US', 'facebook', null, new Map<String, String>{'language' => 'en_US'} );

        // Act
        AutocreatedRegHandler1721914690109 handler = new AutocreatedRegHandler1721914690109();
        User result = handler.createUser(null, data);

        // Assert
        System.assertEquals(testUser.Id, result.Id);
    }

    @isTest
    static void testUpdateUser() {
        // Arrange
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@email.com',
            Username = 'testusercustomreghandler@test.com',
            FederationIdentifier = 'test@email.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Auth.UserData data = new Auth.UserData( 'testId', 'testFirst', 'testLast', 'testFirst testLast', 
                                                'testuse8888r@example.org', null, 'testuse8888r@example.org', 
                                                'en_US', 'facebook', null, new Map<String, String>{'language' => 'en_US'} );

        // Act
        AutocreatedRegHandler1721914690109 handler = new AutocreatedRegHandler1721914690109();
        handler.updateUser(testUser.Id, null, data);

        // Assert
        // Since updateUser does nothing, no assertions needed. Just ensuring no exceptions are thrown.
    }
}