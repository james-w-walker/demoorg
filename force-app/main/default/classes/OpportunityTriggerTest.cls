@isTest
private class OpportunityTriggerTest {
	
	@isTest static void testAfterUpdate() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity Opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		update opp;
	}
	

		//test to make sure trigger didn't run
	
		@isTest static void testBeforeUpdate(){
	}
	
}