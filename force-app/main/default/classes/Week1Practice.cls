public with sharing class Week1Practice {
	public Week1Practice() {
		
		List<Account> AccountList = [SELECT Id, Name, Industry FROM Account WHERE Active__c = 'TRUE'];

		System.debug(AccountList);

	}
}