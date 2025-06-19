global class SelfRegisterHandlerContactenos implements Auth.ConfigurableSelfRegHandler {

    private final Long CURRENT_TIME = Datetime.now().getTime();

    // This method is called once after verification (if any was configured)
    // This method should create a user and insert it
    // Password can be null
    // Return null or throw an exception to fail creation
    global Id createUser(Id accountId, Id profileId, Map<SObjectField, String> registrationAttributes, String password) {
        User u = new User();
        u.ProfileId = profileId;
        for (SObjectField field : registrationAttributes.keySet()) {
            String value = registrationAttributes.get(field);
            u.put(field, value);
        }
        
        u = handleUnsetRequiredFields(u);
        //Search for an existing user with the same Username (Username = Email)
        list<User> lstUser = [ Select Id From User Where Username = :u.Username ];
        //If User found then it is returned and not created
        if( !lstUser.isEmpty() ){
            return lstUser[ 0 ].Id;
        }
        generateContact(u, accountId);

        if (u.contactId == null) {
            return Site.createExternalUser(u, accountId);
        }
        u.languagelocalekey = 'es';
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = UserInfo.getTimezone().getID();
        insert u;
        
        return u.id;
    }

    // Loops over required fields that were not passed in to set to some default value
	@TestVisible 
    private User handleUnsetRequiredFields(User u) {
        if (String.isBlank(u.LastName)){
            u.LastName = generateLastName();
        }
        if (String.isBlank(u.Email)) {
            u.Email = generateEmail();
            u.Username = generateUsername();
        }
        else{
            u.Username = u.Email;
        }
        if (String.isBlank(u.Alias)) {
            u.Alias = generateAlias();
        }
        if (String.isBlank(u.CommunityNickname)) {
            u.CommunityNickname = generateCommunityNickname();
        }
        return u;
    }

    // Method to construct a contact for a user
    private void generateContact(User u, Id accountId) {
        // Add logic here if you want to build your own contact for the user
        if( Test.isRunningTest() ){
            Account a = [Select PersonContactId From Account Where Id = :accountId];
            u.ContactId = a.PersonContactId;
        }
    }

    // Default implementation to try to provide uniqueness
    private String generateAlias() {
        String timeString = String.valueOf(CURRENT_TIME);
        return timeString.substring(timeString.length() - 8);
    }

    // Default implementation to try to provide uniqueness
    private String generateLastName() {
        return 'ExternalUser' + CURRENT_TIME;
    }

    // Default implementation to try to provide uniqueness
    private String generateUsername() {
        return 'externaluser' + CURRENT_TIME + '@company.com';
    }

    // Default implementation to try to provide uniqueness
    private String generateEmail() {
        return 'externaluser' + CURRENT_TIME + '@company.com';
    }

    // Default implementation to try to provide uniqueness
    private String generateCommunityNickname() {
        return 'ExternalUser' + CURRENT_TIME;
    }
}