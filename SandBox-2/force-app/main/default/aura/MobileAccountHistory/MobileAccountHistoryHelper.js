({
	gettask : function(cmp) {
        console.log('---id in component--'+cmp.get("v.recordId"));
        var action = cmp.get('c.gettask');
        action.setParams({ Relatedto : cmp.get("v.recordId") });

        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());

            if(state === "SUCCESS"){  
                console.log("List" + response.getReturnValue());
                cmp.set("v.taskWrapperList",response.getReturnValue()); 
                
                window.setTimeout(function(){
                        var changeActivityDate = cmp.get('c.activityDateChange');
                		$A.enqueueAction(changeActivityDate);
                },0);
            }
           
        });
        $A.enqueueAction(action)
    },
    
    /* helperFun : function(component,event,secId) {
      var acc = component.find(secId);
            for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
    },*/
})