({
    callInIt: function(component, helper){
      console.log('doInit of component called');
        //console.log("test"+component.get('v.recordId'));
        var columns = [
            {
                type: 'url',
                fieldName: 'AccountURL',
                label: 'Account Name',
                typeAttributes: {
                    label: { fieldName: 'accountName' },
                    target:'_blank',
                    tooltip: {
                        fieldName: 'accountName'
                    }
                }
            },
            
            {
                type: 'Text(20)(External ID)',
                fieldName: 'DDD_Outlet_ID__c',
                label: 'DDD Outlet ID'
            },

            
            {
                type: 'Lookup(User)',
                fieldName: 'OwnerId',
                label: 'Account Owner'
            },

            
            {
                type: 'textArea',
                fieldName: 'BillingStreet',
                label: 'Street'
            },
             {
                type: 'textArea',
                fieldName: 'BillingCity',
                label: 'City'
            },
            
            {
                type: 'textArea',
                fieldName: 'BillingState',
                label: 'State/Province'
            },
            {
                type: 'textArea',
                fieldName: 'BillingPostalCode',
                label: 'Zip/Postal Code'
            },
            {
                type: 'textArea',
                fieldName: 'BillingCountry',
                label: 'Country'
            }
                        
        ];
        if( ($A.get("$Browser.formFactor")=='DESKTOP')){
            component.set('v.gridColumns', columns);
        }
        else{
            var column1 = [
                {
                    type: 'url',
                    fieldName: 'AccountURL',
                    label: 'Account Name',
                    typeAttributes: {
                        label: { fieldName: 'accountName' }
                    }
                    
                },
            ];
                component.set('v.gridColumns', column1);
                }
                
                
                
                
                
                //var tsObjectName= component.get('v.ltngSobjectname');
                //var tparentFieldAPIname= component.get('v.ltngParentFieldAPIName');
                //var tlabelFieldAPIName= component.get('v.ltngLabelFieldAPIName');
                
                this.callToServer(
                component,
                "c.findHierarchyData",
                function(response) {
                var expandedRows = [];
            var apexResponse = response;
            var roles = {};
            console.log('*******apexResponse:'+JSON.stringify(apexResponse));
            var results = apexResponse;
            roles[undefined] = { Name: "Root", _children: [] };
            apexResponse.forEach(function(v) {
                expandedRows.push(v.Id);
                console.log("v id"+ v.Id);
                var aa=component.get('v.recordId');
                console.log("v aa:"+ aa);
                if(v.Id.startsWith(aa)){
                    roles[v.Id] = { 
                        
                        accountName: '*'+v.Name , 
                        name: v.Id,
                        DDD_Outlet_ID__c:v.DDD_Outlet_ID__c,
                        OwnerId:v.Owner.Name,
                        BillingStreet:v.BillingStreet,
                        BillingCity:v.BillingCity,
                        BillingState:v.BillingState,
                        BillingPostalCode:v.BillingPostalCode,
                        BillingCountry:v.BillingCountry,
                        AccountURL:'/'+v.Id,
                        _children: [] };}
                    else{
                        
                    roles[v.Id] = { 
                        accountName:v.Name ,
                        name: v.Id,
                        DDD_Outlet_ID__c:v.DDD_Outlet_ID__c,
                        OwnerId:v.Owner.Name,
                        BillingStreet:v.BillingStreet,
                        BillingCity:v.BillingCity,
                        BillingState:v.BillingState,
                        BillingPostalCode:v.BillingPostalCode,
                        BillingCountry:v.BillingCountry,
                        AccountURL:'/'+v.Id,
                        _children: [] };

                    }
                
            }     );
            
            console.log("name"+name);
            apexResponse.forEach(function(v) {
                roles[v.ParentId]._children.push(roles[v.Id]);   
            });                
            component.set("v.gridData", roles[undefined]._children);
            console.log('*******treegrid data:'+JSON.stringify(roles[undefined]._children));
            
            component.set('v.gridExpandedRows', expandedRows);
        }, 
            {
                recId: component.get('v.recordId')
            }
        );    
    },
	callToServer : function(component, method, callback, params) {
        console.log('Calling helper callToServer function');
		var action = component.get(method);
        if(params){
            action.setParams(params);
        }
        console.log(JSON.stringify(params));
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state"+ state);
            if (state === "SUCCESS") {
               //alert('Processed successfully at server');
                callback.call(this,response.getReturnValue());
               component.set("v.accountList",response.getReturnValue());
            }else if(state === "ERROR"){
                //alert('Problem with connection. Please try again.');
            }
        });
		$A.enqueueAction(action);
    },
    getAccountID : function(component,helper) {
        console.log('Calling helper callToServer function');
		var action = component.get('c.getAccountId');        
        action.setParams({spId: component.get('v.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state"+ state);
            if (state === "SUCCESS") {
               component.set("v.recordId",response.getReturnValue());
                this.callInIt(component,helper);
            }else if(state === "ERROR"){
                //alert('Problem with connection. Please try again.');
            }
        });
		$A.enqueueAction(action);
    }
})