public with sharing class Day2Point5Class {
	public Day2Point5Class() {
		
	}

	public void loopProblem2 (List<String> nameList){
		//Write a program that takes a list of names (like the ones in the class and 
		//prints out how many names start with a vowel, and how many start with a consonant)

		Integer vowellcounter = 0;
		Integer consonantcounter = 0;

		for(String name : nameList){
			If(name.startsWithIgnoreCase('A') || name.startsWithIgnoreCase('E') 
			|| name.startsWithIgnoreCase('I') || name.startsWithIgnoreCase('O')
			|| name.startsWithIgnoreCase('U')){
				vowellcounter++;
			} else  {
				consonantcounter ++;
			}
		}

		System.debug('There are ' + vowellcounter + ' vowells and ' + consonantcounter + 'consonants');

	}


}