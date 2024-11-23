global class AccountOrderScheduler implements Schedulable {
    
    private Id accountId;
    
    global AccountOrderScheduler() {
        this.accountId = null;
    }
    
    global AccountOrderScheduler(Id accountId) {
        this.accountId = accountId;
    }
    
    global void execute(SchedulableContext sc) {
         date nextOrderDate ;
        // Get accounts with recurring orders
        List<Account> accounts;
        
        list<order> deleteOrders = new list<order>();
        set<string> deleteJobs = new set<string>();
        
        
        if (accountId != null) {
            accounts = [SELECT Id, Recurring_Order_Quantity__c, Recurring_Order_Frequency__c, Recurring_Order_Start_Date__c,
                       (SELECT Id,IsApproved__c,scheduled_Job__c,EffectiveDate FROM orders) FROM Account 
                        WHERE Id = :accountId AND Recurring_Order_Quantity__c != null AND Recurring_Order_Frequency__c != null AND Recurring_Order_Start_Date__c != null];
     
        for(account acc : accounts){    
             nextOrderDate = calculateNextOrderDate(acc.Recurring_Order_Frequency__c, acc.Recurring_Order_Start_Date__c);
            if(acc.Orders.size()>0){                
               for(order ord:acc.orders){
                   if(ord.scheduled_Job__c != null && ord.scheduled_Job__c == String.valueOf('OrderCreationJob'+'_'+ord.id) && ord.IsApproved__c == false){
                       deleteOrders.add(ord);
                       deleteJobs.add(ord.scheduled_Job__c);
                   }
               }
            }
        }
        }
                    
            
            if(deleteOrders.size()>0){
                             
                        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name 
                                                           FROM CronTrigger 
                                                           WHERE CronJobDetail.Name =:deleteJobs];
                                  
                                   for (CronTrigger job : scheduledJobs) {
                                        System.abortJob(job.Id);
                                   }                                           
                   }
        
        delete deleteOrders ;
 
             for(account acc : accounts){   
            
            if(acc.Orders.size()>0){                
               for(order ord:acc.orders){
                   if(ord.scheduled_Job__c != null && ord.scheduled_Job__c == String.valueOf('OrderCreationJob'+'_'+ord.id)){
                       nextOrderDate = calculateNextOrderDate(ord.account.Recurring_Order_Frequency__c, ord.EffectiveDate);
                   }
               }
            }
                else{
                       nextOrderDate = calculateNextOrderDate(acc.Recurring_Order_Frequency__c, acc.Recurring_Order_Start_Date__c);
                }
        }
        
        
   
        string orderId;
        String jobName = 'OrderCreationJob';
        String jobNameWithId; 
        // Create and schedule orders for each account
        for (Account acc : accounts) {
            
            // Calculate the next order date based on the frequency and start date
           //  Date nextOrderDate = calculateNextOrderDate(acc.Recurring_Order_Frequency__c, acc.Recurring_Order_Start_Date__c);
            // Create the order
            Order newOrder = new Order();
            newOrder.AccountId = acc.Id;
            newOrder.Quantity__c = acc.Recurring_Order_Quantity__c;
            newOrder.EffectiveDate = nextOrderDate;
            
          
            newOrder.status = 'draft';
            insert newOrder;          
            
            orderId = String.valueOf(newOrder.id);
            jobNameWithId = jobName + '_' + orderId;
            
            newOrder.Scheduled_Job__c = jobNameWithId;
            update newOrder;
            
            // Schedule the order to be re-created on the next order date
            createScheduledJob(nextOrderDate, newOrder.Id, jobNameWithId);
        }
    }
    
    // Helper method to calculate the next order date
    private Date calculateNextOrderDate(String frequency, Date startDate) {
        
        Date nextOrderDate;
        
        if (frequency == 'Weekly') {
            nextOrderDate = startDate.addDays(7);
        } else if (frequency == 'Monthly') {
            nextOrderDate = startDate.addMonths(1);
        } else if (frequency == 'Quarterly') {
            nextOrderDate = startDate.addMonths(3);
        } else {
            nextOrderDate = startDate.addYears(1);
        }
        
        return nextOrderDate;
    }
    
    // Helper method to create a scheduled job to re-create the order on the next order date
    private void createScheduledJob(Date nextOrderDate, Id orderId, string EffectiveDate) {
        
        String cronExp = '0 0 0 ' + nextOrderDate.day() + ' ' + nextOrderDate.month() + ' ? ' + nextOrderDate.year();
        
        if (accountId != null) {
            System.schedule(EffectiveDate + orderId, cronExp, new AccountOrderScheduler(accountId));
        } else {
            System.schedule('Order Creation Job ' + orderId, cronExp, new AccountOrderScheduler());
        }
    }
    
}








/////////////////////////////////////////////





 


/*global class RecurringOrdersScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Get all accounts with non-null values for the recurring order fields
        List<Account> accounts = [SELECT Id, Recurring_Order_Quantity__c, Recurring_Order_Frequency__c, Recurring_Order_Start_Date__c FROM Account WHERE Recurring_Order_Quantity__c != null AND Recurring_Order_Frequency__c != null AND Recurring_Order_Start_Date__c != null];
        
        // Loop through each account and create the scheduled orders
        for (Account acct : accounts) {
            Decimal quantity = acct.Recurring_Order_Quantity__c;
            String frequency = acct.Recurring_Order_Frequency__c;
            Date startDate = acct.Recurring_Order_Start_Date__c;
            
            // Calculate the interval between orders based on the frequency field
            Integer interval = 0;
            if (frequency == 'Daily') {
                interval = 1;
            } else if (frequency == 'Weekly') {
                interval = 7;
            } else if (frequency == 'Monthly') {
                interval = 30;
            }
            
            // Calculate the next order date based on the start date and frequency
            Date nextOrderDate = startDate.addDays(interval);
            
            // Create the order and schedule it for the next order date
            Order order = new Order();
            order.AccountId = acct.Id;
            order.Quantity__c = quantity;
            order.EffectiveDate = nextOrderDate;
            insert order;
            
            // Schedule the next order
            System.schedule('Recurring Order for Account ' + acct.Id, '0 0 0 ' + String.valueOf(nextOrderDate.day()) + ' ' + String.valueOf(nextOrderDate.month()) + ' ?', new RecurringOrdersScheduler());
        }
    }
    
    public static void rescheduleOrders() {
        // Delete all existing scheduled orders
        List<CronTrigger> existingTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'RecurringOrdersScheduler'];
      
      
    for(CronTrigger ct : existingTriggers) {
         System.abortJob(ct.id);
    }
 
    // Schedule new orders to run immediately
    RecurringOrdersScheduler scheduler = new RecurringOrdersScheduler();
    ID jobId = System.enqueueJob(scheduler);
    
         
        // Schedule new orders
       // System.schedule('Recurring Orders', '0 0 0 * * ?', new RecurringOrdersScheduler());
    }
}
 


////////////////////////////////////////////////////////////////////
 


global class AccountOrderScheduler implements Schedulable {
    
    private Id accountId;
    
    global AccountOrderScheduler() {
        this.accountId = null;
    }
    
    global AccountOrderScheduler(Id accountId) {
        this.accountId = accountId;
    }
    
    global void execute(SchedulableContext sc) {
        
        // Get accounts with recurring orders
        List<Account> accounts;
        
        if (accountId != null) {
            accounts = [SELECT Id, Recurring_Order_Quantity__c, Recurring_Order_Frequency__c, Recurring_Order_Start_Date__c,
                       (SELECT Id,scheduled_Job__c,EffectiveDate FROM orders) FROM Account 
                        WHERE Id = :accountId AND Recurring_Order_Quantity__c != null AND Recurring_Order_Frequency__c != null AND Recurring_Order_Start_Date__c != null];
        } 
        
        Date nextOrderDate; 
        
        for(account acc : accounts){   
            
            if(acc.Orders.size()>0){                
               for(order ord:acc.orders){
                   if(ord.scheduled_Job__c != null && ord.scheduled_Job__c == String.valueOf('OrderCreationJob'+'_'+ord.id)){
                       nextOrderDate = calculateNextOrderDate(ord.account.Recurring_Order_Frequency__c, ord.EffectiveDate);
                   }
               }
            }
                else{
                       nextOrderDate = calculateNextOrderDate(acc.Recurring_Order_Frequency__c, acc.Recurring_Order_Start_Date__c);
                }
        }
        
   
        string orderId;
        String jobName = 'OrderCreationJob';
        String jobNameWithId; 
        // Create and schedule orders for each account
        for (Account acc : accounts) {
            
            // Calculate the next order date based on the frequency and start date
           //  Date nextOrderDate = calculateNextOrderDate(acc.Recurring_Order_Frequency__c, acc.Recurring_Order_Start_Date__c);
            // Create the order
            Order newOrder = new Order();
            newOrder.AccountId = acc.Id;
            newOrder.Quantity__c = acc.Recurring_Order_Quantity__c;
            newOrder.EffectiveDate = nextOrderDate;
            
          
            newOrder.status = 'draft';
            insert newOrder;          
            
            orderId = String.valueOf(newOrder.id);
            jobNameWithId = jobName + '_' + orderId;
            
            newOrder.Scheduled_Job__c = jobNameWithId;
            update newOrder;
            
            // Schedule the order to be re-created on the next order date
            createScheduledJob(nextOrderDate, newOrder.Id, jobNameWithId);
        }
    }
    
    // Helper method to calculate the next order date
    private Date calculateNextOrderDate(String frequency, Date startDate) {
        
        Date nextOrderDate;
        
        if (frequency == 'Weekly') {
            nextOrderDate = startDate.addDays(7);
        } else if (frequency == 'Monthly') {
            nextOrderDate = startDate.addMonths(1);
        } else if (frequency == 'Quarterly') {
            nextOrderDate = startDate.addMonths(3);
        } else {
            nextOrderDate = startDate.addYears(1);
        }
        
        return nextOrderDate;
    }
    
    // Helper method to create a scheduled job to re-create the order on the next order date
    private void createScheduledJob(Date nextOrderDate, Id orderId, string EffectiveDate) {
        
        String cronExp = '0 0 0 ' + nextOrderDate.day() + ' ' + nextOrderDate.month() + ' ? ' + nextOrderDate.year();
        
        if (accountId != null) {
            System.schedule(EffectiveDate + orderId, cronExp, new AccountOrderScheduler(accountId));
        } else {
            System.schedule('Order Creation Job ' + orderId, cronExp, new AccountOrderScheduler());
        }
    }
    
}

*/