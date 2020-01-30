@isTest
private class AccHierarchyApexTest {
  
      private static testMethod void createAcc()
    {
        
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='Test25';
        acc1.Outlet_Name__c = 'Test1';
        acc1.ParentId= acc.id;
        insert acc1;
        system.debug('Acc Id = '+acc.Id);
        
        Sales_Planner__c   sp = new  Sales_Planner__c();
        sp.Name ='Test Sp 2019';
        sp.Sales_Planner_Year__c='2019';
        sp.Account_Sales_Planner__c = acc.id;
        insert  sp;
        
         
    

        
        
        
        
      
        Test.startTest();
        //ContactsDisplay cD=new ContactsDisplay();
        AccHierarchyApex.getAccountId(sp.id);
       String spId= sp.id;
         String recId= acc.id;
         String recId1= sp.id;
        
        List <Account> ac =  new List<Account>();
         spId =  [select id ,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:spId LIMIT 1].Account_ID__c;
       // String formattedDate = string.valueOf(ta.ActivityDate.month())+'-'+string.valueOf(ta.ActivityDate.day())+'-'+string.valueOf(ta.ActivityDate.year());   
         
        AccHierarchyApex.findHierarchyData (recId1);
    //   recId = [select id ,name,Account_Sales_Planner__c,Parent_Account__c,Account_ID__c from Sales_Planner__c where id =:recId LIMIT 1].Account_ID__c;
        
         AccHierarchyApex.GetUltimateParentId(recId);
        string queryString = 'select id ,name, ParentId from Account where Id =:recId LIMIT 1';
      
        test.stopTest();
        
    }
    
    
}