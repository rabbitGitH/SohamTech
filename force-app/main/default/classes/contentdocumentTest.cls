@isTest
public class contentdocumentTest{

public Static contentVersion contentVersion_1{get;set;}
public Static Customer__c dt {get;set;}

 @isTest
 public static void setupData() {
 
 Customer__c dt = new Customer__c();
 insert dt;
 
 }
public  static void methodOne() {
 
 contentVersion_1 = new ContentVersion();
 contentVersion_1.Title = 'Penguins';
 contentVersion_1.FirstPublishLocationId = dt.id;
 contentVersion_1.PathOnClient = 'Penguins.jpg';
 contentVersion_1.VersionData = Blob.valueOf('Test Content');
 contentVersion_1.IsMajorVersion = true;
 
 } 
 
 public static void methodTwo() {

 Test.StartTest(); 
 { 
 insert contentVersion_1;
 }
 Test.StopTest();
 
 }
 }