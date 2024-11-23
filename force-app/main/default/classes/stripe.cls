public class stripe {
    
    
    /*
     
// @autor Gyan
//
public class StripePaymentService {
    public class CustomException extends Exception {}
    
    public Static Map<String, Object> makeHttpCallToStripe(String endPoint, String reqMethod){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint(endPoint);
        req.setMethod(reqMethod);
        Stripe_Secret__mdt stripeSecret = Stripe_Secret__mdt.getInstance('Api_Key');
        req.setHeader('Authorization', stripeSecret.Auth_Token__c);
        
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        HttpResponse res = http.send(req);
        Map<String, Object> result = (Map<String, Object>)json.deserializeuntyped(res.getBody());
        return result;
    }
    
    @AuraEnabled
    public static void createPaymentLink(Id invoiceId){

        //  system.assertequals(1,3);
        createPaymentLinkHelper(new List<Id>{invoiceId});
    }
    
    @AuraEnabled(cacheable = true)
    public static blng__Invoice__c getPaymentData(Id recordId){
        blng__Invoice__c invoice = [
            SELECT Id
            , Name
            , Stripe_Payment_Url__c
            , Stripe_Payment_Status__c
            , Email_Sent__c
            , blng__InvoiceStatus__c
            , Cancelled_to_Amend__c
            , blng__BillToContact__r.Email
            , blng__DaysOutstanding__c
            , blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c
            FROM blng__Invoice__c 
            WHERE Id= :recordId];
        return invoice;
    }
    
    @InvocableMethod(label='Create Stripe Payment')
    public static void createPaymentLinkInvocable(List<Id> invoiceIds){

        System.debug('Entered by Flow');
      
        if(System.isBatch() || System.isFuture() || System.isQueueable()) {
            createPaymentLinkHelper(invoiceIds);
        } else {
            createPaymentLinkHelperFuture(invoiceIds);
        }
    }
    
    @future(callout=true)
    public static void createPaymentLinkHelperFuture(List<Id> invoiceIds){
        createPaymentLinkHelper(invoiceIds);
    }
    
    public static void createPaymentLinkHelper(List<Id> invoiceIds){

       //   system.assertequals(1,3);

        String stripeBaseUrl = System.Label.Stripe_Base_Url;
        List<blng__Invoice__c> invoices = [
            SELECT Id
            , Name
            , Stripe_Invoice_Id__c
            , Stripe_Payment_Url__c
            , Stripe_Payment_Status__c
            , blng__Balance__c
            , blng__BillToContact__r.Email

            , blng__BillToContact__r.MailingStreet
            , blng__BillToContact__r.MailingCity 
            , blng__BillToContact__r.MailingState 
            , blng__BillToContact__r.MailingPostalCode 
            , blng__BillToContact__r.MailingCountry 



            FROM blng__Invoice__c 
            WHERE Id IN:invoiceIds];
        for(blng__Invoice__c invoice : invoices){
            if(invoice.Stripe_Payment_Url__c != null){
                return;
            }
            if(invoice.blng__BillToContact__r.Email == null){
                throw new CustomException('Please make sure email exists in Bill To Contact'); 
            }
            String email = invoice.blng__BillToContact__r.Email;
            String customerId = '';

             String MailingStreet = invoice.blng__BillToContact__r.MailingStreet;
             String MailingCity = invoice.blng__BillToContact__r.MailingCity; 
             String MailingState = invoice.blng__BillToContact__r.MailingState; 
             String MailingPostalCode = invoice.blng__BillToContact__r.MailingPostalCode; 
             String MailingCountry = invoice.blng__BillToContact__r.MailingCountry; 

             System.debug('mailStreet'+MailingStreet);
              System.debug('MailingCity'+MailingCity);
               System.debug('MailingPostalCode'+MailingPostalCode);

            
            //String customerId = invoice.blng__Account__r.sblng__Stripe_Customer_Id__c;
            //String customerEndPoint = stripeBaseUrl + 'customers?email=' + email;

               //  String customerEndPoint =  stripeBaseUrl + 'customers?email=' + email + '&address[city]=NewYork&address[country]=US&address[line1]=123MainSt&address[postal_code]=10001&address[state]=NY';

String customerEndPoint = stripeBaseUrl + 'customers?email=' + email 
    + '&name=' + invoice.Name
    + '&address[city]=' + MailingCity
    + '&address[country]=' + MailingCountry
    + '&address[line1]=' + MailingStreet
   // + '&address[line2]=123%20Main%20St'
    + '&address[postal_code]=' + MailingPostalCode
    + '&address[state]=' + MailingState;
    /*'&shipping[name]=treee'
    + '&shipping[address][city]=Pune'
    + '&shipping[address][country]=India'
    + '&shipping[address][line1]=123%20Main%20St'
    + '&shipping[address][postal_code]=411002'
    + '&shipping[address][state]=Maharashtra'; 

 
            Map<String, Object> customerInfo = makeHttpCallToStripe(customerEndPoint, 'GET');
            
            if((integer)customerInfo.get('count')>0){
                List<Object> customerList = (List<Object>)customerInfo.get('data');
                Map<String, Object> firstCustomer = (Map<String, Object>)customerList[0];
                customerId = (String)firstCustomer.get('id');
            }else{
                Map<String, Object> customer = makeHttpCallToStripe(customerEndPoint, 'POST');
                customerId = (String)customer.get('id');
            }
            
            Integer amount = (Integer)(invoice.blng__Balance__c*100);
            System.debug('amount'+amount);
            String curr = 'usd';
            String description = invoice.Name;
            
            String invoiceLinesEndPoint = stripeBaseUrl + 'invoiceitems?customer='+customerId+'&description='+description+'&amount='+amount+'&currency='+curr;
            Map<String, Object> invoiceLines = makeHttpCallToStripe(invoiceLinesEndPoint, 'POST');
            
            Integer daysUntilDue = 30;
           
            String invoiceEndPoint = stripeBaseUrl + 'invoices?customer='+customerId+'&collection_method=send_invoice&days_until_due='+daysUntilDue+'&description='+description+'&pending_invoice_items_behavior=include';
            Map<String, Object> invoiceStripe = makeHttpCallToStripe(invoiceEndPoint, 'POST');
            
            String invoiceFinalizeEndPoint = stripeBaseUrl + 'invoices/'+invoiceStripe.get('id')+'/finalize';
            Map<String, Object> invoiceFinalize = makeHttpCallToStripe(invoiceFinalizeEndPoint, 'POST');
            system.debug('paymentUrl::'+invoiceFinalize.get('hosted_invoice_url'));
            
            invoice.Stripe_Payment_Url__c = (String)invoiceFinalize.get('hosted_invoice_url');
            invoice.Stripe_Invoice_Id__c = (String)invoiceStripe.get('id');
            invoice.Stripe_Payment_Status__c = 'Open';
            //update invoice;
            System.debug('invoice::'+ invoice);
        }
        update invoices;
        //invoice.Stripe_Invoice_Id__c = (String)invoiceStripe.get('id');      
    }
    
    @AuraEnabled
    public static void sendEmail(Id invoiceId, List<String> emailArr, String templateName){
        blng__Invoice__c invoice = [
            SELECT Id
            , Name
            , blng__BillToContact__c
            , Email_Sent__c
            , blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c
            , blng__InvoiceStatus__c
            , Stripe_Payment_Url__c
            FROM blng__Invoice__c 
            WHERE Id = :invoiceId];
        
        if(invoice.Stripe_Payment_Url__c == null && !Test.isRunningTest()){
            throw new CustomException('Please make sure Stripe Payment Url exists'); 
        }
        
        InvoiceEmailHelper.sendEmail(invoice, emailArr, templateName);
    }
    
    @AuraEnabled
    public static void processPayment(Id invoiceId){
        String stripeBaseUrl = System.Label.Stripe_Base_Url;
        blng__Invoice__c invoice = [
            SELECT Id, Stripe_Invoice_Id__c, Stripe_Payment_Status__c, blng__Account__c 
            FROM blng__Invoice__c 
            WHERE Id = :invoiceId];
        
        String invoiceEndPoint = stripeBaseUrl + 'invoices/'+invoice.Stripe_Invoice_Id__c;
        Map<String, Object> invoiceStripe = makeHttpCallToStripe(invoiceEndPoint, 'GET');
        
        if((String)invoiceStripe.get('status') == 'paid' && invoice.Stripe_Payment_Status__c != 'Paid'){
            invoice.Stripe_Payment_Status__c = 'Paid';
            Decimal stripeAmountPaid = (Decimal)invoiceStripe.get('amount_paid')/100;
            if(stripeAmountPaid > 0){
                createPaymentRecord(invoice, stripeAmountPaid, (String)invoiceStripe.get('charge'));
            }
            update invoice;
            
        } else if((String)invoiceStripe.get('status') == 'open' && invoice.Stripe_Payment_Status__c != 'Open'){
            invoice.Stripe_Payment_Status__c = 'Open';
            update invoice;
            
        }
        
    }
    
    @AuraEnabled
    public static blng__Invoice__c CancelToAmend(Id invoiceId){
        //System.debug('invoiceId::'+invoiceId);
        blng__Invoice__c invoice = [
            SELECT Id, Cancelled_to_Amend__c, blng__InvoiceStatus__c, LastmodifiedDate 
            FROM blng__Invoice__c 
            WHERE Id = :invoiceId];
        
        if(invoice.Cancelled_to_Amend__c == false){
            invoice.Cancelled_to_Amend__c = true;
            update invoice;
        }
        return invoice;
    }
    public static void createPaymentRecord(blng__Invoice__c invoice, Decimal stripeAmountPaid, String chargeId){
        blng__Payment__c payment = new blng__Payment__c();
        if(chargeId != null){
            String stripeBaseUrl = System.Label.Stripe_Base_Url;
            String chargeEndPoint = stripeBaseUrl + 'charges/'+chargeId;
            Map<String, Object> chargeStripe = makeHttpCallToStripe(chargeEndPoint, 'GET');
            Map<String, Object> cardDetails = (Map<String, Object>)chargeStripe.get('payment_method_details');
            
            if(cardDetails.get('type') == 'card'){
                payment.blng__PaymentType__c = 'Credit Card';
            }  
            
        }
        
        payment.blng__Account__c = invoice.blng__Account__c;
        payment.blng__Amount__c = stripeAmountPaid;
        payment.blng__Invoice__c = invoice.Id;
        payment.blng__Status__c = 'Posted';
        insert payment;
        
        List<Id> paymentIdList = new List<Id>();
        paymentIdList.add(payment.Id);
        BillingPaymentHelper.allocatePayment([
            SELECT Id, blng__Invoice__c, blng__Balance__c 
            FROM blng__Payment__c 
            WHERE Id IN :paymentIdList]);
    }
    
} 


  
  





 
* makeStripeCalloutToCreatePayment: 
* 		1) makes call to stripe to get payment info. 
* 		2) creates payment record on salesforce
*      3) allocates payment to invoiceline if the payment is eaqual for more than an invoice line
* 		4) udpdates invoice  
* 
global class BillingPaymentHelper {
    
    @future(callout=true)
    public Static void makeStripeCalloutToCreatePayment(DateTime prevFiredTime){
        String strUnixTimeStamp = String.valueof( prevFiredTime.getTime() );
        String stripeBaseUrl = System.Label.Stripe_Base_Url;
        String paymentIntentsUrl = stripeBaseUrl + 'payment_intents/search?expand[0]=data.invoice.charge&query=created>'+strUnixTimeStamp.substring(0, strUnixTimeStamp.length()-3);
        Map<String, Object> paymentIntents = makeHttpCallToStripe(paymentIntentsUrl, 'GET');
        List<Object> dataList = (List<Object>)paymentIntents.get('data');
        Boolean hasMore = (Boolean)paymentIntents.get('has_more');
        String nextPageId = (String)paymentIntents.get('next_page');
        while(hasMore == true){
            Map<String, Object> nextPaymentIntents = getNextPageData(nextPageId, strUnixTimeStamp, stripeBaseUrl);
            List<Object> nextDataList = (List<Object>)paymentIntents.get('data');
            dataList.addAll(nextDataList);
            hasMore = (Boolean)nextPaymentIntents.get('has_more');
            nextPageId = (String)nextPaymentIntents.get('next_page');
        }
        Map <String, Decimal> stripeInvAmountMap = new Map <String, Decimal>();
        Map <String, String> stripeInvPaymentStatusMap = new Map <String, String>();
        Map <String, String> stripeInvPaymentTypeMap = new Map <String, String>();
        
        for (object item : dataList){
            Map<String, Object> itemAttributes  = (Map<String, Object>)item;
            Object stripeInvoice = (Object)itemAttributes.get('invoice');
            Map<String, Object> invoiceAttributes  = (Map<String, Object>)stripeInvoice;
            Decimal amountPaid = (Decimal)itemAttributes.get('amount_received')/100;
            if(amountPaid<=0){
                continue;
            }
            String invPaymentStatus = (String)invoiceAttributes.get('status');
            String stripeInvId = (String)invoiceAttributes.get('id');
            stripeInvAmountMap.put(stripeInvId, amountPaid);
            stripeInvPaymentStatusMap.put(stripeInvId, invPaymentStatus);
            Map<String, Object> paymentDetails = (Map<String, Object>)invoiceAttributes.get('charge');
            Map<String, Object> cardDetails = (Map<String, Object>)paymentDetails.get('payment_method_details');
            
            if(cardDetails != null && cardDetails.get('type') == 'card'){
                stripeInvPaymentTypeMap.put(stripeInvId, 'Credit Card');
            } 
        }
        //Todo: decricate this batch job (delete it)
        //BillingPaymentHelperJob billingPaymentHelper = new BillingPaymentHelperJob(stripeInvAmountMap, stripeInvPaymentStatusMap);
        //Database.executeBatch(billingPaymentHelper);
        
        List<blng__Invoice__c> invoices = [
            SELECT Id
            , blng__Account__c
            , Stripe_Invoice_Id__c
            , Stripe_Payment_Status__c 
            FROM blng__Invoice__c 
            WHERE Stripe_Invoice_Id__c IN :stripeInvAmountMap.keySet()
            AND Stripe_Payment_Status__c != 'Paid'];
        List<blng__Payment__c> paymentList = new List<blng__Payment__c>();
        for(blng__Invoice__c invoice : invoices){
            
            blng__Payment__c payment = new blng__Payment__c();
            payment.blng__Account__c = invoice.blng__Account__c;
            payment.blng__Amount__c = stripeInvAmountMap.get(invoice.Stripe_Invoice_Id__c);
            payment.blng__Invoice__c = invoice.Id;
            payment.blng__PaymentType__c = stripeInvPaymentTypeMap.get(invoice.Stripe_Invoice_Id__c);
            payment.blng__Status__c = 'Posted';
            paymentList.add(payment);
            invoice.Stripe_Payment_Status__c = stripeInvPaymentStatusMap.get(invoice.Stripe_Invoice_Id__c);
            
        }
        
        insert paymentList;
        update invoices;
        
        List<blng__PaymentAllocationInvoiceLine__c> paymentAllocationList = allocatePayment([
            SELECT Id 
            , blng__Invoice__c 
            , blng__Balance__c 
            FROM blng__Payment__c
            WHERE Id IN :paymentList
        ]);
        System.debug('paymentAllocationList::' + paymentAllocationList);
        //TODO: Allocate Payement Here
        //Allocate payment to invoice lines
        //PaymentAllocationHelperJob paymentAllocationJob = new PaymentAllocationHelperJob(paymentList);
        //Database.executeBatch(paymentAllocationJob); 
    }
    
    public static List<blng__PaymentAllocationInvoiceLine__c> allocatePayment (List<blng__Payment__c> paymentList){
        Map<Id, List<blng__Payment__c>> invoiceIdPaymentMap = new Map<Id, List<blng__Payment__c>>();
        
        for(blng__Payment__c payment : paymentList){ 
            if(invoiceIdPaymentMap.get(payment.blng__Invoice__c) == null){ 
                invoiceIdPaymentMap.put(payment.blng__Invoice__c, new List<blng__Payment__c>());
            }
            invoiceIdPaymentMap.get(payment.blng__Invoice__c).add(payment);
        }
        
        Set<Id> InvoiceIds = invoiceIdPaymentMap.keySet();
        List<blng__Invoice__c> invoiceList = [
            SELECT Id,
            (SELECT Id,
             blng__Invoice__c,
             blng__Balance__c, 
             blng__TotalAmount__c, 
             blng__OrderProduct__c,
             blng__OrderProduct__r.blng__PendingBillings__c 
             FROM blng__InvoiceInvoiceLines__r ) 
            FROM blng__Invoice__c 
            WHERE Id IN :InvoiceIds
        ];
        
        Map<Id, Decimal> invoiceLineIdPendingBillMap = new Map<Id, Decimal>();
        Map<Id, List<Id>> invoiceIdInvoiceLinesMap = new Map<Id, List<Id>>();
        
        for(blng__Invoice__c invoice : invoiceList){
            List<blng__InvoiceLine__c> invoiceLines = invoice.blng__InvoiceInvoiceLines__r;
            
            for(blng__InvoiceLine__c invoiceLine : invoiceLines){
                invoiceLineIdPendingBillMap.put(invoiceLine.Id, invoiceLine.blng__Balance__c);
                
                if(invoiceIdInvoiceLinesMap.get(invoiceLine.blng__Invoice__c) == null){
                    invoiceIdInvoiceLinesMap.put(invoiceLine.blng__Invoice__c, new List<Id>());
                }
                invoiceIdInvoiceLinesMap.get(invoiceLine.blng__Invoice__c).add(invoiceLine.Id);
                
            }
        }
        
        List<blng__PaymentAllocationInvoiceLine__c> paymentInvoiceLinesAll = new List<blng__PaymentAllocationInvoiceLine__c>();
        //List<blng__Invoice__c> invoices = new List<blng__Invoice__c>();
        for(Id invoiceId : invoiceIdPaymentMap.keySet()){
            
            List<blng__PaymentAllocationInvoiceLine__c> paymentInvoiceLines = new List<blng__PaymentAllocationInvoiceLine__c>();
            List<blng__Payment__c> invPaymentList = invoiceIdPaymentMap.get(invoiceId);
            
            Double paymentRecieved = 0.00;
            Double paymentNeeded = 0.00;
            
            Integer paymentIndex = 0;
            for(blng__Payment__c payment : invPaymentList){
                
                Double availableAmount = payment.blng__Balance__c;
                paymentRecieved = paymentRecieved + availableAmount;
                
                
                if(availableAmount == 0 ){
                    //if payment amount is 0 then don't create payment allocation invoice lines
                    continue;
                }
                
                for(Id invoiceLineId : invoiceIdInvoiceLinesMap.get(invoiceId)){
                    
                    blng__PaymentAllocationInvoiceLine__c paymentInvoiceLine = new blng__PaymentAllocationInvoiceLine__c();
                    
                    if(paymentIndex == 0){
                        paymentNeeded = paymentNeeded + invoiceLineIdPendingBillMap.get(invoiceLineId);
                    }
                    
                    if(availableAmount == 0 || invoiceLineIdPendingBillMap.get(invoiceLineId) == 0){
                        //if payment amount is 0 OR is there is no pending bill in order product then don't create payment allocation invoice lines
                        //loop for other invoice lines with amount>0
                        continue;
                        
                    }
                    
                    // System.debug('paymentNeeded::'+paymentNeeded);
                    if(invoiceLineIdPendingBillMap.get(invoiceLineId) <= availableAmount){
                        
                        //Assign total pending amount to invoice line as available amount in payment is more
                        paymentInvoiceLine.blng__Amount__c = invoiceLineIdPendingBillMap.get(invoiceLineId);
                        
                        //Substract Amount from Payment as it is already assigned to Invoice Line 
                        availableAmount = availableAmount - invoiceLineIdPendingBillMap.get(invoiceLineId);
                        
                        //Full Payment is done so make Invoice Line pending bill = 0
                        invoiceLineIdPendingBillMap.put(invoiceLineId, 0);
                        
                    }else if (invoiceLineIdPendingBillMap.get(invoiceLineId) > availableAmount){
                        
                        //Assign whatever amount is left in payment to invoice line as available amount in payment is less
                        paymentInvoiceLine.blng__Amount__c = availableAmount;
                        
                        //Full Payment is Not done so subtract Invoice Line pending bill from whatever paid
                        Double orderProdPendingBill = invoiceLineIdPendingBillMap.get(invoiceLineId) - availableAmount;
                        invoiceLineIdPendingBillMap.put(invoiceLineId, orderProdPendingBill);
                        
                        //Make Amount in Payment as 0 because complete amount from payment is assigned to Invoice Line 
                        availableAmount = 0;
                        
                    }
                    
                    //Assignment to Payment Allocation Invoice Line
                    paymentInvoiceLine.blng__InvoiceLine__c = invoiceLineId;
                    paymentInvoiceLine.blng__Payment__c = payment.Id;
                    paymentInvoiceLine.blng__Type__c = 'Allocation';
                    
                    paymentInvoiceLines.add(paymentInvoiceLine);
                }
                paymentIndex++;
            }
            
            //As paymentRecieved < paymentNeeded so Payment allocation can't be completed so don't create record
            System.debug('paymentRecieved::'+ paymentRecieved + ' paymentNeeded::'+ paymentNeeded);
            if(paymentRecieved < paymentNeeded){
                //payment recieved is less. So we don't have complete information for payment allocation
                continue;
            }
            blng__Invoice__c invoiceItem = new blng__Invoice__c();
            invoiceItem.Id = invoiceId;
            //invoiceItem.blng__InvoiceStatus__c = 'Posted';
            //invoices.add(invoiceItem);
            paymentInvoiceLinesAll.addAll(paymentInvoiceLines);
            
        }
        
        insert paymentInvoiceLinesAll;
        
        return paymentInvoiceLinesAll;
    }
    
    public Static Map<String, Object> makeHttpCallToStripe(String endPoint, String reqMethod){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint(endPoint);
        req.setMethod(reqMethod);
        Stripe_Secret__mdt stripeSecret = Stripe_Secret__mdt.getInstance('Api_Key');
        req.setHeader('Authorization', stripeSecret.Auth_Token__c);
        
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        HttpResponse res = http.send(req);
        Map<String, Object> result = (Map<String, Object>)json.deserializeuntyped(res.getBody());
        return result;
    }
    
    public Static Map<String, Object> getNextPageData(String nextPageId, String strUnixTimeStamp, String stripeBaseUrl){
        String nextPaymentIntentsUrl = stripeBaseUrl + 'payment_intents/search?expand[0]=data.invoice.charge&query=created>' + strUnixTimeStamp.substring(0, strUnixTimeStamp.length()-3) + '&page=' + nextPageId;
        Map<String, Object> nextPaymentIntents = makeHttpCallToStripe(nextPaymentIntentsUrl, 'GET');
        return nextPaymentIntents;
    }
    
    
    
    
}
    
    

//////////////////////////////////////


public class Error_Log_Handler {  
    
    //error handler that creates the record
    
    public static void errorHandler(String classname, string error){
        
        //query number of logs all time and get the number for log name
        
        List<sObject> numberoflogs = [SELECT Name
                                      FROM Error_Logs__c
                                      ORDER BY CreatedDate Desc
                                      LIMIT 1];
        Integer logCount = 1;
        if(numberoflogs.Size() > 0){
            String name = (String)(numberoflogs[0].get('Name'));
            List<String> nameStrArr = name.split('# ');
            logCount = Integer.valueof(nameStrArr[1]) + 1;
        }
        
        
        Error_Logs__c newlog = new Error_Logs__c (); {
            
            newlog.Class_Name__c  = string.valueof(classname);
            newlog.Error_Message__c  = string.valueof(error);
            newlog.Name = 'Log # ' + (logCount);
            
        }
        
        insert newlog;
        
       
        // Querying the GoGuardian user and making them a temp contact (for setTargetObjectId) and then deleting after.
        Emailtemplate emailtemplate = [SELECT Id
                                       FROM Emailtemplate
                                       WHERE DeveloperName = 'Error_Log_Created'];
        
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'test@mail.com' };
            if(!Test.isRunningTest()){
                Contact salesops = [SELECT Id FROM Contact WHERE Email = 'test@mail.com'];
                
                message.setTargetObjectId(salesops.Id);
                message.setWhatId(newlog.Id);
                
                message.setTemplateId(emailtemplate.id);
            }
        else{
            message.setPlainTextBody('this is a test');
        }
        message.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.Email[] { message });
        
        
    }
    
    public class Error{
        @InvocableVariable(label='Flow Name')
        public String FlowName;
        
        @InvocableVariable(label='Message')
        public String Message;
    }
    
    @InvocableMethod(label='Send Error Message')
    public static void sendErrorMessage(List<Error> errors){
        for(Error err: errors){
            errorHandler(err.FlowName,err.Message);
        }
    }
}


/////////////////////////////////




//
// @autor gyan
//
public class InvoiceEmailHelper {
    // EXCEPTIONS 
    public class SendException extends Exception { } 
    public class Request { 
        @InvocableVariable(label='Template' required=true) 
        public String template; 
        
        @InvocableVariable(label='To Address' required=true) 
        public String[] toAddress; 
        
        @InvocableVariable(label='Contact Id' required=true) 
        public Id contactId; 
        
        @InvocableVariable(label='Current Record Id' required=true) 
        public Id recordId; 
        
        @InvocableVariable(label='Related Id' required=true) 
        public Id relatedId; 
        
        @InvocableVariable(label='Send Attachment' required=true) 
        public Boolean sendAttachment;
        
        //@InvocableVariable(label='Has Email Already Been Sent' required=false) 
        //public Boolean emailSent;
    } 
    
    @InvocableMethod(label='Attach Invoice' ) 
    public static void attachInvoice(List<Request> requests) { 
        Request request = (requests != null && requests.size() == 1) ? requests[0] : null; //why size 1??
        if(request != null) {
            sendEmailWithPdf(request);
        }
    }
    
    public static void sendEmailWithPdf(Request request) { 
        try { 
            if (request != null) { 
                // Get Content Document Ids 
                Set<String> contentDocumentIds = new Set<String>(); 
                List<ContentDocumentLink> cdls = [
                    SELECT ContentDocumentId 
                    FROM ContentDocumentLink 
                    WHERE LinkedEntityId = :request.recordId]; 
                
                for (ContentDocumentLink doc : cdls) { 
                    contentDocumentIds.add(doc.ContentDocumentId); 
                } 
                
                // Get Email Template 
                Id templateId = [
                    SELECT Id 
                    FROM EmailTemplate  
                    //limit 1]?.Id;
                  WHERE DeveloperName = :request.template]?.Id;
                  system.debug('templateId'+templateId);
                
                String emailSenderAddress = System.Label.Invoice_Email_Sender;
                OrgWideEmailAddress orgWideEmailAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: emailSenderAddress Limit 1];
                
                // New email message 
                Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId, null, request.relatedId); 
                
                // Set Email Properties 
                mail.toAddresses = request.toAddress; 
                mail.setTargetObjectId(request.contactId); 
                mail.setWhatId(request.relatedId); 
                mail.setTreatTargetObjectAsRecipient(false); 
                mail.setTreatBodiesAsTemplate(true); 
                mail.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
                
                // Set Email Attachments 
                
                if (request.sendAttachment == true) { 
                    List<ContentVersion> contentVersionFile = [
                        SELECT VersionData, Title, FileType 
                        FROM ContentVersion 
                        WHERE ContentDocumentId IN :contentDocumentIds 
                        AND IsLatest = true 
                        Order by Createddate desc Limit 1]; 
                    List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>(); 
                    for (ContentVersion cv : contentVersionFile) { 
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment(); 
                        efa.setFileName(cv.Title + '.' + cv.FileType); 
                        efa.setBody(cv.VersionData); 
                        emailFileAttachments.add(efa); 
                    } 
                    if (!emailFileAttachments.isEmpty()) { 
                        system.debug('emailFileAttachments===>'+!emailFileAttachments.isEmpty());
                        mail.setFileAttachments(emailFileAttachments); 
                        
                        // Send Email 
                        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{mail}; 
                            if (!Test.isRunningTest()) { 
                                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
                                if (results[0].success) { 
                                    System.debug('The email was sent successfully.');
                                    //update Send_Email__c to false. It will not send email agai and again when the invoice record is updated
                                    
                                    //if(!request.emailSent){
                                    blng__invoice__c invoice = new blng__invoice__c();
                                    invoice.Id = request.recordId;
                                    invoice.Last_Emailed_Date__c = Datetime.now();
                                    invoice.Email_Sent__c = true;
                                    update invoice;
                                    //}
                                } else { 
                                    System.debug('The email failed to send: ' + results[0].errors[0].message); 
                                } 
                            } 
                    } 
                } 
            } 
        } catch (Exception e) { 
            System.debug(e.getMessage()); 
            throw new SendException(e.getMessage(), e); 
        } 
    }
    
    public static void sendEmail(blng__Invoice__c invoice, List<String> emailArr, String templateName){
        //System.debug('sendEmail invoice number = ' + invoice.Name + ', templateName = ' + templateName);
        List<ContentDocumentLink> contentDoc = [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :invoice.Id];
        
        if(contentDoc.Size() == 0){
            throw new SendException('The invoice document is not generated. Please generate the document or contact your administrator.'); 
        }
       
        //if(invoice.blng__BillToContact__c == null){
        //    throw new CustomException('No Bill to Contact Found'); 
        //}
        if(invoice.blng__InvoiceStatus__c == 'Post In progress' 
           || invoice.blng__InvoiceStatus__c == 'Error' 
           || invoice.blng__InvoiceStatus__c == 'Initiated' 
           || invoice.blng__InvoiceStatus__c == null)
        {
            throw new SendException('Can\'t send email as invoice status is ' + invoice.blng__InvoiceStatus__c); 
        }
        InvoiceEmailHelper.Request request = new InvoiceEmailHelper.Request(); 
        //if(invoice.blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c == False){
        //  request.template = System.Label.Standard_Invoice_Email_Template;
        //}
        //else {
        //  request.template = System.Label.Manual_Invoice_Email_Template;
        //}
        request.template = templateName;
        request.toAddress = emailArr;
        request.contactId = invoice.blng__BillToContact__c;
        request.recordId = invoice.Id;
        request.relatedId = invoice.Id;
        request.sendAttachment = true;
        //request.emailSent = invoice.Email_Sent__c;
        
        InvoiceEmailHelper.sendEmailWithPdf(request);
    }
    
    
}



///////////////////////////





//
// @author: Gyan
// @modifiedby: ddas
//
public class InvoiceEmailJob implements Database.Batchable<sObject> {
    public static String Late_Payment_10_Days = 'Late_Payment_10_Days';
    public static String Past_Due_10_Days = 'Past_Due_10_Days';
    public static String Past_Due_30_Days = 'Past_Due_30_Days';
    public static String Past_Due_45_Days = 'Past_Due_45_Days';
    public static String Past_Due_60_Days = 'Past_Due_60_Days';
    
    public String dunningType = 'None';
    public InvoiceEmailJob(String dunningType){
        this.dunningType = dunningType;
    }
    public List<blng__Invoice__c> start(Database.BatchableContext bc){
        
        List<blng__Invoice__c> invoices = new List<blng__Invoice__c>();
        if(dunningType == 'None'){
            invoices = [
                SELECT Id
                , blng__BillToContact__r.Email
                , Name
                , blng__InvoiceStatus__c
                , Email_Sent__c
                , blng__DaysOutstanding__c
                , blng__BillToContact__r.Account.Name               
                FROM blng__Invoice__c 
                WHERE blng__BillToContact__r.Email != null
                AND blng__InvoiceStatus__c = 'Posted' 
                AND blng__TaxStatus__c = 'Posted' 
                AND Last_Emailed_Date__c = null
                AND Email_Sent__c = false
                AND Stripe_Invoice_Id__c  != null                    
                AND blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c = false
                //AND blng__Account__r.Test_Account__c = false
                AND CreatedDate >= YESTERDAY
                ORDER BY CreatedDate DESC];
                 system.debug('invoices====11'+invoices);
        }else {
            Integer[] dunningRangeArr = getDunningRange();
            invoices = [
                SELECT Id
                , blng__BillToContact__r.Email
                , Name
                , blng__InvoiceStatus__c
                , Email_Sent__c
                , blng__DaysOutstanding__c
                //Past_Due_Create_Case__c
                , blng__BillToContact__r.Account.Name               
                FROM blng__Invoice__c 
                WHERE blng__BillToContact__r.Email != null
                //AND Past_Due_Create_Case__c = false
                AND blng__InvoiceStatus__c = 'Posted' 
                AND blng__TaxStatus__c = 'Posted' 
                AND blng__PaymentStatus__c = 'Unpaid'               
                //AND (Dunning_Notice_Day__c = NULL 
                     //OR Dunning_Notice_Day__c < :dunningRangeArr[0]) 
                //AND blng__Account__r.Test_Account__c = false
                AND blng__DaysOutstanding__c >= :dunningRangeArr[0]
                AND blng__DaysOutstanding__c < :dunningRangeArr[1]
                ORDER BY CreatedDate DESC];
                system.debug('invoices===='+invoices);
        }
        return invoices;
        
    } 
    
    public void execute(Database.BatchableContext bc, List<blng__Invoice__c> invoiceList){
        System.debug('into execute------');
       // List<string> cdwAccounts = Label.Exclude_account_from_email_send.split(';');
        Map<Id, String> invIdEmailMap = new Map<Id, String>();
        //String emailTemplate = System.Label.Standard_Invoice_Email_Template;
        if(dunningType != 'None'){
            //emailTemplate = getDunningEmailTemplate();
        }
        List<blng__Invoice__c> invoiceUpdateList = new List<blng__Invoice__c>();
        //we are processing one invoice 
        for(blng__Invoice__c invoice : invoiceList){ 
            blng__invoice__c invoice2Update = new blng__invoice__c(Id = invoice.Id);
          //  invoice2Update.Dunning_Notice_Day__c = invoice.blng__DaysOutstanding__c; 
            if(dunningType == Past_Due_60_Days){
                //invoice2Update.Past_Due_Create_Case__c = true;
            } else {
                 if(!cdwAccounts.contains(invoice.blng__BillToContact__r.Account.Name)){ 
                    system.debug('into if------');
            		InvoiceEmailHelper.sendEmail(invoice, new List<String>{invoice.blng__BillToContact__r.Email}, emailTemplate);
                } 
            }
            invoiceUpdateList.add(invoice2Update); 

        }
        update invoiceUpdateList;
        system.debug('invoiceUpdateList===>'+invoiceUpdateList);
    }
    
    private String getDunningEmailTemplate(){
        if(dunningType == Late_Payment_10_Days){
            return 'Payment_Reminder_10_Days_Before_Due_Date';
        } else if(dunningType == Past_Due_10_Days){
            return 'Payment_Reminder_10_Days_Past_Due_Date';
        } else if(dunningType == Past_Due_30_Days){
            return 'Payment_Reminder_30_Days_Past_Due_Date';
        } else if(dunningType == Past_Due_45_Days){
            return 'Payment_Reminder_45_Days_Past_Due_Date';
        }
        return null;
    }
    
    private Integer[] getDunningRange(){
        if (dunningType == Late_Payment_10_Days){
            return new Integer[]{-10, 0};  
        } else if (dunningType == Past_Due_10_Days){
            return new Integer[]{10, 30};  
        } else if (dunningType == Past_Due_30_Days){
            return new Integer[]{30, 45};   
        }else if (dunningType == Past_Due_45_Days){
            return new Integer[]{45, 60};    
        } else { //Past_Due_60_Days
            return new Integer[]{60, 365};    
        }
    }
    
    private String getNextDunningType(){
        if(dunningType == 'None'){
            return Late_Payment_10_Days;
        } else if (dunningType == Late_Payment_10_Days){
            return Past_Due_10_Days;
        } else if (dunningType == Past_Due_10_Days){
            return Past_Due_30_Days;
        } else if (dunningType == Past_Due_30_Days){
            return Past_Due_45_Days;
        } else if (dunningType == Past_Due_45_Days){
            return Past_Due_60_Days;
        }else if (dunningType == Past_Due_60_Days){
            //  return Past_Due_60_Days;
        }
        return null;
        
    }
    
    // The batch job finishes
    public void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('InvoiceEmailJob Status::' + job.Status);
        String nextDunningType = getNextDunningType();
        System.debug('nextDunningType = ' + nextDunningType);
        if(nextDunningType != null) {
            Database.executeBatch(new InvoiceEmailJob(nextDunningType), 1);
        }
        
    }
}


///////////////////////////////////

    

public class InvoiceQuickActionController {
    
    @AuraEnabled
    public static void createPaymentLink(Id invoiceId){
        StripePaymentService.createPaymentLink(invoiceId);
    }
    
    @AuraEnabled(cacheable = true)
    public static blng__Invoice__c getPaymentData(Id recordId){
        blng__Invoice__c invoice = [
            SELECT Id
            , Name
            , Stripe_Payment_Url__c
            , Stripe_Payment_Status__c
            , Email_Sent__c
            , blng__InvoiceStatus__c
            , Cancelled_to_Amend__c
            , blng__BillToContact__r.Email
            , blng__DaysOutstanding__c
            , blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c
            FROM blng__Invoice__c 
            WHERE Id= :recordId];
        return invoice;
    }

    @AuraEnabled
    public static String cancelUrl(Id invoiceId){
        String cancelPage = new PageReference('/apex/blng__cancelInvoice?id='+invoiceId).getUrl();
        System.debug('cancelPage=' + cancelPage);
        return cancelPage;
    }
    
    @AuraEnabled
    public static void processPayment(Id invoiceId){
		StripePaymentService.processPayment(invoiceId);
    }
    
    @AuraEnabled
    public static void sendEmail(Id invoiceId, List<String> emailArr, String templateName){
        StripePaymentService.sendEmail(invoiceId, emailArr, templateName);
    }
    
    @AuraEnabled
    public static blng__Invoice__c CancelToAmend(Id invoiceId){
        blng__Invoice__c invoice = StripePaymentService.CancelToAmend(invoiceId);
        return invoice;
    }
}




////////////////////




 
* Author: Shubham Rakshit
* Description: This class is used for the LWC Component invoiceStatus.
*
public class InvoiceStatusController {
    
    @AuraEnabled
    public static Map<String, Object> getInvoiceStatus(Id invoiceId){
        Map<String, Object> returnData = new Map<String, Object>();
        
        blng__Invoice__c invoiceRecord = [SELECT Id
                                          , name
                                          , blng__TaxErrorMessage__c
                                          , blng__TaxStatus__c
                                          , blng__Order__c
                                          , blng__PaymentStatus__c
                                          , Email_Sent__c
                                          , Last_Emailed_Date__c
                                          , (SELECT Id
                                             , name
                                             , blng__TaxTreatment__c
                                             , blng__TaxStatus__c
                                             , blng__TaxErrorMessage__c 
                                             FROM blng__InvoiceInvoiceLines__r) 
                                          FROM blng__Invoice__c 
                                          WHERE Id = :invoiceId];
        returnData.put('invoiceRecord', invoiceRecord);
        
        if(invoiceRecord.blng__Order__c!= Null){
            List<OrderItem> orderItems =[SELECT Id
                                         , Product2.Name
                                         , OrderItemNumber
                                         , blng__LegalEntity__c 
                                         FROM OrderItem 
                                         WHERE OrderId = :invoiceRecord.blng__Order__c];
            returnData.put('orderItemRecords', orderItems);
        }
        
        return returnData;
    }
}
    
    
    
    ///////////////////////////////
    
    
    
    
    <template>
    <div class="slds-box slds-theme_default">
        <lightning-tabset>

            <lightning-tab label="Payment">
                <div class="slds-grid">
                    <div class="slds-col slds-size_1-of-2">
                        <template if:false={isCreatePaymentDisabled}>
                            <lightning-icon class="custom-icon" icon-name="action:share_link"
                                title="Generate Stripe Payment Link" onclick={createPaymentLink}></lightning-icon>
                        </template>
                        <template if:true={isCreatePaymentDisabled}>
                            <lightning-icon class="disabled-icon" icon-name="action:share_link"
                                title="Generate Stripe Payment Link" onclick={createPaymentLink}></lightning-icon>
                        </template>
                        <div class="slds-text-body_regular slds-text-color_weak">Generate Link</div>
                    </div>
                    <div class="slds-col slds-size_1-of-2">
                        <template if:false={isProcessPaymentDisabled}>
                            <lightning-icon class="custom-icon" icon-name="action:email" title={emailStatus}
                                onclick={showModalBox}></lightning-icon>
                        </template>
                        <template if:true={isProcessPaymentDisabled}>
                            <lightning-icon class="disabled-icon" icon-name="action:email" title={emailStatus}
                                onclick={sendEmail}></lightning-icon>
                        </template>
                        <div class="slds-text-body_regular slds-text-color_weak">{emailStatus}</div>
                    </div>
                    <div class="slds-col slds-size_1-of-2">
                        <template if:false={isProcessPaymentDisabled}>
                            <lightning-icon class="custom-icon" icon-name="action:change_record_type"
                                title="Process Stripe Payment" onclick={processStripePayment}></lightning-icon>
                        </template>
                        <template if:true={isProcessPaymentDisabled}>
                            <lightning-icon class="disabled-icon" icon-name="action:change_record_type"
                                title="Process Stripe Payment" onclick={processStripePayment}></lightning-icon>
                        </template>
                        <div class="slds-text-body_regular slds-text-color_weak">Process Payment</div>
                    </div>
                    <lightning-spinner if:true={showSpinner} alternative-text="Loading" size="medium">
                    </lightning-spinner>
                </div>
            </lightning-tab>

        <!--     <lightning-tab label="Cancel And Rebill">
                <div class="slds-grid">
                    <div class="slds-col slds-size_1-of-2">
                        <template if:false={isCancelAndRebillDisabled}>
                            <lightning-icon class="custom-icon" icon-name="action:priority"
                                title="Cancel and rebill only" onclick={cancelAndRebill}
                                data-my-param="CancelAndRebill"></lightning-icon>
                        </template>
                        <template if:true={isCancelAndRebillDisabled}>
                            <lightning-icon class="disabled-icon" icon-name="action:priority"
                                title="Cancel and rebill only" onclick={cancelAndRebill}
                                data-my-param="CancelAndRebill"></lightning-icon>
                        </template>
                        <div class="slds-text-body_regular slds-text-color_weak">Cancel and Rebill</div>
                    </div>

                    <div class="slds-col slds-size_1-of-2">
                        <template if:false={isCancelToAmendDisabled}>
                            <lightning-icon class="custom-icon" icon-name="action:goal"
                                title="Cancel and rebill for amendment" onclick={cancelAndRebill}
                                data-my-param="CancelToAmend"></lightning-icon>
                        </template>
                        <template if:true={isCancelToAmendDisabled}>
                            <lightning-icon class="disabled-icon" icon-name="action:goal"
                                title="Cancel and rebill for amendment" onclick={cancelAndRebill}
                                data-my-param="CancelToAmend"></lightning-icon>
                        </template>
                        <div class="slds-text-body_regular slds-text-color_weak">Cancel to Amend</div>
                    </div>
                    <lightning-spinner if:true={showSpinner} alternative-text="Loading" size="medium">
                    </lightning-spinner>
                </div>
            </lightning-tab>-->


        </lightning-tabset>
    </div>

    <!-- modal start -->
    <template if:true={isShowModal}>
        <section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
            aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
            <div class="slds-modal__container">
                <!-- modal header start -->
                <header class="slds-modal__header">
                    <button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse"
                        title="Close" onclick={hideModalBox}>
                        <lightning-icon icon-name="utility:close" alternative-text="close" variant="inverse"
                            size="small"></lightning-icon>
                        <span class="slds-assistive-text">Close</span>
                    </button>
                    <h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Send Email</h2>
                </header>

                <!-- modal body start -->
                <div class="slds-modal__content slds-p-around_medium c-container" id="modal-content-id-1">
                    <!-- <div class="c-container"> -->
                        <lightning-layout>
                            <lightning-layout-item padding="around-small" class='slds-modal__content'>
                                <div style="margin-top:5px; width:105px">Bill To Contact</div>
                            </lightning-layout-item>
                            <lightning-layout-item padding="around-small" class='slds-modal__content' style='width: 400px'>
                                <lightning-input class='slds-show_inline' label="Input Box" value={billToContactEmail} variant='label-hidden' type = 'email' disabled></lightning-input>
                            </lightning-layout-item>
                            <lightning-layout-item padding="around-small">
                                <div style="margin-top:4px">
                                    <lightning-input type="checkbox" label="Checkbox" checked={isBillToContactChecked} onchange={handleCheckboxChange} value='billToContactCheckbox' variant='label-hidden'></lightning-input>
                                </div>
                            </lightning-layout-item>
                        </lightning-layout>
                        <lightning-layout>
                            <lightning-layout-item padding="around-small" class='slds-modal__content' style='padding-right:0px'>
                                <div style="margin-top:5px; width:100px">Additional Email</div>
                            </lightning-layout-item>
                            <lightning-layout-item padding="around-small" style='padding-left:0px'>
                                <lightning-helptext style="margin-left:-5px" content="Use , or ; to enter multiple email address"></lightning-helptext>
                            </lightning-layout-item>
                            <lightning-layout-item padding="around-small" class='slds-modal__content' style='padding-left:6px; width: 392px'>
                                <!-- <lightning-input class='slds-show_inline' label="Input Box" value={inputValue} onchange={handleInputChange} variant='label-hidden' type ='email' multiple></lightning-input> -->
                                <lightning-input class='slds-show_inline' label="Input Box" value={inputValue} onchange={handleInputChange} variant='label-hidden'></lightning-input>
                            </lightning-layout-item>
                            <lightning-layout-item padding="around-small">
                                <div style="margin-top:4px">
                                    <lightning-input type="checkbox" label="Checkbox" checked={isAddEmailChecked} onchange={handleCheckboxChange} value='additionalEmailCheckBox' variant='label-hidden'></lightning-input>
                                </div>
                            </lightning-layout-item>
                        </lightning-layout>

                        <lightning-layout>
                            <lightning-layout-item padding="around-small" class='slds-modal__content' style='padding-right:0px'>
                                <div style="margin-top:5px; width:100px; margin-right:17px;">Email Template</div>
                            </lightning-layout-item>
                            <lightning-layout-item style="width: 400px; padding-left:12px" padding="around-small" class='slds-modal__content' >
                                <lightning-combobox  name="Email Template" value={templateValue} placeholder="Select Progress" options={emailTemplateOptions} onchange={handleComboboxChange} variant="label-hidden" ></lightning-combobox>
                            </lightning-layout-item>
                        </lightning-layout>
                    <!-- </div> -->
                </div>

                <!-- modal footer start-->
                <footer class="slds-modal__footer">
                    <button class="slds-button slds-button_neutral" onclick={hideModalBox}>Cancel</button>
                    <button class="slds-button slds-button_neutral" onclick={sendEmail} disabled={disableModalSendBtn}>Send</button>
                </footer>

            </div>
        </section>
        <div class="slds-backdrop slds-backdrop_open"></div>
    </template>
    <!-- modal end -->
</template>
                        
                        
                        
                        
                        
////////////////////////////////////

                        
import { LightningElement, api, wire, track } from 'lwc';
import createPaymentLink from '@salesforce/apex/InvoiceQuickActionController.createPaymentLink';
import processPayment from '@salesforce/apex/InvoiceQuickActionController.processPayment';
import getPaymentData from '@salesforce/apex/InvoiceQuickActionController.getPaymentData';
import sendEmail from '@salesforce/apex/InvoiceQuickActionController.sendEmail';
import CancelToAmend from '@salesforce/apex/InvoiceQuickActionController.CancelToAmend';
import getCancelUrl from '@salesforce/apex/InvoiceQuickActionController.cancelUrl';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from "lightning/confirm";
import emailTemplateOptions from '@salesforce/label/c.Invoice_Email_Template_Options';
export default class InvoiceQuickActions extends LightningElement {

    isCreatePaymentDisabled = false;
    isProcessPaymentDisabled = false;
    isCancelToAmendDisabled = false;
    isCancelAndRebillDisabled = false;
    isEmailSent = false;
    emailStatus = 'Send Email';
    showSpinner = false;
    isShowModal = false;
    isBillToContactChecked = true;
    isAddEmailChecked = false;
    disableModalSendBtn = false;
    billToContactEmail = '';
    additionalEmailStr = '';
    isAddEmailValid = false;
    templateValue = '';
    emailTemplates = [];
    draftInvoice = false;
    invoiceStatus = '';
    cancelUrl = 'none';

    @api recordId;
    @wire(getPaymentData, { recordId: '$recordId' })
    wiredActivities({ error, data }) {
        if (data) {
            let templateApiName = [];
            this.invoiceStatus = data.blng__InvoiceStatus__c;
            for (let charIdx in emailTemplateOptions) {
                if (
                    emailTemplateOptions[charIdx] == ',' || 
                    emailTemplateOptions[charIdx] == ';' || 
                    charIdx == emailTemplateOptions.length - 1
                ) {
                    if (charIdx == emailTemplateOptions.length - 1) {
                        templateApiName = templateApiName + emailTemplateOptions[charIdx];
                    }
                    this.emailTemplates.push(templateApiName);
                    if (data.blng__DaysOutstanding__c > 0 && 
                        templateApiName.toLowerCase().includes('past')
                    ) {
                        this.templateValue = templateApiName;
                    } else if (
                        data.blng__DaysOutstanding__c >= -5 && 
                        data.blng__DaysOutstanding__c <= 0 && 
                        templateApiName.toLowerCase().includes('reminder')
                    ) {
                        this.templateValue = templateApiName;
                    } else if (
                        data.blng__Order__r &&
                        data.blng__Order__r.SBQQ__Quote__r &&
                        data.blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c && 
                        data.blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c == true && 
                        templateApiName.toLowerCase().includes('manual')
                    ) {
                        this.templateValue = templateApiName;
                    } else if (
                        data.blng__Order__r &&
                        data.blng__Order__r.SBQQ__Quote__r &&
                        data.blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c && 
                        data.blng__Order__r.SBQQ__Quote__r.Manual_Invoice__c == false && 
                        templateApiName.toLowerCase().includes('regular')
                    ) {
                        this.templateValue = templateApiName;
                    }

                    templateApiName = '';
                } else if (
                    emailTemplateOptions[charIdx] != ' ' && 
                    emailTemplateOptions[charIdx] != ',' && 
                    emailTemplateOptions[charIdx] != ';'
                ) {
                    templateApiName = templateApiName + emailTemplateOptions[charIdx];
                }
            }

            if (data.Stripe_Payment_Url__c) {
                this.isCreatePaymentDisabled = true;
            }
            if (data.Stripe_Payment_Status__c == 'Paid') {
                this.isProcessPaymentDisabled = true;
            }
            if (data.Email_Sent__c == true) {
                this.isEmailSent = true;
                this.emailStatus = 'Resend Email';
            }

            if (data.blng__InvoiceStatus__c == 'Draft') {
                this.draftInvoice = true;
            }

            if (data.blng__InvoiceStatus__c == 'Cancelled' || data.blng__InvoiceStatus__c == 'Rebilled') {
                this.isCancelAndRebillDisabled = true;
                if (data.Cancelled_to_Amend__c == true) {
                    this.isCancelToAmendDisabled = true;
                }
            }

            if (data.blng__BillToContact__r && data.blng__BillToContact__r.Email) {
                this.billToContactEmail = data.blng__BillToContact__r.Email;
            } else {
                this.isBillToContactChecked = false;
                this.disableModalSendBtn = true;
            }

        }
        if (error) {
            console.log('Error in generatePaymentLink component', error);
        }
    }

    get emailTemplateOptions() {
        const levelValueArr = [];
        for (let charIdx in this.emailTemplates) {
            let labelObj = {}
            labelObj.value = this.emailTemplates[charIdx];
            labelObj.label = this.emailTemplates[charIdx].replaceAll('_', ' ')
            levelValueArr.push(labelObj);
        }

        return levelValueArr;
    }


    createPaymentLink() {
        this.isCreatePaymentDisabled = true;
        this.showSpinner = true;
        createPaymentLink({ invoiceId: this.recordId })
            .then((result) => {
                window.console.log('result ====> ');
                window.console.log(result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Link Succesfully Created',
                        variant: 'success',
                    }),
                );
                this.showSpinner = false;
                window.location.reload();
                console.log('result', result);
            })
            .catch((error) => {
                console.log('Error', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error In Link Generation',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                this.showSpinner = false;
                this.isCreatePaymentDisabled = false;
            });
    }

    async sendEmail() {
        this.isShowModal = false;
        this.showSpinner = true;
        const emailArray = [];
        if (this.isBillToContactChecked) {
            emailArray.push(this.billToContactEmail);
        }
        if (this.isAddEmailChecked) {
            this.additionalEmailStr = this.additionalEmailStr.replaceAll(' ', '');
            this.additionalEmailStr = this.additionalEmailStr.replaceAll(';', ',');
            emailArray.push(...this.additionalEmailStr.split(','));
        }
        sendEmail({ invoiceId: this.recordId, emailArr: emailArray, templateName: this.templateValue })
            .then((result) => {
                window.console.log('result ====> ');
                window.console.log(result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Email Succesfully Sent',
                        variant: 'success',
                    }),
                );
                this.showSpinner = false;
                this.isEmailSent = true;
                this.emailStatus = 'Resend Email';
                this.isAddEmailChecked = false;
                console.log('result', result);
            })
            .catch((error) => {
                window.console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error While Sending',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log('error', error);
                this.showSpinner = false;
            });
    }

    processStripePayment() {
        this.isProcessPaymentDisabled = true;
        this.showSpinner = true;
        processPayment({ invoiceId: this.recordId })
            .then((result) => {
                window.console.log('result ====> ');
                window.console.log(result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Satus Succesfully Updated',
                        variant: 'success',
                    }),
                );
                this.showSpinner = false;
                window.location.reload();
                console.log('result', result);
            })
            .catch((error) => {
                window.console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error While Verifyning Payment',
                        message: error.message,
                        variant: 'error',
                    }),
                );
                console.log('error', error);
                this.showSpinner = false;
            });
    }

    cancelAndRebill(event) {
        this.showSpinner = true; 
        let dataParams = event.target.dataset.myParam;       
        getCancelUrl({ invoiceId: this.recordId })
            .then((result) => {
                window.console.log('cancelUrl=>', result);
                this.cancelUrl = result;
                this.redirectToCancel(dataParams);
            })
            .catch((error) => {
                console.log('Error', error);
                this.showSpinner = false;
            }
        );
    }

    redirectToCancel(dataParams) {    
        let showMessage = true;
        // if (this.isCancelAndRebillDisabled == false) {
        //     window.location.href = this.cancelUrl;
        //     showMessage = false;
        // }

        if (dataParams == 'CancelAndRebill') {
            this.isCancelAndRebillDisabled = true;
            window.location.href = this.cancelUrl;
        } else if (dataParams == 'CancelToAmend') {

            this.isCancelToAmendDisabled = true;
            CancelToAmend({ invoiceId: this.recordId })
                .then((result) => {
                    if (showMessage == true) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success!!',
                                message: 'Sucessfully cancelled for amendment',
                                variant: 'success',
                            }),
                        );
                    }

                    this.isCancelAndRebillDisabled = true;
                    console.log('result', result);
                    showMessage = false;
                    this.showSpinner = false;
                    window.location.href = this.cancelUrl;
                })
                .catch((error) => {
                    console.log('error', error);
                    this.showSpinner = false;
                });

        }

    }

    async showModalBox() {
        this.showSpinner = true;

        if (this.invoiceStatus == 'Draft' || this.invoiceStatus == 'Rebilled' || this.invoiceStatus == 'Cancelled') {
            const result = await LightningConfirm.open({
                //message: "Send Email?",
                variant: "warning", //headerless
                theme: "warning",
                label: "Invoice is in " + this.invoiceStatus + " status. Do you still want to send email?"
            });

            if (!result) {
                this.showSpinner = false;
                return;
            }
        }

        if (this.isEmailSent == true) {
            const result = await LightningConfirm.open({
                //message: "Send Email Again?",
                variant: "default", //headerless
                theme: "shade",
                label: "Email has already been sent. Do you still want to send again?"
            });

            if (!result) {
                this.showSpinner = false;
                return;
            }
        }

        this.isShowModal = true;

        //this.sendEmail();
    }
    hideModalBox() {
        this.isShowModal = false;
        this.showSpinner = false;
    }
    handleInputChange(event) {
        this.additionalEmailStr = event.target.value;
        if (this.additionalEmailStr) {
            this.isAddEmailChecked = true;
        }
        //const regExp = new RegExp(/^(\s?[^\s,]+@[^\s,]+\.[^\s,]+\s?,)*(\s?[^\s,]+@[^\s,]+\.[^\s,]+)$/);
        const regExp = new RegExp(/^(\s?[^\s@,;]+@[^\s@,;]+\.[^\s@,;]+\s*([,;])\s*)*(\s?[^\s@,;]+@[^\s@,;]+\.[^\s@,;]+)$/i);
        //const regExp = new RegExp(/^(\s?[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+(?:\s*[;,]\s*|\s*$))+$/i);
        this.isAddEmailValid = regExp.test(this.additionalEmailStr);

        if (this.isAddEmailValid && (this.isBillToContactChecked == true || this.isAddEmailChecked == true)) {
            this.disableModalSendBtn = false;
        } else {
            this.disableModalSendBtn = true;
        }
    }

    handleCheckboxChange(event) {
        //this.isChecked = event.detail.value;
        if (event.target.checked == true) {
            if (event.target.value == 'additionalEmailCheckBox') {
                this.isAddEmailChecked = true;
            }
            if (event.target.value == 'billToContactCheckbox') {
                this.isBillToContactChecked = true;
            }
        } else {
            if (event.target.value == 'additionalEmailCheckBox') {
                this.isAddEmailChecked = false;
            }
            if (event.target.value == 'billToContactCheckbox') {
                this.isBillToContactChecked = false;
            }
        }

        if ((this.isAddEmailChecked == true)) {
            this.disableModalSendBtn = this.isAddEmailValid && this.additionalEmailStr != '' ? false : true;
        } else if ((this.billToContactEmail && this.isBillToContactChecked == true)) {
            this.disableModalSendBtn = false;
        }
        else {
            this.disableModalSendBtn = true;
        }

    }

    handleComboboxChange(event) {
        //console.log('handleComboboxChange::', event.target, event.target.value);
        this.templateValue = event.target.value;
    }

}
    
    
    
    
    
////////////////////////////

    
.slds-grid {
    display: flex;
}

.slds-col {
    flex: 1;
    text-align: center;
}

.slds-text-body_regular {
    font-size: 0.780rem;
    margin-top: 0.5rem;
    text-align: center;
}

.custom-icon {
    font-size: 1rem;
    cursor: pointer;
    filter: contrast(200%);
}

.disabled-icon {
    filter: grayscale(100%);
    pointer-events: none;
}
    
  //////////////////////
    
    <?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>55.0</apiVersion>
      <targets>
    <target>lightning__RecordPage</target>
    </targets>
    <isExposed>true</isExposed>
</LightningComponentBundle>
        
        
/////////////////////////////////////



<template>
  <lightning-card title="Invoice Information">

    <div class="spinner">
      <template if:true={isLoading}>
        <lightning-spinner alternative-text="Loading" variant="brand" size="large">
        </lightning-spinner>
      </template>
    </div>

    <div class="slds-var-p-horizontal_medium">
      <p style="margin-top: 10px; margin-bottom: 5px;"><strong>Invoice Status: </strong>{invoiceStatus}</p>
    </div>

    <div class="slds-var-p-horizontal_medium">
      <p style="margin-top: 10px; margin-bottom: 5px;"><strong>Email Status: </strong>{emailSentMsg}</p>
    </div>

    <div class="slds-var-p-horizontal_medium">
      <p style="margin-top: 10px; margin-bottom: 5px;"><strong>Payment Status: </strong>{paymentStatus}</p>
    </div>
    
    <div class="slds-var-p-horizontal_medium" if:false={orderFound}>
      <p style="font-weight:bold; margin-top: 10px; margin-bottom: 5px;">Order Error:</p>
      <p>Order not found.</p>
    </div>

    <div class="slds-var-p-horizontal_medium" if:true={isInvoiceStatusError}>
      <p style="font-weight:bold; margin-top: 10px; margin-bottom: 5px;">Invoice Error:</p>
      <p>{taxErrorMsg}</p>
    </div>

    <div class="slds-var-p-horizontal_medium" if:true={uniqueInvoiceLineErrorsLen}>
      <p style="font-weight:bold; margin-top: 10px; margin-bottom: 5px;">Invoice Line Item Errors:</p>
      <ul>
        <template for:each={uniqueInvoiceLineErrors} for:item="err">
          <li key={err.count}>
            <p>{err.error}</p>
          </li>
        </template>
      </ul>
    </div>

    <div class="slds-var-p-horizontal_medium" if:true={invoiceLinesWithNoTaxTreatmentLen}>
      <p style="font-weight:bold; margin-top: 10px; margin-bottom: 5px;">Tax Treatment Missing on Invoice Lines:</p>
      <ul>
        <template for:each={invoiceLinesWithNoTaxTreatment} for:item="taxTreatmentLine">
          <li key={taxTreatmentLine.id}>
            <p><a href={taxTreatmentLine.link}>{taxTreatmentLine.name}</a></p>
          </li>
        </template>
      </ul>
    </div>

    <div class="slds-var-p-horizontal_medium" if:true={orderProductErrorsLen}>
      <p style="font-weight:bold; margin-top: 10px; margin-bottom: 5px;">Legal Entity Missing on Order Product:</p>
      <ul>
        <template for:each={orderProductErrors} for:item="orderProductError">
          <li key={orderProductError.id}>
            <p><a href={orderProductError.link}>{orderProductError.name}</a></p>
          </li>
        </template>
      </ul>
    </div>

  </lightning-card>
</template>
                
                
///////////////////////////////

                
                
import { LightningElement, api } from 'lwc';
import getInvoiceStatus from '@salesforce/apex/InvoiceStatusController.getInvoiceStatus';

export default class InvoiceStatus extends LightningElement {
  @api recordId;
  isLoading = true;
  taxErrorMsg = 'No tax error found.';
  emailSentMsg = 'Email was not sent.'
  orderFound = true;
  invoiceStatus = '';
  paymentStatus = '';
  uniqueInvoiceLineErrors = [];
  invoiceLinesWithNoTaxTreatment = [];
  orderProductErrors = [];

  get uniqueInvoiceLineErrorsLen() {
    return this.uniqueInvoiceLineErrors.length > 0;
  }
  get invoiceLinesWithNoTaxTreatmentLen() {
    return this.invoiceLinesWithNoTaxTreatment.length > 0;
  }
  get orderProductErrorsLen() {
    return this.orderProductErrors.length > 0;
  }
  get isInvoiceStatusError() {
    return this.invoiceStatus == 'Error';
  }

  connectedCallback() {
    getInvoiceStatus({ invoiceId: this.recordId })
      .then(result => {
        console.log("Invoive Comp Res:", result);

        if (
          result.invoiceRecord.blng__Order__c == undefined ||
          result.invoiceRecord.blng__Order__c == null ||
          result.invoiceRecord.blng__Order__c == ''
        ) {
          this.orderFound = false;
        }

        this.invoiceStatus = result.invoiceRecord.blng__TaxStatus__c;
        if (result.invoiceRecord.blng__TaxStatus__c == 'Error') {
          this.taxErrorMsg = 'Tax Error: ' + result.invoiceRecord.blng__TaxErrorMessage__c;
        }

        this.paymentStatus = result.invoiceRecord.blng__PaymentStatus__c;

        const invoiceLineErrors = new Set();
        const taxTreatmentErr = [];
        for (let invoiceLineItem of result.invoiceRecord.blng__InvoiceInvoiceLines__r) {
          if (invoiceLineItem.blng__TaxStatus__c == 'Error') {
            invoiceLineErrors.add(invoiceLineItem.blng__TaxErrorMessage__c);
          }
          if (
            invoiceLineItem.blng__TaxTreatment__c == undefined ||
            invoiceLineItem.blng__TaxTreatment__c == null ||
            invoiceLineItem.blng__TaxTreatment__c == '') {
            taxTreatmentErr.push({
              id: invoiceLineItem.Id,
              name: invoiceLineItem.Name,
              link: '/' + invoiceLineItem.Id
            });
          }
        }

        //loop the set
        let invoiceLineErrorsArr = [];
        let count = 1;
        for (let invoiceLineError of invoiceLineErrors) {
          invoiceLineErrorsArr.push({ error: invoiceLineError, count: count++ });
        }
        this.uniqueInvoiceLineErrors = invoiceLineErrorsArr;
        this.invoiceLinesWithNoTaxTreatment = taxTreatmentErr;

        //orderItemRecords
        const orderItemsError = [];
        for (let orderItemLine of result.orderItemRecords) {
          if (orderItemLine.blng__LegalEntity__c == undefined ||
            orderItemLine.blng__LegalEntity__c == null ||
            orderItemLine.blng__LegalEntity__c == '') {
            orderItemsError.push({
              id: orderItemLine.Id,
              name: orderItemLine.Product2.Name + "(" + orderItemLine.OrderItemNumber + ")",
              link: '/' + orderItemLine.Id
            });
          }
        }
        this.orderProductErrors = orderItemsError;

        if (result.invoiceRecord.Email_Sent__c == true) {

          if (result.invoiceRecord.Last_Emailed_Date__c == undefined ||
            result.invoiceRecord.Last_Emailed_Date__c == null ||
            result.invoiceRecord.Last_Emailed_Date__c == '') {
            this.emailSentMsg = 'Email was sent.'
          } else {
            let dt = new Date(result.invoiceRecord.Last_Emailed_Date__c)
            this.emailSentMsg = 'Email was sent on ' + dt.toDateString()+".";
          }
        }

        this.isLoading = false;
      })
      .catch((error) => {
        console.log("Error:" + JSON.stringify(error));
        this.isLoading = false;
      });
  }
}
    
    
///////////////////////////


*/
    
        
                        
                        
    



}