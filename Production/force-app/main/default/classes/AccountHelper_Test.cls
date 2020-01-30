@isTest
public class AccountHelper_Test {
    public static testMethod void updateContractAmounts(){
        TriggerSettings__c settings = new TriggerSettings__c(TriggersEnabled__c = true,
                                                            updateContractAmount__c = true);
        insert settings;
        
        Vivotif_Contract__c contract1 = new Vivotif_Contract__c(Vivotif_Contract_Name__c = 'Test Contract 1',
                                                               Contract_Price__c = 100);
        insert contract1;
        
        
        Vivotif_Contract__c contract2 = new Vivotif_Contract__c(Vivotif_Contract_Name__c = 'Test Contract 2',
                                                               Contract_Price__c = 200);
        insert contract2;
        
        Account a = new Account(Name = 'Test Account',
                               Current_Vivotif_Contract__c = 'Test Contract 1',
                               Contract_Price__c = 0);
        test.startTest();
        //test insert
        insert a;
        a = [select Id, Contract_Price__c from Account where Id =: a.Id];
        system.debug('### a.Contract_Price__c: ' + a.Contract_Price__c);
        system.assert(a.Contract_Price__c == 100);
        
        //test update
        a.Current_Vivotif_Contract__c = 'Test Contract 2';
        update a;
        a = [select Id, Contract_Price__c from Account where Id =: a.Id];
        system.debug('### a.Contract_Price__c: ' + a.Contract_Price__c);
        system.assert(a.Contract_Price__c == 200);
        
        //test no Account Contract specified
        a.Current_Vivotif_Contract__c = null;
        update a;
        a = [select Id, Contract_Price__c from Account where Id =: a.Id];
        system.debug('### a.Contract_Price__c: ' + a.Contract_Price__c);
        system.assert(a.Contract_Price__c == null);
        
        //test Contract record doesn't exist
        a.Current_Vivotif_Contract__c = 'Does Not Exist';
        update a;
        a = [select Id, Contract_Price__c from Account where Id =: a.Id];
        system.debug('### a.Contract_Price__c: ' + a.Contract_Price__c);
        system.assert(a.Contract_Price__c == null);
        test.stopTest();
    }
}