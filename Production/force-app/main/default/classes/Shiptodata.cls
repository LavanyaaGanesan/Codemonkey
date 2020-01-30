/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Handler class used  for Salesplanner trigger
* @Change:  
* @last modify by:  Archie Bisen
* @last modify date:  8-Jan-2020
* *************************************************************** */

public class Shiptodata {
   
     /* ***************************************************************
    * @description: Wrapper class for fetching data from different list
    * @Change:
    * *************************************************************** */
    public class WrapperShipToDailySalesClass{
        
         /* ***************************************************************
    * @description: list for fetching the data from Shipto information object
    * @Change:
    * *************************************************************** */
        @AuraEnabled
        public list<ShipTo_Information__c> lstShipToInfo = new list<ShipTo_Information__c>();
        
   /* ***************************************************************
    * @description: lists for fetching the direct and indirect data from Shipto information object
    * @Change:
    * *************************************************************** */
        
        @AuraEnabled
        public list<ShipTo_Information__c> lstShipToInfoDirOnly = new list<ShipTo_Information__c>();
        
        @AuraEnabled
        public list<ShipTo_Information__c> lstShipToInfoInDirOnly = new list<ShipTo_Information__c>();
        
   /* **************************************************************************************************************
    * @description: list for fetching the Direct data from Vaxchora Sales Data object for displaying in pagination
    * @Change:
    * ************************************************************************************************************** */
        
        @AuraEnabled 
        public lstDailySalesDataDirectPagination lstDailySalesDataDirect = new lstDailySalesDataDirectPagination();
        
         /* **************************************************************************************************************
    * @description: list for fetching the Indirect data from Vaxchora Sales Data object for displaying in pagination
    * @Change:
    * ************************************************************************************************************** */
        
        @AuraEnabled
        public lstDailySalesDataInDirectPagination lstDailySalesDataInDirect = new lstDailySalesDataInDirectPagination();
        
           /* **************************************************************************************************************
    * @description: list for fetching all daily sales data from Vaxchora Sales Data object for displaying in excel sheet
    * when we click on download data button
    * @Change:
    * ************************************************************************************************************** */
        
        @AuraEnabled
        public list<Daily_Sales_Data__c> lstDailySalesData = new list<Daily_Sales_Data__c>();
        
           /* **************************************************************************************************************
    * @description: list for fetching indirect daily sales data from Vaxchora Sales Data object for displaying after selecting year
    * @Change:
    * ************************************************************************************************************** */
        @AuraEnabled
        public list<Daily_Sales_Data__c> lstDailySalesINDirectData = new list<Daily_Sales_Data__c>();
       
    }
    
     
 /* **************************************************************************************************************
    * @description: function to be called when the current year is selected
    * @Change:
    * ************************************************************************************************************** */
    @AuraEnabled
    public static WrapperShipToDailySalesClass fetchDailysalesData(String strAccId,Decimal pageNumber,
                                                                   decimal pageSize,String SelectedType2)
    {
        WrapperShipToDailySalesClass objWrapperShipToDailySalesClass = new WrapperShipToDailySalesClass();
        try{
        
        
        objWrapperShipToDailySalesClass.lstShipToInfo =  [SELECT IsDelete__c, Id, Name, CreatedDate, CreatedById, LastModifiedDate,City__c,Country__c,State__c,Zip__c,
                                                          Address__c,Ship_To__c,LastModifiedById, DDD_Outlet_ID__c,ShipTo_Type__c, Account__c,Account__r.Name 
                                                          FROM ShipTo_Information__c where Account__c=: strAccId AND IsDelete__c!= True Order by ShipTo_Type__c,LastModifiedDate];
        
        objWrapperShipToDailySalesClass.lstShipToInfoDirOnly =  [SELECT IsDelete__c, Id, Name, CreatedDate, CreatedById, LastModifiedDate,City__c,Country__c,State__c,Zip__c,
                                                                 Address__c,Ship_To__c,LastModifiedById, DDD_Outlet_ID__c,ShipTo_Type__c, Account__c,Account__r.Name 
                                                                 FROM ShipTo_Information__c where Account__c=: strAccId AND IsDelete__c!= True AND ShipTo_Type__c='Direct' Order by LastModifiedDate];
        
        
        objWrapperShipToDailySalesClass.lstShipToInfoInDirOnly =  [SELECT IsDelete__c, Id, Name, CreatedDate, CreatedById, LastModifiedDate,City__c,Country__c,State__c,Zip__c,
                                                                   Address__c,Ship_To__c,LastModifiedById, DDD_Outlet_ID__c,ShipTo_Type__c, Account__c,Account__r.Name 
                                                                   FROM ShipTo_Information__c where Account__c=: strAccId AND IsDelete__c!= True AND ShipTo_Type__c='Indirect' Order by LastModifiedDate];
       
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        Integer totalRecords;
        Integer recordEnd;
        //Total Records
        if(SelectedType2=='1')
        {
            totalRecords = [SELECT count() FROM Daily_Sales_Data__c where ShipTo_Date__c= THIS_YEAR AND  Account__c=: strAccId AND ShipTo_Type__c='Direct'AND Is_Deleted__c != True ];
            recordEnd = pSize * pNumber;
        }
        else if(SelectedType2=='2')
        {
            totalRecords = [SELECT count() FROM Daily_Sales_Data__c where ShipTo_Date__c= LAST_YEAR AND  Account__c=: strAccId AND ShipTo_Type__c='Direct'AND Is_Deleted__c != True ];
            recordEnd = pSize * pNumber;
        }
        
        
        //Instance of DataTable Wrapper Class
        lstDailySalesDataDirectPagination objDT =  new lstDailySalesDataDirectPagination();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        
        //if condition for fetching direct data of current year
        if(SelectedType2=='1')
        {
            objDT.lstDailySalesDataDirectPage = [SELECT Id, ShipTo_ID__c,DDD_Outlet_ID__c, Account__c, Quantity__c, ShipTo_Type__c, Material_Description__c,Invoice__c,
                                                 Item_Category__c,ShipTo_Date__c,Reason_for_Transaction__c, NDC__c,Invoice_Quantity__c,
                                                 Created_On__c FROM Daily_Sales_Data__c where ShipTo_Date__c= THIS_YEAR AND  Account__c=: strAccId AND ShipTo_Type__c='Direct'AND Is_Deleted__c != True LIMIT :pSize OFFSET :offset];
          
        }
         //if condition for fetching direct data of last year
        else if(SelectedType2=='2')
        {
            objDT.lstDailySalesDataDirectPage = [SELECT Id, ShipTo_ID__c,DDD_Outlet_ID__c, Account__c, Quantity__c, ShipTo_Type__c, Material_Description__c,Invoice__c,
                                                 Item_Category__c,ShipTo_Date__c,Reason_for_Transaction__c, NDC__c,Invoice_Quantity__c,
                                                 Created_On__c FROM Daily_Sales_Data__c where ShipTo_Date__c= LAST_YEAR AND  Account__c=: strAccId AND ShipTo_Type__c='Direct'AND Is_Deleted__c != True LIMIT :pSize OFFSET :offset]; 
            
         
        }
                  objWrapperShipToDailySalesClass.lstDailySalesDataDirect = objDT;
      
        }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('Shiptoinfo', 'fetchDailysalesData', ex.getMessage(), ex.getLineNumber());
        }
          
               return objWrapperShipToDailySalesClass;
    }
    
    /* **************************************************************************************************************
    * @description: function to be called when the last year is selected
    * @Change:
    * ************************************************************************************************************** */
    
    @AuraEnabled
    public static WrapperShipToDailySalesClass fetchDailysalesData1(String strAccId,Decimal pageNumber2,decimal pageSize2,String SelectedType3){
       
        WrapperShipToDailySalesClass objWrapperShipToDailySalesClass = new WrapperShipToDailySalesClass();
        try{
        objWrapperShipToDailySalesClass.lstShipToInfo =  [SELECT IsDelete__c, Id, Name, CreatedDate, CreatedById, LastModifiedDate,City__c,Country__c,State__c,Zip__c,
                                                          Address__c,Ship_To__c,LastModifiedById, DDD_Outlet_ID__c,ShipTo_Type__c, Account__c,Account__r.Name 
                                                          FROM ShipTo_Information__c where Account__c=: strAccId AND IsDelete__c!= True Order by ShipTo_Type__c,LastModifiedDate];
        
        
        Integer pSize2 = (Integer)pageSize2;
        Integer pNumber2 = (Integer)pageNumber2;
        
        //Offset for SOQL
        Integer offset2 = (pNumber2 - 1) * pSize2;
        Integer totalRecords2;
         Integer recordEnd2;
        //Total Records
         if(SelectedType3=='1')
        {
        totalRecords2 = [SELECT count() FROM Daily_Sales_Data__c where ShipTo_Date__c= THIS_YEAR AND  Account__c=: strAccId AND ShipTo_Type__c='Indirect'AND Is_Deleted__c != True ];
        system.debug('-----Count2 '+totalRecords2);
        recordEnd2 = pSize2 * pNumber2;
        }
         if(SelectedType3=='2')
        {
        totalRecords2 = [SELECT count() FROM Daily_Sales_Data__c where ShipTo_Date__c= LAST_YEAR AND  Account__c=: strAccId AND ShipTo_Type__c='Indirect'AND Is_Deleted__c != True ];
        system.debug('-----Count2 '+totalRecords2);
        recordEnd2 = pSize2 * pNumber2;
        }
        //Instance of DataTable Wrapper Class
        lstDailySalesDataInDirectPagination objDT2 =  new lstDailySalesDataInDirectPagination();  
        objDT2.pageSize2 = pSize2;
        objDT2.pageNumber2 = pNumber2;
        objDT2.recordStart2 = offset2 + 1;
        objDT2.recordEnd2 = totalRecords2 >= recordEnd2 ? recordEnd2 : totalRecords2;
        objDT2.totalRecords2 = totalRecords2; 
        
         //if condition for fetching indirect data of current year
        if(SelectedType3=='1')
        {
        
        objDT2.lstDailySalesDataInDirectPage = [SELECT Id, ShipTo_ID__c, Account__c,DDD_Outlet_ID__c, Quantity__c,ShipTo_Type__c, Material_Description__c,Invoice__c,
                                                Item_Category__c,ShipTo_Date__c,Reason_for_Transaction__c, NDC__c,Invoice_Quantity__c,
                                                Created_On__c FROM Daily_Sales_Data__c where ShipTo_Date__c= THIS_YEAR AND Account__c=: strAccId AND ShipTo_Type__c='Indirect'AND Is_Deleted__c!= True LIMIT :pSize2 OFFSET :offset2];
        }
         //if condition for fetching indirect data of last year
         if(SelectedType3=='2')
        {
        
        objDT2.lstDailySalesDataInDirectPage = [SELECT Id, ShipTo_ID__c, Account__c,DDD_Outlet_ID__c, Quantity__c,ShipTo_Type__c, Material_Description__c,Invoice__c,
                                                Item_Category__c,ShipTo_Date__c,Reason_for_Transaction__c, NDC__c,Invoice_Quantity__c,
                                                Created_On__c FROM Daily_Sales_Data__c where ShipTo_Date__c= LAST_YEAR AND Account__c=: strAccId AND ShipTo_Type__c='Indirect'AND Is_Deleted__c!= True LIMIT :pSize2 OFFSET :offset2];
        }
        
        objWrapperShipToDailySalesClass.lstDailySalesDataInDirect = objDT2;        
        
        }
        
   catch(exception ex){
            ApexDebugLogController.insertLog('Shiptoinfo', 'fetchDailysalesData1', ex.getMessage(), ex.getLineNumber());
        }
        return objWrapperShipToDailySalesClass;
    }
    
    /* **************************************************************************************************************
    * @description: Class for direct data pagination
    * @Change:
    * ************************************************************************************************************** */
    
    public class lstDailySalesDataDirectPagination {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public String SelectedType2 {get;set;}
        @AuraEnabled
        public List<Daily_Sales_Data__c> lstDailySalesDataDirectPage {get;set;}
    }
    
        /* **************************************************************************************************************
    * @description: Class for indirect data pagination
    * @Change:
    * ************************************************************************************************************** */
    
    public class lstDailySalesDataInDirectPagination {
        @AuraEnabled
        public Integer pageSize2 {get;set;}
        @AuraEnabled
        public Integer pageNumber2 {get;set;}
        @AuraEnabled
        public Integer totalRecords2 {get;set;}
        @AuraEnabled
        public Integer recordStart2 {get;set;}
        @AuraEnabled
        public Integer recordEnd2 {get;set;}
        @AuraEnabled
        public String SelectedType3 {get;set;}
        @AuraEnabled
        public List<Daily_Sales_Data__c> lstDailySalesDataInDirectPage {get;set;}
    }
    
        /* **************************************************************************************************************
    * @description: Function to be called when "Download data" button is clicked and full data will be downloaded 
    * irrrespective of year
    * @Change:
    * ************************************************************************************************************** */
    
    @AuraEnabled
    public static WrapperShipToDailySalesClass fetchAllDailysalesData(String strAccId){
       
        WrapperShipToDailySalesClass objWrapperShipToDailySalesClass = new WrapperShipToDailySalesClass();
        try{
        objWrapperShipToDailySalesClass.lstShipToInfo =  [SELECT IsDelete__c, Id, Name, CreatedDate, CreatedById, LastModifiedDate,City__c,Country__c,State__c,Zip__c,
                                                          Address__c,Ship_To__c,LastModifiedById, DDD_Outlet_ID__c,ShipTo_Type__c, Account__c,Account__r.Name 
                                                          FROM ShipTo_Information__c where Account__c=: strAccId AND IsDelete__c!= True Order by ShipTo_Type__c,LastModifiedDate];
        
        
        objWrapperShipToDailySalesClass.lstDailySalesData= [SELECT Id, ShipTo_ID__c,DDD_Outlet_ID__c, Account__c, Quantity__c, ShipTo_Type__c, Material_Description__c,Invoice__c,
                                                            Item_Category__c,ShipTo_Date__c,Reason_for_Transaction__c, NDC__c,Invoice_Quantity__c,
                                                            Created_On__c FROM Daily_Sales_Data__c where ShipTo_Date__c < NEXT_YEAR AND ShipTo_Date__c>= LAST_YEAR AND Account__c=: strAccId AND Is_Deleted__c!= True AND ShipTo_Type__c='Direct' ORDER by ShipTo_Date__c ];
        
        
        
        objWrapperShipToDailySalesClass.lstDailySalesINDirectData=  [SELECT Id, ShipTo_ID__c,DDD_Outlet_ID__c, Account__c, Quantity__c,ShipTo_Type__c, Material_Description__c,Invoice__c,
                                                                     Item_Category__c,ShipTo_Date__c,Reason_for_Transaction__c, NDC__c,Invoice_Quantity__c,
                                                                     Created_On__c FROM Daily_Sales_Data__c where ShipTo_Date__c < NEXT_YEAR AND ShipTo_Date__c>= LAST_YEAR AND Account__c=: strAccId AND ShipTo_Type__c='Indirect' ORDER by ShipTo_Date__c ];
        
        }
   catch(exception ex){
            ApexDebugLogController.insertLog('Shiptoinfo', 'fetchAllDailysalesData', ex.getMessage(), ex.getLineNumber());
        }
        return objWrapperShipToDailySalesClass;
    }
    
     
}