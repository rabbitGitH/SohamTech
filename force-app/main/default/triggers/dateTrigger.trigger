trigger dateTrigger on Customer__c (before update) {

for(Customer__c cus : trigger.new)
{

        Customer__c newCus = cus;
        Customer__c oldCus = trigger.oldmap.get(cus.id);

         map<string,testMetadata__mdt> mdt = new map<string,testMetadata__mdt>{};
         
         for(testMetadata__mdt md: [select Label,firstField__c,firstValue__c,secondField__c,secondValue__c,Information__c from testMetadata__mdt])
         {
            mdt.put(md.label,md);
         } 

        if (newCus.FirstName__c == 'Approved' && oldCus.LastName__c == 'Intel')
        {
            if (
                 oldCus.get(mdt.get('cond01').secondField__c) != mdt.get('cond01').firstValue__c && 
                 newCus.get(mdt.get('cond01').secondField__c) == mdt.get('cond01').firstValue__c)
                {                   
                       
                    newCus.Information__c = 'correct'; 
                }
        } 


}
}