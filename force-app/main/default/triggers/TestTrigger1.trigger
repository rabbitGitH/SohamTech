trigger TestTrigger1 on ContentDocumentLink (before insert) {
    // Set to store ContentDocument IDs
    Set<Id> contentDocumentIds = new Set<Id>();
    // Map to hold ContentDocumentId and their corresponding LinkedEntityId
    Map<Id, Id> contentDocumentLinkMap = new Map<Id, Id>();

    // Get the Profile Id of the System Administrator profile
    Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
    System.debug('System Administrator Profile ID: ' + systemAdminProfileId);
    
    // Only run if the trigger is for insert
    if (Trigger.isInsert) {
        // Add ContentDocument Ids from the trigger new records
        for (ContentDocumentLink newContentDocumentLink : Trigger.new) {
            contentDocumentIds.add(newContentDocumentLink.ContentDocumentId);
            System.debug('Adding ContentDocumentId to set: ' + newContentDocumentLink.ContentDocumentId);
        }
        
        // Convert the set of ContentDocumentIds to a list for the query
        List<Id> contentDocIdList = new List<Id>(contentDocumentIds);
        System.debug('ContentDocumentId list for query: ' + contentDocIdList);
        
        // Query ContentDocumentLink records to find the related LinkedEntityId (the record the document is linked to)
        List<ContentDocumentLink> linkedEntities = [
            SELECT ContentDocumentId, LinkedEntityId 
            FROM ContentDocumentLink 
            WHERE ContentDocumentId IN :contentDocIdList
        ];
        System.debug('Queried ContentDocumentLink records: ' + linkedEntities);
        
        // Populate the map with ContentDocumentId and LinkedEntityId pairs
        for (ContentDocumentLink link : trigger.new) {
            contentDocumentLinkMap.put(link.ContentDocumentId, link.LinkedEntityId);
            System.debug('Adding to map - ContentDocumentId: ' + link.ContentDocumentId + ', LinkedEntityId: ' + link.LinkedEntityId);
        }
        
        // Iterate over the new ContentDocumentLink records
        for (ContentDocumentLink newContentDocumentLink : Trigger.new) {
            Id linkedEntityId = contentDocumentLinkMap.get(newContentDocumentLink.ContentDocumentId);
            System.debug('Processing ContentDocumentLink with ContentDocumentId: ' + newContentDocumentLink.ContentDocumentId + ', LinkedEntityId: ' + linkedEntityId);
            
            // Check if the linked entity is a Quote, the quote status is approved, and the user is a System Administrator
            if (linkedEntityId != null && isQuoteApproved(linkedEntityId) && isSystemAdmin()) {
                // Add an error to prevent the attachment from being linked to an approved quote by a system admin
                newContentDocumentLink.addError('This attachment cannot be inserted because the related quote is approved and you are a System Administrator.');
                System.debug('Error added to ContentDocumentLink: This attachment cannot be inserted because the related quote is approved and you are a System Administrator.');
            }
        }
    }

    // Helper method to check if the related Quote is approved
    private static Boolean isQuoteApproved(Id linkedEntityId) {
        // Query the related quote status
        SBQQ__Quote__c relatedQuote = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id = :linkedEntityId LIMIT 1];
        System.debug('Queried related quote: ' + relatedQuote);
        
        // Return true if the quote status is "Approved"
        return relatedQuote.SBQQ__Status__c == 'Approved';
    }

    // Helper method to check if the current user is a System Administrator
    private static Boolean isSystemAdmin() {
        // Get the current user's profile ID
        Id currentUserProfileId = UserInfo.getProfileId();
        System.debug('Current User Profile ID: ' + currentUserProfileId);
        
        // Check if the current user's profile ID matches the System Administrator profile ID
        return currentUserProfileId == systemAdminProfileId;
    }
}