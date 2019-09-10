public with sharing class CreateUsageOrderController {
	
	public class UsageWrapper {
		
		//set global variables
		public Boolean isSelected {get; set;}
		public Usage_Summary__c summary {get; set;}

		//create wrapper to hold usage within checkboxes
		public UsageWrapper(Usage_Summary__c summary){
			this.summary = summary;    
			isSelected = false;
		
		}

	}

	//set global variables
	public List <UsageWrapper> usageWrappers {get; set;}
	//active summary points to selected summary (checkbox)
	public Usage_Summary__c activeSummary {get; set;}
	//usage summary record which is created through the vf page
	public Usage_Summary_Record__c usage1 {get; set;}  
	//summary id passed through the javascript button
	public Id summaryId {get; set;}
	//order id passed through the javascript button
	public Id orderId {get; set;}
	//amount which user sets in number input field set as variable
	public Integer amount1 {get; set;}  
	//disableSave integer prevents the user from clicking the save button until a usage summary is selected
	public boolean disableSave {get; set;}


	public CreateUsageOrderController() {
		
		//gets usage summaries within the order which called the page and inserts into the wrapper list
		usageWrappers = new List<UsageWrapper>();
		Id queryOrderId =  ApexPages.CurrentPage().
					GetParameters().get('orderId');

		List<Usage_Summary__c> summaries = [
			SELECT Id, Account__c, Order__c, Name,
			Order_Product__r.SBQQ__QuoteLine__r.SBQQ__Product__c, 
			Status__c, Usage_Record_Quantity__c
			FROM Usage_Summary__c
			WHERE Order__c = :  queryOrderId
			LIMIT 30
		];
		//adds each summary to the wrapper list
		for(Usage_Summary__c summary : summaries){
			usageWrappers.add(new UsageWrapper(summary));  
		}

		//user cannot click save until select is clicked
		disableSave = true; 
		
	}
		
	public void selectsummary() {
		
		
		boolean checkboxselected = false;
		//queries usage summaries to see if checkbox is selected on VF page
		for(UsageWrapper curUsageWrapper : usageWrappers){
			If(curUsageWrapper.isSelected){
				summaryId = curUsageWrapper.summary.Id;
				//switches variable to true if one is selected
				checkboxselected = true;
				break;
			}

		}
			
		
		System.debug('summaryId = ' + summaryId);

			//if a checkbox is selected, call the orderSource1 method
			If(checkboxselected = true){
				orderSource1();
			}
		
	}


	public void orderSource1(){

		//creates teh usage summary record with the variable parameters passed in by the javascript button
		//and selectsummary method
		usage1 = new Usage_Summary_Record__c();
		usage1.Order__c = ApexPages.CurrentPage().
					GetParameters().get('orderId');
		usage1.Usage_Summary__c = summaryId; 
		usage1.Usage_Amount__c = amount1;

		
		System.debug('Usage Summary is ' + summaryId);
		System.debug('orderId = ' + orderId);

		//once usage summary record is created, allow users to click the save button on the top of the page
		disableSave = false; 
	}

	//inserts the usage record and displays success message
	public void CreateUsageSummaryRecordOrder(){
		
		insert usage1;

		String userMessage = 'usage record created';
			ApexPages.Message myMessage = 
			new ApexPages.Message(ApexPages.Severity.CONFIRM, userMessage);
			ApexPages.addMessage(myMessage);

		//refreshes the page by calling the selectsummary method
		selectsummary();
		
			
		
	}	
 
}