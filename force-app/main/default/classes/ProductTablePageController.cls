public class ProductTablePageController {
    
    public List<ProductTable__c> products;
    public String searchQuery, searchOrder, searchLimit;
    public boolean isDisplaying {get; set;}
    public boolean isDel {get; set;}
    public ProductTable__c product;
    public String searchKey {get; set;}
    public String sortOrderDirection = 'DESC';
    public String sortOrder = 'AddedDate__c'; 
   	public Integer counter = 0;  
  	public Integer pageSize = 5; 
   	public Integer productTableSize = [SELECT Count() FROM ProductTable__c];
      
    public void insertNewProductTable () {
        try {
            insert product;
            isDisplaying = false;
            product = null;
            getProducts();
	    } 
        catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
    }
    
    public void deleteProductTable() {
    	String prodid = ApexPages.CurrentPage().getParameters().get('rowid');
    	ProductTable__c delRow;
        for(Integer i = 0; i < products.size(); i++) {
        	if(products[i].id == prodid) {
             	delRow = products[i];
                products.remove(i);
                break;
          	}
       	}
        if (delRow != null) {
        	delete delRow;
        }
    }
    
    public void updateNewProductTable() {
        try {
            update products;
	    } 
        catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
    }
        
    public List<ProductTable__c> getProducts() {
        searchQuery = 'SELECT Name, Amount__c, Price__c, ProductType__c, ReleaseDate__c, Available__c, AddedDate__c FROM ProductTable__c';
        searchOrder = ' ORDER BY ' + sortOrder + ' ' + sortOrderDirection;
        searchLimit = ' LIMIT ' + pageSize + ' OFFSET ' + counter;
        if (!String.isEmpty(searchKey)) {
            if (checkIfDate(searchKey)) {
            	if (isDate(searchKey) != null) {
                    String searchKeyStartTime = String.ValueofGmt(isDate(searchKey)).left(10) + 'T00:00:00Z';
                    String searchKeyEndTime = String.ValueofGmt(isDate(searchKey)).left(10) + 'T23:59:59Z'; 
                	searchQuery = searchQuery + ' WHERE AddedDate__c >= '+ searchKeyStartTime +' AND AddedDate__c <= ' + searchKeyEndTime;  
            	}
            }
            else {
                searchQuery = searchQuery + ' WHERE Name LIKE \'%'+ searchKey +'%\'';    
            }
        }
        System.debug(searchQuery + searchOrder + searchLimit + 'test');
        products = Database.query(searchQuery + searchOrder + searchLimit); 
        List<ProductTable__c> productsNoLimit = Database.query(searchQuery + searchOrder); 
        productTableSize = productsNoLimit.size();
        return products;
    }
    
	public ProductTable__c getProduct() {
        if (product == null) {
            product = new ProductTable__c();
        }
        return product;
    }
        
    public void view() {
        isDisplaying = true;
    }
    
    public void del() {
        isDel = true;
    }
    
    public void cancelDel() {
        isDel = false;
    }
    
    public void search() {
        counter = 0;        
    }
    
    public void clear() {
        searchKey = null;
        getProducts();
    }
	
    public boolean checkIfDate(String stringIfDate) {
        String expression = '^([1-9]|1[012])/([1-9]|[12][0-9]|3[01])/(19|2[0-9])[0-9]{2}?$';
        boolean result;
        result = (Pattern.compile(expression).matcher(stringIfDate).find());
       	return result; 
    }
    
    public Date isDate(String stringDate) {
        Date searchDate;
        searchDate = Date.parse(stringDate);
        return searchDate;
    }    
    
    public String order
    {
    get
    {
    	return sortOrder;
    }
    set
    {
        if (value == sortOrder) {
        	sortOrderDirection = (sortOrderDirection == 'ASC')? 'DESC' : 'ASC';
        }
        else {
        	sortOrderDirection = 'ASC';
        }
        sortOrder = value;
	}
    }

 	public String getSortDirection(){
        if (order == null || order == '') {
      		return 'ASC';
        }
        else {
     		return sortOrderDirection;
        }
 	}

    public void setSortDirection(String value) {
		sortOrderDirection = value;
 	}

    public void sort() {
        getProducts();
    }
    
    public void first() { 
        counter = 0;
    }

    public void previous() { 
        counter = counter - pageSize;
    }

    public void next() { 
        counter = counter + pageSize;
    }

    public void last() { 
        counter = getProductTableSize() - math.mod(getProductTableSize(), pageSize);
    }
    
    public Boolean getDisablePrevious() { 
        if (counter > 0) {
            return false; 
        }
        else {
            return true;
        }
    }

    public Boolean getDisableNext() { 
        if (counter + pageSize < getProductTableSize()) {
            return false; 
        } 
        else {
            return true;
       }
    }

    public Integer getProductTableSize() {
        return productTableSize;
    }

    public Integer getPageNumber() {
		return (counter/pageSize + 1);
    }

    public Integer getTotalPages() {
       	if (math.mod(getProductTableSize(), pageSize) > 0) {
          	return getProductTableSize()/pageSize + 1;
       	} 
       	else {
          	return (getProductTableSize()/pageSize);
       	}
    }  
}