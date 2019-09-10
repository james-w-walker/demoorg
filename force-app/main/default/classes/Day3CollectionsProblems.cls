public with sharing class Day3CollectionsProblems {
	public Day3CollectionsProblems() {

	}
	
	public void conditionalPractice(String firstName, Set<String> nameList){
		//Write a program that takes a list of first names, 

		//if the person is already in the list of names,
		// print out "x is already a memeber of the class",
		// if they are not, add them to the list of names and print out a message saying "X was added as a member of the class"
	
		if(nameList.contains(firstName)){
			System.debug(firstName + ' is already a member of the class');
		}else{
			System.debug(firstName + ' was added as a member of the class');
			nameList.add(firstName); 
		}
	
	
	}

	public void sortingHat(String firstName, Boolean noble, Boolean Brave){
	//Write a program that takes someone's name, whether they are mischievous or Nobel, 
	//and whether they are Brave or Cunning. Sort them into one of the houses below, 
	//and then pring out the message "Name has been placed into House" 
	//If they are Misch & Brave - Gryffindor
	//If they are Misch & Cunning - Slytherin
	//If they are Nobel & Brave - Hufflepuff
	//If they are Nobel and Cunning - Ravenclaw

 		String house = noble ? brave ? 'Hufflepuff' : 'Ravenclaw' : brave ? 'Gryffindor' : 'Slytherin';
 		System.debug(firstName + 'is part of ' + house + ' house');
 
	 }
 
	/* public void loopProblems(){
		List<Integer> intList = new List<Integer>{1,2,3,4,5,6,7,8,9,10};
		for(Integer i=0; i<intlist.size(); i++){
			System.debug(intList.get(i));
		}
	} */

	public void loopProblems(List<String> nameList){
	//Write a program that takes a list of names (like the ones in the class)
	//and prints out how many names start with a vowel, and how many start with a consonant
		

		//Need to build out 2 additional lists to classify the components into

		/* for(Integer i=0; i<nameList.size(); i++){
		nameList.get(i).startsWith('A', 'E', 'I', 'O', 'U') ? 
			System.debug('Vowells Are ' + nameList.get(i)) :
			System.debug('Consonants Are ' + nameList.get(i));
			 
		}

	
*/
	}

}

 







/*


	public void mapProblems(){Map<String,Integer> m2 = new Map<String,String>{
		'Jim Bean' => 2018, 'Jane Smith' => 2018, 'Robbie Rotten' => 2018, 
		'Javier Hughes' =>  2017, 'Kenneth Fuller' => 2017, 'Brandy Medina' => 2018,
		'Carroll Maldonado' =>  2019, 'Israel Castro' =>  2016, 'Tyrone Jones' => 2015, 
		'Jan Mckenzie' =>  2016, 'Judith Rios' =>  2014, 'Thomas Keller' => 2014, 
		'Tami Mcguire' => 2010, 'Sidney Cobb' =>  2019, 'Crystal Washington' => 2015, 
		'Eileen Reed' =>  2018, 'Sylvester Ferguson' =>  2014};

		//Who is the oldest member(s)
		System.debug('The Oldest Members are: ' + for(Max(values()m2))
		//Who is the newest member(s)
	
	*/