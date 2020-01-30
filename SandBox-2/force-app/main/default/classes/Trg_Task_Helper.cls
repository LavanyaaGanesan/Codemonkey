/* ***************************************************************
* Owner/Modify by Name : Sai G
* @description: Heper class for Trg_Task trigger
* @Change:  
* @last modify by:  Vishal Soni
* @last modify date:  17-Jan-2020
* *************************************************************** */
public class Trg_Task_Helper {
    //After insert method for update account records.
    public static void afterinsert(list<Task> trgNew)
    {
        accountUpdate(trgNew);
    }
     //After insert update for update account records.
    public static void afterUpdate(list<Task> trgNew)
    {
        accountUpdate(trgNew);
    }
     //After Delete update for update account records.
    public static void afterDelete(list<Task> trgOld)
    {
        accountUpdate(trgOld);
    }
    
    //After insert update for update account records.
    public static void accountUpdate(List<Task> trgNew)
    {
        Set<Id> setids=new Set<Id>();                       
        for(Task t : trgNew)
        {    
         if(t.Status=='Completed')
        {  
            setids.add(t.WhatId);    

        }
            
        } 
        //creating list salesplanner object records.
        List<Sales_Planner__c> updateAcc=new List<Sales_Planner__c>();
        //Getting task related to salesplanner object.
        List<Sales_Planner__c> LisSales=[select id,X2019_TotalActivities__c,(select id,status,Type,WhatId from Tasks where status='Completed' ) from Sales_Planner__c   where id In:setids];
        for(Sales_Planner__c a: LisSales)
        {
            
            a.X2019_TotalActivities__c=a.Tasks.size();
            updateAcc.add(a);
        }
        update updateAcc;
    }
    
}