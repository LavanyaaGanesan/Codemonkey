({
    doInit: function (component, event, helper) { 
        var recId = component.get("v.recordId");
        if (!recId.startsWith('001'))
        {
            helper.getAccountID(component,helper);
        }	
        else{
            helper.callInIt(component,helper);
        }
    },
    /*getobj: function(component, event, helper){
          var recId = component.get("v.recordId");
        var action = component.get('c.getobj');
         action.setParams(recId);
    }*/
    
    
})