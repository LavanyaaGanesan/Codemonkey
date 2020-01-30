({  
    doInit: function(component, event, helper) { 
        if ($A.get("$Browser.isPhone") || $A.get("$Browser.isTablet")){
            component.set("v.borderWidth","0");
        }
        helper.getIsAdmin(component,event);
        helper.getIconName(component,event);
        helper.getSalesPlannerHistory(component,event, helper); 
    },
    getSPHistory: function(component, event, helper) {      
        helper.getSalesPlannerHistory(component,event, helper); 
    },// added by SG
    handleonRetriveClick:function(component, event, helper) {
        component.set("v.showMessage",false);
        var SelectedsalesPlannerIds = []; 
        var notCurYear=false; 
        var radioButton=document.getElementsByName('rbdSPH');
        for (var i=0; i<radioButton.length;i++){
            if(radioButton[i].checked){
                var aIY =radioButton[i].value.split('~');
                if (aIY[1]!=new Date().getUTCFullYear()){
                    notCurYear=true;
                    console.log(radioButton[i].value);
                    //helper.showMessage('warning','Information!','Please select current year record to retrieve!');
                    if (!$A.get("$Browser.isPhone") && !$A.get("$Browser.isTablet")){
                        $A.get('e.force:refreshView').fire();
                        var toastEvent = $A.get("e.force:showToast");                
                        toastEvent.setParams({
                            "type" : 'warning',
                            "title": 'Information!',
                            "message": 'Please select current year record to retrieve!'
                        });
                        toastEvent.fire();
                    }
                    else{
        				component.set("v.showMessage",true);
                        component.set("v.errorMessageClass",'red');                        
                        component.set("v.errorMessage","Please select current year record to retrieve!");
                    }
                    break;
                }
                else{
                    SelectedsalesPlannerIds.push(aIY[0]);
                }
            }
        }
        console.log(SelectedsalesPlannerIds);
        if (SelectedsalesPlannerIds.length>0){
            helper.RetriveselectedSalesPlanner(component, event, SelectedsalesPlannerIds);
        }
        else if(SelectedsalesPlannerIds.length==0 && !notCurYear){
            //helper.showMessage('warning','Information!','Please select record to retrieve!');
            if (!$A.get("$Browser.isPhone") && !$A.get("$Browser.isTablet")){
                $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");                
                toastEvent.setParams({
                    "type" : 'warning',
                    "title": 'Information!',
                    "message": 'Please select record to retrieve!'
                });
                toastEvent.fire();
            }
            else{
                component.set("v.showMessage",true);
                component.set("v.errorMessageClass",'red');
                component.set("v.errorMessage","Please select record to retrieve!");
            }
        }
    },
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    }
    
    
    //END
    
   /* handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();

    }*/
})