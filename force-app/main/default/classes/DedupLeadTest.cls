@isTest

private class DedupLeadTest {

@isTest

static void test() {


    
    contact con = new contact ();
    con.email = 'Rosee@gmail.com';
    con.firstname = 'abc';
   // con.account.name = null;
    con.lastname = 'test';
    insert con;
    
    lead ld = new lead ();
    ld.email='Rosee@gmail.com';
    ld.description='abc';
    ld.lastname='abc';
    ld.company='abc';
    insert ld;
    
    }
    }