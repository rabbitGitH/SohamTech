trigger afterUpdate on Customer__c (before Update,after insert) 
{
 /* if(trigger.isupdate){
      system.debug(' # trigger #');
      set<id> setId = new set<id>();
      for(Customer__c  cus:trigger.new)
      {
         setId.add(cus.id);
      }
      
      //for(invoices
      }
      id cusId;
       for(Customer__c  cus: trigger.new)
         {
       cusId =  cus.id;
       }
      
      list<Customer__c> updateList = new list<Customer__c>();
      if(trigger.isInsert)
      
      
      {
         for(Customer__c  cus: [select id,firstName__c from Customer__c   where id =:cusId])
         {
             cus.firstName__c = 'after Insert';
             updateList.add(cus);
           
         }
           update updateList;
      }
      */
      
      if(trigger.isupdate){
      
      set<id> setId = new set<id>();
      
      for(Customer__c  cus:trigger.new)
      {
      
     date tt =  cus.Date_c__c;
     double Last_Day_of_End_Date_Month = tt.day();
     
     date tempEndDate = cus.LastInvoiceAcitvityDate__c + 1 ;
                     
                    double diffBet_tempEndDate_FirstDayOfNextQuarter = tempEndDate.daysBetween(cus.Invoice_latest_Date__c);
                    
                    system.debug('Last_Day_of_End_Date_Month'+Last_Day_of_End_Date_Month);
                    system.debug('diffBet_tempEndDate_FirstDayOfNextQuarter'+diffBet_tempEndDate_FirstDayOfNextQuarter );
                     
    //  decimal NextQuarterValuee =  (FLOOR(((cus.LastInvoiceAcitvityDate__c +1-cus.Invoice_latest_Date__c)/365)*12)* cus.a_value__c) + ((cus.b_value__c/DAY(cus.Date_c__c))*cus.a_value__c);


                    
                   double NextQuarterValue =  ((((diffBet_tempEndDate_FirstDayOfNextQuarter)/365)*12)* 
                  cus.a_value__c) + ((cus.b_value__c/Last_Day_of_End_Date_Month)*cus.a_value__c); 
          
          
                    date aa                           = CUS.LastInvoiceAcitvityDate__c;
                    Decimal Temp_End_Date             = aa.day();
                    date bb                           = CUS.Invoice_latest_Date__c;
                    Decimal First_Day_of_Next_Quarter = bb.day();
                    date EER                          = CUS.Date_c__c;
                    Decimal DateT                     = EER.day();
          
  DECIMAL FORMULA = ((((Temp_End_Date +1-First_Day_of_Next_Quarter)/365)*12)* CUS.a_value__c) + ((CUS.b_value__c/(DateT))*CUS.a_value__c);
          
                     
                    //((((LastInvoiceAcitvityDate__c +1-Invoice_latest_Date__c)/365)*12)* a_value__c) + ((b_value__c/DAY(Date_c__c))*a_value__c)     
                                              
   // double NextQuarterValue = ((diffBet_tempEndDate_FirstDayOfNextQuarter)/365)*12;
    
  double qqq =  (((diffBet_tempEndDate_FirstDayOfNextQuarter)/365)*12);
      
       date qw = cus.LastInvoiceAcitvityDate__c;
       decimal pp = qw.day();
       date ee = cus.Invoice_latest_Date__c;
       decimal op = ee.day();
       decimal ppp = (((pp +1-op)/365)*12);
   system.debug('ppp'+ppp);                                           
     cus.d_value__c =   FORMULA;
     
     }
     }
     }