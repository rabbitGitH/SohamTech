trigger CountFemaleContacts on Contact (after insert, after update, after delete) {
  List<Contact> contactsInTrigger;
  if (Trigger.isDelete) {
    contactsInTrigger = Trigger.old;
  } else {
    contactsInTrigger = Trigger.new;
  }
  for (Contact c : contactsInTrigger) {

    List<Account> accounts = 
        [SELECT Id, Name, NumberofFemales__c, 
          (SELECT Id FROM Contacts WHERE Sex__c = 'Female') 
          FROM Account];
    for (Account a : accounts) {
      List<Contact> femaleContacts = a.Contacts;
      if (femaleContacts != null) {
        a.NumberofFemales__c = femaleContacts.size();
      }
      update a;
    }

  }
}