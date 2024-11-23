trigger CopyActivityDate on Task (after insert, after update) {
List<Task> ListOfTaskToUpsert = new List<Task>();
    list<Task> UpdatedTaskList =[SELECT id,ActivityDate FROM Task Where Id IN :Trigger.new];
    for (Task utl: UpdatedTaskList) {         
         boolean IsUpdateActivityDate = true;
          if (Trigger.isUpdate) {
            Task oldTask = Trigger.oldMap.get(utl.Id);
                if (oldTask.ActivityDate == utl.ActivityDate) {
                    IsUpdateActivityDate = false;}}
       
        if (IsUpdateActivityDate) {
           task t1 = new Task();
                t1.Id = utl.Id;
                t1.CopyOfActivityDate__c = utl.ActivityDate;
            ListOfTaskToUpsert.add(t1);}}
        
upsert  ListOfTaskToUpsert;

}