/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test Class for IndirectSalesBatch class.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  8-Jan-2020
* *************************************************************** */
@isTest
public class IndirectDailySalesBatchTest {
 @isTest
    public static void TestMeth()
    {
       //To provide profileID for the test user.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        //Creation of user test data.
        User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser2@gmail.com');
        insert u;
        //insert test data for file to be process in IndirectDailySalesBatch class.
        String csvContent ='DDD_Id,INVOICE,DATE,CUST,SHIP#,SH.NAME,SH.ADDR,SH.CITY,SH.ST,SH.ZIP,PART,DESC,NUM\n'
            +'55443200,32315,19/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'55443200,32315,20/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'5543200,32315,20/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'55443200,32315,10/20/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'5543200,32315,10/20/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'12345679,32315,19/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722';
            
        list<String> rows = new list<String>(csvContent.split('\n'));
        system.debug('rowsize--------- '+rows.size());
      
        system.runAs(u)
        {
            // for uploading the file in file object.
            ContentVersion cv = new ContentVersion();
            cv.VersionData = Blob.valueOf(csvContent);
            cv.Title = 'IDS-test';
            cv.PathOnClient = 'filename';
            cv.OwnerId=u.id;
            insert cv;
        }
        //to store account records with the fields.
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='55443200';
        a.ShipTo_ID__c='1234567890';
        insert a;
        
        Account a1 = new Account();
        a1.Name='Test';
        a1.DDD_Outlet_ID__c='12345679';
        a1.ShipTo_ID__c='1234567899';
        insert a1;
        
        Account a2 = new Account();
        a2.Name='Test';
        a2.DDD_Outlet_ID__c='55443200';
        a2.ShipTo_ID__c='9999999999';
        insert a2;
        
        Account a3 = new Account();
        a3.Name='Test';
        a3.DDD_Outlet_ID__c='12345678';
        a3.ShipTo_ID__c='9999999999';
        insert a3;
        // store records in shipto information object.
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
        insert sToinfo;
        //store records in daily sales object.
        Daily_Sales_Data__c DSInfo = new Daily_Sales_Data__c();
        DSInfo.Account__c= a.Id;
        DSInfo.ShipTo_ID__c= a.ShipTo_ID__c;
        DSInfo.ShipTo_Date__c= Date.today();
        DSInfo.Quantity__c= 30;
        DSInfo.ShipTo_Type__c='Direct';                               
        DSInfo.Invoice__c= '131624268';
        DSInfo.Invoice_Line__c='1';
        DSInfo.Reason_for_Transaction__c= 'Not assigned';
        DSInfo.NDC__c= '70460-0001-01';
        DSInfo.Item_Category__c='Standard Item';
        DSInfo.Material_Description__c='Vaxchora pwd 1/EA';
        insert DSInfo;
        
        system.runAs(u)
        {
            //To execute Indirect Batch class
            Test.startTest();
            IndirectDailySalesBatch idsb = new IndirectDailySalesBatch();
            DataBase.executeBatch(idsb);
            Test.stopTest();
        }
        }
    
 @isTest
    public static void TestMeth2()
    {
        
        //To provide profileID for the test user.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        //Creation of user test data.
        User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser3@gmail.com');
        insert u;
         //insert test data for file to be process in IndirectDailySalesBatch class.
        String csvContent ='DDD_Id,INVOICE,DATE,CUST\n,SHIP#,SH.NAME,SH.ADDR,SH.CITY,SH.ST,SH.ZIP,PART,DESC,NUM\n'
            +'55443200,32315,19/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'55443200,32315,20/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'5543200,32315,20/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'12345679,32315,19/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722';
            
        list<String> rows = new list<String>(csvContent.split('\n'));
        system.debug('rowsize--------- '+rows.size());
        
        // for uploading the file in file object.
        
        system.runAs(u)
        {
            ContentVersion cv = new ContentVersion();
            cv.VersionData = Blob.valueOf(csvContent);
            cv.Title = 'IDS-test';
            cv.PathOnClient = 'filename';
            cv.OwnerId=u.id;
            insert cv;
        }
        //insert account records with fields.
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='55443200';
        a.ShipTo_ID__c='1234567890';
        insert a;
        
        Account a1 = new Account();
        a1.Name='Test';
        a1.DDD_Outlet_ID__c='12345679';
        a1.ShipTo_ID__c='1234567899';
        insert a1;
        
        Account a2 = new Account();
        a2.Name='Test';
        a2.DDD_Outlet_ID__c='55443200';
        a2.ShipTo_ID__c='9999999999';
        insert a2;
        
        Account a3 = new Account();
        a3.Name='Test';
        a3.DDD_Outlet_ID__c='12345678';
        a3.ShipTo_ID__c='9999999999';
        insert a3;
        // store records in shipto information object.
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
        insert sToinfo;
       // store records in Daily_Sales_Data__c object.
        Daily_Sales_Data__c DSInfo = new Daily_Sales_Data__c();
        DSInfo.Account__c= a.Id;
        DSInfo.ShipTo_ID__c= a.ShipTo_ID__c;
        DSInfo.ShipTo_Date__c= Date.today();
        DSInfo.Quantity__c= 30;
        DSInfo.ShipTo_Type__c='Direct';                               
        DSInfo.Invoice__c= '131624268';
        DSInfo.Invoice_Line__c='1';
        DSInfo.Reason_for_Transaction__c= 'Not assigned';
        DSInfo.NDC__c= '70460-0001-01';
        DSInfo.Item_Category__c='Standard Item';
        DSInfo.Material_Description__c='Vaxchora pwd 1/EA';
        insert DSInfo;
        
       // for uploading the file in file object.
        system.runAs(u)
        {
            Test.startTest();
            IndirectDailySalesBatch idsb = new IndirectDailySalesBatch();
            DataBase.executeBatch(idsb);
            Test.stopTest();
        }
    }
     @isTest
    public static void TestMeth3()
    {
        
        //To provide profileID for the test user.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        //Creation of user test data.
        User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser4@gmail.com');
        insert u;
        //insert test data for file to be process in IndirectDailySalesBatch class.
        String csvContent ='DDD_Id,INVOICE,DATE,CUST\n,SHIP#,SH.NAME,SH.ADDR,SH.CITY,SH.ST,SH.ZIP,PART,DESC,NUM\n'
            +'55443200,32315,19/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'55443200,32315,20/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'5543200,32315,20/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722\n'
            +'12345679,32315,19/10/2019,184440,1,E7_HEALTH,500_E_WINDMILL_LN,LAS_VEGAS,NV,89123,0775-0001-01,VAXCHORA-ORAL_CHOLERA,722';
            
        list<String> rows = new list<String>(csvContent.split('\n'));
        system.debug('rowsize--------- '+rows.size());
        
       //insert account records with fields.
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='55443200';
        a.ShipTo_ID__c='1234567890';
        //insert account record.
        insert a;
        
        Account a1 = new Account();
        a1.Name='Test';
        a1.DDD_Outlet_ID__c='12345679';
        a1.ShipTo_ID__c='1234567899';
        insert a1;
        
        Account a2 = new Account();
        a2.Name='Test';
        a2.DDD_Outlet_ID__c='55443200';
        a2.ShipTo_ID__c='9999999999';
        insert a2;
        
        Account a3 = new Account();
        a3.Name='Test';
        a3.DDD_Outlet_ID__c='12345678';
        a3.ShipTo_ID__c='9999999999';
        insert a3;
        //insert ShipTo_Information__c records with fields.
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
        insert sToinfo;
        //insert Daily_Sales_Data__c records with fields.
        Daily_Sales_Data__c DSInfo = new Daily_Sales_Data__c();
        DSInfo.Account__c= a.Id;
        DSInfo.ShipTo_ID__c= a.ShipTo_ID__c;
        DSInfo.ShipTo_Date__c= Date.today();
        DSInfo.Quantity__c= 30;
        DSInfo.ShipTo_Type__c='Direct';                               
        DSInfo.Invoice__c= '131624268';
        DSInfo.Invoice_Line__c='1';
        DSInfo.Reason_for_Transaction__c= 'Not assigned';
        DSInfo.NDC__c= '70460-0001-01';
        DSInfo.Item_Category__c='Standard Item';
        DSInfo.Material_Description__c='Vaxchora pwd 1/EA';
        insert DSInfo;
        
     // for uploading the file in file object.
        system.runAs(u)
        {
            Test.startTest();
            IndirectDailySalesBatch idsb = new IndirectDailySalesBatch();
            DataBase.executeBatch(idsb);
            Test.stopTest();
        }
  
    }
   
}