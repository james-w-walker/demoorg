public with sharing class AccountManagerController {
	
	public class AccountWrapper {
		public Boolean isSelected {get; set;}
		public Account account {get; set;}

		public AccountWrapper(Account account){
			this.account = account;
			isSelected = false;
		}
	}

	public List<AccountWrapper> accountsWrappers {get; set;}

	public Account activeAccount {get; set;}
		
	public AccountManagerController() {
			activeAccount = new Account();
			fetchAccounts();
	}

		public void fetchAccounts() {
			accountsWrappers = new  List<AccountWrapper>();
			List<Account> accounts = [
				SELECT Id, Name, Type, CreatedDate
				FROM Account
				ORDER BY CreatedDate DESC
				Limit 50
				
			];

			for(Account account: accounts){
				accountsWrappers.add(new AccountWrapper(account));    
			} 

		}

		public void deleteAccounts() {

			List<Account> accountsToDelete = new List<Account>();

			for(AccountWrapper currAccountWrapper :accountsWrappers){
				If(currAccountWrapper.isSelected){
					accountsToDelete.add(currAccountWrapper.account);
				}
			}

				If(accountsToDelete.size() > 0) {
					delete accountsToDelete;
				}

			fetchAccounts();
			
			String userMessage = 'You have deleted ' + accountsToDelete.size() + ' accounts';
			ApexPages.Message myMessage = new ApexPages.Message(ApexPages.Severity.CONFIRM, userMessage);
			ApexPages.addMessage(myMessage);
		

		}   

		public PageReference createAccounts() {
			
			insert activeAccount;

			fetchAccounts();
			activeAccount = new Account();

			return null;

		}
		
	
}