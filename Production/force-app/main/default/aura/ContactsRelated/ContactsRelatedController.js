({
    
 doInit: function(component, event, helper) {    
     console.log('In doinit');
    helper.getCons(component,event, helper);
    helper.getSalesPlanner(component,event, helper); 
    helper.getIconName(component,event);

    }, 
 createRecord: function (component) {
     
        var createRecordEvent = $A.get('e.force:createRecord');
        if ( createRecordEvent ) {
            
            createRecordEvent.setParams({
                'entityApiName': 'Contact',
                'defaultFieldValues': {
                    'Salesplanner_Name__c' : component.get("v.recordId"),
                    'AccountId' : component.get("v.AccountId"),
                }
              
            });
            createRecordEvent.fire();
             
        } else {
            /* Create Record Event is not supported 
            alert("Contact creation not supported");*/
        }
     
    }

 
    
 })