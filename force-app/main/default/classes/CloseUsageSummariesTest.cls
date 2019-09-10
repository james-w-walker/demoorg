@isTest
private class CloseUsageSummariesTest {
	
	@testSetup static void testSetup() {
		// Create Account
		Account acct = CPQTestUtils.createAccount('BatchTest', true);

		//Create Product
		Product2 product = CPQTestUtils.createProduct(true);

		//Create Pricebook
		Pricebook2 pricebook = CPQTestUtils.createPricebook(true);

		//Create PBE
		PricebookEntry pbe = CPQTestUtils.createPricebookEntry(pricebook, product, true);

		//Create Opps
		Opportunity opp = CPQTestUtils.createOpportunity(acct, true);
		
		//Create Quotes
		SBQQ__Quote__c quote = CPQTestUtils.createQuote(acct, opp, true);
	
		System.debug('Quote End Date: ' + quote.SBQQ__EndDate__c);   
		
		//create Quote Lines
		SBQQ__QuoteLine__c quoteLine = CPQTestUtils.createQuoteLineSingle(quote, product, pbe, false);
	
		insert quoteLine;


		
		//Order Quote
		quote.SBQQ__Ordered__c = true;

		Test.startTest();
		update quote; 
		
		
		List<Order> orderCreated = [SELECT Id, EndDate, SBQQ__Quote__c 
									FROM Order
									WHERE SBQQ__Quote__c = : quote.id];

		for(Order o : orderCreated){
			system.debug('Order Id and end date: ' + o.Id + o.EndDate);
		}
		
		//Find Order & End Date
		List <OrderItem> oPsCreated = [SELECT Id, SBQQ__Activated__c, EndDate, OrderId, SBQQ__QuoteLine__c
										FROM OrderItem
										WHERE SBQQ__QuoteLine__c = : quoteLine.id];

		for(OrderItem oi : oPsCreated){
			system.debug('Order Product End Date: ' + oi.Id + oi.EndDate);
		}

		
		
		
		CloseUsageSummaries closebatch = new CloseUsageSummaries();

		Database.executeBatch(closebatch, 20);  
		
		Test.stopTest();  

		//Tests close box is checked
		List<Usage_Summary__c> uSCreated = [SELECT Id, Closed__c, End_Date__c, Order__c, Order_Product__c,
												Order__r.SBQQ__Quote__c
											FROM Usage_Summary__c
											WHERE Order__r.SBQQ__Quote__c = : quote.id];

		for(Usage_Summary__c uSS : USCreated){
			system.debug('Usage Summaries End Date & Close Status: ' + uSS.Id + uSS.End_Date__c + uSS.Closed__c);
		}

			
		// for(Usage_Summary__c summary1 : uSCreated){
		// 	System.Assert(summary1.Closed__c == true, 'summary not closed ' + summary1.Id);
		// }

		//Test that invoice was created for each 
		List<Usage_Invoice__c> invoices = [SELECT Id, Usage_Summary__c, Usage_Summary__r.End_Date__c, Usage_Summary__r.Order__r.SBQQ__Quote__c	
											FROM Usage_Invoice__c WHERE Usage_Summary__r.Order__r.SBQQ__Quote__c = : quote.id];

		// System.Assert(invoices.size() == USCreated.size(), 'invoices size ' + invoices.size() + 'does not equal summary size ' + USCreated.size());
		
	}
	

		
	@isTest static void test2() {
   	  
	  Test.startTest();

      Account a = new Account();
      a.Name = 'testScheduledApexFromTestMethod';
      insert a;

    

      String jobId = System.schedule('testBasicScheduledApex','0 0 1 * * ?', new CloseUsageSummaries());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals('0 0 1 * * ?', ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
    //   System.assertEquals('2019-03-03 01:00:00', 
    //      String.valueOf(ct.NextFireTime));

   	Test.stopTest();

   }
	
}