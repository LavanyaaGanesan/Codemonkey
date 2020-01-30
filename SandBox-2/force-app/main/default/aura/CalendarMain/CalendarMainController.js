({
    doInit : function(component, event, helper) {
        setTimeout(function(){
            var data = component.get("v.customData")==undefined 
            ? {event:'init', isOpen:false, id: $A.get("$SObjectType.CurrentUser.Id"), 
               taskId: '',accountId: '',selectedDate: '',selectedEndDate: '', isJSLoaded:false, objectName:'',
               listViewLoaded:false, eventsLoaded:false} 
            : component.get("v.customData");
            component.set("v.customData", data);
            component.set("v.obejctCreated", true);
            //console.log("Main Component Init : " + component.get("v.customData"));
       	},3000);
	},
	 customDataParentChange: function(component, event, helper) {
        //console.log('Calendar Main: Custom Data Change fire');
        var cData = component.get("v.customData");
        component.set("v.customDataMod", component.get("v.customDataParent"));
        component.set("v.customData", component.get("v.customDataParent"));
    },
	 customDataChange: function(component, event, helper) {
        var cData = component.get("v.customData");
         if (cData!=undefined && cData.listViewLoaded){
             component.get("v.listViewLoaded", true);
             setTimeout(function(){ 
                helper.jsLoadedHelper(component, event, helper);
             },0);
         }
    },
    jsLoaded: function(component, event, helper) {
        
        setTimeout(function(){
            helper.jsLoadedHelper(component, event, helper);
        },5000);
    }
    
  
})