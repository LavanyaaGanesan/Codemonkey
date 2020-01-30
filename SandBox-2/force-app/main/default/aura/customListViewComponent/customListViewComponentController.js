({
	doInit : function(component, event, helper) {
        helper.showListViewData(component, event, helper);
    },    
    onListViewChange : function(component, event, helper) {
        helper.showRecordsData(component, event, helper);
    },
    bodyDataChange : function(component, event, helper) {
       component.set("v.dataLoaded",true);
    }
})