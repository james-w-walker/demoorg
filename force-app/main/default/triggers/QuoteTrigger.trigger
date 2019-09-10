trigger QuoteTrigger on SBQQ__Quote__c (before insert, before update, after update) {


    //Anders did quote address update only AFTER UPDATE

    If(Trigger.isBefore && Trigger.isInsert){
        QuoteTriggerHandler.HandleBeforeInsert(Trigger.new);
    }
    
    IF(Trigger.isBefore && Trigger.isUpdate) {
        QuoteTriggerHandler.HandleBeforeUpdate(Trigger.new);
    }

    IF(Trigger.isAfter && Trigger.isUpdate){ 
        QuoteTriggerHandler.HandleAfterUpdate(Trigger.new);
    }

}