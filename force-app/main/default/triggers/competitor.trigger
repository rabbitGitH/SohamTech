trigger competitor on opportunity (before insert, before update) {

     for(opportunity opp : trigger.new) {
     
         List<Decimal> CompetitorsPrices = new List<Decimal>();
         
         CompetitorsPrices.add(opp.Competitor_1_price__c);
         CompetitorsPrices.add(opp.Competitor_2_price__c); 
         CompetitorsPrices.add(opp.Competitor_3_price__c); 
         
         List<String> Competitors = new List<string>();
         
         Competitors.add(opp.Competitors_1__c);     
         Competitors.add(opp.Competitors_2__c);
         Competitors.add(opp.Competitors_3__c);
         
         Decimal LowestPrice;
         integer LowestPricePostion;
         
         for(integer i=0;i<CompetitorsPrices.size();i++){
         Decimal currentPrice = CompetitorsPrices.get(i);
         
         if(LowestPrice==NULL || currentPrice < LowestPrice){
         LowestPrice = currentPrice;
         LowestPricePostion = i;
         
         }
         }
         opp.Leading_Competitor__c = Competitors.get(LowestPricePostion );
         }
         }