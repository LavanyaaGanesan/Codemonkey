public class IMSHelper {
    public static void createIMSYear(List<Account> accounts){
        List<IMS_Yearly_Stats__c> imsYearsToCreate = new List<IMS_Yearly_Stats__c>();
        String year = system.now().format('YYYY');

        //build map of duplicates
        Map<Id, String> accountYearMap = new Map<Id, String>();
        for (IMS_Yearly_Stats__c imsYear : [select Id, Account__c, Year__c
                                            FROM IMS_Yearly_Stats__c 
                                            WHERE Year__c =: year]){
        	accountYearMap.put(imsYear.Account__c, imsYear.Year__c);
        }

        
        for (Account a : accounts){
            if(accountYearMap.containsKey(a.Id) && accountYearMap.get(a.Id) == year){                
                system.debug('### IMS Year [' + year + '] already exists for Account [' + a.Id +']');
            }
            else{
                system.debug('### IMSHelper Creating IMS Year [' + year + ']  for Account [' + a.Id +']');
                imsYearsToCreate.add(new IMS_Yearly_Stats__c(Year__c = year,
                                                             Account__c = a.Id));
            }
        }
        
        if (!imsYearsToCreate.isEmpty()){
            insert imsYearsToCreate;
        }
        
    }
    public static void createPreviousIMSMonth(List<IMS_Yearly_Stats__c > imsYears){
        List<IMS_Monthly_Stats__c> imsMonthsToCreate = new List<IMS_Monthly_Stats__c>();
        String month = system.now().addMonths(-1).format('MMMMM');
        String year = system.now().format('YYYY');
        
        //build map of duplicates
        Map<Id, String> yearMonthMap = new Map<Id, String>();
        for (IMS_Monthly_Stats__c imsMonth : [select Id, IMS_Year__c, FORMULA_Year__c, Month__c 
                                              FROM IMS_Monthly_Stats__c 
                                              WHERE FORMULA_Year__c =: year AND Month__c =: month]){
            yearMonthMap.put(imsMonth.IMS_Year__c, imsMonth.Month__c);
        }
        
        
        for (IMS_Yearly_Stats__c imsYear : imsYears){
            if(yearMonthMap.containsKey(imsYear.Id) && yearMonthMap.get(imsYear.Id) == month){
                system.debug('### IMSHelper IMS Month [' + month + '] already exists for Year [' + year +'] for Account [' + imsYear.Account__c +']');
            }
            else{
                system.debug('### IMSHelper Creating IMS Month [' + month + '] for Year [' + year +'] for Account [' + imsYear.Account__c +']');
                imsMonthsToCreate.add(new IMS_Monthly_Stats__c (IMS_Year__c = imsYear.Id,
                                                                Month__c = month));
            }
        }
        
        if(!imsMonthsToCreate.isEmpty()){
            insert imsMonthsToCreate;
        }
    }
}