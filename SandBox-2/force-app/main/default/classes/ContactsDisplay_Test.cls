@isTest
private class ContactsDisplay_Test {
    
    private static testMethod void createContact()
    {
        
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        system.debug('Acc Id = '+acc.Id);
        
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2019';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        
        Contact cont = new Contact();
        cont.LastName='Test';
        // cont.Account ='CARNEGIE MELLON UNIV';
        cont.Accountid= acc.id;
        insert cont;
        system.debug('::::cont.Accountid::::::'+cont.Accountid);
        System.debug(':::cont::::::;'+cont);
        
        Test.startTest();
        //ContactsDisplay cD=new ContactsDisplay();
        ContactsDisplays.getContacts(sp.id);
        Contact[] conn = [select Title,Phone,email,Name,Primary_Contact__c,Status__c,Contact_Relationship__c,Role__c from contact where accountid =: acc.id];
        system.debug('::::::::::conn:::::::::'+conn);
        system.assertEquals(1, conn.size());
        test.stopTest();
        
    }
    
}