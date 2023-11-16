/**
 * @description       : Account Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-16-2023
**/
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    AccountTriggerHandler.run();
}