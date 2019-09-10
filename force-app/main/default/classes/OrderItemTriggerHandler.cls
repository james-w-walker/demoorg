public with sharing class OrderItemTriggerHandler {
	public OrderItemTriggerHandler() {
		
	}

	public static void FireAfterInsert(List<OrderItem> orderItemList){
		CreateUsageSummaries(orderItemList);
	}

	private static void CreateUsageSummaries(List<OrderItem> orderItemList){

		//Create a set of OrderItem Id's
		Set<Id> orderItemIds = new Set<Id>();
		List<OrderItem> usageOrderItems = new List<OrderItem>();

		
		//If usage frequency is set, add the order products to the list and set
		for(OrderItem item : orderItemList){
			If(item.Usage_Frequency__c != null){
				orderItemIds.add(item.Id);
				usageOrderItems.add(item);
			}
		}

		System.debug('usageOrderItems Count = ' + usageOrderItems.size());
		
		//Create a map of OrderItems based off of Id for only OrderItems with usage frequency (Use SOQL)
		If(orderItemIds.size() > 0 ){ 
			Map<Id, OrderItem> orderItemMap = new Map<Id, OrderItem> ([
				SELECT Id, OrderId, Order.AccountId, Usage_Frequency__c, ServiceDate, EndDate
				FROM OrderItem 
				WHERE Id IN : orderItemIds
			]);
		
		

		//Create a list of usage summary records, iterate through the OrderItem map and assign lookups to the usage summary. 
		//Also assign dates based on Monthly/Yearly using if statement within loop
		//add each usage summary to the list

			List<Usage_Summary__c> newUsageSummaries = new List<Usage_Summary__c>();

			//Create a varaible to hold the subscription term in order to know how many usage summaries to create
			Double monthCount = 12;

			//iterate through usage order proudcts and treat based on usage frequency
			for(OrderItem item : usageOrderItems){
				If(item.SBQQ__SubscriptionTerm__c != null){
					monthCount = (item.SBQQ__SubscriptionTerm__c);
				}
				If(item.Usage_Frequency__c == 'Annual') {
					//set dates according to order product dates
					Date annualStartDate = orderItemMap.get(item.Id).ServiceDate;
					
					//Dividing monthcount by 12 to determine how many usage summaries to create for annual
					for(Integer i = 0; i < monthCount/12; i++ ){
						//generate end date based on start date set in previous cycle
						//Per Anders --> .addyears1 function
						Date annualEndDate = annualStartDate + 364;
						If(orderItemmap.get(item.Id).EndDate < annualEndDate){
						annualEndDate = orderItemmap.get(item.Id).EndDate;
						}

						//create usage summary record and add it to the list
						Usage_Summary__c u = new Usage_Summary__c(
							Account__c = orderItemMap.get(item.Id).Order.AccountId, 
							Order__c = orderItemMap.get(item.Id).OrderId, 
							Order_Product__c = orderItemMap.get(item.Id).Id,
							Start_Date__c = annualStartDate, 
							End_Date__c = annualEndDate
						);

					newUsageSummaries.add(u);
					
					//set order product start date to next iteration
					annualStartDate = annualStartDate + 365;

					}

				//Use the else clause to generate a usage summary for each month of the subsciption term if the Frequency is monthly
				} else{

					//set correct intitial date through variables
					Integer startDay = item.ServiceDate.day();
					Integer startMonth = item.ServiceDate.month();
					Integer startYear = item.ServiceDate.year();
					Date endDate = System.today();
	
					System.debug('startDay: ' + startDay);
					System.debug('startMonth: ' + startMonth);
					System.debug('startYear: ' + startYear);
					


					for(Integer ii = 0; ii < monthCount; ii++){
						//Set end date based on start date
						//Per Anders:
						//end date = startdate.addmonths(1).adddays(-1);
						If(startDay == 1)
						{
							endDate = date.newinstance(startYear, startMonth + 1, 1) - 1;
						}
							Else if(startDay > ((date.newinstance(startYear, startMonth + 2, 1)) - 1).day())
							{
								endDate = (date.newinstance(startYear, startMonth + 2, 1) - 1);
							}
								Else {
									endDate = date.newinstance(startYear, startMonth + 1, startDay - 1);
								}
					
						//Assign Usage Summary fields based on Order Fields/relationships & date variables
						Usage_Summary__c u1 = new Usage_Summary__c(
							Account__c = orderItemMap.get(item.Id).Order.AccountId, 
							Order__c = orderItemMap.get(item.Id).OrderId, 
							Order_Product__c = orderItemMap.get(item.Id).Id,
							Start_Date__c = date.newinstance(startYear, startMonth, startDay),
							End_Date__c = endDate
						);

						//Add the usage summary item to the list to be inserted
						newUsageSummaries.add(u1);

						//Adjust dates within the loop to set for next iteration
						//Per Anders - enddate.adddays(-1)
						If(startMonth == 12){
							startYear = startYear + 1;
							startMonth = 1;
						}
							Else if(
								startDay > ((date.newinstance(startYear, startMonth + 2, 1)) - 1).day()
							){
								startMonth = startMonth + 2;
							}
								Else{
								startMonth = startMonth + 1;
								}
						startDay = (endDate +1).day();
						
						
					}
				}

			}

			

			//outside the loop, DML the Usage Summaries using INSERT
			insert newUsageSummaries;

			System.debug('newUsageSummaries Inserted');

		}

		



		
	}
}