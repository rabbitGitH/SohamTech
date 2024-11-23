trigger productTrg on Product2 (before insert,before update,after delete) {
 
 /*   
    if(trigger.isInsert){
        productHelper.insertRecords(trigger.new);
    }
    
    if(trigger.isUpdate){
        productHelper.updateRecords(trigger.new);
    }
    
    if(trigger.isDelete){
        productHelper.deleteRecords(trigger.old);
    }
    
    
    */
}
    
    
    
    
    
    
    
    
    
    /*
    if(trigger.isInsert){
    list<product__c> pp = new  list<product__c>();
    Product2 p2;
    for(Product2 p : trigger.new){
     //   p2 = p;
        
    product__c pc    = new product__c();
    pc.name          = p.name ;
    pc.Product2Id__C = p.id;
    pp.add(pc);  
    
    }
     
    
    insert pp;
          
			Group flex = [Select Id from Group where type='Queue' and Name='Flex queue'];
			
			List<GroupMember> flexMembers = [Select UserOrGroupId From GroupMember where GroupId =:flex.id];	
        
        list<string> flexMembersIds = new list<string>() ;
        
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
    
    if(trigger.isUpdate){
        
    Map<id,Product2>mapP2 = new Map<id,Product2>();
    for(Product2 p : trigger.new){
        mapP2.put(p.id,p);
    }
    List<product__c> updateProductC;
    List<product__c> pc = [select id,Product2Id__C,name from product__c where Product2Id__C in:mapP2.keyset()];
 
        if(pc.size()>0){
            
        for(product__c pq : pc){
            pq.name = mapP2.get(pq.Product2Id__C).name;
            updateProductC.add(pq);
   }
     
        update updateProductC;
       
        }
    
}
    
    if(trigger.isDelete){
        
        set<id> pId = new  set<id>();
        for(Product2 p:trigger.old){
            pId.add(p.id);
        }
        
        List<product__c> deleteCP = new  List<product__c>();
        for(product__c p : [select id from product__c where Product2Id__C in: pId ]){
            deleteCP.add(p);
        }
        delete deleteCP;
        
    }
    
}*/