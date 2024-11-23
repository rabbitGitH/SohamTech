trigger Leadtrigger on Lead (before insert,after insert) {
    
  
    Set<String> emailSet = new Set<String>();
    for (Lead ld : trigger.new) {
        emailSet.add(ld.Email);
    }
    
    if(trigger.isAfter && trigger.isInsert) {
    Map<String, Lead> leadMap = new Map<String, Lead>();
    for (Lead l : [SELECT Id, Email, Download_White_Paper__c
                  FROM Lead WHERE Email IN :emailSet]) {
        leadMap.put(l.Email, l);
    }
     system.debug('leadMap'+leadMap);


    for (Lead newLead : Trigger.new) {
        if (leadMap.containsKey(newLead.Email)) {
            Lead existingLead = leadMap.get(newLead.Email);
            existingLead.Download_White_Paper__c = true;
            update existingLead;
            system.debug('existingLead'+existingLead);

           newLead.addError('A lead with the same email already exists. Fields have been updated on the existing lead.');
        }
    }

        if(trigger.isbefore && trigger.isInsert) {
            
            Map<String, Lead> leadMapp = new Map<String, Lead>();
            
    for (Lead l : [SELECT Id, Email, Download_White_Paper__c
                  FROM Lead WHERE Email IN :emailSet]) {
        leadMapp.put(l.Email, l);
    }
     system.debug('leadMap'+leadMapp);


    for (Lead newLead : Trigger.new) {
        if (leadMapp.containsKey(newLead.Email)) {
            Lead existingLead = leadMap.get(newLead.Email);
            existingLead.Download_White_Paper__c = true;

           newLead.addError('A lead with the same email already exists. Fields have been updated on the existing lead.');
        }
    }
            
        }
        
    }
}