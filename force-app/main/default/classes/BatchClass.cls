global class BatchClass implements database.batchable<Sobject>, database.stateful{
    
    integer i = 0;

    global database.queryLocator start(database.batchableContext context){
    string query = 'SELECT id FROM Account';
    return database.getQueryLocator(query);
    }
    
    global void execute(database.batchableContext context, List<account> accounts){
        
        for(account acc: accounts){
            i++;
        }
        
    }
    
    global void finish(database.batchableContext context){
        
        system.debug('Count'+i);
    }
    
    
    
}