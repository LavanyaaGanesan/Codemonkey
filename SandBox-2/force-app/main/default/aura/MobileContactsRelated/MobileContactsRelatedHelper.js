({
      getIconName : function(component,event){
      var action = component.get("c.getIconName");
        action.setParams({ "sObjectName" : component.get("v.sObjectName") });
        action.setCallback(this, function(response) {
           component.set("v.iconName", response.getReturnValue() );
        });
        $A.enqueueAction(action);  
    
     },
    
    
    getCons : function(cmp) {
        
        var action = cmp.get('c.getContacts');
        console.log('---id in component--'+cmp.get("v.recordId"));
		action.setParams({ SalesPlannerID : cmp.get("v.recordId") });

        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());

            if(state === "SUCCESS"){
                
                cmp.set("v.contactsList",response.getReturnValue());                
            }
           
        });
        $A.enqueueAction(action)
    },
    
    getSalesPlanner : function(cmp) {
         var action = cmp.get('c.getSalesPlanner');
		action.setParams({ SalesPlannerID : cmp.get("v.recordId") });

        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());

            if(state === "SUCCESS"){
                
                cmp.set("v.AccountId",response.getReturnValue().Account_Sales_Planner__c);
                
            }
           
        });
        $A.enqueueAction(action);        
    }
    
   
})