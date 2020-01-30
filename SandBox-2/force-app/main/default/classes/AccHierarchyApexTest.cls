/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: AccHierarchyApexTest is used to provide test data for AccHierarchyApex for code coverage.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  10-Jan-2020
* *************************************************************** */
@isTest
private class AccHierarchyApexTest {
    /* ***************************************************************
* @description: calling function to pass test data to AccHierarchyApex class for code coverage
* @Change:
* *************************************************************** */
    private static testMethod void createAcc()
    {
        //insert test account data
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='Test25';
        acc1.Outlet_Name__c = 'Test1';
        acc1.ParentId= acc.id;
        insert acc1;
        
        //insert test salesplanner data related to test account created.
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2020';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        
        Test.startTest();
        //test salesplanner id is passed as paramater to getAccountId method of AccHierarchyApex class to get account id.
        AccHierarchyApex.getAccountId(sp.id);
        String spId= sp.id;
        String recId= acc.id;
        String recId1= sp.id;
        
        List <Account> ac =  new List<Account>();
        //retrieve Account Id of test salesplaner sp.
        spId =  [select id ,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:spId LIMIT 1].Account_ID__c;
        //test salesplanner id is passed as paramater to findHierarchyData method of AccHierarchyApex class.
        AccHierarchyApex.findHierarchyData (recId1);
        //test account id is passed as paramater to GetUltimateParentId method of AccHierarchyApex class.
        AccHierarchyApex.GetUltimateParentId(recId);
        string queryString = 'select id ,name, ParentId from Account where Id =:recId LIMIT 1';
        
        test.stopTest();
        
    }
    
    
}