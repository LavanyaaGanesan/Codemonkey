@isTest
private class NewTaskMapApexTest {

private static testMethod void testAutoRun() {

 test.startTest();
   PageReference pageRef = Page.salesplanner;
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
   Test.setCurrentPage(pageRef);
   pageRef.getParameters().put('id',sp.id);
   ApexPages.StandardController sc = new ApexPages.standardController(sp);
  
  
   
   test.stopTest();
}

}