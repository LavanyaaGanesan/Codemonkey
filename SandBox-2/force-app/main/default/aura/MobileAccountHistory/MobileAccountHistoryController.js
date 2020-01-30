({
	doInit: function(component, event, helper) {      
    helper.gettask(component,event, helper);    
    },
    jsLoaded: function(component, event, helper) {      
    	 component.set('v.jsLoaded', true);
    },
    activityDateChange: function(component, event, helper) { 
        if (component.get('v.jsLoaded')){
            $(document).ready(function(){            
                $("span.spanActivityDate").each(function( index ) {
                    var arr = $(this).text().split('-');
                    $(this).text(arr[1]+'/'+arr[2]+'/'+arr[0]);
                });
            });            
        }
    },
    changeDateFormat:function(component, event, helper) {
        alert('Fire');
    }
    /*handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },*/
     
})