@isTest
private class OpportunityTriggerHandlerTest {
	
	@isTest static void testAfterUpdate() {
		//create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);
		//create opportunity
		Opportunity opp = CPQTestUtils.createOpportunity(account, True);
		//create quote
		SBQQ__Quote__c quote = CPQTestUtils.createQuote(account, opp, true);
		//Change a field on my opp
		opp.Bill_To_Street__c = '456 street';

		//Do an update on my opp
		update opp;

		//Query out the quote or opportunity to make sure the quote value matches the opp value
		SBQQ__Quote__c updatedQuote = [SELECT Id, SBQQ__BillingCity__c, SBQQ__BillingCountry__c,
										SBQQ__BillingName__c, SBQQ__BillingPostalCode__c, SBQQ__BillingState__c,
										SBQQ__BillingStreet__c, SBQQ__BillingFrequency__c
										FROM SBQQ__Quote__c WHERE Id = : quote.id];

		System.assertEquals(opp.Bill_To_Street__c, updatedQuote.SBQQ__BillingStreet__c);

		
		
	}
	
	@isTest static void test_method_two() {
		// Implement test code
	}
	
}