public class AccountHelper {
    public static void updateContractAmount(List<Account> accounts){
        Map<String, Decimal> contractNameAmount = new Map<String, Decimal>();
        for(Vivotif_Contract__c contract : [select Vivotif_Contract_Name__c, Contract_Price__c from Vivotif_Contract__c]){
            contractNameAmount.put(contract.Vivotif_Contract_Name__c, contract.Contract_Price__c);
        }
        system.debug('### AccountHelper.updateContractAmount() found [' + contractNameAmount.size() + '] values');
        for (Account a : accounts){
            if(a.Current_Vivotif_Contract__c <> null){
                if(contractNameAmount.containsKey(a.Current_Vivotif_Contract__c)){
                    a.Contract_Price__c = contractNameAmount.get(a.Current_Vivotif_Contract__c);
                }
                else{
                    system.debug('### AccountHelper.updateContractAmount - No matching VC record found for contract: ' + a.Current_Vivotif_Contract__c);
                    a.Contract_Price__c = null;
                }
            }
            else{
                system.debug('### AccountHelper.updateContractAmount - No contract value supplied');
                a.Contract_Price__c = null;
            }
        }
    }
}