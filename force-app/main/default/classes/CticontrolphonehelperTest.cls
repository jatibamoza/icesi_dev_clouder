@isTest
    public class CticontrolphonehelperTest {
    @TestSetup
    static void setup() {
        // Create some test Accounts
        Account testAccount1 = new Account(Name = 'Test Account 1', Phone = '1234567890');
        insert testAccount1;

        Account testAccount2 = new Account(Name = 'Test Account 2', Phone = '0987654321');
        insert testAccount2;

        // Create some test Contacts
        Contact testContact1 = new Contact(FirstName = 'Test', LastName = 'Contact1', Phone = '1234567890', AccountId = testAccount1.Id);
        insert testContact1;

        Contact testContact2 = new Contact(FirstName = 'Test', LastName = 'Contact2', Phone = '0987654321', AccountId = testAccount2.Id);
        insert testContact2;

       
    }

    // Test method for searchAccountByPhone
    @IsTest
    static void testSearchAccountByPhone() {
        Test.startTest();
        
        // Positive test case
        Account result = CTiControlPhoneHelper.searchAccountByPhone('1234567890');
        System.assertNotEquals(null, result, 'Account should be found');
        System.assertEquals('1234567890', result.Phone, 'Phone number should match');
        
        // Negative test case
        Account nullResult = CTiControlPhoneHelper.searchAccountByPhone('1111111111');
        System.assertEquals(null, nullResult, 'No Account should be found');
        
        Test.stopTest();
    }

    // Test method for searchIdByPhone
    @IsTest
    static void testSearchIdByPhone() {
        Test.startTest();
        
        // Positive test case
        String resultId = CTiControlPhoneHelper.searchIdByPhone('1234567890');
        System.assertNotEquals(null, resultId, 'ID should be found');
        
        // Negative test case
        String nullIdResult = CTiControlPhoneHelper.searchIdByPhone('1111111111');
        System.assertEquals(null, nullIdResult, 'No ID should be found');
        
        Test.stopTest();
    }

    // Test method for CreateCallTask
    @IsTest
    static void testCreateCallTask() {
        Account acc = [SELECT id from Account LIMIT 1];
        Test.startTest();
        
        String recordId = acc.Id; // Use a valid Id if possible
        String peerPhone = '1234567890';
        String source = 'source_123';
        String status = 'ANSWERED';
        String destination = '123';
        Integer duration = 123;
        String strDate = '2024-07-06';
        String strTime = '09:34:30';
        String direction = 'Entrante';
        
        CTiControlPhoneHelper.CreateCallTask(recordId, peerPhone, source, status, destination, duration, strDate, strTime, direction);
        
        // Validate that the task was created
        Task createdTask = [SELECT Id, WhoId, WhatId, Subject, Source__c, Status__c FROM Task WHERE UniqueID__c = :source LIMIT 1];
        System.assertNotEquals(null, createdTask, 'Task should have been created');
        System.assertEquals('Call', createdTask.Subject, 'Task Subject should be "Call"');
        
        Test.stopTest();
    }

    // Test method for edge cases in CreateCallTask
    @IsTest
    static void testCreateCallTaskWithNullRecordId() {
        Test.startTest();
        
        String peerPhone = '1234567890';
        String source = 'source_124';
        String status = 'ANSWERED';
        String destination = '123';
        Integer duration = 123;
        String strDate = '2024-07-06';
        String strTime = '09:34:30';
        String direction = 'Entrante';
        
        // Call the method with a null recordId
        CTiControlPhoneHelper.CreateCallTask(null, peerPhone, source, status, destination, duration, strDate, strTime, direction);
        
        // Validate that the task was created
        Task createdTask = [SELECT Id, WhoId, WhatId, Subject, Source__c, Status__c FROM Task WHERE UniqueID__c = :source LIMIT 1];
        System.assertNotEquals(null, createdTask, 'Task should have been created');
        System.assertEquals('Call', createdTask.Subject, 'Task Subject should be "Call"');
        
        Test.stopTest();
    }
}