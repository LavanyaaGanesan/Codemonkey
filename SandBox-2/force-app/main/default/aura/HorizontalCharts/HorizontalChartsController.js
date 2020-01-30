({
    loadChart : function(component, event, helper)  
    {
    //    if ($A.get("$Browser.formFactor")=='PHONE'){
            component.set("v.resetChart", false);
            helper.getQChartReverse(component);
            
            component.set("v.vaxResetChart", false);
            helper.getQChartReverseVax(component);
            
            component.set("v.TypResetChart", false);
            helper.getQChartReverseTyp(component);
   //   }

       // helper.getQChart(component);
    },
    refreshedChart : function(component, event, helper) 
    {
        component.set("v.resetChart", false);
        helper.getRelatedDataReverse(component);
        
        component.set("v.vaxResetChart", false);
        helper.getRelatedDataReverseVax(component);
        
        component.set("v.TypResetChart", false);
        helper.getRelatedDataReverseTyp(component);
        
        //helper.getRelatedData(component);
    },
})