/*
   # BLUVIUM Assignment 
   # Created Date: Apr 13 2022
   # Purpose : 1) inserted contacts needs to link with account by matching email id
               2) if inserted contact is Primary contact (checkbox is checked) then previous Primary contact needs to uncheck.
 
trigger trg_contact on Contact (before insert,after insert)
{   
    if(trigger.isbefore && trigger.isInsert)
    {
       ContactHelper.linkContact(trigger.new);
        // uncheckedPreviousPrimaryContact.unchecked(trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert)
    {
    }
}*/

trigger trg_contact on Contact (before insert) {
    String emailValues;
    for (Contact contact : Trigger.new) {
        emailValues = contact.email;
    }

    // Prepare the flow input variables
    Map<String, string> flowInputs = new Map<String, string>();
    flowInputs.put('rrr', emailValues);

    // Invoke the flow
    Flow.Interview.create_con_Record myFlow = new Flow.Interview.create_con_Record(flowInputs);
    myFlow.start();

    // Optionally, you can retrieve the flow output values
    // Map<String, Object> flowOutputs = myFlow.getOutputs();

    // Handle any post-flow processing or additional logic here
}