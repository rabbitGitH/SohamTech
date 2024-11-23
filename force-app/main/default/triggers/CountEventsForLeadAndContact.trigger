trigger CountEventsForLeadAndContact on event (after insert,after undelete,after delete){

   set<id>setid=new set<id>();
   List<Lead>leadupdate=new List<Lead>();
   List<contact>contactupdate=new List<contact>();
  
   if(trigger.isInsert  ||  trigger.isUndelete){
   
           for(event e : trigger.new){
                  if(e.whatid==null  &&  e.whoid.getSobjecttype().getDescribe().getName()=='Lead'){
                  setid.add(e.whoid);}
                  if(e.whatid==null  &&  e.whoid.getSobjecttype().getDescribe().getName()=='Contact'){
                  setid.add(e.whoid);}}
          
          for(Lead ld : [select id,TotalCountOfRelatedEvents__c,(select id from events)from lead where id in : setid]){
          Lead l = new lead ();
          l.TotalCountOfRelatedEvents__c = ld.events.size();
          l.id = ld.id;
          leadupdate.add(l);}
          
          for(Contact con : [select id,TotalCountOfRelatedEvents__c,(select id from events)from Contact where id in : setid]){
          Contact c = new Contact ();
          c.TotalCountOfRelatedEvents__c = con.events.size();
          c.id = con.id;
          contactupdate.add(c);}}
          
          if(trigger.isDelete){
   
           for(event e : trigger.old){
                  if(e.whatid==null  &&  e.whoid.getSobjecttype().getDescribe().getName()=='Lead'){
                  setid.add(e.whoid);}
                  if(e.whatid==null  &&  e.whoid.getSobjecttype().getDescribe().getName()=='Contact'){
                  setid.add(e.whoid);}}
          
          for(Lead ld : [select id,TotalCountOfRelatedEvents__c,(select id from events)from lead where id in : setid]){
          Lead l = new lead ();
          l.TotalCountOfRelatedEvents__c = ld.events.size();
          l.id = ld.id;
          leadupdate.add(l);}
          
          for(Contact con : [select id,TotalCountOfRelatedEvents__c,(select id from events)from Contact where id in : setid]){
          Contact c = new Contact ();
          c.TotalCountOfRelatedEvents__c = con.events.size();
          c.id = con.id;
          contactupdate.add(c);}}
          
          update leadupdate;
          update contactupdate;
          
          }