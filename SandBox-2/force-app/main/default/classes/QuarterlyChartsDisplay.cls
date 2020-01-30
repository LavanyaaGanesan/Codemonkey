public class QuarterlyChartsDisplay {
    
    @AuraEnabled
    /* public Static List<AggregateResult> getQuarterly(String SalesPlannerID,String productName,String year)
{
Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
List<AggregateResult> saledata;
if (year == 'LAST YEAR')
saledata = [SELECT CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name=:productName and Date__c =last_year GROUP BY CALENDAR_QUARTER(Date__c) ];
else 
saledata = [SELECT CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name=:productName and Date__c =this_year GROUP BY CALENDAR_QUARTER(Date__c) ];    
//List<Sales_Data__c> saledata = [SELECT id FROM Sales_Data__c where Account__c =: salesPlanner.Account_Sales_Planner__c and Date__c = LAST_YEAR];
System.debug('saledata ::: '+saledata);
return saledata;

//CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c)
}*/
    
    
    public Static Map<string,List<AggregateResult>> getVaxQuarterly(String SalesPlannerID,String productName)
    { 
        system.debug('::::SalesPlannerID'+SalesPlannerID);
        system.debug('::::productName' +productName); 
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        List<AggregateResult> saldata;
        List<AggregateResult> saldata2; 
        List<String> prdList = productName.split(',');
        system.debug(':::salesPlanner.Account_Sales_Planner__c'+salesPlanner.Account_Sales_Planner__c);
        Map<string,List<AggregateResult>> prodQuarResult = new Map<string,List<AggregateResult>>();
        saldata = [SELECT CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =last_year GROUP BY CALENDAR_QUARTER(Date__c) ];
        prodQuarResult.put('Lastyear', saldata);
        saldata2 = [SELECT CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =this_year GROUP BY CALENDAR_QUARTER(Date__c) ];    
        //List<Sales_Data__c> saledata = [SELECT id FROM Sales_Data__c where Account__c =: salesPlanner.Account_Sales_Planner__c and Date__c = LAST_YEAR];
        System.debug('saledata ::: '+saldata);
        prodQuarResult.put('Thisyear', saldata2);
        //saldata.addAll(saldata2);
        return prodQuarResult;

        //CALENDAR_QUARTER(Date__c), SUM(Doses_Month_0__c)
    }
    
    
    
    
    
}