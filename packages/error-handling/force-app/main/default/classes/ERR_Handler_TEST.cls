/*
    Copyright (c) 2014, Salesforce.org
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce.org
* @date 2014 
* @group ErrorHandling
* @description Test class for error handling framework.
*/
@isTest
public with sharing class ERR_Handler_TEST {

    /*********************************************************************************************************
    * @description Sets up Hierarchy Settings for error notifications to be on, and stores errors.
    */
    private static void setupWithNotificationOn() {
        Id chatterGroupId = null;
        if (!Test.isRunningTest()) {
            CollaborationGroup chatterGroup = new CollaborationGroup();
            chatterGroup.Name = 'Test Group';
            chatterGroup.CollaborationType = 'Private';
            insert chatterGroup;
            chatterGroupId = chatterGroup.Id;
            UTIL_CustomSettings_API.getSettingsForTests(
                new Hierarchy_Settings__c(
                    Error_Notifications_On__c = true,
                    Error_Notifications_To__c = chatterGroup.Id,
                    Store_Errors_On__c = true
                )
            );
        } else {
            UTIL_CustomSettings_API.getSettingsForTests(
                new Hierarchy_Settings__c(
                    Error_Notifications_On__c = true,
                    Error_Notifications_To__c = null,
                    Store_Errors_On__c = true
                )
            );
        }
    }

    private static void setupWithEmailNotifications() {
        // Create test user for notifications
        User user = new User(
            FirstName = 'Test',
            LastName = 'User', 
            Email = 'testuser@example.com',
            Username = System.now().getTime() + '@testerson.com',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert user;

        UTIL_CustomSettings_API.getSettingsForTests(
            new Hierarchy_Settings__c(
                Error_Notifications_On__c = true,
                Error_Notifications_To__c = user.Id,
                Store_Errors_On__c = true
            )
        );
    }

    /*********************************************************************************************************
    * @description Tests error handling when doing DML on Contacts with a required field (Last Name) missing.
    */
    static testMethod void testHandleRequiredFieldMissingErrorWithNotificationOnWithDMLOptions() {
        setupWithNotificationOn();

        Test.startTest();
        //create contact missing Last Name
        Contact contact = new Contact(FirstName = 'Test');
        Database.SaveResult result = Database.insert(contact, false);

                 //get errors
         ERR_Handler.Errors errors = ERR_Handler.getErrors(new List<Object>{result}, new List<SObject>{contact});
        System.assert(errors.errorsExist);
        System.assertEquals(1, errors.errorRecords.size());

        Error__c error = errors.errorRecords[0];
        System.assertEquals('Contact', error.Object_Type__c);
        System.assert(error.Full_Message__c.contains('REQUIRED_FIELD_MISSING'));
        Test.stopTest();
        
        //verify error record was created
        List<Error__c> savedErrors = [SELECT Id FROM Error__c];
        System.assertEquals(1, savedErrors.size());
    }

    /*********************************************************************************************************
    * @description Tests error handling when doing DML on Contacts using Lists instead of single objects.
    */
    static testMethod void testHandleErrorsWithDMLOptionsAndList() {
        setupWithNotificationOn();

        Test.startTest();
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName = 'Test1')); // Missing Last Name
        contacts.add(new Contact(FirstName = 'Test2')); // Missing Last Name
        
        Database.SaveResult[] results = Database.insert(contacts, false);

        //get errors  
        ERR_Handler.Errors errors = ERR_Handler.getErrors(results, contacts);
        System.assert(errors.errorsExist);
        System.assertEquals(2, errors.errorRecords.size());
        Test.stopTest();

        //verify error records were created
        List<Error__c> savedErrors = [SELECT Id FROM Error__c];
        System.assertEquals(2, savedErrors.size());
    }

    /*********************************************************************************************************
    * @description Tests that settings can be overridden.
    */
    static testMethod void testOverrideSettings() {
        UTIL_CustomSettings_API.getSettingsForTests(
            new Hierarchy_Settings__c(
                Error_Notifications_On__c = false,
                Store_Errors_On__c = false
            )
        );

        Test.startTest();
        Contact contact = new Contact(FirstName = 'Test'); // Missing Last Name
        Database.SaveResult result = Database.insert(contact, false);

                 // Force error handling even though settings are off
         ERR_Handler.Errors errors = ERR_Handler.getErrors(new List<Object>{result}, new List<SObject>{contact});
        System.assert(errors.errorsExist);
        System.assertEquals(1, errors.errorRecords.size());
        Test.stopTest();

        // Verify error record was created despite settings
        List<Error__c> savedErrors = [SELECT Id FROM Error__c];
        System.assertEquals(1, savedErrors.size());
    }

    /*********************************************************************************************************
    * @description Tests error notifications via email.
    */
    static testMethod void testEmailNotifications() {
        setupWithEmailNotifications();

        Test.startTest();
        Contact contact = new Contact(FirstName = 'Test'); // Missing Last Name
        Database.SaveResult result = Database.insert(contact, false);

                 ERR_Handler.Errors errors = ERR_Handler.getErrors(new List<Object>{result}, new List<SObject>{contact});
        System.assert(errors.errorsExist);
        Test.stopTest();

        // Verify error record was created
        List<Error__c> savedErrors = [SELECT Id FROM Error__c];
        System.assertEquals(1, savedErrors.size());
    }
}
