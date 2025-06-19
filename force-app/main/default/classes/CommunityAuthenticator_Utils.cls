public without sharing class CommunityAuthenticator_Utils {
    @AuraEnabled
    public static String login(String username, String password, String permissionName ) {
        String result = null;
        try {
            //Add permissions to the user if needed.
            addPermissions( username, permissionName );
            //Actually Site Login
            ApexPages.PageReference lgn = Site.login( getUser( username ).Username, password, '');
            result = (lgn != null) ? lgn.getUrl() : null;
        } catch (Exception ex) {
            result = ex.getMessage();
        }
        return result;
    }

    @AuraEnabled
    public static void addPermissions(String username, String permissionName ) {
        
        User objUsr = getUser( username );
        PermissionSet objPS = getPermissionSet( permissionName );
        list<PermissionSetAssignment> lstPSA = [ Select Id From PermissionSetAssignment Where AssigneeId = :objUsr.Id and PermissionSetId = :objPS.Id ];
        if( lstPSA.isEmpty() ) {
            insert new PermissionSetAssignment(AssigneeId = objUsr.Id, PermissionSetId = objPS.Id);
        }
    }

    @AuraEnabled
    public static String createPortalUser(String firstName, String lastName, String email, String phone, Date dob, String idType, String idNumber, String accRTName, String usrProfileId ) {
        try{
            //If user is found then it already exist
            getUser( idNumber );
            //return 'El número de documento ya existe como usuario del sistema.';
            return 'Ya cuentas con usuario en el sistema, puedes <a href="{URL_LOGIN}">iniciar sesión aquí</a>, tu usuario es tu número de identificación. Si no recuerdas tu contraseña, puedes <a href="{URL_RESET}" class="padding-right-15">restablecerla aquí</a>';
        }catch(Exception e){
            //If an exception is throwned is because the user doesn't exist yet, so the process can continue
        }

        try{
            //If user is found then it already exist
            getUserByEmail( email );
            return 'El correo electrónico ya está registrado en el sistema.';
        }catch(Exception e){
            //If an exception is throwned is because the user doesn't exist yet, so the process can continue
        }
        
        try {
            String strNickname = firstName + ' ' + lastName;
            // Create the Person Account record
            Account personAccount = new Account();
            personAccount.FirstName = firstName;
            personAccount.LastName = lastName;
            personAccount.PersonEmail = email;
            personAccount.PersonMobilePhone = phone;
            personAccount.PersonBirthdate = dob;
            personAccount.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = :accRTName LIMIT 1].Id;
            personAccount.OwnerId = Site.getAdminId();
            personAccount.CC_Acc_Tipo_id__c = idType;
            personAccount.CC_ACC_N_mero_id__c = idNumber;
            personAccount.CC_Fecha_nacimiento__c = dob;
            insert personAccount;

            // Set up User fields
            User user = new User();
            user.Username = email;
            user.Email = email;
            user.FirstName = firstName;
            user.LastName = lastName;
            user.FederationIdentifier = idNumber;
            user.Alias = email.substring( 0, Math.min( email.length(), 8 ) );
            user.CommunityNickname = strNickname.substring( 0, Math.min( strNickname.length(), 40) );
            user.Phone = phone;
            user.ProfileId = [SELECT Id FROM Profile WHERE Name = :usrProfileId LIMIT 1].Id;
            user.LocaleSidKey = 'es_CO';  // Spanish (Colombia)
            user.EmailEncodingKey = 'UTF-8';
            user.LanguageLocaleKey = 'es';  // Spanish
            user.TimeZoneSidKey = 'America/Bogota';  // Timezone for Bogotá, Colombia

            // Create Portal User using Site.createExternalUser createExternalUser
            ID newUserId = Site.createExternalUser( user, personAccount.Id );
            return 'OK';
        } catch (Site.ExternalUserCreateException e) {
            //An exception when creating the user is expected if profile is not added to a community
            System.debug('result: ' + e.getDisplayMessages() );
            return 'OK ADD_PERMISSIONS - Error: ' + e.getMessage();
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getIdTypePicklistValues() {
        List<Map<String, String>> picklistOptions = new List<Map<String, String>>();

        try {
            // Describe the Account object and get the picklist field description
            Schema.DescribeFieldResult fieldResult = Account.CC_Acc_Tipo_id__c.getDescribe();

            // Loop through each picklist value
            for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
                Map<String, String> picklistItem = new Map<String, String>();
                picklistItem.put('label', entry.getLabel());  // Display Name
                picklistItem.put('value', entry.getValue());  // API Name
                picklistOptions.add(picklistItem);
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving picklist values: ' + e.getMessage());
        }

        return picklistOptions;
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isRegistrationEnabled() {
        return Site.isRegistrationEnabled();
    }

    @AuraEnabled
    public static String resetPassword(String username) {
        String result = null;
        try {
            if( Site.forgotPassword( getUser( username ).Username ) ){
                result = Site.getBaseUrl();
            }else{
                result = 'Password reset unsuccessful';
            }
        } catch (Exception ex) {
            result = ex.getMessage();
        }
        return result;
    }

    private static User getUser( String strFederationId ) {
        try {
            // Get the User
            return [ Select Id, Username, FederationIdentifier From User Where FederationIdentifier = :strFederationId limit 1 ];
        }
        catch( System.exception e ){
            throw new CommunityAuthenticator_Exception('No se ha podido encontrar el usuario con número de identificación: ' +  strFederationId + '.');
        }
    }

    private static User getUserByEmail( String strEmail ) {
        try {
            // Get the User
            return [ Select Id, Username, FederationIdentifier From User Where username = :strEmail limit 1 ];
        }
        catch( System.exception e ){
            throw new CommunityAuthenticator_Exception('No se ha podido encontrar el usuario: ' +  strEmail + '.');
        }
    }

    private static PermissionSet getPermissionSet( String strPermissionName ) {
        try {
            // Get the Permission Set
            return [ Select Id From PermissionSet Where Name = :strPermissionName limit 1 ];
        }
        catch( System.exception e ){
            throw new CommunityAuthenticator_Exception('Conjunto de permisos \'' +  strPermissionName + '\' no encontrado. Notifique de este error al Administrador del Sistema.');
        }
    }

    public class CommunityAuthenticator_Exception extends Exception {    }
    
}