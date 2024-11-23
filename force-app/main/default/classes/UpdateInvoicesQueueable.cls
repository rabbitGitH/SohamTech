public class UpdateInvoicesQueueable implements Queueable {
    List<Invoices__c> invoicesToUpdate;

    public UpdateInvoicesQueueable(List<Invoices__c> invoices) {
        this.invoicesToUpdate = invoices;
    }

    public void execute(QueueableContext context) {
        for (Invoices__c invoice : invoicesToUpdate) {
            invoice.master_invoice__c = true;
        }
        update invoicesToUpdate;
    }
}