/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: Test Class to provide test data for DeleteDailySaleWhenShipToDeleteC class.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  09-Jan-2020
* *************************************************************** */
@istest
public class DeleteDailySaleWhenShipToDeleteCTest 
{
    
    /* ***************************************************************
* @description: Method which provides test data for the DeleteDailySaleWhenShipToDeleteC class 
* @Change:
* *************************************************************** */
    @istest
    public static void testMeth1()
    {
         //test record for custom setting
        ShipTo_Setting__c spSetting =  ShipTo_Setting__c.getOrgDefaults();
        spSetting.IsActive_trigger__c=true;
        insert spSetting;
        //to insert test data for Account record
        Account a = new Account();
        a.Name='Test';
        a.DDD_Outlet_ID__c='12345678';
        a.ShipTo_ID__c='1234567890';
        insert a;
        //to insert test data for ShipTo Information record related to Account inserted above
        ShipTo_Information__c sToinfo= new ShipTo_Information__c();
        sToinfo.Name='shiptest';
        sToinfo.Ship_To__c=a.ShipTo_ID__c;
        sToinfo.Account__c=a.Id;
        sToinfo.DDD_Outlet_ID__c=a.DDD_Outlet_ID__c;
        sToinfo.ShipTo_Type__c='Direct';
       
            insert sToinfo;    
        
        //insert test data for Daily sales records related to above inserted shipTo Id
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
        
        Daily_Sales_Data__c DSInfo1 = new Daily_Sales_Data__c();
        DSInfo1.Account__c= a.Id;
        DSInfo1.ShipTo_ID__c= a.ShipTo_ID__c;
        DSInfo1.ShipTo_Date__c= Date.today();
        DSInfo1.Quantity__c= 20;
        DSInfo1.ShipTo_Type__c='Direct';                               
        DSInfo1.Invoice__c= '131624268';
        DSInfo1.Invoice_Line__c='1';
        DSInfo1.Reason_for_Transaction__c= 'Not assigned';
        DSInfo1.NDC__c= '70460-0001-01';
        DSInfo1.Item_Category__c='Standard Item';
        DSInfo1.Material_Description__c='Vaxchora pwd 1/EA';
        insert DSInfo1;
        
        Daily_Sales_Data__c DSInfo2 = new Daily_Sales_Data__c();
        DSInfo2.Account__c= a.Id;
        DSInfo2.ShipTo_ID__c= '1222';
        DSInfo2.ShipTo_Date__c= Date.today();
        DSInfo2.Quantity__c= 200;
        DSInfo2.ShipTo_Type__c='Direct';                               
        DSInfo2.Invoice__c= '131624268';
        DSInfo2.Invoice_Line__c='1';
        DSInfo2.Reason_for_Transaction__c= 'Not assigned';
        DSInfo2.NDC__c= '70460-0001-01';
        DSInfo2.Item_Category__c='Standard Item';
        DSInfo2.Material_Description__c='Vaxchora pwd 1/EA';
        insert DSInfo2;
        
        //delete shipTo information record, this triggers DeleteDailySaleWhenShipToDelete trigger which inturn calls DeleteDailySaleWhenShipToDeleteC class.
        delete sToinfo;
        
        
    }
}