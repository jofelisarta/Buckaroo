/**
 * @description       : Trigger Helper for Contact Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-16-2023
**/
public with sharing class ContactTriggerHelper {
    
    public static void updateRelatedAcctAndContacts(List<Contact> newContactList, Map<Id, Contact> oldContactMap) {
        System.debug('ContactTriggerHelper');
        Set<Id> updatedContactsIdSet = new Set<Id>();
        List<Account> acctsListToUpdate = new List<Account>();
        List<Contact> contactsListToUpdate = new List<Contact>();
        Map<Id, Boolean> acctIdContactMap = new Map<Id, Boolean>();

        for(Contact eachCon : newContactList) {
            if(eachCon.Activated__c != oldContactMap.get(eachCon.Id).Activated__c) {
                updatedContactsIdSet.add(eachCon.Id);
                if(!acctIdContactMap.containsKey(eachCon.AccountId)) {
                    acctIdContactMap.put(eachCon.AccountId, eachCon.Activated__c);
                }
            }
        }

        for(Account eachAcc : [SELECT Id, (SELECT Id, Activated__c FROM Contacts) FROM Account WHERE Id IN :acctIdContactMap.keySet()]) {
            
            eachAcc.Activated__c = acctIdContactMap.get(eachAcc.Id);

            for(Contact eachCon : eachAcc.Contacts) {
                if(!updatedContactsIdSet.contains(eachCon.Id)) {
                    eachCon.Activated__c = acctIdContactMap.get(eachAcc.Id);
                    contactsListToUpdate.add(eachCon);
                }
            }
            acctsListToUpdate.add(eachAcc);
        }

        try {
            System.debug('Update Contact Trigger');
            System.debug('acctsListToUpdate: ' + acctsListToUpdate);
            update acctsListToUpdate;
            
            update contactsListToUpdate;
                     
        } catch (Exception e) {
            System.debug('The following error has occurred: ' + e.getMessage());
        }
    }
}