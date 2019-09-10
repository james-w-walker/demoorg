trigger UsageSummaryRecordTrigger on Usage_Summary_Record__c (after insert) {

    If(Trigger.isAfter && Trigger.isInsert){
        UsageSummaryRecordTriggerHandler3.executeAfterInsert(Trigger.new);  
    }

}