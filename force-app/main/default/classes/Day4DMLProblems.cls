public with sharing class Day4DMLProblems {
	public Day4DMLProblems() {
		//Account newAcct = new Account(name = 'Facebook');
		  //   insert newAcct;
	}


	public void createManyOpptys(){
	//Use a loop to create 15 opportunities for the newly created Account

	/*Integer limit = 15;

	for(
		Opportunity newOpp = new Opportunity(Account =
	[SELECT Name FROM Account WHERE Name = 'Facebook' LIMIT 1],
	 StageName = 'Qualification', CloseDate = 01/17/2018)){
		insert newOpp; */

		Account a = [SELECT Name FROM Account WHERE Name = 'Facebook' LIMIT 1];
	
		for (Integer i = 0; i < 15; i++ ){
			Opportunity newOpp = new Opportunity(AccountId = a.Id,
	 		StageName = 'Qualification', CloseDate = System.today(), Name = 'Test');
	 		insert newOpp;

		}

	}

	public void deleteAllOpptys(){
		
		List<Opportunity> OppList = [SELECT Id FROM Opportunity];
					delete OppList;
		}

	
	public void undeleteOpptys(Opportunity opptyId){
		
		undelete opptyId;

	}
}