/*@RestResource(urlMapping='/myResource/{recordType}')
global without sharing class AccountContactRestResource {
    
    public interface Record {
        String getId();
        Datetime getLastModifiedDate();
    }
    
    public abstract class RecordImpl implements Record {
        public Datetime LastModifiedDate {get;set;}
    }
    
    public class AccountRecord extends RecordImpl {
        public Account Account {get;set;}
        public String getId() {
            return Account.Id;
        }
        public Datetime getLastModifiedDate() {
            return Account.LastModifiedDate;
        }
    }
    
    public class ContactRecord extends RecordImpl {
        public Contact Contact {get;set;}
        public String getId() {
            return Contact.Id;
        }
        public Datetime getLastModifiedDate() {
            return Contact.LastModifiedDate;
        }
    }
    
    public class AccountContactRelationRecord extends RecordImpl {
        public AccountContactRelation Relation {get;set;}
        public String getId() {
            return Relation.Id;
        }
        public Datetime getLastModifiedDate() {
            return Relation.LastModifiedDate;
        }
    }
     
    @HttpGet
    global static List<Record> getRecords() {
        RestRequest request = RestContext.request;
        String recordType = request.requestURI.substringAfterLast('/');
        Datetime lastModifiedDate = Datetime.newInstance(2023, 4, 16, 0, 0, 0);
        
        switch on recordType {
            when 'account' {
                List<AccountRecord> accountRecords = new List<AccountRecord>();
                for (Account account : [SELECT Id, Name, BillingCity, LastModifiedDate FROM Account WHERE LastModifiedDate >= :lastModifiedDate]) {
                    AccountRecord accountRecord = new AccountRecord();
                    accountRecord.Account = account;
                    accountRecords.add(accountRecord);
                }
                return accountRecords;
            }
            when 'contact' {
                List<ContactRecord> contactRecords = new List<ContactRecord>();
                for (Contact contact : [SELECT Id, FirstName, LastName, Email, LastModifiedDate FROM Contact WHERE LastModifiedDate >= :lastModifiedDate]) {
                    ContactRecord contactRecord = new ContactRecord();
                    contactRecord.Contact = contact;
                    contactRecords.add(contactRecord);
                }
                return contactRecords;
            }
             when 'accountcontactrelation' {
                List<AccountContactRelationRecord> relationRecords = new List<AccountContactRelationRecord>();
                for (AccountContactRelation relation : [SELECT Id, AccountId, ContactId, LastModifiedDate FROM AccountContactRelation WHERE LastModifiedDate >= :lastModifiedDate]) {
                    AccountContactRelationRecord relationRecord = new AccountContactRelationRecord();
                    relationRecord.Relation = relation;
                    relationRecords.add(relationRecord);
                }
                return relationRecords;
            } 
            when else {
                throw new RestException('Invalid record type: ' + recordType);
            }
        }
    }
}

*/


@RestResource(urlMapping='/myResource/*')
global without sharing class AccountContactRestResource {
    
    
    @HttpGet
    global static List<sObject> getRecords() {
        RestRequest request = RestContext.request;
       String recordType = request.requestURI.substringAfterLast('/');
        
        system.debug('recordType'+recordType);
        
        Datetime lastModifiedDate = Datetime.newInstance(2023, 4, 16, 0, 0, 0);
        List<sObject> sList =  new List<sObject>();
        switch on recordType {
            when 'account' {
                List<Account> accountRecords = new List<Account>();
                for (Account acc : [SELECT Id, Name, BillingCity, LastModifiedDate FROM Account WHERE LastModifiedDate >= :lastModifiedDate]) {
                    account accountRecord = new account();
                    accountRecord = acc;
                    sList.add(accountRecord);
                }
             //   return (List<Account>) accountRecords;
            }
            when 'contact' {
                List<Contact> contactRecords = new List<Contact>();
                for (Contact con : [SELECT Id, FirstName, LastName, Email, LastModifiedDate FROM Contact WHERE LastModifiedDate >= :lastModifiedDate]) {
                    Contact contactRecord = new Contact();
                    contactRecord = con;
                    sList.add(contactRecord);
                }
              //  return (List<contact>) contactRecords;
            }
            when 'AccountContactRelation' {
                List<AccountContactRelation> accContactRecords = new List<AccountContactRelation>();
                for (AccountContactRelation accCon : [SELECT Id,Contact.Name, Account.Name FROM AccountContactRelation WHERE LastModifiedDate >= :lastModifiedDate]) {
                    AccountContactRelation accountContactRecord = new AccountContactRelation();
                    accountContactRecord = accCon;
                    accContactRecords.add(accCon);
                }
                return (List<AccountContactRelation>) accContactRecords;
            }
            when else {
                system.debug('Invalid record type: '  );
            }
        }
        
        return sList;
    }
}