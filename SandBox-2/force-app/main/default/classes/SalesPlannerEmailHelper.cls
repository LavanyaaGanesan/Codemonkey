public class SalesPlannerEmailHelper {
    static String TestingEmail = '';
    static List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
    static map<String,Sales_Planner__c> spOwnerMap = new map<String,Sales_Planner__c>();
    static map<ID,User> userMap = new map<ID,User>();
    static map<String,Task> taskMap = new map<String,Task>();
    static map<String,Event> eventMap = new map<String,Event>();
    static map<String,pvSalesPlannerEmailFormats__mdt> emailFormatMap = new map<String,pvSalesPlannerEmailFormats__mdt>();
    static string header ='';
    static string[] taskType;                  
    static String OwnerID, ManagerId;
    static LIST<String> finalUserCSVEmailData=new List<String>();
    static LIST<String> finalManagerCSVEmailData=new List<String>();
    static Integer count = 0;
    
    public static List<Messaging.SingleEmailMessage> setEmailsToSPOwnerAndManager(
        List<Sales_Planner__c> SPList,List<User> UserList, 
        List<Task> TaskList, List<Event> EventList,
        List<pvSalesPlannerEmailFormats__mdt> EmailFormatMetaData,
        List<pvEmailBatchConf__mdt> EmailBatchConf
    )
    {
        //Create the SalesPlanner Owner Map
        for(Sales_Planner__c sp : SPList)
        {
            spOwnerMap.put(sp.Account_Owner_ID__c,sp);
        }  
        //Create the User Map
        for(User u : UserList)
        {
            userMap.put(u.ID,u);
        }  
        //Create the Task Map
        for(Task t : TaskList)
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
        for(Event e : EventList)
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
        for(pvSalesPlannerEmailFormats__mdt eMDT : EmailFormatMetaData)
        {
            emailFormatMap.put(eMDT.Label ,eMDT);
        }
        
        //string header = 'DDD Outlet_ID,Account Owner,Owner_Role,Outlet Name,Account Name,Parent Account,Address,City,State,Zip,Last Inperson Activity Date,Last Non-Personal Activity Date,Last Non-personal activity (email;phone call;voicemail),Days since Last in-person visit \n';
        header = EmailBatchConf[0].CsvHeader__c +'\n';
        taskType = EmailBatchConf[0].TypePicklistValues__c.split(',');        
        
        for(Sales_Planner__c sp : SPList)
        {    
            try{
                if (count==0){
                    ownerID = sp.Account_Owner_ID__c;
                    ManagerId = sp.Account_Owner_Manager_ID__c;
                    finalUserCSVEmailData.add(header);
                    finalManagerCSVEmailData.add(header);
                }
                User objUser = userMap.get(ownerID);
                
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
                                if (nonInPersonUntouchedDays!=null && t.DaysSinceLastActivityDate__c < nonInPersonUntouchedDays){
                                    nonInPersonType = string.valueOf(t.type);
                                    nonInPersonDate = t.ActivityDate;
                                    nonInPersonUntouchedDays = t.DaysSinceLastActivityDate__c;
                                }else{
                                    nonInPersonType = string.valueOf(t.type);
                                    nonInPersonDate = t.ActivityDate;
                                    nonInPersonUntouchedDays = t.DaysSinceLastActivityDate__c;
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
                    if (UntouchedDays < 90 && UntouchedDays>=60){
                        daysInBetween = '60-89';
                    }
                    else if (UntouchedDays < 120 && UntouchedDays>=90){
                        daysInBetween = '90-119';
                    }
                    else if (UntouchedDays>=120){
                        daysInBetween = '>120'; 
                    } 
                }
                else{
                    daysInBetween = 'No Inperson activity logged';
                }
                
                if (daysInBetween!=null && daysInBetween.length()>0){
                    string recordString = '';
                    if (ownerID == sp.Account_Owner_ID__c){
                        recordString = sp.ID+','+replaceUnwantedData(sp.Name)+','+sp.DDD_Outlet_ID__c+','+objUser.Name+','+sp.Owner_Role__c+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ getParentAccountNameID(sp.Parent_Account__c)+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                        finalUserCSVEmailData.add(recordString);
                    }
                    if (ManagerId == sp.Account_Owner_Manager_ID__c){ 
                        recordString='';
                        recordString = sp.ID+','+replaceUnwantedData(sp.Name)+','+sp.DDD_Outlet_ID__c+','+objUser.Name+','+sp.Owner_Role__c+','+ replaceUnwantedData(sp.Outlet_Name__c)
                            +','+replaceUnwantedData(sp.Account_Name__c) +','+ getParentAccountNameID(sp.Parent_Account__c)+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
                            +','+replaceUnwantedData(sp.State_Province2__c)+','+replaceUnwantedData(sp.Zip_Postal_Code2__c) +','+ (inPersonDate!=null ? string.valueOf(inPersonDate) : '')
                            +','+ (nonInPersonDate!=null ? string.valueOf(nonInPersonDate) : '') +','+ (nonInPersonType!=null? string.valueOf(nonInPersonType) :'') +','+ daysInBetween +'\n';
                        finalManagerCSVEmailData.add(recordString);
                    }
                    //System.debug('5 : Condition :' + ownerID  + ' != ' + sp.Account_Owner_ID__c + ' || ' + count + ' >= ' +spList.size() 
                    //             +' - Email Size :' + EmailFormatMetaData.size());                   
                    //Check Email Format Metadata Values
                    if (EmailFormatMetaData.size()>0){                        
                        //System.debug('6 : User Object :' + objUser);
                        if (objUser!=null){ 
                            //****************************************************************
                            //Start : User - Email creation
                            //****************************************************************
                            if (ownerID != sp.Account_Owner_ID__c || count >=spList.size()){ 
                                //Code for the attachemnt
                                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                                blob csvBlob = Blob.valueOf(String.join(finalUserCSVEmailData,''));
                                string csvname= 'SalesPlanners-Untouched-list.csv';
                                csvAttc.setFileName(csvname);
                                csvAttc.setBody(csvBlob);
                                
                                //Code for the sending emaial
                                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
                                
                                string[] to = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.email }; 
                                    email.setToAddresses(to);
                                
                                if(objUser.manager.email!=null && objUser.manager.email != '' ){
                                    string[] bcc = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.manager.email};
                                        email.setBccAddresses(bcc);
                                }
                                String subject =EmailFormatMetaData[0].subject__c;
                                String body =EmailFormatMetaData[0].body__c;
                                body= body.replace('##OWNER##',objUser.Name);
                                
                                email.setSubject(subject); 
                                email.setHtmlBody(body);
                                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                                
                                //System.debug('7 : Email Object :' + email);
                                
                                emailList.add(email);
                                //Last Steps to execute
                                ownerID = sp.Account_Owner_ID__c;
                                finalUserCSVEmailData.clear();
                                finalUserCSVEmailData.add(header);
                                string recordStringNotSame = sp.ID+','+replaceUnwantedData(sp.Name)+','+sp.DDD_Outlet_ID__c+','+objUser.Name+','+sp.Owner_Role__c+','+ replaceUnwantedData(sp.Outlet_Name__c)
                                    +','+replaceUnwantedData(sp.Account_Name__c) +','+ getParentAccountNameID(sp.Parent_Account__c)+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
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
                            if (ManagerId != sp.Account_Owner_Manager_ID__c  || count >=spList.size() ){
                                //Start: Code to attach the CSV in the File object
                                String csvSFLink = generateCSVLink(objUser.manager.Name, objUser.ManagerId,finalManagerCSVEmailData);
                                //End: Code to attach the CSV in the File object
                                
                                //Code for the sending emaial
                                Messaging.SingleEmailMessage emailManager = new Messaging.SingleEmailMessage();  
                                
                                string[] toMan = new string[] {TestingEmail.length()>4 ? TestingEmail : objUser.manager.email};
                                    emailManager.setToAddresses(toMan);                            
                                
                                String subjectMan =EmailFormatMetaData[1].subject__c;
                                String bodyMan =EmailFormatMetaData[1].body__c;
                                bodyMan= bodyMan.replace('##OWNER##',objUser.manager.Name);
                                bodyMan= bodyMan.replace('##CSVDOWNLOADURL##',csvSFLink);
                                
                                emailManager.setSubject(subjectMan); 
                                emailManager.setHtmlBody(bodyMan);                                
                                emailList.add(emailManager);                                
                                
                                //Last Steps to execute
                                ManagerId = sp.Account_Owner_Manager_ID__c;
                                finalManagerCSVEmailData.clear();
                                finalManagerCSVEmailData.add(header);
                                string recordManagerStringNotSame = sp.ID+','+replaceUnwantedData(sp.Name)+','+sp.DDD_Outlet_ID__c+','+objUser.Name+','+sp.Owner_Role__c+','+ replaceUnwantedData(sp.Outlet_Name__c)
                                    +','+replaceUnwantedData(sp.Account_Name__c) +','+ getParentAccountNameID(sp.Parent_Account__c)+','+replaceUnwantedData(sp.Street2__c)+','+replaceUnwantedData(sp.City2__c)
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
            }
            catch(Exception mEx){
                System.debug('Exception : For Loop : ' + sp.ID + ', Error : ' + mEx.getStackTraceString());
            }
        }        
        return emailList;
    }
    public static String replaceUnwantedData(String input){
        if (input!=null){  
            input = input.replace(',', ' ');
            input = input.replace('<br>', ' ');
            input = input.replace('\n', ' ');
            input = input.replace('\r', ' ');
        }
        return input;
    }
    public static String getParentAccountNameID(String input){
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
    public static String generateCSVLink(String ManagerName, String ManagerId, List<String> finalCSVEmailData){
        try{
            string fileCreationDate= string.valueOf(System.Datetime.now()).replace(' ','-').replace(':','-');
            //Start : Code to insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = 'SalesPlanners-Untouched-list-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate  + '.csv';//File name with extention
            cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = UserInfo.getUserId();//Owner of the file
            cVersion.Title = 'SalesPlanners-Untouched-list-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate;//Name of the file
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
            cd.Name = 'SalesPlanners-Untouched-list-' + ManagerName.replace(' ', '_') +'-'+ fileCreationDate;
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