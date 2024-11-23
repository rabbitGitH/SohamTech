public class NPIExtension {
    public Lead leadRecord { get; set; }
    public NPI__c npiRecord { get; set; }
    public boolean showNPI { get; set; }

    public NPIExtension(ApexPages.StandardController controller) {
        leadRecord = (Lead)controller.getRecord();
        showNPI = false;
        if (leadRecord.NPI__c != null) {
            npiRecord = [SELECT Id, Name, NPI_No__c FROM NPI__c WHERE NPI_No__c = :leadRecord.NPI__c LIMIT 1];
            showNPI = (npiRecord != null);
        }
    }
}