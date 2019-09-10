@isTest
private class QuoteTriggerTest {
	
	@isTest static void testBeforeInsert() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity Opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		SBQQ__Quote__c quote = CPQTestUtils.createquote(account, opp, True);
			
	}

	@isTest static void testBeforeUpdate() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity Opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		SBQQ__Quote__c quote = CPQTestUtils.createquote(account, opp, True);
			
	}

	@isTest static void testAfterUpdate() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity Opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		SBQQ__Quote__c quote = CPQTestUtils.createquote(account, opp, True);
			
	}
	
}