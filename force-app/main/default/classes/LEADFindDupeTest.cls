@isTest

private class LEADFindDupeTest {

@isTest

static void test() {

   contact con = new contact ();
   con.lastname = 'abc';
   con.email = 'Rt@gmail.com';
   insert con;
   
   lead ld = new lead ();
   ld.lastname = 'abcdd';
   ld.company = 'abce';
   //ld.email = 'Rt@gmail.com';
   insert ld;
   
   lead l = new lead ();
   l.lastname = 'abcs';
   l.company = 'abct';
   l.email = 'Rt@gmail.com';
   try{
   insert l;
   }
    catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}
}
}