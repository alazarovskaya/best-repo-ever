public class ProductTableTriggerHelper {
    
    public static void beforeInsert (List<ProductTable__c> products) {
        checkAddedDate(products);
        checkAvailable(products);
    }
    
    public static void beforeUpdate (List<ProductTable__c> products) {
		checkAvailable(products);
    }
    
    public static void checkAddedDate (List<ProductTable__c> products) {
        for (ProductTable__c prod : products) {
            	prod.AddedDate__c = Datetime.now();
            }
        }
    
	public static void checkAvailable (List<ProductTable__c> products) {
        for (ProductTable__c prod : products) {
            if (prod.Amount__c >= 0) {
                prod.Available__c = true;
            }
        }
    }
}