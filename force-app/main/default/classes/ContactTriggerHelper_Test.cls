/**
 * @description       : Test Class for ContactTriggerHelper
 * @author            : Joana Felisarta
 * @last modified on  : 11-22-2023
**/
@isTest
public with sharing class ContactTriggerHelper_Test {

    @TestSetup
    static void setupTestData(){

        //insert Accounts - deactivated by default
        List<Account> newDeactivatedAcctsList = TestDataFactory.insertAccounts(300, true);  

        //insert 2 Contacts to relate to each inserted deactivated Account
        List<Contact> newDeactivatedConList = TestDataFactory.insertContactsWithAccounts(3, newDeactivatedAcctsList, true);

        //insert activated Accounts
        List<Account> newActivatedAcctsList = TestDataFactory.insertAccounts(400, false);
        for(Account accRecord : newActivatedAcctsList) {
            accRecord.Activated__c = true;
        }
        insert newActivatedAcctsList;

        //insert 2 Contacts to relate to each inserted activated Accounts
        List<Contact> newActivatedContactList = TestDataFactory.insertContactsWithAccounts(3,  newActivatedAcctsList, false);
        for(Contact con : newActivatedContactList) {
            con.Activated__c = true;
        }
        insert newActivatedContactList;
    }

    @isTest
    static void testActivateContactSingleUpdate() {

        Contact contactToActivate = [SELECT Id, AccountId FROM Contact WHERE Activated__c = false LIMIT 1];
        contactToActivate.Activated__c = true;
        update contactToActivate;

        Account acctRec = [SELECT Id, Activated__c, (SELECT Id, Activated__c FROM Contacts WHERE Activated__c = true) 
                            FROM Account 
                            WHERE Id = :contactToActivate.AccountId];

        Assert.areEqual(true, acctRec.Activated__c, 'Parent Account must be activated when a child contact is activated');
        
        for(Contact conRec : acctRec.Contacts) {
            if(contactToActivate.Id != conRec.Id) {
                Assert.areEqual(true, conRec.Activated__c, 'All other child Contact records must be activated when a sibling Contact was activated');
            }
        }
    }

    @isTest
    static void testDeactivateContactSingleUpdate() {

        Contact contactToDeactivate = [SELECT Id, AccountId FROM Contact WHERE Activated__c = true LIMIT 1];
        contactToDeactivate.Activated__c = false;
        update contactToDeactivate;

        Account acctRec = [SELECT Id, Activated__c, (SELECT Id, Activated__c FROM Contacts WHERE Activated__c = false) 
                            FROM Account 
                            WHERE Id = :contactToDeactivate.AccountId];

        Assert.areEqual(false, acctRec.Activated__c, 'Parent Account must be deactivated when a child contact is deactivated');
        
        for(Contact conRec : acctRec.Contacts) {
            if(contactToDeactivate.Id !=  conRec.Id) {
                Assert.areEqual(false, conRec.Activated__c, 'All other child Contact records must be deactivated when a sibling Contact was deactivated');
            }
        }

    }

    @isTest
    static void testActivateContactBulkUpdate() {

        Set<Id> parentAcctIdSet = new Set<Id>();
        Set<Id> contactsToActivateIdSet = new Set<Id>();

        List<Contact> contactsToActivateList = [SELECT Id, AccountId
                                                FROM Contact
                                                WHERE Name = 'Test Contact 1'
                                                    AND Activated__c = false];

        for(Contact conRecord : contactsToActivateList) {
            conRecord.Activated__c = true;
            parentAcctIdSet.add(conRecord.AccountId);
            contactsToActivateIdSet.add(conRecord.Id);
        }
        update contactsToActivateList;

        for(Account accRecord : [SELECT Id, Activated__c FROM Account WHERE Id IN :parentAcctIdSet]) {
            Assert.areEqual(true, accRecord.Activated__c, 'Parent Accounts must be activated when a child contact is activated');
        }

        for(Contact conRec : [SELECT Id, Activated__c FROM Contact WHERE AccountId IN :parentAcctIdSet]) {
            if(!contactsToActivateIdSet.contains(conRec.Id)) {
                Assert.areEqual(true, conRec.Activated__c, 'All other child Contact records must be activated when a sibling Contact was activated');
            }
        }
    }

    @isTest
    static void testDeactivateContactBulkUpdate() {
        
        Set<Id> parentAcctIdSet = new Set<Id>();
        Set<Id> contactsToDeactivateIdSet = new Set<Id>();

        List<Contact> contactsToDeactivateList = [SELECT Id, AccountId
                                                  FROM Contact 
                                                  WHERE NAME = 'Test Contact 1'
                                                    AND Activated__c = true];

        for(Contact conRecord : contactsToDeactivateList) {
            conRecord.Activated__c = false;
            parentAcctIdSet.add(conRecord.AccountId);
            contactsToDeactivateIdSet.add(conRecord.Id);
        }
        update contactsToDeactivateList;

        for(Account accRecord : [SELECT Id, Activated__c FROM Account WHERE Id IN :parentAcctIdSet]) {
            Assert.areEqual(false, accRecord.Activated__c, 'Parent Accounts must be deactivated when a child contact is deactivated');
        }

        for(Contact conRecord : [SELECT Id, Activated__c FROM Contact WHERE AccountId IN :parentAcctIdSet]) {
            if(!contactsToDeactivateIdSet.contains(conRecord.Id)) {
                Assert.areEqual(false, conRecord.Activated__c, 'All other child Contact records must be deactivated when a sibling Contact was deactivated');
            }
        }
    }

}