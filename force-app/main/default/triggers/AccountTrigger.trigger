trigger AccountTrigger on Account (before insert) {
    
    AccountTriggerHandler Handler = New AccountTriggerHandler();
        If(Trigger.isBefore && Trigger.isInsert){
            Handler.HandleBeforeInsert(Trigger.new);
        }

        }