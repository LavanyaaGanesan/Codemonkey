/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Send email to respective owner of SalesPlanner as well as the System Admin 
* @Change:  
* @last modify by:  Prashant Damke
* @last modify date:  13-Jan-2020
* *************************************************************** */
global class SPEmailBatch implements Database.Batchable<sObject>, Database.Stateful {
	//declare global List of Email batch custom Metadata config info
    global List<pvEmailBatchConf__mdt> b_EmailBatchConf;
    //declare global list of SP Email format config info
    global List<pvSalesPlannerEmailFormats__mdt> b_EmailFormatMetaData;
    //declare List of User, SP, Task and event 
	global List<User> b_UserList;
    global List<Sales_Planner__c> b_SPList;
    global List<Task> b_TaskList;
    global List<Event> b_EventList;
    //declare variables to use while sending email
    global String TestingEmail = '';
    global string[] BccEmailIDs;
    global string[] ManagersEmailIdInCC;
    //declarestring of array for exclude UserIDs
    global string[] excludeUserIDs;
    //declare map of User, SP, Task, Events and SP Email format
    global map<ID,User> userMap;
    global map<String,Sales_Planner__c> spOwnerMap;
    global map<String,Task> taskMap;
    global map<String,Event> eventMap;
    global map<String,pvSalesPlannerEmailFormats__mdt> emailFormatMap;
    //declare header variable for csv
    global string header ='';
    //declare string of array of TaskType
    global string[] taskType;  
    //declare string variable for Owner ID and Manager ID
    global String OwnerID, ManagerId;
    //declare list of string for UserEmailData VSC and ManagerEmailData CSV
    global LIST<String> finalUserCSVEmailData;
    global LIST<String> finalManagerCSVEmailData;
    //declare integer variables 
    global Integer totalCount=0,count = 0,callExecute = 0;     
    /* ***************************************************************
    * @description: This function use to capture all essential data for SP email at the start of batch process
    * @Change:  
    * *************************************************************** */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string spQuery = '';
        try{
            //initialize the map  of object
            spOwnerMap = new map<String,Sales_Planner__c>();
            //initialize the list of object
            finalUserCSVEmailData=new List<String>();
            finalManagerCSVEmailData=new List<String>();
            //fetch the Email batch config data from custom metadata based on the SOQL defined in custom label
            b_EmailBatchConf =  Database.query(System.Label.pvEmailBatchConfQuery);
            //set initial value in the variables
            totalCount=0;
            count = 0;
            callExecute = 0;        
            //check the list of Email batch not empty
            if (!b_EmailBatchConf.isEmpty()){  
                //Check ManagersEmailIdInCC__c not null and assign value in ManagersEmailIdInCC string array
                if (b_EmailBatchConf[0].ManagersEmailIdInCC__c!=null){
                    ManagersEmailIdInCC = string.valueOf( b_EmailBatchConf[0].ManagersEmailIdInCC__c).split(',');
                }
                //Check BccEmailID__c not null and assign value in BccEmailIDs string array
                if (b_EmailBatchConf[0].BccEmailID__c!=null){
                    BccEmailIDs = string.valueOf( b_EmailBatchConf[0].BccEmailID__c).split(',');
                }
                //Check ExcludeUserID__c not null and assign value in excludeUserIDs string array
                if (b_EmailBatchConf[0].ExcludeUserID__c!=null){
                    excludeUserIDs = string.valueOf(b_EmailBatchConf[0].ExcludeUserID__c ).split(',');
                }
                
                //fetch the list of User records based on the SOQL query mention in UserQuery__c
                b_UserList = Database.query(b_EmailBatchConf[0].UserQuery__c);
                //***********************************************************
                //Start : Getting UserIDs in string 
                //***********************************************************
                //declare variables
                String userID ='';
                Integer c = 0;
                //set User List size in the variable
                Integer cTotal = b_UserList.size();
                //loop through User list
                for (User u : b_UserList){                    
                    c++;
                    //check excludeUserIDs = null
                    if (excludeUserIDs==null){  
                        //set user Id
                        userID += '\'' + u.Id + '\'' + (c<ctotal ? ',':''); 
                    }
                    else if (excludeUserIDs!=null &&  !excludeUserIDs.contains(u.ID)){  
                        //set user Id
                        userID += '\'' + u.Id + '\'' + (c<ctotal ? ',':''); 
                    }
                }
                //***********************************************************
                //End : Getting UserIDs in string 
                //***********************************************************
                //fetch to SP cound based on the SOQL 
                totalCount = Database.countQuery(string.valueOf(b_EmailBatchConf[0].SPTotalCount__c).replace('##USERIDS##',userID));
                System.debug('Total Count :' + string.valueOf(totalCount));
                //fetch the SP query
                spQuery = b_EmailBatchConf[0].SalesPlannerQuery__c;
                //replace '##USERIDS##' with userID
                spQuery = spQuery.replace('##USERIDS##',userID);
                
                //initialize the Task List object
                b_TaskList = new List<Task>();
                //loop through task List based on the SOQL defined in the TaskQuery__c 
                for (Task t : Database.query(b_EmailBatchConf[0].TaskQuery__c)){
                    //add task record in the list
                    b_TaskList.add(t);
                }
                
                //loop through Event List based on the SOQL defined in the EventQuery__c
                b_EventList = new List<Event>();
                for (Event e : Database.query(b_EmailBatchConf[0].EventQuery__c)){
                    //add event record in the list
                    b_EventList.add(e);
                }
                
                //Create the User Map and add user record based on the UserList
                userMap = new map<ID,User>();
                for(User u : b_UserList)
                {
                    userMap.put(u.ID,u);
                }  
                //Create the Task Map
                taskMap = new map<String,Task>();
                for(Task t : b_TaskList)
                {
                    //create a task object
                    Task ot = new task(); 
                    //set TaskType in the string
                    String ttype = t.Type!=null ? t.Type.replace(' ','_') : '';
                    //get the task records based on the whatid and task type
                    ot= taskMap.get(String.valueOf(t.whatid)+ttype);
                    //check task =null
                    if (ot==null){
                        //add task records having a whatID and tasktype as a key
                        taskMap.put(t.whatid+ttype,t);
                    }else if (ot!=null && ot.DaysSinceLastActivityDate__c >t.DaysSinceLastActivityDate__c){
                        //check task not null and old and new task activity date and add task if met the condition
                        taskMap.put(t.whatid+ttype,t);
                    } 
                }        
                //Create the Event Map
                eventMap = new map<String,Event>();
                for(Event e : b_EventList)
                {
                    //create a event object
                    Event oe = new Event();
                    //set EventType in the string
                    String etype = e.Type!=null ? e.Type.replace(' ','_') : '';
                    //get the event records based on the whatid and event type
                    oe= eventMap.get(String.valueOf(e.whatid)+etype);
                    //check event = null
                    if (oe==null){
                        //add event records having a whatID and eventtype as a key
                        eventMap.put(e.whatid+etype,e);
                    }else if (oe!=null && oe.DaysSinceLastActivityDate__c >e.DaysSinceLastActivityDate__c){
                        //check event not null and old and new event activity date and add event if met the condition
                        eventMap.put(e.whatid+etype,e);
                    }
                }       
                //Create the Email Format Metadata Map based on the SOQL defined in the EmailFormatMetadataQuery__c          
                b_EmailFormatMetaData = Database.query(b_EmailBatchConf[0].EmailFormatMetadataQuery__c);
                //initialize the emailformat map
                emailFormatMap = new map<String,pvSalesPlannerEmailFormats__mdt>();
                //loop through email format metadata
                for(pvSalesPlannerEmailFormats__mdt eMDT : b_EmailFormatMetaData)
                {
                    //add emailformat record in the map
                    emailFormatMap.put(eMDT.Label ,eMDT);
                }
                
                //string header = 'DDD Outlet_ID,Account Owner,Owner_Role,Outlet Name,Account Name,Parent Account,Address,City,State,Zip,Last Inperson Activity Date,Last Non-Personal Activity Date,Last Non-personal activity (email;phone call;voicemail),Days since Last in-person visit \n';
                //set the header for CSV
                header = b_EmailBatchConf[0].CsvHeader__c +'\n';
                //assign tasktype based on the TypePicklistValues__c in metadata
                taskType = b_EmailBatchConf[0].TypePicklistValues__c.split(',');
                //check TestingEmail__c!=null if condition met assign assign the value in variable
                if (b_EmailBatchConf[0].TestingEmail__c!=null){
                    TestingEmail = b_EmailBatchConf[0].TestingEmail__c;
                } 
            }
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('SPEmailBatch', 'start', ex.getMessage(), ex.getLineNumber());
        }
        if (spQuery==''){
            //If spQuery is blank then set SOQL having limit of zero 
            spQuery ='Select ID, Name from Sales_Planner__c limit 0';
        }
        return Database.getQueryLocator(spQuery); 
    }
    /* ***************************************************************
    * @description: This function start execution of the process and send email
    * @Change:  
    * *************************************************************** */
    global void execute(Database.BatchableContext BC, List<Sales_Planner__c> spList) 
    {
        //create the Email List object
        transient List<Messaging.SingleEmailMessage> b_EmailList = new List<Messaging.SingleEmailMessage>();
        //increment the counter 
        callExecute++;
        
        //Create the SalesPlanner Owner Map
        for(Sales_Planner__c sp : spList)
        {
            spOwnerMap.put(sp.Account_Owner_ID__c,sp);
        }
        //create user object
        User objUser;
        //loop through SP List
        for(Sales_Planner__c sp : spList)
        {    
            try{
                //check the count =0 
                if (count==0){
                    //assogn OwnerID, ManagerID
                    ownerID = sp.Account_Owner_ID__c;
                    ManagerId = sp.Account_Owner_Manager_ID__c;
                    //Add header for User and Manager in list
                    finalUserCSVEmailData.add(header);
                    finalManagerCSVEmailData.add(header);
                }
                //increment counter
                count++;
                //declare the variable for non Inperson type
                String nonInPersonType;
                Date inPersonDate, nonInPersonDate;
                //declare the variable for untouch days and non inperson untouch days
                Decimal UntouchedDays,nonInPersonUntouchedDays;
                
                //loop thorugh task list Start : Get InPerson and Non-InPerson information from Task
                for(Integer cT=0; cT<taskType.size(); cT++){
                    //get Task record based on SP ID and task type from the Task Map
                    Task t = taskMap.get(String.valueOf(sp.Id)+taskType[cT]);
                    //check task  not null
                    if (t!=null){
                        //check ct == 0
                        if(cT == 0){
                            //assign Activity date and last activity date in respectivly variables
                            inPersonDate = t.ActivityDate;
                            UntouchedDays = t.DaysSinceLastActivityDate__c;
                        }
                        else{
                            //check nonInPersonUntouchedDays=null
                            if (nonInPersonUntouchedDays==null){
                                //assign task type, activity date and DaysSinceLastActivityDate__c in respectivly variables
                                nonInPersonType = string.valueOf(t.type);
                                nonInPersonDate = t.ActivityDate;
                                nonInPersonUntouchedDays = t.DaysSinceLastActivityDate__c;
                            }
                            else if (t.DaysSinceLastActivityDate__c < nonInPersonUntouchedDays){
                                //check t.DaysSinceLastActivityDate__c < nonInPersonUntouchedDays condition
                                //assign task type, activity date and DaysSinceLastActivityDate__c in respectivly variables 
                                nonInPersonType = string.valueOf(t.type);
                                nonInPersonDate = t.ActivityDate;
                                nonInPersonUntouchedDays = t.DaysSinceLastActivityDate__c;
                            } 
                        }
                    }
                }
                //declare variable to get the daysInBetween
                String daysInBetween;
                //check UntouchedDays not = null
                if (UntouchedDays!=null ){
                    //check UntouchedDays < 60 and add static value in variable
                    if (UntouchedDays < 60){
                        daysInBetween = '0-59';
                    }
                    else if (UntouchedDays < 90 && UntouchedDays>=60){
                        //check UntouchedDays < 90 && UntouchedDays>=60 and add static value in variable
                        daysInBetween = '60-89';
                    }
                    else if (UntouchedDays < 120 && UntouchedDays>=90){
                        //check UntouchedDays < 120 && UntouchedDays>=90 and add static value in variable
                        daysInBetween = '90-119';
                    }
                    else if (UntouchedDays>=120){
                        //check UntouchedDays>=120 and add static value in variable
                        daysInBetween = '>=120'; 
                    } 
                }
                else{
                    //In else, add static value in variable
                    daysInBetween = 'No Inperson activity logged';
                }
                //check daysInBetween not null and daysInBetween length  > 0
                if (daysInBetween!=null && daysInBetween.length()>0){
                    //get User record from map based on the owner id and assign to objUser 
                    objUser = userMap.get(ownerID);
                    //declare string variable to capture the SP Email row data
                    string recordString = '';
                    //check ownerID euqal to sp.Account_Owner_ID__c
                    if (ownerID == sp.Account_Owner_ID__c){
                        //assign SP data in variable for Indivisual user
                        recordString = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                        //add data in user string list
                        finalUserCSVEmailData.add(recordString);
                    }
                    //check ManagerId equal to sp.Account_Owner_Manager_ID__c
                    if (ManagerId == sp.Account_Owner_Manager_ID__c){ 
                        //check ownerID not equal to sp.Account_Owner_ID__c and get user from map and assign to objUser
                        if (ownerID != sp.Account_Owner_ID__c)
                            objUser = userMap.get(sp.Account_Owner_ID__c);
                        //set blank value
                        recordString='';
                        //assign SP data in variable for Manager user
                        recordString = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                        //add data in Manager string list
                        finalManagerCSVEmailData.add(recordString);
                        //get user from map and assign to objUser
                        objUser = userMap.get(ownerID);
                    }                   
                    //Check Email Format Metadata Values
                    if (b_EmailFormatMetaData.size()>0){                        
                        //check  objUser not null
                        if (objUser!=null){ 
                            //check below condition and add user email in emailList 
                            if (ownerID != sp.Account_Owner_ID__c || (totalCount!=null && count ==totalCount)){ 
                                b_EmailList.add(getEmailUser(objUser)); 
                            } 
                            //check below condition and add Manager email in emailList 
                            if (ManagerId != sp.Account_Owner_Manager_ID__c  || (totalCount!=null && count ==totalCount) ){                                
                                b_EmailList.add(getEmailManagerUser(objUser));
                            }
                            //For User: check below condition, if its true then goes to below section
                            if (ownerID != sp.Account_Owner_ID__c || (totalCount!=null && count ==totalCount)){ 
                                //Last Steps to execute, set Account_Owner_ID__c in ownerID variable
                                ownerID = sp.Account_Owner_ID__c;
                                //get user from map and assign to objUser
                                objUser = userMap.get(ownerID);
                                //clear the User CSV data
                                finalUserCSVEmailData.clear();
                                //add header for new User
                                finalUserCSVEmailData.add(header);
                                //assign SP data in variable for user
                                string recordStringNotSame = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                                    +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                                    +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                                    +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                                //add data in User string list
                                finalUserCSVEmailData.add(recordStringNotSame);  
                            }
                            
                            //For Manager: check below condition, if its true then goes to below section
                            if (ManagerId != sp.Account_Owner_Manager_ID__c  || (totalCount!=null && count ==totalCount) ){
                                //Last Steps to execute, set Account_Owner_Manager_ID__c in ManagerId variable
                                ManagerId = sp.Account_Owner_Manager_ID__c;
                                //clear the Manager CSV data
                                finalManagerCSVEmailData.clear();
                                //add header for new Manager
                                finalManagerCSVEmailData.add(header);
                                //assign SP data in variable for Manager
                                string recordManagerStringNotSame = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                                    +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                                    +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                                    +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                                //add data in Manager string list
                                finalManagerCSVEmailData.add(recordManagerStringNotSame);
                            }
                        }                    
                    }
                }  
            }
            catch(Exception mEx){
                System.debug('Exception : For Loop : ' + sp.ID + ', Error Message : ' + mEx.getMessage() + ', Error : ' + mEx.getStackTraceString());
            	ApexDebugLogController.insertLog('SPEmailBatch', 'execute', mEx.getMessage(), mEx.getLineNumber());
            }
        }
        //check below list not empty
        if (!b_EmailList.isEmpty()){
            //send bulk email
            Messaging.sendEmail(b_EmailList);
        }       
    }   
    /* ***************************************************************
    * @description: This function use to after finish the process
    * @Change:  
    * *************************************************************** */
    global void finish(Database.BatchableContext BC) {        
    }
    /* ***************************************************************
    * @description: This function use to create a Email object for User
    * @Change:  
    * *************************************************************** */
    global Messaging.SingleEmailMessage getEmailUser(user objUser){
        //Code for the attachemnt
        //create the attachment object
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        //convert the CSV data into blob and assign
        blob csvBlob = Blob.valueOf(String.join(finalUserCSVEmailData,''));
        //set the csv file name
        string csvname= 'Report-SalesPlanner.csv';
        //set setFileName in attachment object
        csvAttc.setFileName(csvname);
        //set setBody in attachment object
        csvAttc.setBody(csvBlob);
        
        //Code for the sending emaial
        //create email object
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
        //create to list and assign in email object
        string[] to = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.email }; 
        email.setToAddresses(to);
        //check BCC IDs and set in email object
        if(BccEmailIDs!=null && BccEmailIDs.size() > 0 ){
            email.setBccAddresses(BccEmailIDs);
        }
        //set subject and body
        String subject = b_EmailFormatMetaData[0].subject__c;
        String body = b_EmailFormatMetaData[0].body__c;
        //replace user name with hardcoded variable
        body= body.replace('##OWNER##',objUser.Name);
        //setSubject, setHtmlBody and setFileAttachments in email object  
        email.setSubject(subject); 
        email.setHtmlBody(body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        //return email object
        return email;
    }
    /* ***************************************************************
    * @description: This function use to create a Email object for Manager
    * @Change:  
    * *************************************************************** */
    global Messaging.SingleEmailMessage getEmailManagerUser(user objUser){
        //code to attach the CSV in the File object
        String csvSFLink = generateCSVLink(objUser.manager.Name, objUser.ManagerId,finalManagerCSVEmailData);
                
        //create sending email object
        Messaging.SingleEmailMessage emailManager = new Messaging.SingleEmailMessage();  
        //create to list and assign in email object
        string[] toMan = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.manager.email};
        emailManager.setToAddresses(toMan);
        //check CC IDs and set in email object
        if(ManagersEmailIdInCC!=null && ManagersEmailIdInCC.size() > 0 ){
                emailManager.setCcAddresses(ManagersEmailIdInCC);
        } 
        //check BCC IDs and set in email object
        if(BccEmailIDs!=null && BccEmailIDs.size() > 0 ){
                emailManager.setBccAddresses(BccEmailIDs);
        }
        //set subject and body
        String subjectMan =b_EmailFormatMetaData[1].subject__c;
        String bodyMan =b_EmailFormatMetaData[1].body__c;
        //replace Manager name and CSV link with hardcoded variables
        bodyMan= bodyMan.replace('##OWNER##',objUser.manager.Name);
        bodyMan= bodyMan.replace('##CSVDOWNLOADURL##',csvSFLink);
        //setSubject and setHtmlBody in email object 
        emailManager.setSubject(subjectMan); 
        emailManager.setHtmlBody(bodyMan);
        //return email object
        return emailManager;
    }
    /* ***************************************************************
    * @description: This function use to replace unwanted data
    * @Change:  
    * *************************************************************** */
    global String replaceUnwantedData(String input){
        //check input is not null
        if (input!=null){  
            //replace below carecter with space
            input = input.replace(',', ' ');
            input = input.replace('<br>', ' ');
            input = input.replace('\n', ' ');
            input = input.replace('\r', ' ');
        }
        else
            input ='';
        //return input after replacing unwanted data
        return input;
    }
    /* ***************************************************************
    * @description: This function use to format the Account Name and ID
    * @Change:  
    * *************************************************************** */
    global String getParentAccountNameID(String input){
        //check input not null
        if (input!=null){            
            try{  
                //check input contain href = ''
                if (input.contains('href=" "')){
                    input='';
                }
                else{
                    //if href not blank, split it and adding to string array
                    String[] splitHref = input.split('href="');
                    //declare the variable for ID and Name
                    string pID ='',pName='';
                    //check the string array length  > 0 
                    if (splitHref.size()>0){
                        //fetch ID and assign in pID
                        pID = splitHref[1].split('"')[0];
                        //getch name and assign in pName
                        pName = (splitHref[1].split('>')[1]).split('<')[0];
                    }
                    //set Name and ID in below format
                    input = pName + ' [ ' + pId + ' ]' ;
                }
            }
            catch(Exception e){
                input='';ApexDebugLogController.insertLog('SPEmailBatch', 'getParentAccountNameID', e.getMessage(), e.getLineNumber());
            }
        }
        return input; 
    }
    /* ***************************************************************
    * @description: This function use to generate a CSV link for Manager
    * @Change:  
    * *************************************************************** */
    global String generateCSVLink(String ManagerName, String ManagerId, List<String> finalCSVEmailData){
        try{
            //assign date in below variable
      		string fileCreationDate= string.valueOf(System.Datetime.now()).replace(' ','-').replace(':','-');
            //Start : Code to insert ContentVersion
            //create a ContentVersion object
            ContentVersion cVersion = new ContentVersion();
            //set ContentLocation to 'S'
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            //set file name with extention
            cVersion.PathOnClient = 'Report-SalesPlanner-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate  + '.csv';//File name with extention
            cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = UserInfo.getUserId();//Owner of the file
            cVersion.Title = 'Report-SalesPlanner-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate;//Name of the file
            cVersion.VersionData = Blob.valueOf(string.join(finalCSVEmailData,''));//File content
            //insert record in salesforce
            Insert cVersion;
            System.debug('cVersion : ' + cVersion);
            //End : Code to insert ContentVersion
            
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            //System.debug('conDocument : ' + conDocument);
            
            //Start : Code to insert ContentDocumentLink with the refernce of ContentVersion
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = ManagerId ;//'0582F0000008sUzQAI';//Add attachment parentId - This is a Library ID
            cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            //System.debug('cDocLink : ' + cDocLink);
            //End : Code to insert ContentDocumentLink with the refernce of ContentVersion
            
            //Start : Code to insert ContentDistribution with the refernce of ContentVersion
            ContentDistribution cd = new ContentDistribution();
            //set name and content version id
            cd.Name = 'Report-SalesPlanner-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate;            
            cd.ContentVersionId = cVersion.Id;
            insert cd;//insert a record
            //End : Code to insert ContentDistribution with the refernce of ContentVersion
            
            //Start : Code to get ContentDistribution Data
            List<ContentDistribution> cdSelect = [Select ContentDownloadUrl from ContentDistribution where ID=: cd.Id];
            if (!cdSelect.isEmpty()){
                return cdSelect[0].ContentDownloadUrl;
            }
            else
            {
                return '';
            }
            //End : Code to get ContentDistribution Data 
        }
        catch(Exception ex){  
            ApexDebugLogController.insertLog('SPEmailBatch', 'generateCSVLink', ex.getMessage(), ex.getLineNumber());
            return '';
        }
    }
}