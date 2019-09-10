@isTest
public class CreateUsageRecordsControllerTest {
	
	static testMethod void test_method_one() {
		
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

		Order order = CPQTestUtils.createOrder(acct, opp, quote, true);

		Usage_Summary__c summary = CPQTestUtils.createExpiredUsageSummaries(order, true);




		Test.StartTest();

			//Assign Id's to VF controller paramters
			ApexPages.currentPage().getParameters().put('summaryId', String.valueOf(summary.Id));
			ApexPages.currentPage().getParameters().put('orderId', String.valueOf(order.Id));
			CreateUsageRecordsController  testSummaryVF = new CreateUsageRecordsController();
			testSummaryVF.usageSummarySource();
			testSummaryVF.CreateUsageSummaryRecord();

		Test.StopTest();


	}
	
	
	
}