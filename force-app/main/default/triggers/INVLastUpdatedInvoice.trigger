trigger INVLastUpdatedInvoice on invoices__c (before insert,before update){

    Map<Id,Id> cusinv = new Map<Id,Id>();
    List<Invoices__c> invlist = new List<Invoices__c>();
    for(Invoices__c inv:Trigger.new)
    {
        if( inv.customer__c!=NULL  && Trigger.isInsert || Trigger.isUpdate && inv.LastUpdatedInvoice__c &&
          !Trigger.oldmap.get(inv.Id).LastUpdatedInvoice__c)
        {
          cusinv.put(inv.customer__c,inv.id);
        }
    }
    for(Invoices__c inv:[select id,LastUpdatedInvoice__c from Invoices__c where customer__c in:cusinv.keyset()
                        AND id NOT in:cusinv.values()
                        AND LastUpdatedInvoice__c =true])
    {
        inv.LastUpdatedInvoice__c=false;
        invlist.add(inv);
    }
    if(!invlist.isEmpty())
    {
        update invlist;
    }

}