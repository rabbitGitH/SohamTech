trigger AutoCreateOpp on Account (after insert) {
    // Every trigger has this loop!
    for (Account a : Trigger.new) {
        // Check if it's a 'Prospect' Account
        if (a.Type == 'Prospect') {
            // Create a new Opp (but don't save yet)
            Opportunity o = new Opportunity();
            o.Name = 'Big Deal';
            o.StageName = 'Prospecting';
            o.CloseDate = Date.today().addDays(30);
            o.AccountId = a.Id;
            
            // Set the Opp amount based on the Industry
            if (a.Industry == 'Technology') {
                o.Amount = 5000000;
            } else if (a.Industry == 'Non-Profit') {
                o.Amount = 1000;
            } else {
                o.Amount = 5000;
            }
            
            // Double the Opp amount if there are many employees!
            Integer bigCompanyMultiplier = 2;
            if (a.NumberOfEmployees > 1000) {
                o.Amount = o.Amount * bigCompanyMultiplier;
            }
            
            // Don't forget to save!
            insert o;
        }
    }

}