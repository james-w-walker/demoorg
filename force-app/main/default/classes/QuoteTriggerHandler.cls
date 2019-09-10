public with sharing class QuoteTriggerHandler {
	//Write or update a trigger that will check the Show watermark on quote creation/update if the status is not approved/accepted
	//Write or update a trigger that will un-check the Show watermark button if the Status is changed to approved or accepted

	public static void HandleBeforeInsert(List<SBQQ__Quote__c> quoteList) {
		CheckShowWatermark(quoteList);
		InsertAddressFromOpp(quoteList);
		
	}

	public static void HandleBeforeUpdate(List<SBQQ__Quote__c> quoteList){
		CheckShowWatermark(quoteList);
		CalculateAverageDiscounts(quoteList);


	}

	public static void HandleAfterUpdate(List<SBQQ__Quote__c> quoteList){
		UpdateOpportunityAddresses(quoteList);

	} 



	private static void InsertAddressFromOpp (List<SBQQ__Quote__c> quoteList){
		List<SBQQ__Quote__c> primaryQuotes = new List<SBQQ__Quote__c>();
		Set<Id> primaryQuoteOpps = new Set<Id>();

		for(SBQQ__Quote__c quote : quoteList){
			
			If(quote.SBQQ__Primary__c == True){
				primaryQuotes.add(quote);
				primaryQuoteOpps.add(quote.SBQQ__Opportunity2__c);
			}
		}

		If(primaryQuoteOpps.size() > 0) {
			Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([
				SELECT Id, Bill_To_City__c, Bill_To_Country__c, Bill_To_Name__c, 
				Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Street__c, 
				Ship_To_City__c, Ship_To_Country__c, Ship_To_Name__c, Ship_To_Postal_Code__c, 
				Ship_To_State__c, Ship_To_Street__c
				FROM Opportunity
				WHERE Id IN :primaryQuoteOpps 
			]);
		
		List<SBQQ__Quote__c> insertQuotes = new List<SBQQ__Quote__c>();

		for(SBQQ__Quote__c quote : primaryQuotes){
			quote.SBQQ__BillingName__c = opportunityMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Name__c;
			quote.SBQQ__BillingCountry__c = opportunityMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Country__c;
			quote.SBQQ__BillingCity__c = opportunityMap.get(quote.SBQQ__Opportunity2__c).Bill_To_City__c;
			quote.SBQQ__BillingState__c = opportunityMap.get(quote.SBQQ__Opportunity2__c).Bill_To_State__c;
			quote.SBQQ__BillingPostalCode__c = opportunityMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Postal_Code__c;
			quote.SBQQ__BillingStreet__c = opportunityMap.get(quote.SBQQ__Opportunity2__c).Bill_To_Street__c;

			insertQuotes.add(quote);
					
		}

	

		}
	}

	private static void CheckShowWatermark(List<SBQQ__Quote__c> quoteList){
		//Create a List of the Quotes where the status is not approved/accepted 
		//Create a List of Quotes where the status IS approved/accepted

		List<SBQQ__Quote__c> unapprovedQuotes = new List<SBQQ__Quote__c>();
		List<SBQQ__Quote__c> approvedQuotes = new List<SBQQ__Quote__c>();
		//loop through each list and assign the correct value to the field. 

		for (SBQQ__Quote__c quote : quoteList){

			System.debug(quote.SBQQ__Status__c);

			If((quote.SBQQ__Status__c != 'Accepted') && (quote.SBQQ__Status__c != 'Approved')){
			unapprovedQuotes.add(quote); 
			} else {
					approvedQuotes.add(quote);
				}
		}

		System.debug(unapprovedQuotes.size());
		System.debug(approvedQuotes.size());

			If(unapprovedQuotes.size() > 0){
				for(SBQQ__Quote__c myquote : unapprovedQuotes){
					myquote.SBQQ__WatermarkShown__c = TRUE;
				}
			}
			
			If(approvedQuotes.size() > 0){
				for(SBQQ__Quote__c myquote2 : approvedQuotes ){
					myquote2.SBQQ__WatermarkShown__c = FALSE;		
				}
			}
	
	}

	private static void UpdateOpportunityAddresses(List<SBQQ__Quote__c> quoteList){

		List<SBQQ__Quote__c> primaryQuotes = new List<SBQQ__Quote__c>();
		Set<Id> primaryQuoteOpps = new Set<Id>();

		for(SBQQ__Quote__c quote : quoteList){
			
			If(quote.SBQQ__Primary__c == True){
				primaryQuotes.add(quote);
				primaryQuoteOpps.add(quote.SBQQ__Opportunity2__c);
			}
		}

		If(primaryQuoteOpps.size() > 0) {
			Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([
				SELECT Id, Bill_To_City__c, Bill_To_Country__c, Bill_To_Name__c, 
				Bill_To_Postal_Code__c, Bill_To_State__c, Bill_To_Street__c, 
				Ship_To_City__c, Ship_To_Country__c, Ship_To_Name__c, Ship_To_Postal_Code__c, 
				Ship_To_State__c, Ship_To_Street__c
				FROM Opportunity
				WHERE Id IN :primaryQuoteOpps 
			]);
		
		List<Opportunity> UpdateOppty = new List<Opportunity>();

		for(SBQQ__Quote__c loopQuote: primaryQuotes){
		
			If(loopQuote.SBQQ__Opportunity2__c != Null){
				
				Opportunity opp = new Opportunity();
				opp = opportunityMap.get(loopQuote.SBQQ__Opportunity2__c);

				//Conditional which evaluats whether the Opp fields = loopQuote fields
				//Action is its adding Opp values = the quote values 
					IF((opp.Bill_To_Name__c != loopQuote.SBQQ__BillingName__c ) ||
						(opp.Bill_To_City__c != loopQuote.SBQQ__BillingCity__c ) ||
						(opp.Bill_To_Country__c != loopQuote.SBQQ__BillingCountry__c ) ||
						(opp.Bill_To_Postal_Code__c != loopQuote.SBQQ__BillingPostalCode__c ) ||
						(opp.Bill_To_State__c != loopQuote.SBQQ__BillingState__c ) ||
						(opp.Bill_To_Street__c != loopQuote.SBQQ__BillingStreet__c )) {

						opp.Bill_To_Name__c = loopQuote.SBQQ__BillingName__c;
						opp.Bill_To_Street__c = loopQuote.SBQQ__BillingStreet__c;
						opp.Bill_To_City__c = loopQuote.SBQQ__BillingCity__c;
						opp.Bill_To_State__c = loopQuote.SBQQ__BillingState__c;
						opp.Bill_To_Postal_Code__c = loopQuote.SBQQ__BillingPostalCode__c;
						opp.Bill_To_Country__c = loopQuote.SBQQ__BillingCountry__c;

						UpdateOppty.add(opp);
					}

					
			}

				//add opp to an opp list

				

		}
				//outside the loop dml update list 

		update UpdateOppty;
		}

	}


	Private Static Void CalculateAverageDiscounts(List<SBQQ__Quote__c> quoteList){

		//Convert quoteList into a set of ids
		Set<Id> quoteIds = new Set<Id>();
		for(SBQQ__Quote__c quote : quoteList){
			quoteIds.add(quote.Id);
		}

		//Create 3 lists of Quotelines using a SOQL sub query (one for each family quoteline)
		MAP<Id, SBQQ__Quote__c> quoteMap = new Map<Id, SBQQ__Quote__c>([SELECT Id, Hardware_Discount__c, Software_Discount__c, 
		Support_Discount__c FROM SBQQ__Quote__c WHERE Id IN : quoteIds]);

		//double loop, for each quote got through the quote line list and if the quote lines' quote = the quote 
		//then Case statement for each family, add up the list and net totals to a variable. 
		//divide list by net & inject it into the field on the quote. 
		//break??

		List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>([SELECT Id, SBQQ__Quote__c, SBQQ__ListTotal__c, SBQQ__NetTotal__c 
																			FROM SBQQ__QuoteLine__c WHERE Id IN : quoteIds]);
	

		for(SBQQ__Quote__c quote : quoteList){

			Decimal hardwareList = 0;
			Decimal softwareList = 0;
			Decimal supportList = 0;
			Decimal hardwareNet = 0;
			Decimal softwareNet = 0;
			Decimal supportNet = 0;

			for(SBQQ__QuoteLine__c quoteLine: quoteLines){
				If(quoteLine.SBQQ__Quote__c == quote.Id) {
					switch on quoteline.SBQQ__ProductFamily__c {
						when 'Hardware'{
							hardwareList = hardwareList + quoteline.SBQQ__ListTotal__c;
							hardwareNet = hardwareNet + quoteline.SBQQ__NetTotal__c; 
						}
						when 'Software'{
							softwareList = softwareList + quoteline.SBQQ__ListTotal__c;
							softwareNet = softwareNet + quoteline.SBQQ__NetTotal__c; 
						}
						when 'Support'{
							supportList = supportList + quoteline.SBQQ__ListTotal__c;
							supportNet = supportNet + quoteline.SBQQ__NetTotal__c; 
						}
					}
					break;
				}
			}

			If(hardwareList >0){
				quote.Hardware_Discount__c = (1 - (hardwareNet/hardwareList));
				}
			If(softwareList >0){
			quote.Software_Discount__c = (1 - (softwareNet/softwareList));
				}
			If(supportList > 0){
				quote.Support_Discount__c = (1 - (supportNet/supportList));
			}
		}
	}
	
}