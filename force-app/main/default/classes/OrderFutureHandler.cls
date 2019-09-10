public with sharing class OrderFutureHandler {

	//Method to Create List of Order IDs to pass to the future method and call it
	public static void ExecuteAfterInsertUpdate(List<Order> sourceOrders) {
		
		List <Id> orderIds = new List<Id>();
		for(Order order : sourceOrders){
			orderIds.add(order.Id);
		}
	//Check to see if a future or batch method is running prior to firing
		if(System.IsBatch() == false && System.isFuture() == false){ 
			ActivateOrder(orderIds);
		}
	}

	
	@Future
	private static void ActivateOrder(List<Id> orderIds){

	//Converts list of IDs into a list of orders
		List<Order> orderList = [SELECT Id, Date_Updated__c, Status, SBQQ__PriceCalcStatus__c, Do_Not_Activate__c
								FROM Order
								WHERE Id IN : orderIds
								];

		System.debug('Order List Size: ' + orderList.size());

	//Creates List for storing orders in order to update
		List<Order> updateOrders = new List<Order>();

	//Loops through orders and sets status to activated if pricing calc sequence is correct, dates have been set and order hasn't been activated
		for(Order order : orderList){
			IF((order.Date_Updated__c == True) && 
			(order.status != 'Activated') && 
			(order.Do_Not_Activate__c == False) &&  
			((order.SBQQ__PriceCalcStatus__c == 'Not Needed') || (order.SBQQ__PriceCalcStatus__c == 'Completed'))){
				order.status = 'Activated';
				updateOrders.add(order); 
			}
		}

			System.debug('Update Order List Size: ' + updateOrders.size());
		
		
		update updateOrders;

	//Calls Contract Class once Orders are activated passing over the list of orders which were activated
		ContractOrder(updateOrders);
		

	}

	//This method contracts the orders which were activated
	private static void ContractOrder(List<Order> updateOrders){

		List<Order> contractOrders = new List<Order>();
	
	//Loops through the orders which were activated, contracts, and adds them to a list which will be updated via dml
		for(Order order : updateOrders){
			order.SBQQ__Contracted__c = True;
			contractOrders.add(order);
		}

		update contractOrders;

	}

}