trigger AccountTriggers on Account (before insert, before update) {
    if(!TriggerSettings__c.getOrgDefaults().TriggersEnabled__c){
        system.debug('### Triggers not enabled, not running AccountTriggers');
        return;
    }
    
    if(TriggerSettings__c.getOrgDefaults().updateContractAmount__c){
        //Set<Id> accountIds = new Set<Id>();
        List<Account> accounts = new List<Account>();
        List<Account> accountsToUpdate = new List<Account>();
        
        Map<Id, String> oldAccounts = new Map<Id, String>();
        if (trigger.isUpdate){
            for(Account a : trigger.old){
                oldAccounts.put(a.Id, a.Current_Vivotif_Contract__c);
            }
            
        
            for(Account a : trigger.new){
                if(a.Current_Vivotif_Contract__c <> oldAccounts.get(a.Id)){
                    accounts.add(a);
                }
            }
        }
        else if (trigger.isInsert){
            for(Account a : trigger.new){
                accounts.add(a);
            }
        }
        
        if(!accounts.isEmpty()){
            AccountHelper.updateContractAmount(accounts);
        }
    }
}