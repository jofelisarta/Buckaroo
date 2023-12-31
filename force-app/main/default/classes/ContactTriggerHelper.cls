/**
 * @description       : Trigger Helper for Contact Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-22-2023
**/
public with sharing class ContactTriggerHelper {
    
    public static void updateRelatedAcctAndContacts(List<Contact> newContactList, Map<Id, Contact> oldContactMap) {

        Set<Id> updatedContactsIdSet = new Set<Id>();
        List<Account> acctsListToUpdate = new List<Account>();
        List<Contact> contactsListToUpdate = new List<Contact>();
        Map<Id, Boolean> acctIdToActivatedValueMap = new Map<Id, Boolean>();

        for(Contact eachCon : newContactList) {

            if(eachCon.Activated__c != oldContactMap.get(eachCon.Id).Activated__c) {
                updatedContactsIdSet.add(eachCon.Id);

                if(!acctIdToActivatedValueMap.containsKey(eachCon.AccountId)) {
                    acctIdToActivatedValueMap.put(eachCon.AccountId, eachCon.Activated__c);
                }
            }
        }

        for(Account eachAcc : [SELECT Id, (SELECT Id, Activated__c FROM Contacts) FROM Account WHERE Id IN :acctIdToActivatedValueMap.keySet()]) {
            
            eachAcc.Activated__c = acctIdToActivatedValueMap.get(eachAcc.Id);
            acctsListToUpdate.add(eachAcc);

            for(Contact eachCon : eachAcc.Contacts) {
                if(!updatedContactsIdSet.contains(eachCon.Id)) {
                    eachCon.Activated__c = acctIdToActivatedValueMap.get(eachAcc.Id);
                    contactsListToUpdate.add(eachCon);
                }
            }
        }

        try {
            
            update acctsListToUpdate;
            update contactsListToUpdate;

        } catch (Exception e) {
            System.debug('The following error has occurred: ' + e.getMessage());
        }
    }
}