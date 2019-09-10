public with sharing class ProductConfiguratorController {
	
	//you need to create an inner class to include the checkboxes just like we did on the 
	//Account Manager

	public class ProductWrapper {
		public Boolean isSelected {get; set;}
		public Product2 product {get; set;}

		public ProductWrapper (Product2 product){
			this.product = product;
			isSelected = false;
		}
	}  
	

	public List<ProductWrapper> resultsProductWrappers {get; set;}
	public String searchTerm {get; set;}  
	public Asset selectedAsset {get; set;}
	public String assetName {get; set;}
	public Product2 activeProduct {get; set;}
	
	public ProductConfiguratorController() {
		activeProduct = new Product2();
		searchTerm = '';
		fetchProducts();
	}

	public void fetchProducts() {
		resultsProductWrappers = new  List<ProductWrapper>();
		List<Product2> products = [
			SELECT Id, Name, ProductCode, Family, isActive
			FROM Product2
			ORDER BY CreatedDate DESC
			Limit 50
			
		];

		for(Product2 product : products){
				resultsProductWrappers.add(new ProductWrapper(product)); 
		}
	}

	public PageReference searchProducts() {
					 
			If(String.isNotBlank(searchTerm)){
				
			String typedProductSOQL = '%' + searchTerm + '%' ;

			resultsProductWrappers = new  List<ProductWrapper>();
			List<Product2> products = [
				SELECT Id, Name, ProductCode, Family, isActive
				FROM Product2
				WHERE Name LIKE : typedProductSOQL
				OR ProductCode LIKE : typedProductSOQL
				Limit 50
			];

				for(Product2 product : products){
					resultsProductWrappers.add(new ProductWrapper(product)); 
				}

			}

			else{
				fetchProducts();
			}

 			return null;
	}

	// public PageReference nameAssets() {

		
	// }
}