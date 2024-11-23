trigger CONIsPrimaryContact on Contact (After insert, After Update) {
    
    Map<Id,Id> AccCon = new Map<Id,Id>();
    List<Contact> ConList = new List<Contact>();
    
    for(Contact Con : Trigger.new){
    
        if(Con.AccountId!=NULL && Con.IsPrimaryContact__c){
              
                AccCon.put(Con.AccountId,Con.Id);
         }
    }
    
    for(Contact Con : [Select Id,IsPrimaryContact__c From Contact Where 
                       
                       Id NOT IN : AccCon.Values()
                AND AccountId IN : AccCon.KeySet()
                AND IsPrimaryContact__c=True]){
                          
                           Con.IsPrimaryContact__c=False;
                           ConList.add(Con);
    }
    
    update ConList;
    }