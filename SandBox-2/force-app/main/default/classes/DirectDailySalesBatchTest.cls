/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Test Class used to provide test data to the DirectDailySalesBatch class.
* @Change:  
* @last modify by: Prashant Damke
* @last modify date:  8-Jan-2020
* *************************************************************** */
@isTest
public class DirectDailySalesBatchTest {
    @isTest
    /* ***************************************************************
	* @description: function to provide test data to the DirectDailySalesBatch class
	* @Change:
	* *************************************************************** */
    public static void TestMeth()
    {
        //fetch profile to assign to test user data.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        //test user data.
        User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser00@gmail.com');
        //insert user
        insert u;
        //Test data of the file upload.
        String csvContent ='Created_On,Ship_Date,Invoice_,Invoice_Line,Item_Category,Sales_,Sales_Line,Customer_PO_Number,Customer_Reference_1,Customer_Reference_2,Customer_Reference_3,Customer_Reference_4,Customer_Reference_5,Customer_Reference_6,Reason_for_Transaction,Terms_of_Payment,Plant,Delivery_,Delivery_Line,Contract_Number,Assignment_Number,External_Number,Sold_To,Sold_To_Name,Material,Material_Description,NDC,Vendor_Batch,Expiry_Date,Ship_To_DEA,Ship_To_HIN,Ship_To_Classification,Ship_To,Ship_To_Name,Ship_To_Street,c,Ship_To_State,Ship_To_Postal_Cd,Invoice_Qty,Discount_Amount,Net_Value,Unit_Price,Ext_WAC,WAC_Unit_Pric\n'
            +'1/23/2019,1/1/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,23456234,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225\n'
            +'1/23/2019,1/1/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,1234567890,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225\n'
            +'1/23/2019,1/2/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,9999999999,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225\n'
            +'1/23/2019,1/3/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,9999999999,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225'
            +'1/23/2019,1/3/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,345345435,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225';
        list<String> rows = new list<String>(csvContent.split('\n'));
		//to upload file in the file object.
        system.runAs(u)
        {
            ContentVersion cv = new ContentVersion();
            cv.VersionData = Blob.valueOf(csvContent);
            cv.Title = 'DS-test';
            cv.PathOnClient = 'filename';
            cv.OwnerId=u.id;
            insert cv;
        }
        //create test account data with different DDD_Outlet_ID__c and ShipTo_ID__c
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='12345678';
        a.ShipTo_ID__c='1234567890';
        insert a;
        
        Account a1 = new Account();
        a1.Name='Test';
        a1.DDD_Outlet_ID__c='12345679';
        a1.ShipTo_ID__c='1234567899';
        insert a1;
        
        Account a2 = new Account();
        a2.Name='Test';
        a2.DDD_Outlet_ID__c='12345678';
        a2.ShipTo_ID__c='9999999999';
        insert a2;
        
        Account a3 = new Account();
        a3.Name='Test';
        a3.DDD_Outlet_ID__c='12345678';
        a3.ShipTo_ID__c='9999999999';
        insert a3;
        //to insert test data for ShipTo_Information__c record
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
        insert sToinfo;
        //to insert test Daily_Sales_Data__c record
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
            Test.startTest();
            //Create a instance of DirectDailySalesBatch class
            DirectDailySalesBatch dsb = new DirectDailySalesBatch();
            //to execute DirectDailySalesBatch class
            DataBase.executeBatch(dsb);
            Test.stopTest();
        }
    }
    @isTest
    /* ***************************************************************
	* @description: function to provide test data to the DirectDailySalesBatch class
	* @Change:
	* *************************************************************** */
    public static void TestMeth2()
    {
         //fetch profile to assign to test user data.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
         //test user data
        User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser0@gmail.com');
        //insert user
        insert u;
        //Test data of the file upload.
        String csvContent ='Created_On,Ship_Date,Invoice_\n,Invoice_Line,Item_Category,Sales_,Sales_Line,Customer_PO_Number,Customer_Reference_1,Customer_Reference_2,Customer_Reference_3,Customer_Reference_4,Customer_Reference_5,Customer_Reference_6,Reason_for_Transaction,Terms_of_Payment,Plant,Delivery_,Delivery_Line,Contract_Number,Assignment_Number,External_Number,Sold_To,Sold_To_Name,Material,Material_Description,NDC,Vendor_Batch,Expiry_Date,Ship_To_DEA,Ship_To_HIN,Ship_To_Classification,Ship_To,Ship_To_Name,Ship_To_Street,c,Ship_To_State,Ship_To_Postal_Cd,Invoice_Qty,Discount_Amount,Net_Value,Unit_Price,Ext_WAC,WAC_Unit_Pric\n'
            +'1/23/2019,1/1/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,23456234,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225\n'
            +'1/23/2019,1/3/2019,131624268,1,StandardItem,115144762,10,71270224400M5976,71270224400M5976,#,71270224400M59,#,#,#,Notassigned,2%30NET31,1700,211586876,10,#,,,100222470,MCKESSONFINANCIALCENTER,5006021,Vaxchorapwd1/EA,70460-0001-01,7000012,6/30/2019,AB1894371,#,RetailPharmacies,345345435,BERKSHIREMEDCTR,725NORTHSTREET,PITTSFIELD,MA,1201,555,0,$225.00,225,$225.00,225';
        list<String> rows = new list<String>(csvContent.split('\n'));

        system.runAs(u)
        {
            //to upload file in the file object.
            ContentVersion cv = new ContentVersion();
            cv.VersionData = Blob.valueOf(csvContent);
            cv.Title = 'DS-test';
            cv.PathOnClient = 'filename';
            cv.OwnerId=u.id;
            insert cv;
        }
        //create test account data with different DDD_Outlet_ID__c and ShipTo_ID__c
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='12345678';
        a.ShipTo_ID__c='1234567890';
        insert a;
        
        Account a1 = new Account();
        a1.Name='Test';
        a1.DDD_Outlet_ID__c='12345679';
        a1.ShipTo_ID__c='1234567899';
        insert a1;
        
        Account a2 = new Account();
        a2.Name='Test';
        a2.DDD_Outlet_ID__c='12345678';
        a2.ShipTo_ID__c='9999999999';
        insert a2;
        
        Account a3 = new Account();
        a3.Name='Test';
        a3.DDD_Outlet_ID__c='12345678';
        a3.ShipTo_ID__c='9999999999';
        insert a3;
        
        //to insert test data for ShipTo_Information__c record
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
        insert sToinfo;
        //to insert test Daily_Sales_Data__c record
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
            Test.startTest();
            //Create a instance of DirectDailySalesBatch class
            DirectDailySalesBatch dsb = new DirectDailySalesBatch();
            //to execute DirectDailySalesBatch class
            DataBase.executeBatch(dsb);
            Test.stopTest();
        }
    }
    /* ***************************************************************
	* @description: function to provide test data to the DirectDailySalesBatch class
	* @Change:
	* *************************************************************** */

    @isTest
    public static void TestMeth3()
    {
         //fetch profile to assign to test user data.
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
 		//test user data.
        User u = new User(
            Alias = 'styu', 
            Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId =profileId.id , 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='stauser1@gmail.com');
        //insert user
        insert u;
        //create test account data with different DDD_Outlet_ID__c and ShipTo_ID__c
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='12345678';
        a.ShipTo_ID__c='1234567890';
        insert a;
        
        Account a1 = new Account();
        a1.Name='Test';
        a1.DDD_Outlet_ID__c='12345679';
        a1.ShipTo_ID__c='1234567899';
        insert a1;
        
        Account a2 = new Account();
        a2.Name='Test';
        a2.DDD_Outlet_ID__c='12345678';
        a2.ShipTo_ID__c='9999999999';
        insert a2;
        
        Account a3 = new Account();
        a3.Name='Test';
        a3.DDD_Outlet_ID__c='12345678';
        a3.ShipTo_ID__c='9999999999';
        insert a3;
        //to insert test data for ShipTo_Information__c record
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
        insert sToinfo;
        //to insert test Daily_Sales_Data__c record
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
            Test.startTest();
            //Create a instance of DirectDailySalesBatch class
            DirectDailySalesBatch dsb = new DirectDailySalesBatch();
             //to execute DirectDailySalesBatch class
            DataBase.executeBatch(dsb);
            Test.stopTest();
        }
    }
}