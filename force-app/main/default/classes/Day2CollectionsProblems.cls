public with sharing class Day2CollectionsProblems {
	public Day2CollectionsProblems() {

	}

	public List<String> listProblems(){

	//Write a list that contains the first names of every participant in the clas
		List<String> ls1 = new List<String>();
		ls1.add('Joseph Desch');
		ls1.add('Samuel Mandell');
		ls1.add('Stephanie Ralls');
		ls1.add('James Walker');
		ls1.add('Anders Windell');
		ls1.add('Abhi');
		ls1.add('Timothy');
		ls1.add('Arif');
		ls1.add('Austin');
//Add Sarah
		ls1.add('Sarah');
//Who is the seventh participant
		System.debug('7th person in the class is ' + ls1.get(4));
//How many people are in the class
		System.debug('There are ' + ls1.size() + ' people in the class');
//Remove me (Anders) from the list using built in functions, print list to verify I am missing
		System.debug('Class: ' + ls1);
		ls1.remove(ls1.indexOf('Anders Windell'));
		System.debug('Class After: ' + ls1);

		return ls1;
	}


	public void setProblems(List<String> nameList){
		//Create a set that copies the first name list
		Set<String> s1 = new Set<String>(nameList);
		//Add Joe Redfern to the class
		//s1.add('Joe')
		//Check the size of the set
		System.debug('Set Size After: ' + s1.size());
		//Check whether the set contains Austin and whether it contains me (Anders)
		System.debug('Set Contains Austin? ' + s1.contains('Austin'));
		}

	public void mapProblems(){
		//Create a map where the key is the first name and the value is the last name of everone in class
		Map<String,String> m1 = new Map<String,String>{'Joe' => 'Desch', 'Samuel' => 'Mandell', 'Stephanie' => 'Ralls', 
														'James' => 'Walker', 'Timothy' => 'Kornish', 'Arif' => 'Nairam', 
														'Abhi' => 'Varagan'};
		//Print all first names of the class
		System.debug('First Names' + m1.keySet());
		//Print all the last names of the class
		System.debug('Last Names' + m1.values());
		//Put in Stephen STanton
		m1.put('Stephen', 'Stanton');
		//Put in Joe Redfern *problematic
		m1.put('Joe', 'Redfern');
		System.debug('m1' + m1);
	
	}
}