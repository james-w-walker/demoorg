trigger OrderFutureHandlerTrigger on Order (after insert, after update) {

    If(Trigger.isAfter && Trigger.isInsert){
        OrderFutureHandler.ExecuteAfterInsertUpdate(Trigger.new);
    }   

    If(Trigger.isAfter && Trigger.isUpdate){
        OrderFutureHandler.ExecuteAfterInsertUpdate(Trigger.new);
    }   
   
}