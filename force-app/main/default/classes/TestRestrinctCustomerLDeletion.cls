@isTest
public class TestRestrinctCustomerLDeletion{
@isTest static void ABCDE(){
customerl__c cus = new customerl__c();
cus.firstname__c='test';
insert cus;
invoicesl__C inv =new invoicesl__c();
inv.customerl__c=cus.id;
insert inv;
test.starttest();
Database.DeleteResult Result = Database.Delete(cus,false);
test.stoptest();
system.assert(!Result.isSuccess());
system.assert(Result.geterrors().size()>0);
system.assertEquals('Cannot delete customer with related invoices',Result.getErrors()[0].getMessage());
}}