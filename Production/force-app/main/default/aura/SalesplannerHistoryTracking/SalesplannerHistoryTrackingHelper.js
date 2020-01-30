({
    getIconName : function(component,event){
        var action = component.get("c.getIconName");
        action.setParams({ "sObjectName" : component.get("v.sObjectName") });
        action.setCallback(this, function(response) {
            component.set("v.iconName", response.getReturnValue());
        });
        $A.enqueueAction(action);  
    },
    getIsAdmin : function(component,event){
        var action = component.get("c.getIsAdmin");
        action.setCallback(this, function(response) {
            component.set("v.isAdmin", response.getReturnValue());
            console.log('Admin : ' + component.get("v.isAdmin"));
        });
        $A.enqueueAction(action);  
    },
    getSalesPlannerHistory : function(cmp) {
        var action = cmp.get('c.getSalesPlannerHistory');
        action.setParams({ accountId : cmp.get("v.recordId") });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            //console.log("---response.getReturnValue()-"+response.getReturnValue());
            if(state === "SUCCESS"){              
                cmp.set("v.spHistoryList",response.getReturnValue());
            }           
        });
        $A.enqueueAction(action)
    }, // added by SG
    RetriveselectedSalesPlanner: function(component, event, salesPlannerids) {
        var action = component.get('c.RetriveRecords');
        action.setParams({
            "lstRecordIds": salesPlannerids
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                //this.showMessage('success','Success!','Successfully retrieved, Refresh the page to see the results.');
                if (!$A.get("$Browser.isPhone") && !$A.get("$Browser.isTablet")){
                    $A.get('e.force:refreshView').fire();
                    var toastEvent = $A.get("e.force:showToast");                
                    toastEvent.setParams({
                        "type" : 'success',
                        "title": 'Success!',
                        "message": 'Successfully retrieved, Refresh the page to see the results.'
                    });
                    toastEvent.fire();
                }
                else{
                	component.set("v.showMessage",true);
                    component.set("v.errorMessageClass",'green');
                    component.set("v.errorMessage","Successfully retrieved, Refresh the page to see the results.");
                }
                var actionGetSP = component.get('c.getSPHistory');
                $A.enqueueAction(actionGetSP); 
            }
        });
        $A.enqueueAction(action);
    },//END
    showMessage: function(type, title,message){
        $A.get('e.force:refreshView').fire();
        var toastEvent = $A.get("e.force:showToast");                
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})