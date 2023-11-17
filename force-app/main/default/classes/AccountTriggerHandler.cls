/**
 * @description       : Trigger Handler for Account Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-17-2023
**/
public with sharing class AccountTriggerHandler {

    public static Boolean bypassExecution = false;
    private static Integer loopCount = 0;

    public static void run(){

        List<Account> newAcctsList = (List<Account>) Trigger.new;
        Map<Id, Account> oldAcctMap = (Map<Id, Account>) Trigger.oldMap;

        if(bypassExecution || loopCount == 1) {
            return;
        }

        loopCount = loopCount + 1;

        switch on Trigger.OperationType {
            when BEFORE_INSERT {
                
            }
            when BEFORE_UPDATE {
                
            }
            when BEFORE_DELETE {
    
            }
            when AFTER_INSERT {
    
            }
            when AFTER_UPDATE {
                ContactTriggerHandler.bypassExecution = true;
                AccountTriggerHelper.updateRelatedContacts(newAcctsList, oldAcctMap);         
                
            }
            when AFTER_DELETE {
    
            }
            when AFTER_UNDELETE {
                
            }
        }

        loopCount = loopCount - 1;
    }
}