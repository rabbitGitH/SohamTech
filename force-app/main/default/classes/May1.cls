global class May1 implements Schedulable {
    global void execute(SchedulableContext sc) {
        try {
            System.debug('May1 class: Starting execution...');
            // Get all accounts that have recurring orders
            Date currentDate = Date.today();
           // Date currentDate = Date.newInstance(2023, 5, 2);

            map<string,date> nextDate = new map<string,date>();
            List<order> orders = new List<order>();
            List<Account> accts = new List<Account>();
            List<Account> accounts = [SELECT Id, 
                                             Recurring_Order_Quantity__c, 
                                             Recurring_Order_Frequency__c, 
                                             Recurring_Order_Start_Date__c, 
                                             next_Recurring_Order_Start_Date__c
                                        FROM Account 
                                       WHERE Recurring_Order_Quantity__c != null AND 
                                             Recurring_Order_Frequency__c != null AND
                                            (Recurring_Order_Start_Date__c =: currentDate OR
                                             next_Recurring_Order_Start_Date__c =: currentDate)];

            System.debug('May1 class: Found ' + accounts.size() + ' accounts with recurring orders.');

            // Loop through each account and generate recurring orders if needed
            
            if(accounts.size()>0){
                
                for (Account acct : accounts) {
                    
                  if(acct.next_Recurring_Order_Start_Date__c != null && acct.next_Recurring_Order_Start_Date__c == currentDate ||
                     acct.next_Recurring_Order_Start_Date__c == null && acct.Recurring_Order_Start_Date__c == currentDate){
                         
                         accts.add(acct);
                     }
                }
            }

            if(accts.size()>0){
                for (Account acct : accts) {
                    Date nextRecurringDate = acct.next_Recurring_Order_Start_Date__c != null ? 
                                             acct.next_Recurring_Order_Start_Date__c : acct.Recurring_Order_Start_Date__c;   

                    String orderFrequency = acct.Recurring_Order_Frequency__c;

                    nextRecurringDate = calculateNextRecurringDate(nextRecurringDate, orderFrequency);

                    nextDate.put(acct.id,nextRecurringDate);

                    Order newOrder = new Order();
                    newOrder.AccountId = acct.Id;
                    newOrder.Quantity__c = acct.Recurring_Order_Quantity__c;
                    newOrder.EffectiveDate = currentDate;
                    newOrder.status = 'Draft';
                    newOrder.type = 'New - Auto Generated';
                    orders.add(newOrder);     
                }

                System.debug('May1 class: Generated ' + orders.size() + ' new orders.');

                if(orders.size()>0){
                    insert orders;  
                }

                for (Account acct : accts) {
                    acct.next_Recurring_Order_Start_Date__c = nextDate.get(acct.id);
                }
                update accts;

                System.debug('May1 class: Updated ' + accts.size() + ' accounts with next recurring order start dates.');
            }

        } catch (Exception e) {
            System.debug('May1 class: Error occurred: ' + e.getMessage());
        } finally {
            System.debug('May1 class: Finished execution.');
        }
    }

    private Date calculateNextRecurringDate(Date currDate, String frequency) {
        if (frequency == 'Weekly') {
            return currDate.addDays(7);
        } else if (frequency == 'Biweekly') {
            return currDate.addDays(14);
        } else if (frequency == 'Monthly') {
            return currDate.addMonths(1);
        } else if (frequency == 'Bimonthly') {
            return currDate.addMonths(2);
        } else if (frequency == 'Quarterly') {
            return currDate.addMonths(3);
        } else {
            return currDate;
        }
    }
}





/*global class May1 implements Schedulable {
global void execute(SchedulableContext sc) {
    try {
        // Get all accounts that have recurring orders
       Date currentDate = Date.today();
       map<string,date> nextDate = new map<string,date>();
       List<order> orders = new List<order>();
       List<Account> accounts = [SELECT Id, 
                                        Recurring_Order_Quantity__c, 
                                        Recurring_Order_Frequency__c, 
                                        Recurring_Order_Start_Date__c, 
                                        next_Recurring_Order_Start_Date__c
                                   FROM Account 
                                  WHERE Recurring_Order_Quantity__c != null AND 
                                        Recurring_Order_Frequency__c != null AND
                                        Recurring_Order_Start_Date__c != null AND
                                       (Recurring_Order_Start_Date__c =: currentDate OR
                                        next_Recurring_Order_Start_Date__c =: currentDate)];


        // Loop through each account and generate recurring orders if needed
        if(accounts.size()>0){
            for (Account acct : accounts) {
                Date nextRecurringDate = acct.next_Recurring_Order_Start_Date__c != null ? 
                                         acct.next_Recurring_Order_Start_Date__c : acct.Recurring_Order_Start_Date__c;   

                String orderFrequency = acct.Recurring_Order_Frequency__c;

                nextRecurringDate = calculateNextRecurringDate(nextRecurringDate, orderFrequency);
                
                nextDate.put(acct.id,nextRecurringDate);

                Order newOrder = new Order();
                newOrder.AccountId = acct.Id;
                newOrder.Quantity__c = acct.Recurring_Order_Quantity__c;
                newOrder.EffectiveDate = currentDate;
                newOrder.status = 'draft';
                orders.add(newOrder);     
            }
        
             if(orders.size()>0){
                insert orders;  
             }
        
             for (Account acct : accounts) {
                  acct.next_Recurring_Order_Start_Date__c = nextDate.get(acct.id);
             }
                  update accounts;
        }
        
        
    } catch (Exception e) {
        System.debug('Error occurred: ' + e.getMessage());
    }
}

    private Date calculateNextRecurringDate(Date currDate, String frequency) {
        if (frequency == 'Weekly') {
            return currDate.addDays(7);
        } else if (frequency == 'Biweekly') {
            return currDate.addDays(14);
        } else if (frequency == 'Monthly') {
            return currDate.addMonths(1);
        } else if (frequency == 'Bimonthly') {
            return currDate.addMonths(2);
        } else if (frequency == 'Quarterly') {
            return currDate.addMonths(3);
        } else {
            return currDate;
        }
    }
}*/