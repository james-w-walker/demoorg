public with sharing class FutureExercise {
	
	@future
	public static void testFutureExercise(List<Id> Ids) {

		//write a query to fetch all accounts that match this id and fetch all of their contacts
		List<Account> accts = [SELECT Id,
								(
								SELECT Id 
								FROM Contacts 
								)
					 	FROM Account 
						WHERE Id IN :Ids ];

		//loop through this list and where there aren't contacts, assign the Number of Contacts field = 0
		// used an if statement to see if number of contacts was 0
		for (Account acct : accts){
			if(acct.Contacts == null){
				acct.Number_Of_Contacts__c = 0;
			}
			//otherwise, use the size function on the looped records Contacts to get the number of contacts (you can do this?)
			else {
				acct.Number_Of_Contacts__c = acct.Contacts.size();
				}
		}

		update accts;

FutureExercise problem = new FutureExercise();

		
	}



}