public class ProductHelper {

    
    public static void insertRecords(List<Product2> p2List){
    
    // if(trigger.isInsert){
    list<product__c> pp = new  list<product__c>();
    Product2 p2;
    for(Product2 p : p2List)
    {          
        product__c pc    = new product__c();
        pc.name          = p.name ;
        pc.Product2Id__C = p.id;
        pp.add(pc);     
    }
     
  
    insert pp;
          
			Group flex = [Select Id from Group where type='Queue' and Name='Flex queue'];
			
			List<GroupMember> flexMembers = [Select UserOrGroupId From GroupMember where GroupId =:flex.id];	
        
          list<string> flexMembersIds = new list<string>() ;
    //    list<string> flexMembersIds = new list<string> {'patil.harshal12345@gmail.com','ptlhrsl@gmail.com','cpqsuperbadge111@gmail.com'};
               list<string> testString;
        system.debug('testString'+testString);
        if(flexMembers.size()>0){           
        for(GroupMember gm : flexMembers){
            flexMembersIds.add(gm.UserOrGroupId);}}
        
           
        if(flexMembersIds.size()>0){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.Subject =  'Subject';
            mail.ToAddresses = flexMembersIds; 
            mail.setSaveAsActivity(false);
            mail.Plaintextbody =  ' task has been skipped for you because the corresponding status field indicates that you have already performed the support action.  Please revisit the Opportunity if any additional business actions are necessary.  Also, please reach out to your regional Sales Operations Analyst if you have any questions.\n\n' +
                'Thank you,\n' + 'Sales Operations Team';
    

            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);      
        
        }
        
        
    } 
        
    
    public static void updateRecords(List<Product2>p2List){
  //  if(trigger.isUpdate){
        
    Map<id,Product2>mapP2 = new Map<id,Product2>();
    for(Product2 p : p2List){
        mapP2.put(p.id,p);
    }
    List<product__c> updateProductC;
    list<product__c> prodList = crudOperation(mapP2.keyset());
        
        if(prodList.size()>0){
      
        for(product__c pq : prodList){
            pq.name = mapP2.get(pq.Product2Id__C).name;
            updateProductC.add(pq);}
        }
     
        update updateProductC;
       
   }
    
 
    
    public static void deleteRecords(List<Product2>oldP2){
  //  if(trigger.isDelete){
        
        set<id> pIds = new  set<id>();
        for(Product2 p:oldP2){
            pIds.add(p.id);
        }
        
        List<product__c> deleteCP = new  List<product__c>();
        list<product__c> prodList = crudOperation(pIds);
        
        if(prodList.size()>0){
        for(product__c p : prodList ){
            deleteCP.add(p);
        }}
        delete deleteCP;
        
    }
    
    
    public static list<product__c> crudOperation(set<id>p2Ids){
        List<product__c> matchingRecords;
        if(p2Ids.size()>0){
        matchingRecords = [select id,Product2Id__C,name from product__c where Product2Id__C in:p2Ids];
        }    
        
              return matchingRecords;
    }
    
  
    
}