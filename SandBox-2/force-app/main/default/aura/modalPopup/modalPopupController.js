({
	customDataChange: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", component.get("v.customDataMod").isOpen);
      if (component.get("v.customDataMod").event!='reload'){
      	component.set("v.customDataCreate", component.get("v.customDataMod"));
      }
   },
    customDataCreateChange: function(component, event, helper) {
        if (component.get("v.customDataCreate").isOpen==false){
          // for Display Model,set the "isOpen" attribute to "true"
          component.set("v.isOpen", component.get("v.customDataCreate").isOpen);
        }
        if (component.get("v.customDataCreate").event=='reload'){
          // for Display Model,set the "isOpen" attribute to "true"
          component.set("v.isOpen", component.get("v.customDataCreate").isOpen);
          component.set("v.customDataMod", component.get("v.customDataCreate"));
        }
   },
	openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
       // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
       component.set("v.isOpen", false);      
       var cData=component.get("v.customDataCreate");
       cData.isOpen=false;
       cData.event='reload';
       component.set("v.customDataCreate",cData);
   },
})