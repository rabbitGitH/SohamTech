global class sendemail implements Database.Batchable < sobject > {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        String Query;
        Date dt = date.today().addDays(1);
        Query = 'SELECT Name,Id From Opportunity WHERE CloseDate =: dt ';
        return Database.getquerylocator(Query);

    }

    global void execute(Database.BatchableContext bc, List < Opportunity > opplist) {

        List < Messaging.SingleEmailMessage > emails = new List < Messaging.SingleEmailMessage > ();
        for (Opportunity opp: opplist) {

            // opp.CloseDate = 'createddate+1'; 

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new String[] {
                'nihar.annamaneni@gmail.com'
            });

            email.setSubject('opportunity closed date');

            email.setPlainTextBody('Dear user, Your opportunity '+opp.name+' closed date is tommorow');

            emails.add(email);

        }

        Messaging.sendEmail(emails);

        // update opplist;

    }

    global void finish(database.BatchableContext bc) {}
}