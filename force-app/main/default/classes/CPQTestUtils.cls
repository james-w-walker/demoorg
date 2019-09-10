@isTest
public class CPQTestUtils {
	
	public static Account createAccount(Boolean doInsert){
		return createAccount('Test Account', doInsert);
	}
	
	public static Account createAccount(String name, Boolean doInsert) {
		//Need to include all required fields Name
		Account acct = new Account();
		acct.Name = name;

		if(doInsert){
			insert acct;
		}

		return acct;
	}  
	
	public static Opportunity createOpportunity(Account acct, Boolean doInsert) {
		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opp';
		opp.AccountId = acct.id;
		opp.StageName = 'Qualification';
		opp.CloseDate = System.today().addDays(30);
		opp.Bill_To_City__c = 'Kent';
		opp.Bill_To_Country__c = 'USA';
		opp.Bill_To_Name__c = 'Test';
		opp.Bill_To_Postal_Code__c = '98031';
		opp.Bill_To_State__c = 'WA';
		opp.Bill_To_Street__c = '123 south st.';
		opp.Ship_To_City__c = 'Kent';
		opp.Ship_To_Country__c = 'WA';
		opp.Ship_To_Name__c = 'Test';
		opp.Ship_To_Postal_Code__c = 98031;
		opp.Ship_To_State__c = 'WA';
		opp.Ship_To_Street__c = '123 easy street';


		If(doInsert){
			insert opp;
		}

		return opp;  
	}


	public static Product2 createProduct(Boolean doInsert){
		Product2 product = new Product2();
		product.Name = 'test Annual Usage Product';
		product.IsActive = true;
		product.Family = 'Support';
		product.SBQQ__SubscriptionPricing__c = 'Fixed Price';
		product.SBQQ__SubscriptionTerm__c = 12;
		product.SBQQ__SubscriptionBase__c = 'List';
		product.SBQQ__SubscriptionType__c = 'Renewable';
		product.SBQQ__PricingMethod__c = 'List';
		product.Base_Usage_Rate__c = 10;
		product.Usage_Frequency__c = 'Annual';
		product.Usage_Type__c = 'Advance';
		product.Usage_Minimum__c = 20;
		product.Usage_Maximum_Allowed__c = 1000;
		product.Usage_Overage_Rate__c = 20;
		product.SBQQ__AssetAmendmentBehavior__c = 'Default';
		product.SBQQ__AssetConversion__c = 'One per quote line';  
		product.SBQQ__BillingFrequency__c = 'Monthly';
		product.SBQQ__BillingType__c = 'Arrears';
		  
		
		If(doInsert){
			insert product;
		}

		return product; 

	}

	public static Pricebook2 createPricebook(Boolean doInsert){
		Pricebook2 testPB = new Pricebook2(Name = 'Test Pricebook', isActive = true);
		Id pricebookId = Test.getStandardPricebookId();
		

		If(doInsert){
			insert testPB;
		}

		return testPB;
	}
		
	public static PricebookEntry createPricebookEntry(Pricebook2 pricebook, Product2 product, Boolean doInsert){
		PricebookEntry standardPrice = new PricebookEntry();
		standardPrice.Product2Id = product.Id;
		standardPrice.Pricebook2Id = Test.getStandardPricebookId();
		standardPrice.UnitPrice = 1;
		standardPrice.IsActive = true;
		// standardPrice.UseStandardPrice = true;

		IF(doInsert){
			insert standardPrice;
		}

		return standardPrice;
	}

	public static SBQQ__Quote__c createQuote (Account acct, Opportunity opp, Boolean doInsert) {
		SBQQ__Quote__c quote = new SBQQ__Quote__c();
		//assign account
		quote.SBQQ__PriceBook__c = Test.getStandardPricebookId();
        quote.SBQQ__PricebookId__c = Test.getStandardPricebookId();
		quote.SBQQ__Primary__c = True;
		quote.SBQQ__Opportunity2__c = opp.id;
		quote.SBQQ__Account__c = acct.id;
		quote.SBQQ__SubscriptionTerm__c = 12;
		quote.SBQQ__StartDate__c = System.today() - 365;  
		quote.SBQQ__EndDate__c = System.today() - 1;
		quote.SBQQ__BillingName__c = 'Tessst';
		quote.SBQQ__BillingStreet__c = '123 street';
		quote.SBQQ__BillingCity__c = 'Kent';
		quote.SBQQ__BillingState__c	= 'WA';
		quote.SBQQ__BillingPostalCode__c = '98031';
		quote.SBQQ__BillingCountry__c = 'USA';
		quote.SBQQ__ShippingCity__c = 'Seattle';
		quote.SBQQ__ShippingCountry__c = 'Pakistan';
		quote.SBQQ__ShippingName__c = 'SendITinc';
		quote.SBQQ__ShippingPostalCode__c = '00394';
		quote.SBQQ__ShippingState__c = 'IL';
		quote.SBQQ__ShippingStreet__c = 'Hardcore street';
		

		If(doInsert){
			insert quote;
		
		
		}

			return quote;

	}

	//method to create single Quote Line
	public static SBQQ__QuoteLine__c createQuoteLineSingle (SBQQ__Quote__c quote, Product2 product, PricebookEntry pbe, Boolean doInsert){
		SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();

				quoteLine.SBQQ__PricebookEntryId__c = pbe.id; 
			    quoteLine.SBQQ__Bundle__c = false;
                quoteLine.SBQQ__PricingMethod__c = product.SBQQ__PricingMethod__c;
                quoteLine.SBQQ__ComponentListTotal__c = 100;
                quoteLine.SBQQ__ComponentTotal__c = 100;   
                quoteLine.SBQQ__CustomerPrice__c = 100;
                quoteLine.SBQQ__Description__c = product.Description;
                quoteLine.SBQQ__ListPrice__c = 100;
                quoteLine.SBQQ__NetPrice__c = 100;
                quoteLine.SBQQ__OriginalPrice__c = 100;
                quoteLine.SBQQ__PartnerPrice__c = 100;
                quoteLine.SBQQ__Product__c = product.Id;
                quoteLine.SBQQ__ProrateMultiplier__c = 1;
                quoteLine.SBQQ__ProratedListPrice__c = 100;
                quoteLine.SBQQ__ProratedPrice__c = 100;
                quoteLine.SBQQ__Quantity__c = 1;
                quoteLine.SBQQ__Quote__c = quote.Id;
                quoteLine.SBQQ__RegularPrice__c = 100;
                quoteLine.SBQQ__SpecialPrice__c = 100;
                quoteLine.SBQQ__SubscriptionBase__c = product.SBQQ__SubscriptionBase__c;
                quoteLine.SBQQ__SubscriptionPricing__c = product.SBQQ__SubscriptionPricing__c;
				quoteLine.Base_Usage_Rate__c = 10;
				quoteLine.Usage_Frequency__c = 'Annual';
				quoteLine.Usage_Type__c = 'Advance';
				quoteLine.Usage_Minimum__c = 20;
				quoteLine.Usage_Maximum_Allowed__c = 1000;
				quoteLine.Usage_Overage_Rate__c = 20;
				quoteLine.SBQQ__BillingFrequency__c = product.SBQQ__BillingFrequency__c;
				quoteLine.SBQQ__BillingType__c = product.SBQQ__BillingType__c;
				quoteLine.SBQQ__ChargeType__c = product.SBQQ__ChargeType__c;

				If(doInsert){
				insert quoteLine;
				}

			return quoteLine;

	}


	//method to create quotelines
	public static List<SBQQ__QuoteLine__c> createQuoteLine (SBQQ__Quote__c quote, List<Product2> products, PricebookEntry pbe, Boolean doInsert){
		List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLIne__c>();
		
		Integer i = 1;

		for(Product2 product : products){
			quoteLines.add(new SBQQ__QuoteLine__c(
				SBQQ__PricebookEntryId__c = pbe.id, 
			    SBQQ__Bundle__c = false,
                SBQQ__PricingMethod__c = product.SBQQ__PricingMethod__c,
                SBQQ__ComponentListTotal__c = 100,
                SBQQ__ComponentTotal__c = 100,   
                SBQQ__CustomerPrice__c = 100,
                SBQQ__Description__c = product.Description,
                SBQQ__ListPrice__c = 100,
                SBQQ__NetPrice__c = 100,
                SBQQ__Number__c = i,
                SBQQ__OriginalPrice__c = 100,
                SBQQ__PartnerPrice__c = 100,
                SBQQ__Product__c = product.Id,
                SBQQ__ProrateMultiplier__c = 1,
                SBQQ__ProratedListPrice__c = 100,
                SBQQ__ProratedPrice__c = 100,
                SBQQ__Quantity__c = 1,
                SBQQ__Quote__c = quote.Id,
                SBQQ__RegularPrice__c = 100,
                SBQQ__SpecialPrice__c = 100,
                SBQQ__SubscriptionBase__c = product.SBQQ__SubscriptionBase__c,
                SBQQ__SubscriptionPricing__c = product.SBQQ__SubscriptionPricing__c,
				Base_Usage_Rate__c = 10,
				Usage_Frequency__c = 'Annual',
				Usage_Type__c = 'Advance',
				Usage_Minimum__c = 20,
				Usage_Maximum_Allowed__c = 1000,
				Usage_Overage_Rate__c = 20,
				SBQQ__BillingFrequency__c = product.SBQQ__BillingFrequency__c,
				SBQQ__BillingType__c = product.SBQQ__BillingType__c,
				SBQQ__ChargeType__c = product.SBQQ__ChargeType__c

			));

			i++;
		}

		If(doInsert){
			insert quoteLines;
		}

		return quoteLines;

	}



	public static Order createOrder(Account acct, Opportunity opp, SBQQ__Quote__c quote, Boolean doInsert){
		Order order = new Order();
		
		order.Accountid = acct.id;
		order.Opportunity = opp; 
		order.SBQQ__Quote__c = quote.id;  
		order.EffectiveDate = System.today();
		order.Status = 'draft';
		order.Type = 'New';
	
		
		If(doInsert){
			insert order;
		}

		return order;
		
	}

	public static OrderItem createOrderItem(Order order, Product2 product, PricebookEntry pbe, SBQQ__QuoteLine__c quoteline, Boolean doInsert){
		OrderItem op = new OrderItem();
		op.Order = order;  
		// op.Quantity = 1;
		op.UnitPrice = 1;
		// op.SBQQ__Activated__c = true;
        // op.SBQQ__DefaultSubscriptionTerm__c = 12;
		// op.SBQQ__ProrateMultiplier__c = 1;
		// op.ServiceDate = system.today();
		// op.EndDate = system.today().AddDays(365);
		// op.SBQQ__QuoteLine__c = quoteline.Id;
		op.PricebookEntryId = '01u1U000001IErw';
	

		If(doInsert){
			insert op;
		}

		return op;
		
	}

	// public static List<OrderItem> createOrderItems(Order order, List<SBQQ__QuoteLine__c> quoteLines) {
    //     List<OrderItem> orderItems = new List<OrderItem>();

    //     for(SBQQ__QuoteLine__c quoteLine : quoteLines) {

    //         orderItems.add(new OrderItem(
    //             EndDate = Date.today().addMonths(12),
    //             OrderId = order.Id,
    //             PricebookEntryId = quoteLine.SBQQ__PricebookEntryId__c,
    //             Quantity = 1,
	// 			SBQQ__Activated__c = true,
    //             SBQQ__DefaultSubscriptionTerm__c = 12,
    //             SBQQ__OrderedQuantity__c = quoteLine.SBQQ__Quantity__c,
    //             SBQQ__ProrateMultiplier__c = 1,
    //             SBQQ__QuoteLine__c = quoteLine.Id,
    //             SBQQ__QuotedListPrice__c = quoteLine.SBQQ__ListPrice__c,
    //             SBQQ__QuotedQuantity__c = quoteLine.SBQQ__Quantity__c,
    //             SBQQ__Status__c = 'Activated',
    //             SBQQ__SubscriptionPricing__c = quoteLine.SBQQ__SubscriptionPricing__c,
    //             SBQQ__SubscriptionTerm__c = quoteLine.SBQQ__SubscriptionTerm__c,
    //             ServiceDate = Date.today(),
    //             UnitPrice = quoteLine.SBQQ__NetPrice__c,
	// 			Usage_Frequency__c = 'Annual',
	// 			Base_Usage_Rate__c = 10,
	// 			Usage_Type__c = 'Advance',
	// 			Usage_Minimum__c = 20,
	// 			Usage_Maximum_Allowed__c = 1000,
	// 			Usage_Overage_Rate__c = 20
                
    //         ));
    //     }

    //     insert orderItems;
    //     return orderItems;
    // }



	public static Usage_Summary__c createExpiredUsageSummaries(Order order, Boolean doInsert){
		Usage_Summary__c uS = new Usage_Summary__c();

			uS.Account__c = Order.Accountid;
			uS.Start_Date__c = System.today() - 31;
			uS.End_Date__c = System.today() -2;
			uS.Order__c = Order.Id;
			// uS.Order_Product__c = op.Id;
			uS.closed__c = false;
			
		
		If(doInsert){
			insert uS;
		}

		return uS;
	}

	// public static OrderItem createOrderProducts(Order order, )
}