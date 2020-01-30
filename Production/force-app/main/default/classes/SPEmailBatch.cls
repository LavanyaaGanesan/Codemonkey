global class SPEmailBatch implements Database.Batchable<sObject>, Database.Stateful {
	// global variables
    global List<pvEmailBatchConf__mdt> b_EmailBatchConf;
	global List<User> b_UserList;
    global List<Sales_Planner__c> b_SPList;
    global List<Task> b_TaskList;
    global List<Event> b_EventList;
    global List<pvSalesPlannerEmailFormats__mdt> b_EmailFormatMetaData;
    
    global String TestingEmail = '';
    global string[] BccEmailIDs;
    global string[] ManagersEmailIdInCC;
    
    global string[] excludeUserIDs;
    global map<String,Sales_Planner__c> spOwnerMap;
    global map<ID,User> userMap;
    global map<String,Task> taskMap;
    global map<String,Event> eventMap;
    global map<String,pvSalesPlannerEmailFormats__mdt> emailFormatMap;
    global string header ='';
    global string[] taskType;                  
    global String OwnerID, ManagerId;
    global LIST<String> finalUserCSVEmailData;
    global LIST<String> finalManagerCSVEmailData;
    global Integer totalCount=0;
    global Integer count = 0;
    global Integer callExecute = 0;
        
    //global String[] finishSubscriberEmailList;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        spOwnerMap = new map<String,Sales_Planner__c>();
        
        finalUserCSVEmailData=new List<String>();
        finalManagerCSVEmailData=new List<String>();
        
        b_EmailBatchConf =  Database.query(System.Label.pvEmailBatchConfQuery);
        
        totalCount=0;
        count = 0;
        callExecute = 0;
        
        string spQuery = '';
        //User List
        if (b_EmailBatchConf.size()>0){  
            
            if (b_EmailBatchConf[0].ManagersEmailIdInCC__c!=null){
                ManagersEmailIdInCC = string.valueOf( b_EmailBatchConf[0].ManagersEmailIdInCC__c).split(',');
            }
            if (b_EmailBatchConf[0].BccEmailID__c!=null){
                BccEmailIDs = string.valueOf( b_EmailBatchConf[0].BccEmailID__c).split(',');
            }
            if (b_EmailBatchConf[0].ExcludeUserID__c!=null){
                excludeUserIDs = string.valueOf(b_EmailBatchConf[0].ExcludeUserID__c ).split(',');
            }
            
            //Get User List
            b_UserList = Database.query(b_EmailBatchConf[0].UserQuery__c);
        	//***********************************************************
        	//Start : Getting UserIDs in string 
        	//***********************************************************
            String userID ='';
            Integer c = 0;
            Integer cTotal = b_UserList.size();
            for (User u : b_UserList){
                c++;
                if (excludeUserIDs==null){                   
                	userID += '\'' + u.Id + '\'' + (c<ctotal ? ',':''); 
                }
                else if (excludeUserIDs!=null &&  !excludeUserIDs.contains(u.ID)){                   
                	userID += '\'' + u.Id + '\'' + (c<ctotal ? ',':''); 
                }
            }
            //***********************************************************
            //End : Getting UserIDs in string 
        	//***********************************************************
        	
            totalCount = Database.countQuery(string.valueOf(b_EmailBatchConf[0].SPTotalCount__c).replace('##USERIDS##',userID));
            System.debug('Total Count :' + string.valueOf(totalCount));
            
            spQuery = b_EmailBatchConf[0].SalesPlannerQuery__c;
            spQuery = spQuery.replace('##USERIDS##',userID);
            
            //b_TaskList = Database.query(b_EmailBatchConf[0].TaskQuery__c);
            b_TaskList = new List<Task>();
            for (Task t : Database.query(b_EmailBatchConf[0].TaskQuery__c)){
                b_TaskList.add(t);
            }
            
            //b_EventList = Database.query(b_EmailBatchConf[0].EventQuery__c);
            b_EventList = new List<Event>();
            for (Event e : Database.query(b_EmailBatchConf[0].EventQuery__c)){
                b_EventList.add(e);
            }
             
            //Create the User Map
            userMap = new map<ID,User>();
            for(User u : b_UserList)
            {
                userMap.put(u.ID,u);
            }  
            //Create the Task Map
            taskMap = new map<String,Task>();
            for(Task t : b_TaskList)
            {
                Task ot = new task(); 
                String ttype = t.Type!=null ? t.Type.replace(' ','_') : '';
                ot= taskMap.get(String.valueOf(t.whatid)+ttype);
                //System.debug('ot : ' + ot);
                if (ot==null){
                    taskMap.put(t.whatid+ttype,t);
                }else if (ot!=null && ot.DaysSinceLastActivityDate__c >t.DaysSinceLastActivityDate__c){
                    taskMap.put(t.whatid+ttype,t);
                } 
            }        
            //Create the Event Map
            eventMap = new map<String,Event>();
            for(Event e : b_EventList)
            {
                Event oe = new Event();
                String etype = e.Type!=null ? e.Type.replace(' ','_') : '';
                oe= eventMap.get(String.valueOf(e.whatid)+etype);
                //System.debug('oe : ' + oe);
                if (oe==null){
                    eventMap.put(e.whatid+etype,e);
                }else if (oe!=null && oe.DaysSinceLastActivityDate__c >e.DaysSinceLastActivityDate__c){
                    eventMap.put(e.whatid+etype,e);
                }
            }       
            //Create the Email Format Metadat Map            
            b_EmailFormatMetaData = Database.query(b_EmailBatchConf[0].EmailFormatMetadataQuery__c);
            emailFormatMap = new map<String,pvSalesPlannerEmailFormats__mdt>();
            for(pvSalesPlannerEmailFormats__mdt eMDT : b_EmailFormatMetaData)
            {
                emailFormatMap.put(eMDT.Label ,eMDT);
            }
            
            //string header = 'DDD Outlet_ID,Account Owner,Owner_Role,Outlet Name,Account Name,Parent Account,Address,City,State,Zip,Last Inperson Activity Date,Last Non-Personal Activity Date,Last Non-personal activity (email;phone call;voicemail),Days since Last in-person visit \n';
            header = b_EmailBatchConf[0].CsvHeader__c +'\n';
            taskType = b_EmailBatchConf[0].TypePicklistValues__c.split(',');
            if (b_EmailBatchConf[0].TestingEmail__c!=null){
            	TestingEmail = b_EmailBatchConf[0].TestingEmail__c;
            } 
        }
        return Database.getQueryLocator(spQuery); 
    }
    
    global void execute(Database.BatchableContext BC, List<Sales_Planner__c> spList) {
      transient List<Messaging.SingleEmailMessage> b_EmailList = new List<Messaging.SingleEmailMessage>();
        
      callExecute++;
      System.debug('Count' + string.valueOf(count) +', SPList size() : ' + string.valueOf(spList.size()) + ', Date : ' + string.valueOf(System.Datetime.now())) ;  
        
        //Create the SalesPlanner Owner Map
        for(Sales_Planner__c sp : spList)
        {
            spOwnerMap.put(sp.Account_Owner_ID__c,sp);
        }
        
        User objUser;
        
        for(Sales_Planner__c sp : spList)
        {    
            try{
                if (count==0){
                    ownerID = sp.Account_Owner_ID__c;
                    ManagerId = sp.Account_Owner_Manager_ID__c;
                    finalUserCSVEmailData.add(header);
                    finalManagerCSVEmailData.add(header);
                }
                
                count++;
                
                String nonInPersonType;
                Date inPersonDate, nonInPersonDate;
                Decimal UntouchedDays,nonInPersonUntouchedDays;//mWhatList.get(String.valueOf(sp.Id))!=null ? mWhatList.get(String.valueOf(sp.Id)) :  Integer.valueOf(sp.Active_Days_Count__c);            
                
                //System.debug('Task Map : ' + taskMap.get('a1961000009IRrcAAGIn_Person'));
                
                //Start : Get InPerson and Non-InPerson information from Task
                for(Integer cT=0; cT<taskType.size(); cT++){
                    //System.debug('Task Key : ' + String.valueOf(sp.Id)+taskType[cT]);
                    Task t = taskMap.get(String.valueOf(sp.Id)+taskType[cT]);
                    if(t!=null){
                        //System.debug('Task Object : ' + t);
                        if (t!=null){
                            if(cT == 0){
                                inPersonDate = t.ActivityDate;
                                UntouchedDays = t.DaysSinceLastActivityDate__c;
                                //System.debug('1111 - Inperson : ' + string.valueOf(inPersonDate) + ' - ' + string.valueOf(UntouchedDays));
                            }
                            else{
                                if (nonInPersonUntouchedDays==null){
                                    nonInPersonType = string.valueOf(t.type);
                                    nonInPersonDate = t.ActivityDate;
                                    nonInPersonUntouchedDays = t.DaysSinceLastActivityDate__c;
                                    //System.debug('Null : ' + nonInPersonUntouchedDays);
                                }
                                else if (t.DaysSinceLastActivityDate__c < nonInPersonUntouchedDays){
                                    nonInPersonType = string.valueOf(t.type);
                                    nonInPersonDate = t.ActivityDate;
                                    nonInPersonUntouchedDays = t.DaysSinceLastActivityDate__c;
                                    //System.debug('Not Null : ' + t.DaysSinceLastActivityDate__c + ' > ' +  nonInPersonUntouchedDays);
                                } 
                                
                                //System.debug('2222 - Non-Inperson : ' + nonInPersonType + ' - ' + 
                                //             string.valueOf(nonInPersonDate) + ' - ' + string.valueOf(nonInPersonUntouchedDays));
                            }
                        }
                    }
                }
                //End : Get InPerson and Non-InPerson information from Task
                
                String daysInBetween;
                if (UntouchedDays!=null ){
                    if (UntouchedDays < 60){
                        daysInBetween = '0-59';
                    }
                    else if (UntouchedDays < 90 && UntouchedDays>=60){
                        daysInBetween = '60-89';
                    }
                    else if (UntouchedDays < 120 && UntouchedDays>=90){
                        daysInBetween = '90-119';
                    }
                    else if (UntouchedDays>=120){
                        daysInBetween = '>=120'; 
                    } 
                }
                else{
                    daysInBetween = 'No Inperson activity logged';
                }
                
                if (daysInBetween!=null && daysInBetween.length()>0){
                    
                    objUser = userMap.get(ownerID);
                    
                    string recordString = '';
                    if (ownerID == sp.Account_Owner_ID__c){
                        recordString = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                        finalUserCSVEmailData.add(recordString);
                    }
                    if (ManagerId == sp.Account_Owner_Manager_ID__c){ 
                        if (ownerID != sp.Account_Owner_ID__c)
                            objUser = userMap.get(sp.Account_Owner_ID__c);
                        
                        recordString='';
                        recordString = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                        finalManagerCSVEmailData.add(recordString);
                        objUser = userMap.get(ownerID);
                    }
                    //System.debug('5 : Condition :' + ownerID  + ' != ' + sp.Account_Owner_ID__c + ' || ' + count + ' >= ' +spList.size() 
                    //             +' - Email Size :' + EmailFormatMetaData.size());                   
                    //Check Email Format Metadata Values
                    if (b_EmailFormatMetaData.size()>0){                        
                        //System.debug('6 : User Object :' + objUser);
                        if (objUser!=null){ 
                            if (ownerID != sp.Account_Owner_ID__c || (totalCount!=null && count ==totalCount)){ 
                                b_EmailList.add(getEmailUser(objUser)); 
                            } 
                            if (ManagerId != sp.Account_Owner_Manager_ID__c  || (totalCount!=null && count ==totalCount) ){                                
                                b_EmailList.add(getEmailManagerUser(objUser));
                            }
                            //****************************************************************
                            //Start : User - Email creation
                            //****************************************************************
                            if (ownerID != sp.Account_Owner_ID__c || (totalCount!=null && count ==totalCount)){ 
                                //Last Steps to execute
                                ownerID = sp.Account_Owner_ID__c;
                                objUser = userMap.get(ownerID);
                                finalUserCSVEmailData.clear();
                                finalUserCSVEmailData.add(header);
                                string recordStringNotSame = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                                finalUserCSVEmailData.add(recordStringNotSame);  
                            }  
                            //****************************************************************
                            //End : User - Email creation
                            //****************************************************************
                            
                            //****************************************************************
                            //Start : Mananger - Email creation
                            //****************************************************************
                            if (ManagerId != sp.Account_Owner_Manager_ID__c  || (totalCount!=null && count ==totalCount) ){
                                //Last Steps to execute
                                ManagerId = sp.Account_Owner_Manager_ID__c;
                                //objUser = userMap.get(ownerID);
                                finalManagerCSVEmailData.clear();
                                finalManagerCSVEmailData.add(header);
                                string recordManagerStringNotSame = sp.ID+','+replaceUnwantedData(sp.Name)+','+replaceUnwantedData(sp.DDD_Outlet_ID__c)+','+replaceUnwantedData(objUser.Name)+','+replaceUnwantedData(sp.Owner_Role__c)+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ replaceUnwantedData(getParentAccountNameID(sp.Parent_Account__c))+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                                finalManagerCSVEmailData.add(recordManagerStringNotSame);
                            }
                            //****************************************************************
                            //End : Mananger - Email creation
                            //****************************************************************
                        }                    
                    }
                }                
                /*if (totalCount!=null && count == totalCount){
                    if (objUser!=null){
                        if (finalUserCSVEmailData.size()>1){
                            b_EmailList.add(getEmailUser(objUser));
                        }
                        if (finalManagerCSVEmailData.size()>1){
                            b_EmailList.add(getEmailManagerUser(objUser));
                        }
                    }
                }*/
            }
            catch(Exception mEx){
                System.debug('Exception : For Loop : ' + sp.ID + ', Error Message : ' + mEx.getMessage() + ', Error : ' + mEx.getStackTraceString());
            }
        }
        //System.debug('Send Email Start');
        if (b_EmailList!=null && b_EmailList.size()>0){
            //System.debug('Send Email 1');
        	Messaging.sendEmail(b_EmailList);
            //System.debug('Send Email 2');
        }
        //System.debug('Send Email End');        
    }   
    
    global void finish(Database.BatchableContext BC) {
        /*if (b_EmailList!=null && b_EmailList.size()>0){
            System.debug('Final Count : ' + string.valueOf(count));
        	Messaging.sendEmail(b_EmailList);
        }*/
    }
    
    global Messaging.SingleEmailMessage getEmailUser(user objUser){
        //Code for the attachemnt
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(String.join(finalUserCSVEmailData,''));
        string csvname= 'Report-SalesPlanner.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        
        //Code for the sending emaial
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
        
        string[] to = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.email }; 
            email.setToAddresses(to);
        
        if(BccEmailIDs!=null && BccEmailIDs.size() > 0 ){
                email.setBccAddresses(BccEmailIDs);
        }
        String subject = b_EmailFormatMetaData[0].subject__c;
        String body = b_EmailFormatMetaData[0].body__c;
        body= body.replace('##OWNER##',objUser.Name);
        
        email.setSubject(subject); 
        email.setHtmlBody(body);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        return email;
    }
    
    global Messaging.SingleEmailMessage getEmailManagerUser(user objUser){
        //Start: Code to attach the CSV in the File object
        String csvSFLink = generateCSVLink(objUser.manager.Name, objUser.ManagerId,finalManagerCSVEmailData);
        //End: Code to attach the CSV in the File object
        
        //Code for the sending emaial
        Messaging.SingleEmailMessage emailManager = new Messaging.SingleEmailMessage();  
        
        string[] toMan = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.manager.email};
            emailManager.setToAddresses(toMan);
        
        
        if(ManagersEmailIdInCC!=null && ManagersEmailIdInCC.size() > 0 ){
                emailManager.setCcAddresses(ManagersEmailIdInCC);
        }    
        if(BccEmailIDs!=null && BccEmailIDs.size() > 0 ){
                emailManager.setBccAddresses(BccEmailIDs);
        }
        
        String subjectMan =b_EmailFormatMetaData[1].subject__c;
        String bodyMan =b_EmailFormatMetaData[1].body__c;
        bodyMan= bodyMan.replace('##OWNER##',objUser.manager.Name);
        bodyMan= bodyMan.replace('##CSVDOWNLOADURL##',csvSFLink);
        
        emailManager.setSubject(subjectMan); 
        emailManager.setHtmlBody(bodyMan);
        return emailManager;
    }
    
    global String replaceUnwantedData(String input){
        if (input!=null){  
            input = input.replace(',', ' ');
            input = input.replace('<br>', ' ');
            input = input.replace('\n', ' ');
            input = input.replace('\r', ' ');
        }
        else
            input ='';
        
        return input;
    }
    global String getParentAccountNameID(String input){
        if (input!=null){            
            try{            
                if (input.contains('href=" "')){
                    input='';
                }
                else{
                    String[] splitHref = input.split('href="');
                    string pID ='',pName='';
                    if (splitHref.size()>0){
                        pID = splitHref[1].split('"')[0];
                        pName = (splitHref[1].split('>')[1]).split('<')[0];
                    }
                    input = pName + ' [ ' + pId + ' ]' ;
                }
            }
            catch(Exception e){
                input='';
            }
        }
        return input; 
    }
    global String generateCSVLink(String ManagerName, String ManagerId, List<String> finalCSVEmailData){
        try{
            System.debug('ManagerName ' + string.valueOf(ManagerName) +', ManagerId : ' + string.valueOf(ManagerId) + ', Date : ' + string.valueOf(System.Datetime.now())) ;  
      		string fileCreationDate= string.valueOf(System.Datetime.now()).replace(' ','-').replace(':','-');
            //Start : Code to insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = 'Report-SalesPlanner-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate  + '.csv';//File name with extention
            cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = UserInfo.getUserId();//Owner of the file
            cVersion.Title = 'Report-SalesPlanner-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate;//Name of the file
            cVersion.VersionData = Blob.valueOf(string.join(finalCSVEmailData,''));//File content
            Insert cVersion;
            System.debug('cVersion : ' + cVersion);
            //End : Code to insert ContentVersion
            
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            System.debug('conDocument : ' + conDocument);
            
            //Start : Code to insert ContentDocumentLink with the refernce of ContentVersion
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = ManagerId ;//'0582F0000008sUzQAI';//Add attachment parentId - This is a Library ID
            cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            System.debug('cDocLink : ' + cDocLink);
            //End : Code to insert ContentDocumentLink with the refernce of ContentVersion
            
            //Start : Code to insert ContentDistribution with the refernce of ContentVersion
            ContentDistribution cd = new ContentDistribution();
            cd.Name = 'Report-SalesPlanner-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate;
            cd.ContentVersionId = cVersion.Id;
            insert cd;
            System.debug('ContentDistribution link : ' + cd.ContentDownloadUrl);
            //End : Code to insert ContentDistribution with the refernce of ContentVersion
            
            //Start : Code to get ContentDistribution Data
            List<ContentDistribution> cdSelect = [Select ContentDownloadUrl from ContentDistribution where ID=: cd.Id];
            if (cdSelect.size()>0){
                return cdSelect[0].ContentDownloadUrl;
            }
            else
            {
                return '';
            }
            //End : Code to get ContentDistribution Data 
        }
        catch(Exception ex){
            System.debug('generateCSVLink Exception : ManagerName : ' + 
                         ManagerName + ', ManagerId : '+ ManagerId + ', Error : ' + ex.getMessage());
            return '';
        }
    }
}