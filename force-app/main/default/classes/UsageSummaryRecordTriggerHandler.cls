global class UsageSummaryRecordTriggerHandler implements Database.Batchable<sObject> {
	
	String query;
	
	global UsageSummaryRecordTriggerHandler() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}