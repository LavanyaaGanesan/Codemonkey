public class Trg_Task_Helper {
    
    public static void afterinsert(list<Task> trgNew)
    {
        accountUpdate(trgNew);
    }
    
    public static void afterUpdate(list<Task> trgNew)
    {
        accountUpdate(trgNew);
    }
    
    public static void afterDelete(list<Task> trgOld)
    {
        accountUpdate(trgOld);
    }
    
    
    public static void accountUpdate(List<Task> trgNew)
    {
        Set<Id> setids=new Set<Id>();                       
        for(Task t : trgNew)
        {    
         if(t.Status=='Completed')
        {  
            setids.add(t.WhatId);    
             system.debug('setids:::::'+setids);
        }
            
        }               
        List<Sales_Planner__c> updateAcc=new List<Sales_Planner__c>();
        List<Sales_Planner__c> LisSales=[select id,X2019_TotalActivities__c,(select id,status,Type,WhatId from Tasks where status='Completed' ) from Sales_Planner__c   where id In:setids];
        for(Sales_Planner__c a: LisSales)
        {
            
            system.debug(a.Tasks.size());
            a.X2019_TotalActivities__c=a.Tasks.size();
            updateAcc.add(a);
        }
        update updateAcc;
    }
    
}