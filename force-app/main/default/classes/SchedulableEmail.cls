global class SchedulableEmail Implements Schedulable
            {
                        global void execute(SchedulableContext sc)
                        {
                                    sendmail();
                        }
 
                        public void sendmail()
                        {// Please add your logic according to requirement
                                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                                    string [] toaddress= New string[]{'ptlhrsl@gmail.com'};
                                    email.setSubject('Subject: SchedulableEmail');
                                    email.setPlainTextBody('Body: SchedulableEmail');
                                    email.setToAddresses(toaddress);
                                    Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
                        }
            }