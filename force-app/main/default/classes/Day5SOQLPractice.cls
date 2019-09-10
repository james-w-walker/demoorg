public with sharing class Day5SOQLPractice {
	public Day5SOQLPractice() {
		
	}
		//Write a mass create method that takes a list of members and creates them in the system
	public void createNewMembers(List<String> firstName, List<String> lastName, 
							      List<Integer> joinYear, List<String> status,
								  List<String> role) {

		//I need to create a member for each value on the list with that attribute
		Integer size = firstName.size();

		for(Integer i = 0; i < size; i++){
			Member__c newMember = new Member__c();
			newMember.First_Name__c = firstName.get(i);
			newMember.Last_Name__c = lastName.get(i);
			newMember.Join_Year__c = joinYear.get(i);
			newMember.Status__c = status.get(i);
			newMember.Role__c = role.get(i);
		}

	}

	public void printMemberInfo(String nameSubstring){

		String Jo = '%' + nameSubstring + '%' ;
		
		//find all memebers with string using SOQL - Conditional & SOQL
		
		List<Member__c> JoMembers = [SELECT Id, First_Name__c, Last_Name__c, Join_Year__c
									FROM Member__c WHERE ((First_Name__c LIKE :Jo) 
									OR (Last_Name__c LIKE :Jo))];
		
		for(Integer ii = 0; ii <JoMembers.size(); ii++){
			System.debug(JoMembers.get(ii));
			
		}

	}

	//Write a method for removing members, can provide a First/Last name combo or a SF ID
	//This (Below) will incorporate method overloading - aka declaring the same method with different parameters.
	//The callout will then know only based on the parameters you pass, which method to call
	

	public void removeMembers(List<String> firstNames, List<String> lastNames){
		
		//first we create 2 lists, one to hold all the memebers with Names, and the other to hold all the members we're going to delete 
		//(based on the Lists we are fed)
		List<Member__c> DelMembers = new List<Member__c>();
		List<Member__c> AllMembers = [SELECT First_Name__c, Last_Name__c FROM Member__c];

		//Next we're going to create 2 loops, the first to go through the provided list, and the inner loop to compare the AllMembers Lists, first
		//and last names with the First & Last names fed in through the firstNames & lastNames Lists one by one (using the get(i) from the first loop 
		//to compare). This will be done through a conditional. 
		for(Integer i = 0; i > firstNames.size(); i++){
			for(Member__c member: AllMembers){
				If(member.First_Name__c == firstNames.get(i) && member.Last_Name__c == lastNames.get(i)){
					DelMembers.add(member);
					break;
				}
			}
		}

		//Use DML to delete the DelList
		delete DelMembers;
	}

	//Added a comment

	//Write a method to relocate a list of members to a new gym 
	//Names given in first last name combo or an ID
	//Gym will be given as Gym name or SF ID

	public void relocateMembers(List<String> firstNames, List<String> LastNames, String gymName){
		//Query out the Member
		//Query the Gym
		//Update the Member's records in Apex
		//DML


		//List<Member__c> relocateMembers = [SELECT First_Name__c, Last_Name__c FROM Member__c WHERE First_Name__c ]

	}

	public void relocateMembers(List<String> firstNames, List<String> LastNames, Id gymId){
		//Query out the Members (Use Helper class)

		//Query the Gym

		//Update the Member's records in Apex
		
		//DML
	}

	public void relocateMembers(List<Id> salesforceIds, String gymName){

	}

	public void relocateMembers(List<String> salesforceIds, Id gymId){

	}

	//private List<Member__c> fetchMembers(List<String> firstNames, List<String> lastNames){}

	

}