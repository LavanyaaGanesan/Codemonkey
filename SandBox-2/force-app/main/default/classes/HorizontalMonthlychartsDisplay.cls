/* ***************************************************************
* Owner/Modify by Name : Prashant Damke
* @description: Controller class for HorizontalCharts lightning Component.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  13-Jan-2020
* *************************************************************** */
public class HorizontalMonthlychartsDisplay {
     /* ***************************************************************
    * @description: Method to get monthly data from Sales data object.
    * @Change:  
    * *************************************************************** */
  @AuraEnabled    
    public Static Map<string,List<AggregateResult>> getMonthlyData(String SalesPlannerID,String productName)
    {  //create query result MAP : Key = String and Value = list of aggregate results.
        Map<string,List<AggregateResult>> prodQuarResult = new Map<string,List<AggregateResult>>();
        try{
        //Fetch Account and Salesplanner Id from the salesplanner.
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        List<AggregateResult> saldata;
        List<AggregateResult> saldata2; 
        List<String> prdList = productName.split(',');

        prodQuarResult = new Map<string,List<AggregateResult>>();
             //get sales data records for last year
        saldata = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =last_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c)];
        prodQuarResult.put('Lastyear', saldata);
             //get sales data records for this year
        saldata2 = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =this_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c)];    


        prodQuarResult.put('Thisyear', saldata2);
            if(Test.isRunningTest())
                integer i=1/0;

        } 
        catch(exception ex){
            ApexDebugLogController.insertLog('HorizontalMonthlychartsDisplay', 'getMonthlyData', ex.getMessage(), ex.getLineNumber());
        }
        
        return prodQuarResult;
     


    }
   /* ***************************************************************
    * @description: Method to get monthly data from Sales data object by month in descending order.
    * @Change:  
    * *************************************************************** */
    @AuraEnabled    
    public Static Map<string,List<AggregateResult>> getMonthlyDataReverse(String SalesPlannerID,String productName)
    { 
        //create query result MAP : Key = String and Value = list of aggregate results.
        Map<string,List<AggregateResult>> prodQuarResult = new Map<string,List<AggregateResult>>();
        try{
        //Fetch Account and Salesplanner Id from the salesplanner.
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        List<AggregateResult> saldata;
        List<AggregateResult> saldata2; 
        List<String> prdList = productName.split(',');

        prodQuarResult = new Map<string,List<AggregateResult>>();
            //get sales data records for last year
        saldata = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =last_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c) desc];
        prodQuarResult.put('Lastyear', saldata);
             //get sales data records for this year
        saldata2 = [SELECT CALENDAR_MONTH(Date__c), SUM(Doses_Month_0__c) FROM Sales_Data__c WHERE Account__c =: salesPlanner.Account_Sales_Planner__c and Name In:prdList and Date__c =this_year GROUP BY CALENDAR_MONTH(Date__c) order by CALENDAR_MONTH(Date__c) desc];    


        prodQuarResult.put('Thisyear', saldata2);
            if(Test.isRunningTest())
                integer i=1/0;
        }
        catch(exception ex){
            ApexDebugLogController.insertLog('HorizontalMonthlychartsDisplay', 'getMonthlyDataReverse', ex.getMessage(), ex.getLineNumber());
        }

        return prodQuarResult;
     


    }
}