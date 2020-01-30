@IsTest
public class emailToCase_Test {
    static testMethod void emailToCase_TestMethod(){
        Account a = new Account(Name = 'Test Account');
        insert a;
        
        a = [select Id, PaxVax_ID__c from Account where Id =: a.Id limit 1];
        String accountId = a.PaxVax_ID__c;
        
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        email.subject = '20160302-178810; ' + accountId + '; In Progress; ALTRU HOSPITAL OP';
        email.fromAddress = 'someaddress@email.com';
        
        email.plainTextBody = 'vvermeulen@playnetwork.com (Vorster Vermeulen) has created a new Zadara Storage account. ' + 
            '>Username: vvermeulen@playnetwork.com ' + 
            '>Email: vvermeulen@playnetwork.com ' +
            '>First Name: Vorster ' +
            '>Last Name: Vermeulen ' +
            '>Company: PlayNetwork, Inc. ' +
            '>Phone Number: 2066796938 ' +
            '>Country: US ' + '\n>' +
            'Note that no action is required on your part to activate the users account.  They will be able to log in immediately.';
        
        Test.startTest();
        emailToCase testInbound = new emailToCase();
        testInbound.handleInboundEmail(email, env);
        
        
        email.subject = '20160302-178810; ' + accountId + '; Closed; ALTRU HOSPITAL OP';
        testInbound.handleInboundEmail(email, env);
        
        email.subject = '20160502-000001; ; In Progress; ALTRU HOSPITAL OP';
        testInbound.handleInboundEmail(email, env);

        email.subject = '20160502-000002; PVA-0000000; In Progress; ALTRU HOSPITAL OP';
        testInbound.handleInboundEmail(email, env);
        
        Test.stopTest();
    }
}