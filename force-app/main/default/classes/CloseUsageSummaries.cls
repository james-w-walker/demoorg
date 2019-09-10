global class CloseUsageSummaries implements Database.Batchable<sObject>, Schedulable{
	
	String query;
	List<Usage_Summary__c> closeSummaries = new List<Usage_Summary__c>();

	global CloseUsageSummaries() {
		
	}
	
	//Start - Query out Usage Summaries where the end date is in the past and the closed field is unchecked.
	global Database.QueryLocator start(Database.BatchableContext BC) {

		query = 'SELECT Id, Name, Account__c, Closed__c, End_Date__c, Order__c, Order_Product__c, Status__c, Total_Amount_Due__c, Order__r.SBQQ__Quote__c, Order__r.SBQQ__Quote__r.SBQQ__Opportunity2__c FROM Usage_Summary__c WHERE End_Date__c < TODAY AND Closed__c = false';
				
		return Database.getQueryLocator(query); 
	}


	//Execute - for each summary queried in 'Start', close the usage summary, and create a usage invoice record. 
	//Add each invoice record to a list within the loop, and then updage summary list & insert invoice list outside the loop.
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		
		List<Usage_Invoice__c> summaryInvoices = new List<Usage_Invoice__c>();

		for(Sobject s: scope){
			Usage_Summary__c summary = (Usage_Summary__c)s;
			summary.Closed__c = true;
			closeSummaries.add(summary);

			Usage_Invoice__c invoice = new Usage_Invoice__c();
			invoice.Account__c = summary.Account__c;
			invoice.Opportunity__c = summary.Order__r.SBQQ__Quote__r.SBQQ__Opportunity2__c;
			invoice.Order__c = summary.Order__c;
			invoice.Order_Product__c = summary.Order_Product__c;
			invoice.Quote__c = summary.Order__r.SBQQ__Quote__c;
			invoice.Usage_Summary__c = summary.Id;
			invoice.Total_Amount_Due__c = summary.Net_Total_Amount_Due__c;  
			summaryInvoices.add(invoice);
		
		}

		System.debug('size of summary list: ' + closeSummaries.size());
		System.debug('size of invoice list: ' + summaryInvoices.size());

		Update closeSummaries;
		Insert summaryInvoices;

		//for each invoice, query the accounts contact roles for the primary contact, assign them as the recipient, and send them an email 
		//email references VF invoice template 'Usage Invoice' 
		for(Usage_Invoice__c i: summaryInvoices){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			List <AccountContactRole> Con= [SELECT Id, AccountId, IsPrimary, ContactId
											FROM AccountContactRole
											WHERE IsPrimary = true AND AccountId = : i.Account__c];
			mail.setTargetObjectId(Con[0].Contactid);
			mail.setWhatId(i.Id);			
			mail.setSenderDisplayName('Salesforce Support');
			mail.setUseSignature(false); 
			mail.setBccSender(false); 
			mail.setSaveAsActivity(false); 
			EmailTemplate et=[Select id from EmailTemplate where Name=:'Usage Invoice']; 		
			mail.setTemplateId(et.id); 
			Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });		
		}

		System.debug('Summaries list size: ' + closeSummaries.size());

	}  
	

	
	global void finish(Database.BatchableContext BC) {
		
	}

	//Enable schedulables through this execute method	
	global void execute (SchedulableContext SC) {
		CloseUsageSummaries batch = new CloseUsageSummaries();
		Database.executebatch(batch);
	}
	
}