public with sharing class UsageSummaryTriggerHandler2 {
	
	public static void HandleBeforeInsert(List<Usage_Summary_Record__c> sourceUsage) {
		Set<Id> sourceIds = new Set<Id>();
		
		for(Usage_Summary_Record__c record : sourceUsage){
			sourceIds.add(record.id);
			
		}

		MediateandRateUsage(sourceUsage);

	}


	// @future



	private static void MediateandRateUsage(List<Usage_Summary_Record__c> usageList) {
		
		// List<Usage_Summary_Record__c> usageList = new List<Usage_Summary_Record__c>();

		
		
		Map<Id, Usage_Summary_Record__c> usagemap = new Map<Id, Usage_Summary_Record__c>([
			SELECT Id, Usage_Summary__c, Usage_Summary__r.Id, Usage_Summary__r.Usage_Record_Quantity__c, Usage_Amount__c, 
			Usage_Summary__r.Base_Usage_Rate__c, Usage_Summary__r.Usage_Maximum_Allowed__c, Usage_Summary__r.Rated_Quantity__c,
			Usage_Summary__r.Usage_Overage_Rate__c
			FROM Usage_Summary_Record__c
			WHERE Id IN : usageList
		]); 

		System.debug('Size of List: ' + usageList.size());
		


		
		//Am not able to declare this as a variable without a value, this value means it will never evaluate true on the first iteration of the loop
		Id UsageSummary = '0011U00000497AF';
		Decimal ratedQuantity = 0;



		for(Usage_Summary_Record__c usage1 : usageList){

			Integer i = 0;
			System.debug('iteration ' + i);

			//Check to see if usage is pulling from the same summary as the last
			If(usagemap.get(usage1.id).Usage_Summary__r.Id != UsageSummary){
			//If not, assign rated quantity again from usage summary again
			ratedQuantity = usagemap.get(usage1.Id).Usage_Summary__r.Rated_Quantity__c;	
			}
			//otherwise rated quantity retains value set in previous iteration


			Decimal maximumAllowed = usagemap.get(usage1.Id).Usage_Summary__r.Usage_Maximum_Allowed__c;
			Decimal baseRate = usagemap.get(usage1.Id).Usage_Summary__r.Base_Usage_Rate__c;
			Decimal overageRate = usagemap.get(usage1.Id).Usage_Summary__r.Usage_Overage_Rate__c;
			Decimal usageQuantity = usage1.Usage_Amount__c;

			If(ratedQuantity + usageQuantity <= maximumAllowed){
				usage1.Total_Charge_Amount__c = (baseRate * usageQuantity);
			}

			Else If(ratedQuantity > maximumAllowed){
				usage1.Total_Charge_Amount__c = (overageRate * usageQuantity);
			}

			Else{
				usage1.Total_Charge_Amount__c = ((usageQuantity - (maximumAllowed - ratedQuantity)) * overageRate) + 
												((maximumAllowed - ratedQuantity) * usageQuantity);
			}
				
			ratedQuantity = ratedQuantity + usageQuantity;
			//assign Usage Summary Id value for rating assignment in next iteration
			UsageSummary = usagemap.get(usage1.Id).Usage_Summary__c;
			i++;
		}

	}
}