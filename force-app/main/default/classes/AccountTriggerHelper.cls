/**
 * @description       : Trigger Helper for Account Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-17-2023
**/
public with sharing class AccountTriggerHelper {

    public static void updateRelatedContacts(List<Account> newAcctsList, Map<Id, Account> oldAcctsMap) {

        Set<Id> acctIdSet = new Set<Id>();
        List<Contact> contactsToUpdateList = new List<Contact>();

        for(Account eachAcc : newAcctsList) {
            if(eachAcc.Activated__c != oldAcctsMap.get(eachAcc.Id).Activated__c) {
                acctIdSet.add(eachAcc.Id);
            }
        }

        for(Contact eachCon : [SELECT Id, Account.Activated__c FROM Contact WHERE AccountId IN :acctIdSet]) {
            eachCon.Activated__c = eachCon.Account.Activated__c;
            contactsToUpdateList.add(eachCon);
        }

        try {
            update contactsToUpdateList;
        } catch (Exception e) {
            System.debug('The following error has occurred: ' + e.getMessage());
        }
    }
}