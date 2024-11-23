global class BatchClass1 implements database.batchable<Sobject>,database.stateful {
    
    integer i=0;
    
    global database.queryLocator start(database.batchableContext context){
    string query = 'select id from account';  
    return database.getQueryLocator(query);           
    }
    
    global void execute(database.batchableContext context, list<account> accounts){
        
        for(account acc:accounts){
            i++;
            
        }
        
    }
    
    global void finish(database.batchableContext context){
        system.debug(i);
    }
    
}

//BatchClass1 bt = new BatchClass1();
//database.executebatch(bt,200);