/**
 * @description       : Contact Trigger
 * @author            : Joana Felisarta
 * @last modified on  : 11-16-2023
**/
trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    ContactTriggerHandler.run();
}