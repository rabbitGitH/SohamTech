public with sharing class NpiController {

    public NpiController(ApexPages.StandardController controller) {

    }

    @AuraEnabled(cacheable=true)
    public static Lead getLeadByNpi(String npi) {
        return [SELECT First_Name__c FROM Lead WHERE NPI__c = :npi LIMIT 1];
    }

    @AuraEnabled
    public static void insertNpiRecord(String firstName ) {
        NPI__c npiRecord = new NPI__c(First_Name__c = firstName );
        insert npiRecord;
    }
}