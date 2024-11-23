trigger ComparableOpps on Opportunity (after insert) {

            for(Opportunity opp : trigger.new) {
                //Query account info for our opp
                Opportunity OppWithAccountInfo = [SELECT Id,
                                                         Account.Industry
                                                    FROM Opportunity
                                                   WHERE Id = :opp.Id
                                                   LIMIT 1];
                if(opp.Amount != NULL){
                //Get our bind veriable ready
                Decimal minAmount = opp.Amount * 0.9;
                Decimal maxAmount = opp.Amount * 1.1;
                // Search for comparable opps
                List<Opportunity> comparableOpps = [SELECT Id
                                                      FROM Opportunity
                                                     WHERE Amount >= :minAmount
                                                       AND Amount <= :maxAmount
                                                       AND Account.Industry = :OppWithAccountInfo.Account.Industry
                                                       AND StageName = 'Closed Won'
                                                       AND CloseDate >= LAST_N_Days:77
                                                   //  AND Owner.Position_Start_Date__c < LAST_N_DAYS:365
                                                       AND Id != :opp.Id];  
                System.debug('Comparable opp(s) found: ' + comparableOpps);
                //For each comparable opp, create a comparable__c record 
                List<Comparable__c> junnctionObjsToInsert = new List<Comparable__c>();
                for(Opportunity comp : comparableOpps) {
                    Comparable__c junctionObj             = new Comparable__c();
                    junctionObj.Base_Opportunity__c       = opp.Id;
                    junctionObj.Comparable_Opportunity__c = comp.Id;
                    junnctionObjsToInsert.add(junctionObj);
                } 
                insert junnctionObjsToInsert;
            }
        }
        }