trigger codeApex on Case (after insert, after update) {
   
    for (Case c : Trigger.new) {
    
          String caseDataJson = JSON.serialize(c);
          system.debug('caseDataJson'+caseDataJson);
          CaseRestApiClient.upsertCasesAsync(caseDataJson);
    }
    
  
}