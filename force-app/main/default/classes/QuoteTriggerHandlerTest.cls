@isTest
private class QuoteTriggerHandlerTest {
	

	@isTest static void testBeforeInsert() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		SBQQ__Quote__c quote = CPQTestUtils.createquote(account, opp, True);
		
		
		SBQQ__Quote__c testquote = [SELECT Id, SBQQ__BillingCity__c, SBQQ__BillingCountry__c,
										SBQQ__BillingName__c, SBQQ__BillingPostalCode__c, SBQQ__BillingState__c,
										SBQQ__BillingStreet__c, SBQQ__BillingFrequency__c
										FROM SBQQ__Quote__c WHERE Id = : quote.id];

		System.assertEquals(testquote.SBQQ__BillingName__c, opp.Bill_To_Name__c);
		System.assertEquals(testquote.SBQQ__BillingCity__c, opp.Bill_To_City__c);
		System.assertEquals(testquote.SBQQ__BillingCountry__c, opp.Bill_To_Country__c);
		System.assertEquals(testquote.SBQQ__BillingPostalCode__c, opp.Bill_To_Postal_Code__c);
		System.assertEquals(testquote.SBQQ__BillingState__c, opp.Bill_To_State__c);
		System.assertEquals(testquote.SBQQ__BillingStreet__c, opp.Bill_To_Street__c);
			
	}

	@isTest static void testBeforeUpdate() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		SBQQ__Quote__c quote = CPQTestUtils.createquote(account, opp, True);
			
	}

	@isTest static void testAfterUpdate() {
		//Create Account
		Account account = CPQTestUtils.createAccount('Test Account', true);  
		//Create Opportunity
		Opportunity opp = CPQTestUtils.createOpportunity(account, True);
		//Insert Opportunity
		SBQQ__Quote__c quote = CPQTestUtils.createquote(account, opp, True);
			
	}
	
}