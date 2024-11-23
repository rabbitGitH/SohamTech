trigger ContactTrigger on Contact (before insert, before update,before delete,after insert, after update, after delete,after undelete) {
 
    // if mailing addess is not null the populate it in the other add
     //if contact phone is blank then throw error
/*    
    if(trigger.isBefore && trigger.isInsert){
        
        for(contact con : trigger.new){
            
            if(con.Phone == null){
                con.adderror('Phone no is required');
            }
            
            if(con.MailingCity != null && con.OtherCity == null){
                
                con.OtherCity = con.MailingCity;
                
            }
        }                    
    }
    
    if(trigger.isBefore && trigger.isDelete){
        
        for(contact con:trigger.old){
            if(con.lastname == 'Admin Record'){
                con.adderror('No one can delete this record');
            }
        }
    }
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isDelete || trigger.isUndelete)){
       
         list<account> accounts = new list<account>();
        
        if(trigger.isAfter && trigger.isInsert){
             set<id> accIds = new set<id>();
            for(contact con : trigger.new){
                
                if(con.AccountId != null){
                accIds.add(con.accountid);
                }
            }
            
           
            if(accIds!= null){
                for(account acc:[select id,contacts_size__c,(select id,Description from contacts)from account where id in:accIds]){
                   acc.contacts_size__c = 'contact size  :'+acc.contacts.size();
                    accounts.add(acc);
                }
            }
        }
        
        if(trigger.isAfter && trigger.isDelete){
             set<id> accIds = new set<id>();
            for(contact con : trigger.old){
                   if(con.AccountId != null){
               			 accIds.add(con.accountid);
                   }
            }
            
               
            if(accIds!= null){
                for(account acc:[select id,contacts_size__c,(select id,Description from contacts)from account where id in:accIds]){
                   acc.contacts_size__c = 'contact size  :'+acc.contacts.size();
                    accounts.add(acc);
                }
            }
        }
        
            if(trigger.isAfter && trigger.isUnDelete){
             set<id> accIds = new set<id>();
            for(contact con : trigger.new){
                   if(con.AccountId != null){
               			 accIds.add(con.accountid);
                   }
            }
            
               
            if(accIds!= null){
                for(account acc:[select id,contacts_size__c,(select id,Description from contacts)from account where id in:accIds]){
                   acc.contacts_size__c = 'contact size  :'+acc.contacts.size();
                    accounts.add(acc);
                }
            }
        }
        
        
        if(accounts.size()!= null) {
             update accounts;
        }*/
    
    
    if(trigger.isAfter && trigger.isUpdate){
        
      
    
    String triggerName='Contact_sync_trg';
         System.debug('triggerName'+triggerName);
    Individual_Trigger_Switch__c contactTriggerSwitch = Individual_Trigger_Switch__c.getValues(triggerName);       // custom setting - false 
    Trigger_Switch__c cs = Trigger_Switch__c.getInstance();
    
        if(contactTriggerSwitch != null && !contactTriggerSwitch.InActive__c && 
               !(cs.TriggerDisabled__c)) {
            System.debug('heyyy Contact trigger');
          
        }
 
        
       
        
        list<account> acclist = new list<account>();
        map<id,contact> accountIdContact = new map<id,contact>(); 
       // list<contact> contacts = new <contact>();
        set<id> accIds = new set<id>();
        //if contact desc is updated then update it all child and parent
        for(contact con:trigger.new){
            accountIdContact.put(con.accountid,con);
            
            if(con.Description != trigger.oldmap.get(con.id).description){
                accIds.add(con.accountid);
            }
        }
        List<contact> contacts = new list<contact>();
        if(!accIds.isEmpty()){
            
            for(account acc:[select id,description,(select id,accountId,description from contacts)from account where id in:accIds]){
                
                acc.Description = accountIdContact.get(acc.id).description;
                acclist.add(acc);
                
                if(acc.contacts.size()>0){
                
                for(contact con:acc.contacts){
                    if(con.id != accountIdContact.get(acc.id).id){
                        contacts.add(con);
                    }
                    
                }
                }
            }
        }
            for(contact con:contacts){
                con.Description = accountIdContact.get(con.AccountId).description;
            }
            
        update contacts;
        update accList;
    }
                          
     
 
    }