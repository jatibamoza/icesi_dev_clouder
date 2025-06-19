@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }

 @IsTest
 static void testExperienceId() {
  LightningLoginFormController.setExperienceId( null );
  LightningLoginFormController.setExperienceId( 'null' );
 }

 @IsTest
 static void testLogin() {
  LightningLoginFormController.login( 'null','null','null' );
  LightningLoginFormController.login( null,null,null );
 }

 @IsTest
 static void testForgotPasswordUrl() {
  LightningLoginFormController.getForgotPasswordUrl( );
 }
}