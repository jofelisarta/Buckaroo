/**
 * @description       : Test Class for AccountTriggerHelper class
 * @author            : Joana Felisarta
 * @last modified on  : 11-22-2023
**/
@isTest
public with sharing class AccountTriggerHelper_Test {

    @TestSetup
    static void setupTestData(){

        //insert Accounts - deactivated by default
        List<Account> newDeactivatedAcctsList = TestDataFactory.insertAccounts(300, true);  

        //insert 2 Contacts for each inserted deactivated Account
        List<Contact> newDeactivatedConList = TestDataFactory.insertContactsWithAccounts(2, newDeactivatedAcctsList, true);

        //insert activated Accounts
        List<Account> newActivatedAcctsList = TestDataFactory.insertAccounts(400, false);
        for(Account accRecord : newActivatedAcctsList) {
            accRecord.Activated__c = true;
        }
        insert newActivatedAcctsList;

        //insert 2 Contacts for each inserted activated Accounts
        List<Contact> newActivatedContactList = TestDataFactory.insertContactsWithAccounts(2,  newActivatedAcctsList, false);
        for(Contact con : newActivatedContactList) {
            con.Activated__c = true;
        }
        insert newActivatedContactList;
        
    }

    @isTest
    static void testActivateAcctSingleUpdate() {

        Account accToActivate = [SELECT Id FROM Account WHERE Activated__c = false LIMIT 1];
        accToActivate.Activated__c = true;
        update accToActivate;

        for(Contact conRecord : [SELECT Id, Activated__c FROM Contact WHERE AccountId = :accToActivate.Id]) {
            Assert.areEqual(true, conRecord.Activated__c, 'All child Contacts must be activated when the parent Account is activated.');
        }
    }

    @isTest
    static void testDeactivateAcctSingleUpdate() {

        Account accToDeactivate = [SELECT Id FROM Account WHERE Activated__c = true LIMIT 1];
        accToDeactivate.Activated__c = false;
        update accToDeactivate;
    
        for(Contact conRecord : [SELECT Id, Activated__c FROM Contact WHERE AccountId = :accToDeactivate.Id]) {

            Assert.areEqual(false, conRecord.Activated__c, 'All related Contacts must be deactivated when parent Account is deactivated.');                   
        }
    }

    @isTest
    static void testActivateAcctBulkUpdate() {

        List<Account> acctsToActivateList = [SELECT Id FROM Account WHERE Activated__c = false];
        
        for(Account accRecord : acctsToActivateList) {
            accRecord.Activated__c = true;
        }
        update acctsToActivateList;
        
        for(Contact conRecord : [SELECT Id, Activated__c FROM Contact WHERE AccountId IN :acctsToActivateList]) {
            Assert.areEqual(true, conRecord.Activated__c, 'All related contacts must be activated when the parent Account is activated');
        }
    
    }

    @isTest
    static void testDeactivateAcctBulkUpdate() {

        List<Account> acctsToDeactivateList = [SELECT Id FROM Account WHERE Activated__c = true];
        
        for(Account acc : acctsToDeactivateList) {
            acc.Activated__c = false;
        }
        update acctsToDeactivateList;
    
        for(Contact conRecord : [SELECT Id, Activated__c FROM Contact WHERE AccountId IN :acctsToDeactivateList]) {
            Assert.areEqual(false, conRecord.Activated__c, 'All related Contacts must be deactivated when the parent Account is deactivated');
        }
    }
}