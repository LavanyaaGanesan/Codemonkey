global class emailToCase implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        Case c;
        Account a;
        
        // Retrieves content from the email. 
        String emailBodyFull = email.plainTextBody;
        String emailSubject = email.subject;
        Boolean accountIdIncluded = true;
        
        List<String> parsedEmailSubject = emailSubject.split(';');
        List<String> trimmedEmailSubject = new List<String>();
        for (String text : parsedEmailSubject){
            trimmedEmailSubject.add(text.trim());
        }
        system.debug(trimmedEmailSubject);
        
        String caseId = trimmedEmailSubject[0];
        String pvAccountId = trimmedEmailSubject[1];
        String caseStatus = trimmedEmailSubject[2];
        String accountName = trimmedEmailSubject[3];
        
        if (pvAccountId.length() < 1){
            accountIdIncluded = false;
        }
        
        system.debug('### Case ID: [' + caseId + ']');
        system.debug('### Account External ID: [' + pvAccountId + ']');
        system.debug('### Case Status: [' + caseStatus + ']');
        system.debug('### Account Name: [' + accountName + ']');
        
        //check to see if case exists, then
        try{
            c = [select Id, McKesson_Case_Id__c,  Status from Case where McKesson_Case_Id__c =: caseId limit 1];
        }
        catch(Exception e){
            system.debug('### No Case Found');
        }
        
        //if a case was found, update the status
        if(c <> null){
            system.debug('### Case Found, Updating Case: ' + c);
            c.Status = caseStatus;
            update c;
            return result;
        }
        
        //if not updating case, check for Account
        if(accountIdIncluded == true){
            //find or Create Account
            try{
                a = [select Id, PaxVax_ID__c, OwnerId from Account where PaxVax_ID__c  =: pvAccountId limit 1];
                system.debug('### Account Matched ' + a);
            }
            catch(Exception e){
                system.debug('### No Account Matched, creating new Account');
                //create new Account
                a = new Account(Name = accountName);
            }
        }
        else{
            system.debug('### No Account Id, creating new Account: ' + accountName);
            a = new Account(Name = accountName);
        }
        
        //create new case
        if(a <> null){
            Id owner;
            if (a.OwnerId <> null){
                owner = a.OwnerId;
            }
            else{
                owner = userInfo.getUserId();
            }
            c = new Case(AccountId = a.Id,
                         Status = caseStatus,
                         McKesson_Case_Id__c  = caseId,
                         Description = emailBodyFull,
                         Origin = 'Email - McKesson',
                         OwnerId = owner
                        );
            
            insert c;
        }
        
        return result;
    }   
}