({
    /* **************************************************************************************************************
    * @description:function to get the daily sales data from fetchDailysalesData method in apex class and set the data in DailyList attribute
    * and set parameter for  strAccId,pageNumber,pageSize,SelectedType2 and set their values according to values coming in resultData 
    * @Change:
    * ************************************************************************************************************** */

    getDaily : function(component,pageNumber,pageSize,SelectedType2) {
        console.log('---');
        console.log('---'+pageNumber+'***'+pageSize);
         console.log('selectedtype2'+ component.get("v.SelectedType2"));
        var action = component.get('c.fetchDailysalesData');
        action.setParams({ 
            strAccId : component.get("v.RecordId"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "SelectedType2": SelectedType2           
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());
            
            if(state === "SUCCESS"){
                
                component.set("v.DailyList",response.getReturnValue());    
                console.log('test fetch daily sales data----'+component.get("v.DailyList"));
                var resultData = response.getReturnValue();
                if (component.isValid() && state === "SUCCESS") if (component.isValid() && state === "SUCCESS"){}
                component.set("v.PageNumber", resultData.lstDailySalesDataDirect.pageNumber);
                 component.set("v.pageSize", resultData.lstDailySalesDataDirect.pageSize);
                component.set("v.TotalRecords", resultData.lstDailySalesDataDirect.totalRecords);
                component.set("v.RecordStart", resultData.lstDailySalesDataDirect.recordStart);
                component.set("v.RecordEnd", resultData.lstDailySalesDataDirect.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.lstDailySalesDataDirect.totalRecords / pageSize));
                
               
            }
        
        });
        $A.enqueueAction(action)
    },    
    /* **************************************************************************************************************
    * @description:function to get the daily sales data from fetchDailysalesData1 method in apex class and set the data in DailyList1 attribute
    * and set parameter for  strAccId,pageNumber2,pageSize2,SelectedType3 and set their values according to values coming in resultData 
    * @Change:
    * ************************************************************************************************************** */

     getDaily1 : function(component,pageNumber2,pageSize2,SelectedType3) {
        console.log('---');
        console.log('---'+pageNumber2);
        var action = component.get('c.fetchDailysalesData1');
          console.log('selectedtype3'+ component.get("v.SelectedType3"));
        action.setParams({ 
            strAccId : component.get("v.RecordId"),
            "pageNumber2": pageNumber2,
            "pageSize2": pageSize2,
            "SelectedType3": SelectedType3,
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());
            
            if(state === "SUCCESS"){
                
                component.set("v.DailyList1",response.getReturnValue());    
                console.log('test fetch daily sales data----'+component.get("v.DailyList"));
                var resultData = response.getReturnValue();
                if (component.isValid() && state === "SUCCESS") if (component.isValid() && state === "SUCCESS"){}
                component.set("v.PageNumber2", resultData.lstDailySalesDataInDirect.pageNumber2);
                component.set("v.pageSize2", resultData.lstDailySalesDataInDirect.pageSize2);
                component.set("v.TotalRecords2", resultData.lstDailySalesDataInDirect.totalRecords2);
                component.set("v.RecordStart2", resultData.lstDailySalesDataInDirect.recordStart2);
                component.set("v.RecordEnd2", resultData.lstDailySalesDataInDirect.recordEnd2);
                component.set("v.TotalPages2", Math.ceil(resultData.lstDailySalesDataInDirect.totalRecords2 / pageSize2));
            }
        
        });
        $A.enqueueAction(action)
    },    
    
   /* **************************************************************************************************************
    * @description:function to get the shipto data from fetchDailysalesData method in apex class and set the data in ShiplistList attribute
    * and set parameter for  strAccId,pageNumber,pageSize. 
    * @Change:
    * ************************************************************************************************************** */

    getShip : function(component,pageNumber,pageSize) {
        
        var action = component.get('c.fetchDailysalesData');
        action.setParams({ 
            strAccId : component.get("v.RecordId"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
           
        });
        console.log('Response---');
        action.setCallback(this,function(response){
            console.log('Response---');
            var state = response.getState();
            console.log("---response.getReturnValue()"+state);
            
            if(state === "SUCCESS"){
                console.log('Ship---');
                component.set("v.ShipList",response.getReturnValue()); 
                this.setHeaderValues(component,response.getReturnValue());
                console.log('test fetch daily sales data!!!!----');
            }
            
        });
        $A.enqueueAction(action)
    },
     /* **************************************************************************************************************
    * @description:function to get the shipto data from fetchDailysalesData1 method in apex class and set the data in ShiplistList attribute
    * and set parameter for  strAccId,pageNumber,pageSize. 
    * @Change:
    * ************************************************************************************************************** */

      getShip1 : function(component,pageNumber2,pageSize2) {
       
        var action = component.get('c.fetchDailysalesData1');
        action.setParams({ 
            strAccId : component.get("v.RecordId"),
           
            "pageNumber2": pageNumber2,
            "pageSize2": pageSize2
        });
        console.log('Response---');
        action.setCallback(this,function(response){
            console.log('Response---');
            var state = response.getState();
            console.log("---response.getReturnValue()"+state);
            
            if(state === "SUCCESS"){
                console.log('Ship---');
                component.set("v.ShipList",response.getReturnValue()); 
                this.setHeaderValues(component,response.getReturnValue());
                console.log('test fetch daily sales data!!!!----');
            }
            
        });
        $A.enqueueAction(action)
    },
     /* **************************************************************************************************************
    * @description: function to display the header values of column in the downloaded excle sheet 
    * @Change:
    * ************************************************************************************************************** */

    setHeaderValues : function(component,shipList) {
        console.log('Ship---'+shipList);
        var shipToId = '';
        var Directshipname = '';
        var Indirectshipname = '';
        var sId='', dddId='',dSName='', dSAdd='', inSName='', inSAdd='';
        if (shipList!=undefined && shipList.lstShipToInfo!=undefined){       
            for (var i=0;i<shipList.lstShipToInfo.length;i++){
                var sInfo=shipList.lstShipToInfo[i]; 
                console.log("Ship list"+sInfo);
               // var ShipToIdArray = [];
                //ShipToId = sInfo.Ship_To__c.split
                if(sInfo.ShipTo_Type__c=='Direct' && sInfo.Ship_To__c!=undefined){
                    shipToId += sInfo.Ship_To__c+','+' ' ; 
                   /* ShipToIdArray = shipToId.split(',');
                    console.log("ShiptoArray"+ShipToIdArray);
                    for(var j=0;j<ShipToIdArray.length;j++){
                       console.log("ShiptoId"+ShipToIdArray[i]);
                       shipToId =  ShipToIdArray[i];
                    }*/
                    /*shipToId = sInfo.Ship_To__c.formattedUrl();*/
                    //shipToId = string.link(sInfo.Ship_To__c);
                    //shipToId += sInfo.Ship_To__c;
                }
                   
                if((sInfo.ShipTo_Type__c=='Direct' && sInfo.Ship_To__c!=undefined)||(sInfo.ShipTo_Type__c=='Indirect'))
                    component.set("v.AccountName",sInfo.Account__r.Name);
                 
                if(sInfo.DDD_Outlet_ID__c!=undefined)
                    component.set("v.DDDOutletId",sInfo.DDD_Outlet_ID__c);
                
                 if(sInfo.Account__c!=undefined)
                    component.set("v.AccountId",sInfo.Account__c);
                
                if(sInfo.ShipTo_Type__c=='Direct' ){
                    Directshipname+= sInfo.DDD_Outlet_ID__c!=undefined ? sInfo.Name+','+' ' :'';
                    component.set("v.DirectShipToAddress",
                                  (sInfo.Address__c!=undefined ? sInfo.Address__c + ',' :''+'\n')+
                                  (sInfo.City__c!=undefined ? sInfo.City__c +', ' :'') +
                                  (sInfo.State__c!=undefined ? sInfo.State__c +', ' :'') +
                                  (sInfo.Zip__c!=undefined ? sInfo.Zip__c + ' ' :''));
                }
                if(sInfo.ShipTo_Type__c=='Indirect' ){
                   component.set("v.containIndirectType",true); 
                    Indirectshipname+= sInfo.DDD_Outlet_ID__c!=undefined ? sInfo.Name+','+' ' :'';
                    component.set("v.IndirectShipToAddress",
                                  (sInfo.Address__c!=undefined ? sInfo.Address__c + ', ' :'')+'\n'+
                                  (sInfo.City__c!=undefined ? sInfo.City__c +', ' :'') +
                                  (sInfo.State__c!=undefined ? sInfo.State__c +', ' :'') +
                                  (sInfo.Zip__c!=undefined ? sInfo.Zip__c + ' ' :''));
                }
            }
            shipToId = shipToId.slice(0, -2); 
            component.set("v.ShipToID",shipToId);
            Directshipname = Directshipname.slice(0, -2);
            component.set("v.DirectShipToName",Directshipname);
            Indirectshipname = Indirectshipname.slice(0, -2);
            component.set("v.IndirectShipToName",Indirectshipname);
        }
    },
    
     /* **************************************************************************************************************
    * @description: fuction for converting the array of records into a csv file 
    * @Change:
    * ************************************************************************************************************** */

    convertArrayOfObjectsToCSV : function(component,objectRecords,keys,keysHeader){
        // declare variables
        var csvStringResult, counter, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return 'no records';
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider variable  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        
        csvStringResult = '';
        csvStringResult += keysHeader.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                
                csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
               if(csvStringResult.includes("undefined"));
            {
                csvStringResult = csvStringResult.replace("undefined", " ");
            }
                console.log('csvStringResult123456789----> '+csvStringResult);
                counter++;
                
            } // inner for loop close 
           // outer main for loop close 
             
            csvStringResult += lineDivider;
        }
        
        // return the CSV formate String 
        return csvStringResult;        
    },
     /* **************************************************************************************************************
    * @description:function to get the data from fetchAllDailysalesData method in apex class and set the data in AllDailyList attribute
    * in order to download all the direct data on click of the download button 
    * @Change:
    * ************************************************************************************************************** */

    getAllRec: function(component,event, helper)
    {

       var action = component.get('c.fetchAllDailysalesData');
        action.setParams({ 
            strAccId : component.get("v.RecordId"),
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());
            
            if(state === "SUCCESS"){
                
                component.set("v.AllDailyList",response.getReturnValue());  
                console.log(' DATA ALL '+component.get("v.AllDailyList"));
                console.log('test fetch daily sales data----'+component.get("v.DailyList"));
            }
        });
        $A.enqueueAction(action)
    }, 
     /* **************************************************************************************************************
    * @description:function to get the data from fetchAllDailysalesData method in apex class and set the data in AllDailyListIndirect attribute
    * in order to download all the indirect data on click of the download button 
    * @Change:
    * ************************************************************************************************************** */

     getAllRecIndirect: function(component,event, helper)
    {

       var action = component.get('c.fetchAllDailysalesData');
        action.setParams({ 
            strAccId : component.get("v.RecordId"),
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            console.log("---response.getReturnValue()-"+response.getReturnValue());
            
            if(state === "SUCCESS"){
                
                component.set("v.AllDailyListIndirect",response.getReturnValue());  
                console.log(' DATA ALL '+component.get("v.AllDailyListIndirect"));
                console.log('test fetch daily sales data----'+component.get("v.AllDailyListIndirect"));
            }
        });
        $A.enqueueAction(action)
    }, 
})