public with sharing class AccountTriggerHandler {

	public void HandleBeforeInsert(List<Account> accountList) {
		PopulateNullFields(accountList);
		
	}

	private void PopulateNullFields(List<Account> accountList){
		//If the number of locations is not populated, it should be set to 1
		//If the Active field is left blank, set it to 'Yes'

		Set<Id> parentIdSet = new Set<Id>();
		List<Account> accountsWithParents = new List<Account>();
		
		for (Account account : accountList){

			If(account.NumberofLocations__c == null){
			account.NumberofLocations__c = 1;
			}

			If(account.Active__c == null){
			account.Active__c = 'Yes';
			}

			If(account.ParentId != null){
				parentIdSet.add(account.ParentId);
				accountsWithParents.add(account);
			}
		}

		If(parentIdSet.size() > 0){
			Map<Id, Account> parentAccountMap = new Map<Id, Account>([
				SELECT Id, SLA__c, Sic, Industry, CustomerPriority__c,
						SLAExpirationDate__c
				FROM Account 
				WHERE Id IN :parentIdSet
			]);

			for(Account acct : accountsWithParents){
				//Longhand
				Account myAccount = parentAccountMap.get(acct.ParentId);
				acct.SLA__c = myAccount.SLA__c;
				//.SLA__c = parentAccountMap.get(acct.ParentId).SLA__c;
				//Shorthand
				acct.Sic = parentAccountMap.get(acct.ParentId).Sic;
				acct.Industry = parentAccountMap.get(acct.ParentId).Industry;
				acct.CustomerPriority__c = parentAccountMap.get(acct.ParentId).CustomerPriority__c;
				acct.SLAExpirationDate__c = parentAccountMap.get(acct.ParentId).SLAExpirationDate__c;
			}
		}
	}
}