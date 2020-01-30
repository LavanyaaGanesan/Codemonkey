({
    
 doInit: function(component, event, helper) {    
     console.log('In doinit');
    helper.getCons(component,event, helper);
    helper.getSalesPlanner(component,event, helper); 
    helper.getIconName(component,event);

    }, 
 createRecord: function (component, event, helper) {
     
     sforce.one.createRecord("Contact",null,{'Salesplanner_Name__c' : component.get("v.recordId"),
                                             'AccountId' : component.get("v.AccountId"),});
               
             
            
             
        
 },
     
  createClient : function (component, event, helper) {

    console.log('Yay');

    }

 
    
 })