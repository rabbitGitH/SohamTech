trigger LinkCivilePdfToCustomer on Customer__c (before insert, before update) {
    // First, gather all the Customer__c records that are being created or updated
    Set<Id> customerIds = new Set<Id>();
    for (Customer__c customer : Trigger.new) {
        customerIds.add(customer.Id);
    }

    // Query for all the Civile PDF files that are uploaded and attached to these Customer__c records
    List<ContentDocumentLink> existingLinks = [
        SELECT Id, ContentDocumentId, LinkedEntityId
        FROM ContentDocumentLink
        WHERE LinkedEntityId IN :customerIds
        AND ContentDocument.FileType = 'pdf'
        AND ContentDocument.Title = 'civile.pdf'
    ];
    Set<Id> existingDocumentIds = new Set<Id>();
    Map<Id, ContentDocumentLink> existingLinksByCustomer = new Map<Id, ContentDocumentLink>();
    for (ContentDocumentLink link : existingLinks) {
        existingDocumentIds.add(link.ContentDocumentId);
        existingLinksByCustomer.put(link.LinkedEntityId, link);
    }

    // For each Customer__c record, check if the civilePdf flag is set to true
    // If it is, create a new ContentDocumentLink to link the civile.pdf file to the record
    List<ContentDocumentLink> newLinks = new List<ContentDocumentLink>();
    for (Customer__c customer : Trigger.new) {
        if (customer.RelatedInvoices__c && !existingLinksByCustomer.containsKey(customer.Id)) {
            ContentDocument civilePdf = [
                SELECT Id
                FROM ContentDocument
                WHERE FileType = 'pdf'
                AND Title = 'civile.pdf'
                LIMIT 1
            ];
            ContentDocumentLink link = new ContentDocumentLink();
            link.ContentDocumentId = civilePdf.Id;
            link.LinkedEntityId = customer.Id;
            link.ShareType = 'V';
            link.Visibility = 'AllUsers';
            newLinks.add(link);
        }
    }

    // Insert the new ContentDocumentLinks
    insert newLinks;
}