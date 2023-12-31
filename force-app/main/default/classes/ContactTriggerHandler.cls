/**
 * @description       : Trigger Handler for Contact Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-22-2023
**/
public with sharing class ContactTriggerHandler {

    public static Boolean bypassExecution = false;
    private static Integer loopCount = 0;

    public static void run() {

        List<Contact> newConList = (List<Contact>) Trigger.new;
        Map<Id, Contact> oldConMap = (Map<Id, Contact>) Trigger.oldMap;

        //To bypass execution and handle recursion
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

                AccountTriggerHandler.bypassExecution = true;
                ContactTriggerHelper.updateRelatedAcctAndContacts(newConList, oldConMap);
                    
            }
            when AFTER_DELETE {
    
            }
            when AFTER_UNDELETE {
                
            }
        }

        loopCount = loopCount - 1;
    }
}