@RestResource(urlMapping='/V1/BookDetails/')

global class BookManager
{
    @httpGet
    global static Book__c bookDetail()
    {
        Map<string,string> Parameter = Restcontext.request.params;
        
        string bookId = Parameter.get('id');
        
        Book__c book = new Book__c();
        
        book = [select id,Name,Price__c from Book__c where id =: bookId];
        
        return book;
        
    }
    
    @httpDelete
    global static string deleteBook()
    {
        Map<string,string> Parameter = Restcontext.request.params;
        
        string bookId = Parameter.get('id');
        
        Book__c book = new Book__c();
        
        book = [select id,Name,Price__c from Book__c where id =: bookId];
        
        delete book;
        
        return 'Book Deletion Succeed !';
        
    }
    
 /*  @httpPost
    global static Book__c insertBook(string Name)
    {
         Book__c book = new Book__c ();
         book.Name = Name;
         insert book;
         return book;
               
    }  */
    
     global class BookInfo 
    {
        Book__c book {get;set;}
    }
    
    @httpPost
    global static Book__c insertBook(BookInfo bkInfo)
    {
        Book__c book = bkInfo.book;
         insert book;
         return book;
    }
    
   //{ "BookInfo" : { "Book" : { "Name" : "FROM WRAPPER CLASS" } } } 
    
    @httpPut
    global static Book__c updateBook(string Name)
    {
         Map<string,string> parameter = RestContext.request.params;
        
         string bookId = parameter.get('id');
        
         Book__c book = new Book__c ();
         book.Name = Name;
         book.id   = bookId;
         update book;
         return book;
               
    }
    
    
    
    /*For updateBook Method we need to pass Name paramer like below
* {
*    "Name" : "BHAGVATGITA";
* }
    */
}