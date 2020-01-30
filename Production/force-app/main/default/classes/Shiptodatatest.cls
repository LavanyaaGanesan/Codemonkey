/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Test Class for Shiptodata class.
* @Change:  
* @last modify by:   Archie Bisen
* @last modify date:  9-Jan-2020
* *************************************************************** */
@isTest
public class Shiptodatatest {
   
      public static testMethod void createAcc()
    {
        //create a record for acccount
        Account acc = new Account();
        acc.Name='Test24';
        acc.Outlet_Name__c = 'Test1';
        
        insert acc;
         //create a record for Daily_Sales_Data__c
        Daily_Sales_Data__c ds = new  Daily_Sales_Data__c();
        ds.Name ='Test 2019';
        ds.ShipTo_Type__c= 'Direct';
        ds.DDD_Outlet_ID__c= '23456788';
        ds.Account__c = acc.id;
        insert  ds;
         //create a record for ShipTo_Information__c
        ShipTo_Information__c st = new ShipTo_Information__c();
        st.Name ='Test 2019';
        st.Account__c = acc.id;
        st.ShipTo_Type__c ='Direct';
        st.DDD_Outlet_ID__c = '23456788';
        insert  st;
        //Execution of fetchDailysalesData and fetchDailysalesData1 methods by passing the values.
        Test.startTest();
       
        Shiptodata.fetchDailysalesData(acc.id,5,5,'1');
        Shiptodata.fetchDailysalesData1(acc.id,5,5,'2');
      Shiptodata.fetchAllDailysalesData(acc.id);
        Shiptodata.fetchDailysalesData1(acc.id,5,5,'1');
        Shiptodata.fetchDailysalesData(acc.id,5,5,'2');
         String recId= acc.id;
         String recId1= acc.id;
        //Fetch the following data by executing the query
        List <Account> ac =  new List<Account>();
       ShipTo_Information__c[] si  =  [SELECT IsDelete__c, Id, Name, CreatedDate, CreatedById, LastModifiedDate,City__c,Country__c,State__c,Zip__c,
           													Address__c,Ship_To__c,LastModifiedById, DDD_Outlet_ID__c,ShipTo_Type__c, Account__c,Account__r.Name 
                                                          FROM ShipTo_Information__c where Account__c=: acc.Id AND IsDelete__c!= True Order by ShipTo_Type__c,LastModifiedDate];

        test.stopTest();
        
    }
    
    

}