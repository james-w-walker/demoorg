public with sharing class UpdateAccountController {
	
	//for vf pages, you're required to have this here vv
	public Account account {get; set;}
	public Contact contact {get; set;}

	public UpdateAccountController() {

		String accountId = ApexPages.currentPage().getParameters().get('id');

		contact = new Contact();

		if(accountId != null){
			account = [
				SELECT Id, Name, CreatedDate, Type,
					(
						SELECT Id, FirstName, LastName
						FROM Contacts
					)
				FROM Account
				WHERE Id =:accountId
			];

		}

		System.debug('UpdateAccountController WAS Called!');

	}

	public PageReference saveAccount() {   

		update account;

		//PageReference
		return ApexPages.currentPAge();

	}

	public PageReference createContact() {   
		//Todo: implment me!

		contact.AccountId = account.Id;

		insert contact;

		return null;

	}

}