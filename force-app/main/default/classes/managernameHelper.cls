public class managernameHelper{

public static void  opportunityHelper(List<Opportunity> triggerNew , Map<Id,Opportunity> oppOldMap){
          Map<Id,String> opportunityMap = new Map<Id,String>();

          for(Opportunity opp: triggerNew){
               String managerEmail = opp.Owner.Manager.Email;
             if(opp.StageName == 'Closed Won' &&
managerEmail!=oppOldMap.get(opp.Id).Owner.Manager.Email){
                opportunityMap.put(opp.Id,managerEmail);
             }
          }

             if(opportunityMap.size()>0){
                 List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                 String body = 'won';
            for(Id oppId : opportunityMap.keySet()){
                string email = opportunityMap.get(oppId);

                Messaging.SingleEmailMessage mail = new
Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<string>{email});
                mail.setSubject('Automated email: Contact created');
                mail.setPlainTextBody(body);
                mails.add(mail);
            }
            if(mails.size() > 0){
                Messaging.sendEmail(mails);
            }
            }
     }
}