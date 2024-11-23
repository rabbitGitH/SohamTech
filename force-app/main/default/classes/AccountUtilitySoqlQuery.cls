public class AccountUtilitySoqlQuery{

public static void viewAnnualRevenue(){


list<account>accountlist=[select id,name,AnnualRevenue from account ];
for(account a : accountlist){

system.debug('Account Name :'+a.name+  'Annual Revenue  :'+a.AnnualRevenue );

}
}
}