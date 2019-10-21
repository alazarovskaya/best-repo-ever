@isTest
public class TestProductTableApplication {

    @isTest
    public static void testCheckAddedDate() {
        List<ProductTable__c> testList = createProducts(1);
        insert testList;
        testList = [SELECT Id, AddedDate__c FROM ProductTable__c ];
        System.assert(testList.get(0).AddedDate__c != null, 'The date is wrong.');
    }
    
    @isTest
    public static void testCheckAvailable() {
        List<ProductTable__c> testList = createProductsWithAmount(1);
        insert testList;
        testList = [SELECT Id, Available__c FROM ProductTable__c ];
        System.assert(testList.get(0).Available__c = true, 'The Available checkbox is not selected after insert.');
        List<ProductTable__c> testList2 = createProducts(1);
        insert testList2;
        testList2 = [SELECT Id, Available__c, Amount__c FROM ProductTable__c ];
        testList2.get(0).Amount__c = 5;
        update testList2;
        System.assert(testList2.get(0).Available__c = true, 'The Available checkbox is not selected after update.');
        
    }
    
    @isTest
    public static void testInsertNewProductTableNoErrors() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.product = new ProductTable__c (Name = 'TestProduct0');
        testProductTablePageController.insertNewProductTable();
        System.assert(testProductTablePageController.getProducts().size() != 0, 'The product is not saved.');
        System.assert(testProductTablePageController.product == null, 'The next new product will not be inserted.');
        System.assertEquals(false, testProductTablePageController.isDisplaying, 'The form for the new product is still dispalaying.');
    }
   
    @isTest
    public static void testInsertNewProductTableWithErrors() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.product = new ProductTable__c (Name = 'TestProduct0', Amount__c = -1);
        testProductTablePageController.insertNewProductTable();
        System.assert(ApexPages.getMessages().size() != 0, 'The error message for the wrong amount is not shown.');
        testProductTablePageController.product = new ProductTable__c (Name = 'TestProduct0', Price__c = -1);
        testProductTablePageController.insertNewProductTable();
        System.assert(ApexPages.getMessages().size() != 0, 'The error message for the wrong price is not shown.');
    }
    
    @isTest
    public static void testUpdateNewProductTableNoErrors() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(2);
        insert testList;
        testProductTablePageController.getProducts();
        testProductTablePageController.products[0].Name = 'TestProduct';
        testProductTablePageController.updateNewProductTable();
        System.assertEquals('TestProduct', testProductTablePageController.products[0].Name, 'The record is not updated.');
    }
    
    @isTest
    public static void testUpdateNewProductTableWithErrors() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(2);
        insert testList;
        testProductTablePageController.getProducts();
        testProductTablePageController.products[0].Amount__c = -1;
        testProductTablePageController.updateNewProductTable();
        System.assert(ApexPages.getMessages().size() != 0, 'The error message for the wrong amount updating is not shown.');
        testProductTablePageController.products[0].Price__c = -1;
        testProductTablePageController.updateNewProductTable();
        System.assert(ApexPages.getMessages().size() != 0, 'The error message for the wrong price updating is not shown.');
    }
    
    @isTest
    public static void testDeleteProductTable() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(1);
        insert testList;
        System.assert(testProductTablePageController.getProducts().size() != 0);
        testProductTablePage.getParameters().put('rowid', testProductTablePageController.products[0].id);
		testProductTablePageController.deleteProductTable();
        System.assert(testProductTablePageController.getProducts().size() == 0, 'The product is not deleted.');
    }    
    
    @isTest
    public static void testGetProducts() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(1);
        insert testList;
        List<ProductTable__c> testProductList = testProductTablePageController.getProducts();
        System.assert(testProductList.size() != 0, 'The product list is not empty.');
        testProductTablePageController.product = new ProductTable__c (Name = 'NewProduct');
        testProductTablePageController.insertNewProductTable();
        List<ProductTable__c> testList2 = testProductTablePageController.getProducts();
		testProductTablePageController.searchKey = 'NewProduct';
        System.assert(testProductTablePageController.getProducts().size() != 0 && testProductTablePageController.getProducts().size() < testList2.size(), 'The product list is not filtered by name.');
        DateTime searchDate = Datetime.now();
        testProductTablePageController.searchKey = searchDate.month() + '/' + searchDate.day() + '/' + searchDate.year();
        System.assert(testProductTablePageController.getProducts().size() == 2, 'The product list is not filtered by date.');    
    }
    
    @isTest
    public static void testGetProduct() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        System.assert(testProductTablePageController.getProduct() != null, 'The new product is not created or not returned.');
    }
    
    @isTest
    public static void testView() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.view();
     	System.assertEquals(true, testProductTablePageController.isDisplaying, 'The form for the new product is not dispalaying.');        
    }
    
    @isTest
    public static void testDel() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.del();
     	System.assertEquals(true, testProductTablePageController.isDel, 'The button for deleting product is not dispalaying.');        
    }
    
    @isTest
    public static void testCancelDel() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.cancelDel();
     	System.assertEquals(false, testProductTablePageController.isDel, 'The button for deleting product is still dispalaying.');        
    }
    
    @isTest
    public static void testSearch() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.search();
     	System.assertEquals(0, testProductTablePageController.counter, 'The results of the search are not showing from the first page.');        
    }
    
    @isTest
    public static void testClear() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(2);
        insert testList;
        testProductTablePageController.searchKey = 'TestProduct0';
        List<ProductTable__c> testList2 = testProductTablePageController.getProducts();
        testProductTablePageController.clear();
     	System.assert(testProductTablePageController.searchKey == null, 'The clear button does return the product list without specific seacrh criteria.');    
        System.assert(testProductTablePageController.getProducts().size() > testList2.size(), 'The product list is empty.');      
    }
    
    @isTest 
    public static void testCheckIfDate() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        System.assertEquals(true, testProductTablePageController.checkIfDate(date.today().month() + '/' + date.today().day() + '/' + date.today().year()), 'The date format is not valid.');    
    }
    
    @isTest 
    public static void testIsDate() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        System.assertEquals(Date.parse(date.today().month() + '/' + date.today().day() + '/' + date.today().year()), testProductTablePageController.isDate(date.today().month() + '/' + date.today().day() + '/' + date.today().year()), 'The date is not converted to required format.');    
    }
    
    @isTest
    public static void testFirst() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.first();
     	System.assertEquals(0, testProductTablePageController.counter, 'The results are not showing from the first page.');        
    }
    
    @isTest
    public static void testNext() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        Integer testCounter = testProductTablePageController.counter + testProductTablePageController.pageSize;
        testProductTablePageController.next();
     	System.assert(testProductTablePageController.counter == testCounter, 'The next page is not showing.');        
    }
    
    @isTest
    public static void testPrevious() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        Integer testCounter = testProductTablePageController.counter - testProductTablePageController.pageSize;
        testProductTablePageController.previous();
     	System.assert(testProductTablePageController.counter == testCounter, 'The previous page is not showing.');        
    }
    
    @isTest
    public static void testLast() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.last();
        Integer testCounter = testProductTablePageController.getProductTableSize() - math.mod(testProductTablePageController.getProductTableSize(), testProductTablePageController.pageSize);
    	System.assert(testProductTablePageController.counter == testCounter, 'The last page is not showing.'); 
    }
    
    @isTest
    public static void testGetPageNumber() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.counter = 5;
        Integer testPageNumber = testProductTablePageController.counter / testProductTablePageController.pageSize + 1;
        System.assertEquals(testPageNumber, testProductTablePageController.getPageNumber(), 'The page number is not calculated correctly.'); 
    }

    @isTest
    public static void testGetTotalPages() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.ProductTableSize = 5;
        System.assertEquals(testProductTablePageController.ProductTableSize/testProductTablePageController.PageSize, testProductTablePageController.getTotalPages(), 'The total page number is not calculated correctly.'); 
        testProductTablePageController.ProductTableSize = 12;
        System.assertEquals(testProductTablePageController.ProductTableSize/testProductTablePageController.PageSize + 1, testProductTablePageController.getTotalPages(), 'The total page number is not calculated correctly.'); 
    }

    
    @isTest
    public static void testGetDisablePrevious() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        testProductTablePageController.counter = 0;
        System.assertEquals(true, testProductTablePageController.getDisablePrevious(), 'The button for the previous page is shown.'); 
        testProductTablePageController.counter = 1;
        System.assertEquals(false, testProductTablePageController.getDisablePrevious(), 'The button for the previuos page is not shown.'); 
    }

    @isTest
    public static void testGetDisableNext() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(12);
        insert testList;
        testProductTablePageController.getProducts();
        System.assertEquals(false, testProductTablePageController.getDisableNext(), 'The button for the next page is not shown.'); 
        testProductTablePageController.counter = 10;
        System.assertEquals(true, testProductTablePageController.getDisableNext(), 'The button for the next page is shown.'); 
    }
    
    @isTest
    public static void testSort() {
        PageReference testProductTablePage = Page.ProductTablePage;
        Test.setCurrentPage(testProductTablePage);
        ProductTablePageController testProductTablePageController = new ProductTablePageController();
        List<ProductTable__c> testList = createProducts(3);
        insert testList;
        testProductTablePageController.sort();
        System.assertEquals('TestProduct2', testProductTablePageController.products[0].Name, 'The sort is not working on Added Date DESC.'); 
		testProductTablePageController.sortOrder = 'Name';
        testProductTablePageController.sort();
        System.assertEquals('TestProduct2', testProductTablePageController.products[0].Name, 'The sort is not working on Name DESC.'); 
        System.assertEquals('Name', testProductTablePageController.order, 'The sort is not working on Name DESC.'); 
        testProductTablePageController.order = 'ASC';
        testProductTablePageController.order = 'DESC';
        testProductTablePageController.order = 'DESC';
        System.assertEquals('DESC', testProductTablePageController.getSortDirection(), 'The sort direction has not been changed.'); 
        testProductTablePageController.order = null;
        System.assertEquals('ASC', testProductTablePageController.getSortDirection(), 'The sort direction has not been changed.');
        testProductTablePageController.setSortDirection('DESC');
		System.assert(testProductTablePageController.getSortDirection() != null, 'The sort direction has not been set.');     
    }
    
     
    public static List<ProductTable__c> createProducts(Integer prodNum) {
        List<ProductTable__c> prodList = new List<ProductTable__c>();
        for (Integer i = 0; i < prodNum; i++) {
            ProductTable__c prod = new ProductTable__c (Name = 'TestProduct' + i);
            prodList.add(prod);
        }
        return prodList;
    }
    
    public static List<ProductTable__c> createProductsWithAmount(Integer prodNum) {
        List<ProductTable__c> prodList = new List<ProductTable__c>();
        for (Integer i = 0; i < prodNum; i++) {
            ProductTable__c prod = new ProductTable__c (Name = 'TestProduct' + i, Amount__c = i + 1);
            prodList.add(prod);
        }
        return prodList;
    }
    
}