public with sharing class UsageSummaryRecordTriggerHandler3 {
	
		public static void executeAfterInsert(List<Usage_Summary_Record__c> sourceUsage){
			//pulls in usage records passed in by the trigger and adds them to a list of Ids to be converted into a SOQL list & map below
			List <Id> Ids = new List<Id>();
			for(Usage_Summary_Record__c u : sourceUsage){
				Ids.add(u.Id);
			}

			usageSummaryRating(Ids);

		}

		@future
		public static void usageSummaryRating(List<Id> Ids) {

			//Write a query to fetch all usage Summary records that match an Id
			List<Usage_Summary_Record__c> sourceUsage = [SELECT Id, Usage_Summary__c, Usage_Summary__r.Id, 
														Usage_Summary__r.Usage_Record_Quantity__c, Usage_Amount__c, 
														Usage_Summary__r.Base_Usage_Rate__c, Usage_Summary__r.Usage_Maximum_Allowed__c, Usage_Summary__r.Rated_Quantity__c,
														Usage_Summary__r.Usage_Overage_Rate__c
														FROM Usage_Summary_Record__c
														WHERE Id IN : Ids
														];

			Map<Id, Usage_Summary_Record__c> usagemap = new Map<Id, Usage_Summary_Record__c>
														([SELECT Id, Usage_Summary__c, Usage_Summary__r.Id, Usage_Summary__r.Usage_Record_Quantity__c, Usage_Amount__c, 
														Usage_Summary__r.Base_Usage_Rate__c, Usage_Summary__r.Usage_Maximum_Allowed__c, Usage_Summary__r.Rated_Quantity__c,
														Usage_Summary__r.Usage_Overage_Rate__c
														FROM Usage_Summary_Record__c
														WHERE Id IN : sourceUsage
														]);

			
			Id UsageSummary = '0011U00000497AF';
			Decimal ratedQuantity = 0;
			
			//loop through list and rate usage
			for(Usage_Summary_Record__c usage1 : sourceUsage){
				Integer i = 0;
				System.debug('iteration ' + i);

				//Check to see if usage is pulling from the same summary as the last
				If(usagemap.get(usage1.id).Usage_Summary__r.Id != UsageSummary){
				//If not, assign rated quantity again from usage summary again
				ratedQuantity = usagemap.get(usage1.Id).Usage_Summary__r.Rated_Quantity__c;	
				}
				//otherwise rated quantity retains value set in previous iteration

				System.debug('ratedQuantity: ' + ratedQuantity);

				//Set variables based on Usage Summary Rated Quantities and Usage Amount
				Decimal maximumAllowed = usagemap.get(usage1.Id).Usage_Summary__r.Usage_Maximum_Allowed__c;
				Decimal baseRate = usagemap.get(usage1.Id).Usage_Summary__r.Base_Usage_Rate__c;
				Decimal overageRate = usagemap.get(usage1.Id).Usage_Summary__r.Usage_Overage_Rate__c;
				Decimal usageQuantity = usage1.Usage_Amount__c;

				//Rate usage under maximum threshold
				//Null clause to fulfill vf page test class
				If(maximumAllowed <> null && ratedQuantity <> null && usageQuantity <> null){
					If(ratedQuantity + usageQuantity <= maximumAllowed){
					usage1.Total_Charge_Amount__c = (baseRate * usageQuantity);
					System.debug('usage rate: ' + ratedQuantity + usageQuantity);
					}
				}

				//Rate usage over maximum threshold
				Else If(ratedQuantity > maximumAllowed){
					usage1.Total_Charge_Amount__c = (overageRate * usageQuantity);
					System.debug('overage rate: ' + ratedQuantity);
				}

				//rate usage which intersects the maximum threshold
				Else If(maximumAllowed <> null && ratedQuantity <> null && usageQuantity <> null){
					Decimal overage = ((maximumAllowed - ratedQuantity) - usageQuantity) * (-1);
					Decimal nonOverage = usageQuantity - overage;

					usage1.Total_Charge_Amount__c = (overage * overageRate) + (nonOverage * baseRate);
					System.debug('split rate - ratedQuantity: ' + ratedQuantity + ' usageQuantity: ' + usageQuantity
									+ ' max allowed: ' + maximumAllowed);
				}


				If(maximumAllowed <> null && ratedQuantity <> null && usageQuantity <> null){
				//add to Usage Summary rated Quantity variable for other usages which inherit the same usage summary.	
				ratedQuantity = ratedQuantity + usageQuantity;
				//assign Usage Summary Id value for rating assignment in next iteration
				UsageSummary = usagemap.get(usage1.Id).Usage_Summary__c;
				i++;
				}
			}
			//update the usage records
			update sourceUsage;
		}

	
}