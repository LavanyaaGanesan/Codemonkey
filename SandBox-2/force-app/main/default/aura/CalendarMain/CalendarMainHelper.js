({	
    jsLoadedHelper: function(component, event, helper) {
        var data = component.get("v.customData");
        //console.log(data);
        if (data!=undefined && ((data.event=='init' && !data.isJSLoaded && data.event!='drop' && data.event!='click')
            || data.event=='reload')){
            if (data.event=='reload')
                data.isJSLoaded=false;
            data.event='load';
            data.isJSLoaded=true;        
            component.set("v.customData", data);
        }
    }
})