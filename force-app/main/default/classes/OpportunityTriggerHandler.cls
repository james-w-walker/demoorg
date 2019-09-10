public with sharing class OpportunityTriggerHandler {
	
//Only After Update

	public static void HandleAfterUpdate(List<Opportunity> oppList) {
		UpdateQuoteAddress(oppList);
	}

	private static void UpdateQuoteAddress(List<Opportunity> oppList){
		
		//opp id set
		Set<Id> oppSet = new Set<Id>();
			for(Opportunity Opp : oppList){
				oppSet.add(Opp.Id);
			}

		//use that to query quotes, and create a list
		List<SBQQ__Quote__c> quotes =new List<SBQQ__Quote__c>();
			
			for(SBQQ__Quote__c q : [SELECT Id, SBQQ__Opportunity2__c FROM SBQQ__Quote__c WHERE SBQQ__Opportunity2__c IN :oppSet])
				{quotes.add(q);
				}

		//put opps into a map
		Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
			 SELECT Id, Bill_To_City__c, Bill_To_Country__c, Bill_To_Name__c, 
				Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Street__c, 
				Ship_To_City__c, Ship_To_Country__c, Ship_To_Name__c, Ship_To_Postal_Code__c, 
				Ship_To_State__c, Ship_To_Street__c 
				FROM Opportunity WHERE Id IN : oppSet
			]);

		List<SBQQ__Quote__c> UpdateQuotes = new List<SBQQ__Quote__c>();

		//loop through the quote list and assign the oppty's value by map
		IF(quotes.size() > 0){
			for(SBQQ__Quote__c quote : quotes){
					quote.SBQQ__BillingName__c = oppMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Name__c; 
					quote.SBQQ__BillingStreet__c = oppMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Street__c;
					quote.SBQQ__BillingCity__c = oppMap.get(quote.SBQQ__Opportunity2__c).Bill_To_City__c;
					quote.SBQQ__BillingState__c = oppMap.get(quote.SBQQ__Opportunity2__c).Bill_To_State__c;
					quote.SBQQ__BillingPostalCode__c = oppMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Postal_Code__c;
					quote.SBQQ__BillingCountry__c = oppMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Country__c;
					UpdateQuotes.add(quote);
			}	
		}

		update UpdateQuotes;

		
	}



}