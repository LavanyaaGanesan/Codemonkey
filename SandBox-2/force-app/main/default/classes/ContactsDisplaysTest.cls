/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test Class for IndirectSalesBatch class.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  10-Jan-2020
* *************************************************************** */
@isTest
private class ContactsDisplaysTest {
 /* ***************************************************************
    * @description: Method to create and store test data.
    * @Change:  
    * *************************************************************** */   
     private static testMethod void createContact()
    {
        //Creation and insertion of Account object test data. 
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        system.debug('Acc Id = '+acc.Id);
        //Creation and insertion of SalesPlanner object test data. 
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2020';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        //Creation and insertion of Contact object test data. 
        Contact cont = new Contact();
        cont.LastName='Test';
        cont.MobilePhone='1234567890';
        cont.Phone='123466789012';
        
        cont.Accountid= acc.id;
        insert cont;
        //start the code coverage execution
        Test.startTest();
        //To get the contact records from query.
        ContactsDisplays.getContacts(sp.id);
        Contact[] conn = [select Title,Phone,email,Name,Primary_Contact__c,Status__c,Contact_Relationship__c,Role__c from contact where accountid =: acc.id];

        system.assertEquals(1, conn.size());
        ContactsDisplays.getSalesPlanner(sp.id);
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:sp.id ];

        String result =ContactsDisplays.getIconName('Contact');
        //Stop the code coverage execution
        test.stopTest();
        
    }
    
    private static testMethod void createContact1()
    {
        //Creation and insertion of Account object test data. 
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;

       //Creation and insertion of Account object test data. 
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2020';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        //Creation and insertion of Contact object test data. 
        Contact cont = new Contact();
        cont.LastName='Test';
        cont.MobilePhone='1234567890';
        cont.Phone='123466789012';

        cont.Accountid= acc.id;
        insert cont;
        //start the code coverage execution
        Test.startTest();
        //To get the contact records from query.
        ContactsDisplays.getContacts(sp.id);
        Contact[] conn = [select Title,Phone,email,Name,Primary_Contact__c,Status__c,Contact_Relationship__c,Role__c from contact where accountid =: acc.id];

        system.assertEquals(1, conn.size());
        ContactsDisplays.getSalesPlanner(sp.id);
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:sp.id ];

        String result =ContactsDisplays.getIconName('Sales_Planner__c');
        //Stop the code coverage execution
        test.stopTest();
        
    }
    
}