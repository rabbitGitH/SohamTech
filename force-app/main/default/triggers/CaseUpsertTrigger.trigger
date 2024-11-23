/*trigger CaseUpsertTrigger on Case (after insert, after update) {
    Map<String, Object> caseData = new Map<String, Object>();
    for (Case c : Trigger.new) {
     //   Map<String, Object> caseData = new Map<String, Object>();
        caseData.put('External_Id__c', c.External_Id__c);
        caseData.put('ContactId', c.ContactId);
        caseData.put('AccountId', c.AccountId);
        caseData.put('Status', c.Status);
        caseData.put('Origin', c.Origin);
        caseData.put('Priority', c.Priority);
        caseData.put('Type', c.Type);
        caseData.put('Reason', c.Reason);
        caseData.put('Subject', c.Subject);
        caseData.put('Description', c.Description);
        caseData.put('Comments', c.Comments);
       // caseData = caseData;
    }
    String caseDataJson = JSON.serialize(caseData);
    CaseRestApiClient.upsertCasesAsync(caseDataJson);
}*/

trigger CaseUpsertTrigger on Case (after insert, after update) {
    List<Map<String, Object>> caseDataList  = new List<Map<String, Object>>();
    for (Case c : Trigger.new) {
        Map<String, Object> caseData = new Map<String, Object>();
        caseData.put('External_Id__c', c.External_Id__c);
        caseData.put('ContactId', c.ContactId);
        caseData.put('AccountId', c.AccountId);
        caseData.put('Status', c.Status);
        caseData.put('Origin', c.Origin);
        caseData.put('Priority', c.Priority);
        caseData.put('Type', c.Type);
        caseData.put('Reason', c.Reason);
        caseData.put('Subject', c.Subject);
        caseData.put('Description', c.Description);
        caseData.put('Comments', c.Comments);
       // caseData.put('Id', c.Id);
        caseDataList.add(caseData);
    }
    String caseDataJson = JSON.serialize(caseDataList);
    system.debug('caseDataJson'+caseDataJson);
    
    
    CaseRestApiClient.upsertCasesAsync(caseDataJson);
}