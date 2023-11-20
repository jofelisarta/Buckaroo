/**
 * @description       : Test Data Factory for inserting records
 * @author            : Joana Felisarta
 * @last modified on  : 11-20-2023
**/

@isTest
public with sharing class TestDataFactory {

    public static List<Account> insertAccounts(Integer numRecords, Boolean isInsert) {

        List<Account> acctsToInsertList = new List<Account>();

        for(Integer count = 1; count <= numRecords ; count++) {
            Account acc = new Account(
                Name = 'Test Account ' + count
            );
            acctsToInsertList.add(acc);
        }

        if(isInsert) {
            insert acctsToInsertList;
        }

        return acctsToInsertList;
    }

    public static List<Contact> insertContactsWithAccounts(Integer numRecordsPerAcct, List<Account> acctList, Boolean isInsert) {

        List<Contact> contactsToInsertList = new List<Contact>();

        for(Account acc : acctList) {
            for(Integer count = 1; count <= numRecordsPerAcct; count++) {
                Contact con = new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact ' + count,
                    accountId = acc.Id
                );
                contactsToInsertList.add(con);
            }
        }

        if(isInsert) {
            insert contactsToInsertList;
        }

        return contactsToInsertList;
    }
}