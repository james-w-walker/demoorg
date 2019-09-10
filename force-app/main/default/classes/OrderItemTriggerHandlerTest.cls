@isTest
private class OrderItemTriggerHandlerTest {
	


	@isTest static void testAfterInsert() {
		
		//Create Account, Opp, Quote, and annual/monthly usage quote lines
		Account account = CPQTestUtils.createAccount('Test Account', true);

		PriceBook2 pricebook = CPQTestUtils.createPricebook(true);
		
		Product2 product = CPQTestUtils.createProduct(true);  
		


		// PriceBook2 pb = CPQTestUtils.createPricebook(true);

		PricebookEntry pbe = CPQTestUtils.createPricebookEntry(pricebook, product, true);         

		Opportunity opp = CPQTestUtils.createOpportunity(account, true);

		SBQQ__Quote__c quote = CPQTestUtils.createQuote(account, opp, true);

		// List<Product2> usageProducts = [SELECT Id FROM Product2 WHERE Name LIKE '%plan%'];

		// System.debug(usageProducts.size());

		//create the Quotelines

		List<Product2> productList = new List<Product2>();
			productList.add(product);

			system.debug('size of products list' + productList.size());

		List<SBQQ__QuoteLine__c> quotelines = CPQTestUtils.createQuoteLine(quote, productList, pbe, true);

		// Order order = CPQTestUtils.createOrder(account, opp, quote, true);

		// List<OrderItem> orderitems = CPQTestUtils.createOrderItems(order, quotelines);

		//Order my quote
		Test.startTest();
		
		quote.SBQQ__Ordered__c = true;
		update quote;
		
		List<OrderItem> orderProducts = [SELECT Id, OrderId, Order.SBQQ__Quote__c, ServiceDate,
												(
													SELECT Id, End_Date__c, Start_Date__c
													FROM Usage_Summaries__r
												)
											FROM OrderItem 
											WHERE Order.SBQQ__Quote__c = : quote.id];

		System.Assert(orderProducts.size() > 0, 'ops not created');

		
		for(OrderItem op : orderProducts){  
			op.SBQQ__Activated__c = true;
		}

		update orderProducts;

		List<Usage_Summary__c> usageSummaries = [SELECT Id, Start_Date__c, End_Date__c 
													FROM Usage_Summary__c 
													WHERE Order_Product__c != : orderProducts];

		
									

		// System.Assert(usageSummaries.size() > 0, 'usage summaries not created');





		Test.stopTest();   


	}
	
	
	   
}