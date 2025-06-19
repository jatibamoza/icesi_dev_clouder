global class AutocreatedRegHandler1721914690109 implements Auth.RegistrationHandler{

    global User createUser(Id portalId, Auth.UserData data) {
        //Search user by FederationIdentifier
        List<User> lstUsers = [SELECT Id FROM User WHERE FederationIdentifier = :data.email ];

        if( lstUsers.isEmpty() ){
            //Throwing an exception fails the SSO flow
            throw new AutocreatedRegHandler1721914690109.RegistrationException( 'User not found' );
        }

        //Returning null or throwing an exception fails the SSO flow
        return lstUsers.get( 0 );
    }
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
      //TO-DO: Do nothing
    }

    public class RegistrationException extends Exception {}
}