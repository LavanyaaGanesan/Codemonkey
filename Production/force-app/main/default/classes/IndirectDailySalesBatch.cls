/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Batch Class to exicute indirect data file.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  8-Jan-2020
* *************************************************************** */
global class IndirectDailySalesBatch implements Database.Batchable<wrapperDailySales>, Database.Stateful{
    //Declaration of the variables and collections
    global List<CustomerMasterConfig__mdt> cmConfig;
    
    global List<Account> AccountList;
    global Map<string, account> AccountMap = new  Map<string, account>();    
    global List<Daily_Sales_Data__c> DailySalesList;
    global Map<string, Daily_Sales_Data__c> DailySalesMap = new  Map<string, Daily_Sales_Data__c>();
    
    global List<ShipTo_Information__c> ShipToInfoList;
    global Map<string, ShipTo_Information__c> ShipToInfoMap = new  Map<string, ShipTo_Information__c>();
    
    global List<ContentVersion> ContentVersionList;
    
    global List<ShipTo_Information__c> insShipToInfoList = new List<ShipTo_Information__c>();
    global Map<string, string> insShipToInfoCheckMap = new Map<string, string>();
    global List<Daily_Sales_Data__c> insDailySalesList = new List<Daily_Sales_Data__c>();
    
    global Map<string, string> MultipleDDDIdAgainstShipToMap = new  Map<string, string>();
    
    global string csvHeader;
    global string csvMultipleDDDHeader;
    global List<string> csvReport=new List<String>();
    global List<string> csvFailedReport=new List<String>();
    global List<string> csvReportMultipleDDD=new List<String>();
    
    global Map<string, string> csvRowsMap = new  Map<string, string>();
    global Map<string, string> excError = new  Map<string, string>();
    global List<string> csvFailedReportAllwithError=new List<String>();
    
    global String[] TestingEmailIds;
    global string[] ToEmailIDs;
    global string[] CcEmailIDs;
    global string[] BccEmailIDs;
    global string EmailSubject;
    global string EmailBody;
    global List<wrapperDailySales> wDailySalesList = new List<wrapperDailySales>();
    
    global boolean isDeleteFile =true;
    /* ***************************************************************
    * @description: Start method to execute batch class. 
    * @Change:  
    * *************************************************************** */
    global Iterable<wrapperDailySales> start(Database.BatchableContext BC)
    {  /**/ 
        csvFailedReport.add('Error Code, Error Message, Error Fields, Object \n');                
        try{
            //Execute the query in CustomerMaster_InDirect_SOQL label
            cmConfig = Database.query(System.Label.CustomerMaster_InDirect_SOQL);  
            //check size of cmConfig
            if (cmConfig.size()>0){  
                //check Content_Version_SOQL__c and query
                if (cmConfig[0].Content_Version_SOQL__c!=null){
                    ContentVersionList =Database.query(cmConfig[0].Content_Version_SOQL__c);
                }
                //check ContentVersionList
                if (ContentVersionList.size()>=1){
                    //if Testing_Email__c is not null then assign TestingEmailIds with data in Testing_Email__c
                    if (cmConfig[0].Testing_Email__c!=null){
                        TestingEmailIds =string.valueOf(cmConfig[0].Testing_Email__c).split(',');
                    } 
                    //if To_Email__c is not null then assign ToEmailIDs with data in To_Email__c
                    if (cmConfig[0].To_Email__c!=null){
                        ToEmailIDs =string.valueOf(cmConfig[0].To_Email__c).split(',');
                    } 
                    //if CC_Email__c is not null then assign CcEmailIDs with data in CC_Email__c
                    if (cmConfig[0].CC_Email__c!=null){  CcEmailIDs =string.valueOf(cmConfig[0].CC_Email__c).split(','); } 
                    //if BCC_Email__c is not null then assign BccEmailIDs with data in BCC_Email__c
                    if (cmConfig[0].BCC_Email__c!=null){ BccEmailIDs =string.valueOf(cmConfig[0].BCC_Email__c).split(','); }
                    //if Email_Header__c is not null then assign EmailSubject with data in Email_Header__c
                    if (cmConfig[0].Email_Header__c!=null){
                        EmailSubject =cmConfig[0].Email_Header__c;
                    } 
                    //if Email_Body__c is not null then assign EmailBody with data in Email_Body__c
                    if (cmConfig[0].Email_Body__c!=null){ 
                        EmailBody =cmConfig[0].Email_Body__c;
                    }
                    //if Report_CSV_Header__c is not null then assign csvHeader with data in Report_CSV_Header__c
                    if (cmConfig[0].Report_CSV_Header__c!=null){
                        csvHeader=cmConfig[0].Report_CSV_Header__c;
                        csvReport.add(csvHeader + '\n');
                    }
                    //if Report_Multiple_DDD_CSV_Header__c is not null then assign csvMultipleDDDHeader with data in Report_Multiple_DDD_CSV_Header__c
                    if (cmConfig[0].Report_Multiple_DDD_CSV_Header__c!=null){
                        csvMultipleDDDHeader =cmConfig[0].Report_Multiple_DDD_CSV_Header__c;
                        //Add csvMultipleDDDHeader to csvReportMultipleDDD 
                        csvReportMultipleDDD.add( csvMultipleDDDHeader + '\n');
                    }
                    //if Account_SOQL__c is not null then query Account_SOQL__c
                    if (cmConfig[0].Account_SOQL__c!=null){
                        AccountList = Database.query(cmConfig[0].Account_SOQL__c);   
                        
                        for(Account a : AccountList){
                            //each account is mapped with DDD_Outlet_ID__c
                            AccountMap.put(a.DDD_Outlet_ID__c,a);
                            //MultipleDDDIdAgainstShipToMap gets updated if shipto is mapped with two DDD IDs.
                            String existingDDDId = MultipleDDDIdAgainstShipToMap.get(a.DDD_Outlet_ID__c);
                            string mDDDValues = a.DDD_Outlet_ID__c +',' + a.Id +',' + a.Name;
                            MultipleDDDIdAgainstShipToMap.put(a.DDD_Outlet_ID__c, (existingDDDId!= null && existingDDDId!= '' ? existingDDDId +'~~' + mDDDValues : mDDDValues));
                        } 
                    } 
                    //if DailySales_Data_SOQL__c is not null then query DailySales_Data_SOQL__c.
                    if (cmConfig[0].DailySales_Data_SOQL__c!=null){
                        DailySalesList = Database.query(cmConfig[0].DailySales_Data_SOQL__c);                    
                        for(Daily_Sales_Data__c dsData : DailySalesList){
                            //DDD_Outlet_ID__c, ShipTo_Date__c & Invoice__c are mapped with DailySales record.
                            DailySalesMap.put(dsData.DDD_Outlet_ID__c+'-'+string.valueOf(dsData.ShipTo_Date__c)+'-'+string.valueOf(dsData.Invoice__c) , dsData);
                        }
                    } 
                    // if ShipTo_Information_SOQL__c is not null then query ShipTo_Information_SOQL__c
                    if (cmConfig[0].ShipTo_Information_SOQL__c!=null){
                        ShipToInfoList =Database.query(cmConfig[0].ShipTo_Information_SOQL__c);                        
                        for(ShipTo_Information__c s : ShipToInfoList)
                            //DDD_Outlet_ID__c,ShipTo_Type__c is mapped with ShipTo_Information__c record.
                            ShipToInfoMap.put(s.DDD_Outlet_ID__c+'-'+s.ShipTo_Type__c,s);
                    }                   
                    Boolean isProcess=false;
                    //For condition to exicute file starts with IDS- 
                    for (ContentVersion cv : ContentVersionList){
                        if (!isProcess && cv.Title.startswith('IDS-')){
                            isProcess=true;
                            Blob csvFileBody =cv.VersionData;
                            List<String> csvFileLines= csvFileBody.toString().split('\n');
                            Integer cnt=0;
                            for(String s : csvFileLines){                                
                                if (cnt==0){
                                    cnt=1;
                                    csvFailedReportAllwithError.add(s.replace('\n','').replace('\r','') + ', Error \n');
                                }
                                else{
                                    List<String> csvRows = s.split(',');
                                    if (csvRows[1]!=null && csvRows[1]!=''){
                                        wrapperDailySales wDailySales = new wrapperDailySales(csvRows);
                                        wDailySalesList.add(wDailySales);
                                        csvRowsMap.put(wDailySales.DDD_Outlet_Id +'-'+
                                                       string.valueOf(wDailySales.ShipTo_Date)+'-'+
                                                       string.valueOf(wDailySales.Invoice), s.replace('\n','').replace('\r',''));                                                          
                                    }
                                }
                            }
                        }                        
                    }
                }
                else
                {
                    csvFailedReport.add(' Content version ' + ', Message : Please upload Daily Sales report in files section.' + ', Stack : No Files available to process.' + ', Warning \n');                                        
                    isDeleteFile=false;
                }
            }
        }
        catch(Exception ex){
            csvFailedReport.add('Exception : Line No : ' + ex.getLineNumber() + ', Message : ' + ex.getMessage() + ', Stack : ' + ex.getStackTraceString() + ', Start Exception \n');                                                                               
            isDeleteFile=false;ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'Start', ex.getMessage(), ex.getLineNumber());
        }        
        return wDailySalesList;
        //return list of wrapperdailysales 
    }
    /* ***************************************************************
    * @description: Execute method for batch class
    * @Change:
    * *************************************************************** */ 
    global void execute(Database.BatchableContext BC,List<wrapperDailySales> wDSBatchList)
    {  
        string key ='';
        string value='';
        string existValue='';  
        try{
            for(wrapperDailySales wDS : wDSBatchList){
                String rowDDD_Data = MultipleDDDIdAgainstShipToMap.get(wDS.DDD_Outlet_Id);
                if(rowDDD_Data!=null){
                    String[] rowDDD_Array = rowDDD_Data.split(',');
                    String DDD_Id = rowDDD_Array.size()>0 ? rowDDD_Array[0] :'';
                    // if DDD_Id is not null and rowDDD_Data containing ~~
                    if (DDD_Id!='' && rowDDD_Data.contains('~~')){
                        // add rowDDD_Data to csvReportMultipleDDD
                        csvReportMultipleDDD.add(rowDDD_Data.replace('~~','\n'));
                        
                        key = DDD_Id +'-'+ string.valueOf(wDS.ShipTo_Date)+'-'+ string.valueOf(wDS.Invoice);
                        existValue = excError.get(key);
                        value='Multiple Account having Same DDD OutletID :: Error : ' + string.valueOf(rowDDD_Data).replace(',',' - ');
                        excError.put(key, (existValue!=null && existValue!='' ? existValue +' ~~ ' + value : value));
                        
                        continue;
                    }
                    
                    //Create new ShipTo_Information__c object
                    ShipTo_Information__c shipToInfo = new ShipTo_Information__c();                       
                    shipToInfo.Name= wDS.ShipTo_Name;
                    shipToInfo.Address__c= wDS.Address;
                    shipToInfo.City__c= wDS.City;
                    shipToInfo.State__c= wDS.State;
                    shipToInfo.Zip__c= wDS.Zip;
                    shipToInfo.ShipTo_Type__c= 'Indirect';
                    
                    //Get Account from Account Map 
                    Account gAccount = AccountMap.get(DDD_Id);
                    
                    if (gAccount!=null){
                        
                        shipToInfo.DDD_Outlet_ID__c= DDD_Id;
                        
                        //Get ShipTo_Information__c from ShipTo_Information__c Map 
                        ShipTo_Information__c gShipToInfo = ShipToInfoMap.get(DDD_Id+'-Indirect');                                    
                        if(gShipToInfo!=null) { shipToInfo.Id= gShipToInfo.Id; }
                        
                        shipToInfo.Account__c= gAccount.Id;
                        
                        string gShipToInfoId = insShipToInfoCheckMap.get(DDD_Id);
                        if (gShipToInfoId==null){
                            insShipToInfoList.add(shipToInfo);
                            if (shipToInfo.Id!=null){ insShipToInfoCheckMap.put(DDD_Id, shipToInfo.Id);}
                            else{insShipToInfoCheckMap.put(DDD_Id, DDD_Id);}
                        }                                                                               
                        
                        //Create new Daily_Sales_Data__c object
                        Daily_Sales_Data__c DSInfo = new Daily_Sales_Data__c();
                        DSInfo.Account__c= gAccount.Id;
                        DSInfo.DDD_Outlet_ID__c= DDD_Id;
                        DSInfo.ShipTo_ID__c= '';
                        DSInfo.ShipTo_Date__c= wDS.ShipTo_Date;
                        DSInfo.Quantity__c= wDS.Quantity;
                        DSInfo.ShipTo_Type__c='Indirect';                               
                        DSInfo.Invoice__c= wDS.Invoice;
                        DSInfo.Material_Description__c=wDS.MaterialDesc;
                        
                        //Get Daily_Sales_Data__c from DailySalesMap  
                        Daily_Sales_Data__c gDSData = DailySalesMap.get(DSInfo.DDD_Outlet_ID__c+'-'+string.valueOf(DSInfo.ShipTo_Date__c)
                                                                        +'-'+string.valueOf(DSInfo.Invoice__c));
                        if (gDSData!=null){ DSInfo.Id=gDSData.Id; }                                        
                        insDailySalesList.add(DSInfo);
                    }
                    else{
                        csvReport.add(shipToInfo.DDD_Outlet_ID__c + ',' + wDS.Invoice + ',' + replaceUnwantedData(shipToInfo.Name) 
                                      + ',' + wDS.ShipTo_Date + ',' + wDS.Quantity + '\n');
                        key = DDD_Id +'-'+ string.valueOf(wDS.ShipTo_Date)+'-'+ string.valueOf(wDS.Invoice);
                        existValue = excError.get(key);
                        value='DDD Outlet Id Not present in Account.';
                        excError.put(key, (existValue!=null && existValue!='' ? existValue +' ~~ ' + value : value));
                    }
                }
                else{
                    csvReport.add(wDS.DDD_Outlet_Id + ',' + replaceUnwantedData(wDS.ShipTo_Name) 
                                  + ',' + wDS.ShipTo_Date + ',' + wDS.Quantity + '\n');
                    key = wDS.DDD_Outlet_Id +'-'+ string.valueOf(wDS.ShipTo_Date)+'-'+ string.valueOf(wDS.Invoice);
                    existValue = excError.get(key);
                    value='DDD Outlet Id Not present in Account.';
                    excError.put(key, (existValue!=null && existValue!='' ? existValue +' ~~ ' + value : value));
                } 
            }
            
            
            Integer i=0;
            //if condition to check the size of the insShipToInfoList
            if (insShipToInfoList.size()>0){
                List<Database.UpsertResult> upSIList = Database.upsert(insShipToInfoList,false);
                // Iterate through each returned result 
                for (Database.UpsertResult upSI : upSIList) {
                    if (!upSI.isSuccess()) {
                        for(Database.Error err : upSI.getErrors()) {
                            csvFailedReport.add(err.getStatusCode() + ','+ err.getMessage() + ','+ err.getFields() +', ShipTo_Information__c \n');                                        
                            
                            ShipTo_Information__c shFailed = insShipToInfoList.get(i);
                            key = shFailed.DDD_Outlet_ID__c;
                            existValue = excError.get(key);
                            value='ShipTo UPSERT :: Error : ' + err.getStatusCode() + ' - '+ err.getMessage() + ' - '+ err.getFields();
                            excError.put(key, (existValue!=null && existValue!='' ? existValue +' ~~ ' + value : value));
                        }
                    }
                }
            }
            i=0;
            if (insDailySalesList.size()>0){
                List<Database.UpsertResult> upDSList = Database.upsert(insDailySalesList,false);
                // Iterate through each returned result 
                for (Database.UpsertResult upDS : upDSList) {
                    if (!upDS.isSuccess()) {
                        for(Database.Error err : upDS.getErrors()) {
                            csvFailedReport.add(err.getStatusCode() + ','+ err.getMessage() + ','+ err.getFields() + ', Daily_Sales_Data__c \n');                                        
                            
                            Daily_Sales_Data__c dsFailed = insDailySalesList.get(i);
                            key = dsFailed.DDD_Outlet_ID__c +'-'+ string.valueOf(dsFailed.ShipTo_Date__c)+'-'+ string.valueOf(dsFailed.Invoice__c);
                            existValue = excError.get(key);
                            value='Daily Sales UPSERT :: Error : ' + err.getStatusCode() + ' - '+ err.getMessage() + ' - '+ err.getFields();
                            excError.put(key, (existValue!=null && existValue!='' ? existValue +' ~~ ' + value : value));   
                        }
                    }
                }
            }
        }catch(exception ex){ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'Execute', ex.getMessage(), ex.getLineNumber());}
    }
    /* ***************************************************************
    * @description: Finish method for batch class.
    * @Change:
    * *************************************************************** */ 
    global void finish(Database.BatchableContext BC){        
        transient List<Messaging.EmailFileAttachment> EmailAttachmentList = new List<Messaging.EmailFileAttachment>();
        transient List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        try{  
            generateFailedReport(); 
            //if conditions code to generate multiple error reports based on conditions. 
            if (csvReport.size()>1){ 
                EmailAttachmentList.add(getEmailAttachment(csvReport, 'IDS-DDD-Not-In-Account-' + string.valueOf(System.now()).replace(' ','')  + '.csv'));                              
            }
            if (csvReportMultipleDDD.size()>1){
                EmailAttachmentList.add(getEmailAttachment(csvReportMultipleDDD, 'IDS-Mulitple-DDD-In-Account-' + string.valueOf(System.now()).replace(' ','')  + '.csv'));                              
            }
            if (csvFailedReport.size()>1){
                EmailAttachmentList.add(getEmailAttachment(csvFailedReport, 'IDS-Error-Report-' + string.valueOf(System.now()).replace(' ','')  + '.csv'));                              
            }
            if (csvFailedReportAllwithError.size()>1){
                EmailAttachmentList.add(getEmailAttachment(csvFailedReportAllwithError, 'IDS-Failed-Report-' + string.valueOf(System.now()).replace(' ','')  + '.csv'));                              
            }
            for (ContentVersion cv : ContentVersionList){
                if (csvFailedReportAllwithError.size()>1 ||  isDeleteFile){
                    ContentDocument cd = new ContentDocument(); 
                    cd.id=cv.ContentDocumentId;
                    delete cd;
                }
            }
            csvReport.clear();
            csvReportMultipleDDD.clear();
            csvFailedReport.clear();
            if (ToEmailIDs!=null && EmailAttachmentList!=null && EmailAttachmentList.size()>0){
                emailList.add(getEmailWithAttach(EmailAttachmentList)); 
            }
            if(emailList!=null && emailList.size()>0){
                Messaging.sendEmail(emailList);
            }
        }
        catch(exception ex){ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'Finish', ex.getMessage(), ex.getLineNumber());}
    }
    
    /* ***************************************************************
    * @description: function to get the email attachment.
    * @Change:
    * *************************************************************** */ 
    global Messaging.EmailFileAttachment getEmailAttachment(List<string> csvRep, string csvname){        
        //Code for the attachment
        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
        try{
            blob csvBlob = Blob.valueOf(String.join(csvRep,''));
            emailAttachment.setFileName(csvname);
            emailAttachment.setBody(csvBlob);
        } 
        catch(exception ex){ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'getEmailAttachment', ex.getMessage(), ex.getLineNumber());}
        return emailAttachment;
    }
    /* ***************************************************************
    * @description: Code for formatting the email
    * @Change:
    * *************************************************************** */ 
    global Messaging.SingleEmailMessage getEmailWithAttach(List<Messaging.EmailFileAttachment> emailAttachList){ 
        
        //Code for the sending email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
        try{
            string[] to = TestingEmailIds.size()>0 ? TestingEmailIds : ToEmailIDs ; 
            email.setToAddresses(to);
            //if condition to set ccEmail address
            if(CcEmailIDs!=null && CcEmailIDs.size() > 0 ){ email.setCcAddresses(CcEmailIDs); }
            //if condition to set BCCEmail address
            if(BccEmailIDs!=null && BccEmailIDs.size() > 0 ){ email.setBccAddresses(BccEmailIDs); }
            String subject = EmailSubject;
            String body = EmailBody;
            
            email.setSubject(subject); 
            email.setHtmlBody(body);
            //if condition to setFileAttachments
            if (emailAttachList!=null && emailAttachList.size()>0){
                email.setFileAttachments(emailAttachList);
            }
        }
        catch(exception ex){ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'getEmailWithAttach', ex.getMessage(), ex.getLineNumber());}
        return email;
    }
    /* ***************************************************************
    * @description: Replace unwanted data like <br> to nothing.
    * @Change:
    * *************************************************************** */
    global String replaceUnwantedData(String input){
        try{ 
            if (input!=null){  
                input = input.replace(',', ' ');
                input = input.replace('<br>', ' ');
                input = input.replace('\n', ' ');
                input = input.replace('\r', ' ');
            }
            else{input ='';}
        }
        catch(exception ex){ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'replaceUnwantedData', ex.getMessage(), ex.getLineNumber());}
        return input;
    }
    /* ***************************************************************
    * @description: Method to generate a failed Report. 
    * @Change:
    * *************************************************************** */
    global void generateFailedReport(){
        try{
            set<String> keySet= csvRowsMap.keySet(); 
            For(String k : keySet) {
                string[] spKey = k.split('-');            
                String s = csvRowsMap.get(k);
                string shipToError = excError.get(spKey[0]); 
                string shipToDateInvoiceError = excError.get(k); 
                string comError ='';
                if (shipToError!=null){comError = shipToError ;}
                if (shipToDateInvoiceError!=null){
                    comError += shipToDateInvoiceError ;
                }
                if (comError!=''){
                    csvFailedReportAllwithError.add(s.replace('\n','').replace('\r','') + ',' + comError + '\n');
                }
            }
            
        }
        catch(exception ex){ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'generateFailedReport', ex.getMessage(), ex.getLineNumber());}
    }
    /* ***************************************************************
    * Owner/Modify by Name : Prashant Damke
    * @description: Wrapper class to store the values from the uploaded file(.csv file)
    * @Change:  
    * @last modify by:  Prashant Damke
    * @last modify date:  8-Jan-2020
    * *************************************************************** */ 
    global class wrapperDailySales{
        //Declaration of variables.
        public String DDD_Outlet_Id{get;set;}
        public String ShipTo_Name{get;set;}
        public Date ShipTo_Date{get;set;}        
        public Integer Quantity{get;set;}
        public String Address{get;set;}
        public String City{get;set;}
        public String State{get;set;}
        public String Zip{get;set;}   
        public String Invoice{get;set;}
        public String MaterialDesc{get;set;}
        //Constructor to get DDD_Outlet_Id,ShipTo_Name,ShipTo_Date,Quantity,Address,City,State,Zip,Invoice,MaterialDesc.
        /* ***************************************************************
        * @description: Constructor to bind the row values in respective fields
        * @Change:
        * *************************************************************** */
        public wrapperDailySales(List<String> csvRow){            
            this.DDD_Outlet_Id=convertDDDToIn8Digit(csvRow[0]);
            this.ShipTo_Name=csvRow[5];
            String[] sDate = string.valueOf(csvRow[2]).trim().split('/');
            if(sDate.size()==0){sDate = string.valueOf(csvRow[2]).trim().split('-');}
            Integer dd, mm, yy;
            dd=Integer.valueOf(string.valueOf(sDate[1]).trim());
            mm=Integer.valueOf(string.valueOf(sDate[0]).trim());
            yy=Integer.valueOf(string.valueOf(sDate[2]).trim());
            this.ShipTo_Date = Date.newInstance(yy, mm, dd);
            this.Quantity= (csvRow[12]!='' ? Integer.valueOf(string.valueOf(csvRow[12]).trim()) : 0);
            this.Address=csvRow[6];
            this.City=csvRow[7];
            this.State=csvRow[8];
            this.Zip=csvRow[9];            
            this.Invoice=csvRow[1];
            this.MaterialDesc=csvRow[11];
        }        
        /* ***************************************************************
        * @description: method to convert DDD ID to 8 Digit
        * @Change:
        * *************************************************************** */ 
        public String convertDDDToIn8Digit(String input){
            try{
                //if inserted DDD id is not 8 digit then conditions to make it 8 digit.
                if (input.length()!=8){
                    Integer addZeroCount=8-input.length();
                    for(integer i=0;i<addZeroCount;i++)
                        input = '0'+input;
                }
            }
            catch(exception ex){ ApexDebugLogController.insertLog('IndirectDailySalesBatch', 'convertDDDToIn8Digit', ex.getMessage(), ex.getLineNumber());}
            return input;
        }
    }
}