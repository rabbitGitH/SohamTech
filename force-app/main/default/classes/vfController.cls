public class vfController {
    private ApexPages.StandardController stdController;
    
    public vfController (ApexPages.StandardController controller) {
        stdController = controller;
    }
    
    public NPI__c  previousNPI {
        get {
            Lead currentLead = (Lead) stdController.getRecord();
            NPI__c  matchingNPI = [SELECT Id, NPI_No__c FROM NPI__c  WHERE NPI_No__c  =: currentLead.NPI__c LIMIT 1];
             
               
            return matchingNPI ;
        } 
    }
}