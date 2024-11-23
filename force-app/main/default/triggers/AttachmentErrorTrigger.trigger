trigger AttachmentErrorTrigger on ContentDocument (before delete ) {
 
    set<Id> contentDocumentIds = new set<Id>();
    List<ContentDocument> deleteContentDocuments = new List<ContentDocument>();
    Map<Id, Id> contentDocumentLinkMap = new Map<Id, Id>();
  
    Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
    system.debug('systemAdminProfileId'+systemAdminProfileId);
 
    if (Trigger.isInsert) {
       
        for (ContentDocument newContentDocument : Trigger.new) {
            contentDocumentIds.add(newContentDocument.Id);
        }
        
         system.debug('contentDocumentIds'+contentDocumentIds.size());
        
             HelperW.methodW(contentDocumentIds);
        
       
        List<ContentDocumentLink> linkedEntities = [
            SELECT ContentDocumentId, LinkedEntityId 
            FROM ContentDocumentLink 
            WHERE ContentDocumentId IN :contentDocumentIds
        ];
          system.debug('linkedEntities'+linkedEntities.size());
       
        for (ContentDocumentLink link : linkedEntities) {
            contentDocumentLinkMap.put(link.ContentDocumentId, link.LinkedEntityId);
        }
        
       
        for (ContentDocument newContentDocument : Trigger.new) {
        
            Id linkedEntityId = contentDocumentLinkMap.get(newContentDocument.Id);
            
           
            if (linkedEntityId != null && isQuoteApproved(linkedEntityId) && isSystemAdmin()) {
                //newContentDocument.addError('This attachment cannot be inserted because the related quote is approved and you are a System Administrator.');
                deleteContentDocuments.add(newContentDocument);
            }
        }
        
           system.debug('deleteContentDocuments'+deleteContentDocuments.size());
        
        delete deleteContentDocuments;
    }

   
    if (Trigger.isDelete) {
        
        for (ContentDocument oldContentDocument : Trigger.old) {
            contentDocumentIds.add(oldContentDocument.Id);
        }
        
        List<ContentDocumentLink> linkedEntities = [
            SELECT ContentDocumentId, LinkedEntityId 
            FROM ContentDocumentLink 
            WHERE ContentDocumentId IN :contentDocumentIds
        ];
        
        for (ContentDocumentLink link : linkedEntities) {
            contentDocumentLinkMap.put(link.ContentDocumentId, link.LinkedEntityId);
        }
        
        
        for (ContentDocument oldContentDocument : Trigger.old) {
          
            Id linkedEntityId = contentDocumentLinkMap.get(oldContentDocument.Id);
           
            if (linkedEntityId != null && isQuoteApproved(linkedEntityId) && isSystemAdmin()) {
                oldContentDocument.addError('This attachment cannot be deleted because the related quote is approved and you are a System Administrator.');
            }
        }
    }
 
    private static Boolean isQuoteApproved(Id linkedEntityId) {
        
        SBQQ__Quote__c relatedQuote = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :linkedEntityId LIMIT 1];
      
        return relatedQuote.SBQQ__Status__c == 'Approved';
    }
 
    private static Boolean isSystemAdmin() {
      
        Id currentUserProfileId = UserInfo.getProfileId();
        
        return currentUserProfileId == systemAdminProfileId;
    }
}