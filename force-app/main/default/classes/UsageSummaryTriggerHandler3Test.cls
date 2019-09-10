@isTest
private class UsageSummaryTriggerHandler3Test {
	
	@isTest static void test_method_one() {
		
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

		update quote; 

		//Find Usage Summary
		List<Usage_Summary__c> uSCreated = [SELECT Id, Closed__c, End_Date__c, Order__c, Order_Product__c,
												Order__r.SBQQ__Quote__c
											FROM Usage_Summary__c
											WHERE Order__r.SBQQ__Quote__c = : quote.id];

		//Create a usage record in the usage summary
		List<Usage_Summary_Record__c> recordList = new List<Usage_Summary_Record__c>();
		
		for(Usage_Summary__c summary : uSCreated){
			Usage_Summary_Record__c record = new Usage_Summary_Record__c();

			record.Order__c = summary.Order__c;
			record.Usage_Amount__c = 10;
			record.Usage_Summary__c = summary.id;
			
			recordList.add(record);
		}

		Test.startTest();
		
		insert recordList;

		Test.stopTest();  
	
		
		Decimal baseRate = product.Base_Usage_Rate__c;
		Double maximum = product.Usage_Maximum_Allowed__c;
		Decimal overage = product.Usage_Overage_Rate__c;


		List<Usage_Summary_Record__c> queriedRecords = [SELECT Id, Order__c, Order__r.SBQQ__Quote__c, Usage_Summary__c, Total_Charge_Amount__c, Usage_Amount__c
														FROM Usage_Summary_Record__c
														WHERE Order__r.SBQQ__Quote__c = : quote.id ];

		//The Usage Record isn't rating... is this a timing thing?
		for(Usage_Summary_Record__c rec : queriedRecords){
			IF(rec.Usage_Amount__c <= maximum){
				System.debug('Less Than Max: amount * base: ' + rec.Usage_Amount__c * baseRate + 'totalCharge ammt: ' + rec.Total_Charge_Amount__c);
				System.Assert(rec.Usage_Amount__c * baseRate == rec.Total_Charge_Amount__c, 'Rate Not Correct');
				
			}
			Else {
				System.debug('Greater Than Max: calculaed: ' + (rec.Usage_Amount__c * baseRate) + ((maximum - rec.Usage_Amount__c) * overage) 
								+ 'totalCharge ammt: ' + rec.Total_Charge_Amount__c);
				System.Assert((rec.Usage_Amount__c * baseRate) + ((maximum - rec.Usage_Amount__c) * overage) == rec.Total_Charge_Amount__c, 'Rate not correct') ;
				
			}
		}
	}


	
	
	
	
}