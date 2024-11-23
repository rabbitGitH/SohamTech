global class MailToNewContact implements Database.Batchable<sObject>
{
    list<contact> IdContactMapBatch=new list<contact>();
    global MailToNewContact(List<contact> IdContactMap){
        IdContactMapBatch=IdContactMap;
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT id,firstname,email from contact where id in:IdContactMapBatch]);
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope) {     
        for(Contact con : scope)
        {    
           Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
               email.setToAddresses(new string[] {con.email});
               email.setSubject('Welcome Mail');
               email.setPlainTextBody('Welcome Your Contact Is Created Successfully In Salesforce');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    global void finish(Database.BatchableContext BC)
    {
    }
}