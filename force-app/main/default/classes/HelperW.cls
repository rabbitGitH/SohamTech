public class HelperW {
    
    
    
    @future
    public static void methodW(set<id> contentDocumentIds){
        List<ContentDocument> deleteContentDocuments = new List<ContentDocument>();
      Map<Id, Id> contentDocumentLinkMap = new Map<Id, Id>();
        
       
        
         List<ContentDocumentLink> linkedEntities = [
            SELECT ContentDocumentId, LinkedEntityId 
            FROM ContentDocumentLink 
            WHERE ContentDocumentId IN :contentDocumentIds
        ];
          system.debug('linkedEntities'+linkedEntities.size());
        
       
        for (ContentDocumentLink link : linkedEntities) {
            system.debug('ContentDocumentId'+link.ContentDocumentId);
        system.debug('LinkedEntityId'+link.LinkedEntityId);
            
            contentDocumentLinkMap.put(link.ContentDocumentId, link.LinkedEntityId);
        }
        
          system.debug('contentDocumentLinkMap'+contentDocumentLinkMap.size());
        
        List<contentDocument> cons = [select id from contentDocument where id in : contentDocumentIds];
         system.debug('cons'+cons.size());
       
        for (ContentDocument newContentDocument : cons) {
        
            Id linkedEntityId = contentDocumentLinkMap.get(newContentDocument.Id);
            
           
            if (linkedEntityId != null && isQuoteApproved(linkedEntityId) && isSystemAdmin()) {
                //newContentDocument.addError('This attachment cannot be inserted because the related quote is approved and you are a System Administrator.');
                deleteContentDocuments.add(newContentDocument);
            }
        }
        
         system.debug('deleteContentDocuments'+deleteContentDocuments.size());
    delete deleteContentDocuments;
        
    }
    
    private static Boolean isQuoteApproved(Id linkedEntityId) {
        
        SBQQ__Quote__c relatedQuote = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :linkedEntityId LIMIT 1];
      
        return relatedQuote.SBQQ__Status__c == 'Approved';
    }
    
     private static Boolean isSystemAdmin() {
          Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
      
        Id currentUserProfileId = UserInfo.getProfileId();
        
        return currentUserProfileId == systemAdminProfileId;
    }


}