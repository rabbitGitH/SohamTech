@isTest

private class competitorTest {

@isTest 

static void test() {

   opportunity opp = new opportunity ();
   
   opp.Name        = 'ABC';
   opp.CloseDate   = Date.today();
   opp.StageName   = 'Closed Won';
   
   insert opp;
   
   }
   }