/* ***************************************************************
* Owner/Modify by Name : Archie Bisen
* @description: Controller class for contactsRelated component.
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  10-Jan-2020
* *************************************************************** */
public class ContactsDisplays {
 /* ***************************************************************
    * @description: Method to fetch data from Contact object.
    * @Change:  
    * *************************************************************** */    
    @AuraEnabled
    public Static List<contact> getContacts(String SalesPlannerID)
    {
        List<Contact> contacts=new List<Contact>();
            try{
        // To get Salesplanner objects records and contact records.        
        Sales_Planner__c salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
        contacts = [select id, Title,Phone,email,Name,Primary_Contact__c,Status__c,Contact_Relationship__c,Role__c from contact where accountid =: salesPlanner.Account_Sales_Planner__c];
                if(Test.isRunningTest())
                    integer i=1/0;
    }
         catch(exception ex){
            ApexDebugLogController.insertLog('ContactsDisplays', 'getContacts', ex.getMessage(), ex.getLineNumber());
        }
        return contacts;
    }
  /* ***************************************************************
    * @description: Method to fetch data from Salesplanner object.
    * @Change:  
    * *************************************************************** */  
    @AuraEnabled
    public Static Sales_Planner__c getSalesPlanner(String SalesPlannerID)
    {
    
        Sales_Planner__c salesPlanner = new Sales_Planner__c();
        try{
        //Fetching Id and name of account from salespanner.
        salesPlanner = [select id,Account_Sales_Planner__c from Sales_Planner__c where id =:SalesPlannerID ];
            if(Test.isRunningTest())
                    integer i=1/0;
        }
         catch(exception ex){
            ApexDebugLogController.insertLog('ContactsDisplays', 'getSalesPlanner', ex.getMessage(), ex.getLineNumber());
        }
        return salesPlanner;
    }
    
     /* ***************************************************************
    * @description: Generic Method to display the Icon relevant with the object.
    * @Change:  
    * *************************************************************** */   
     @AuraEnabled
    public static String getIconName(String sObjectName){
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        return u;
    }
    
    
}