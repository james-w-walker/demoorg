trigger OrderItemTrigger on OrderItem (after insert) {
    
    //After Insert Trigger to create Usage Summaries based on OrderItem Creation

    If(Trigger.isAfter && Trigger.isInsert){
        OrderItemTriggerHandler.FireAfterInsert(Trigger.new);   
    }

}