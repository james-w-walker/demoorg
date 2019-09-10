public with sharing class CreateUsageRecordsController {
	

	//Set variables using get; set; in order to set attributes on usage record
	public Usage_Summary_Record__c usage {get; set;}
	public Id summaryId {get; set;}
	public Id orderId {get; set;}
	public Boolean summarySource {get; set;}
		//// public Boolean orderSource {get; set;}


	public CreateUsageRecordsController() {
		
		If(summarySource = true){
			usageSummarySource();
		}
		
	}

	//pull in id's from javascript button and set to Usage Summary / Order fields
	public void usageSummarySource(){
		usage = new Usage_Summary_Record__c();
		usage.Usage_Summary__c = ApexPages.CurrentPage().
					GetParameters().get('summaryId'); 
		usage.Order__c = ApexPages.CurrentPage().
					GetParameters().get('orderId');
		

	}


	//create the usage record & show user a success message
	public void CreateUsageSummaryRecord(){
		insert usage;

		String userMessage = 'usage record created';
			ApexPages.Message myMessage = 
			new ApexPages.Message(ApexPages.Severity.CONFIRM, userMessage);
			ApexPages.addMessage(myMessage);

	//refresh the page by calling the usage Summary Source class
			usageSummarySource();
		
		
		
	}	
   
	

}