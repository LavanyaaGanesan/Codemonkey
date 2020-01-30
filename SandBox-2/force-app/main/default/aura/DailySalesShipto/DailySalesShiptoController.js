({
     /* **************************************************************************************************************
    * @description: doinit fuction to be called on load of the page
    * @Change:
    * ************************************************************************************************************** */

    doInit: function(component, event, helper) {
        console.log('*****');
        var pageNumber = component.get("v.PageNumber");
        var pageNumber2 = component.get("v.PageNumber2");
        console.log('*****');
        var pageSize = component.get("v.DirectPageValue"); 
        var pageSize2 = component.get("v.InDirectPageValue");
         
       
        console.log('testttttttt*****'+pageSize+pageSize2);
                //console.log('type2**** '+SelectedType2);
        helper.getShip(component, pageNumber, pageSize); 
      
       helper.getShip1(component,pageNumber2,pageSize2); 
         
       helper.getAllRec(component,event, helper);
       helper.getAllRecIndirect(component,event, helper);
        
    },
     /* **************************************************************************************************************
    * @description:  funtion to be called on the change of year for direct and indirect value
    * @Change:
    * ************************************************************************************************************** */

   
    SelectedTypeChange : function(component, event, helper) {
        component.set("v.PageNumber","1");
        var pageNumber = component.get("v.PageNumber");
        component.set("v.PageNumber2","1");
        var pageNumber2 = component.get("v.PageNumber2");
        console.log('*****');
        var pageSize = component.get("v.DirectPageValue"); 
        var pageSize2 = component.get("v.InDirectPageValue");
        
        var SelectedType2 = component.get("v.SelectedType2");
        if (SelectedType2!="0"){
            helper.getDaily(component, pageNumber, pageSize,SelectedType2);
        }
         
          
        var SelectedType3 = component.get("v.SelectedType3");
        if (SelectedType3!="0"){
            helper.getDaily1(component, pageNumber2, pageSize2,SelectedType3);
        }
        
    	  	
    },
     /* **************************************************************************************************************
    * @description: function for next button functionality for direct table
    * @Change:
    * ************************************************************************************************************** */

     
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize =component.get("v.DirectPageValue");//component.get("v.pageSize");
       //var pageSize=5;
        console.log('page sizeeeeeeeee----------------------' + pageSize);
        pageNumber++;
        
      var SelectedType2 = component.get("v.SelectedType2");
        helper.getDaily(component, pageNumber, pageSize,SelectedType2);
    	helper.getShip(component, pageNumber, pageSize); 
    },
    
     /* **************************************************************************************************************
    * @description: function for next button functionality for indirect table
    * @Change:
    * ************************************************************************************************************** */

    handleNext2: function(component, event, helper) {
        
        var pageNumber2 = component.get("v.PageNumber2");  
        var pageSize2 = component.get("v.InDirectPageValue");//component.get("v.pageSize2"); 
      
        pageNumber2++;
        var SelectedType3 = component.get("v.SelectedType3");
        helper.getDaily1(component,pageNumber2, pageSize2,SelectedType3);
    	helper.getShip1(component,pageNumber2, pageSize2); 
    },
     /* **************************************************************************************************************
    * @description: function for Previous button functionality for direct table
    * @Change:
    * ************************************************************************************************************** */

    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.DirectPageValue");//component.find("pageSize").get("v.value");
        pageNumber--;
         var SelectedType2 = component.get("v.SelectedType2");
        helper.getDaily(component, pageNumber,pageSize,SelectedType2);
        
    	helper.getShip(component, pageNumber,pageSize); 
       
    },
     /* **************************************************************************************************************
    * @description:  function for Previous button functionality for indirect table
    * @Change:
    * ************************************************************************************************************** */

     handlePrev2: function(component, event, helper) {
       
        var pageNumber2 = component.get("v.PageNumber2");  
        var pageSize2 = component.get("v.InDirectPageValue");// component.find("pageSize2").get("v.value");
        pageNumber2--;
       var SelectedType3 = component.get("v.SelectedType3");
        helper.getDaily1(component,pageNumber2,pageSize2,SelectedType3);
        
    	helper.getShip1(component,pageNumber2, pageSize2); 
       
    },
     /* **************************************************************************************************************
    * @description: function for changing the number of records per page in for direct table
    * @Change:
    * ************************************************************************************************************** */

    onSelectChange: function(component, event, helper) {
        var page = 1;
        console.log('*****');
        var pageSize = component.get("v.DirectPageValue");//component.find("pageSize").get("v.value");
        console.log('*****'+pageSize);
    //    var Type2 = component.get("v.SelectedType2");
     var SelectedType2 = component.get("v.SelectedType2");
        helper.getDaily(component,page,pageSize,SelectedType2);
    	helper.getShip(component, page,pageSize); 
        
    },
     /* **************************************************************************************************************
    * @description: function for changing the number of records per page in for indirect table
    * @Change:
    * ************************************************************************************************************** */

     onSelectChange1: function(component, event, helper) {
        
        var page2 = 1;
        console.log('*****');
        var pageSize2 = component.get("v.InDirectPageValue");//component.find("pageSize2").get("v.value");
          var SelectedType3 = component.get("v.SelectedType3");
        helper.getDaily1(component,page2,pageSize2,SelectedType3);
    	helper.getShip1(component,page2,pageSize2); 
    },
    
   
  /* **************************************************************************************************************
    * @description: function for downloading the data after clicking the download data button
    * @Change:
    * ************************************************************************************************************** */

 downloadCsv : function(component,event,helper){

    
        // get the Records from 'direct data'  
        var stockData = component.get("v.AllDailyList.lstDailySalesData");
     	var stockDataHDirect = component.get("v.DailyList.lstShipToInfo");
     var stockDataHDirectDirOn = component.get("v.DailyList.lstShipToInfoDirOnly");
     var stockDataHDirectInDirOn = component.get("v.DailyList.lstShipToInfoInDirOnly");
        console.log("stock data HDirect");
       //fetch the header data
     var HDirectKeysHeader = ['Shipto Id','Shipto Name','DDD Outlet ID','Street','City','State','Zip Code','Type'];
      var   HDirectKeys = ['Ship_To__c','Name','DDD_Outlet_ID__c','Address__c','City__c','State__c','Zip__c','ShipTo_Type__c'];
     
        // call the helper function which "return" the CSV data as a String 
        var directKeysHeader = ['Ship To','Item Category','Shipto Date','Reason for Transaction','NDC','Invoice Quantity'];
       var  directKeys = ['ShipTo_ID__c','Item_Category__c','ShipTo_Date__c','Reason_for_Transaction__c','NDC__c','Quantity__c']; 
   
     
     // get the Records list from 'indirect data'  
        var stockDataIndirect = component.get("v.AllDailyList.lstDailySalesINDirectData");
     	//var stockDataHInDirect = component.get("v.DailyList.lstShipToInfo");
        
       //fetch the header data
     var HinDirectKeysHeader = ['Shipto Id','Shipto Name','DDD Outlet ID','Street','City','State','Zip Code','Type'];
      var   HinDirectKeys = ['Ship_To__c','Name','DDD_Outlet_ID__c','Address__c','City__c','State__c','Zip__c','ShipTo_Type__c'];
     
        // call the helper function which "return" the CSV data as a String 
        var indirectKeysHeader = ['DDD ID','Invoice','Shipto Date','Description','Quantity'];
       var  indirectKeys = ['DDD_Outlet_ID__c','Invoice__c','ShipTo_Date__c','Material_Description__c','Quantity__c']; 
   
     //condition for downloading the direct data with current or previous year
     if((component.get("v.SelectedType")== 1 && component.get("v.SelectedType2")== 1)||(component.get("v.SelectedType")== 1 && component.get("v.SelectedType2")== 2)){
         
     		var csv = helper.convertArrayOfObjectsToCSV(component,stockDataHDirectDirOn,HDirectKeys,HDirectKeysHeader);
         csv += '\n\n';
         csv += 'Direct Data \n';
         csv += helper.convertArrayOfObjectsToCSV(component,stockData,directKeys,directKeysHeader);
     }
     //condition for downloading the indirect data with current or previous year
     else if((component.get("v.SelectedType")== 2 && component.get("v.SelectedType3")== 1)||(component.get("v.SelectedType")== 2 && component.get("v.SelectedType3")== 2)){
       
     	 var csv = helper.convertArrayOfObjectsToCSV(component,stockDataHDirectInDirOn,HinDirectKeys,HinDirectKeysHeader);
          csv += '\n\n';
         csv +='Indirect Data \n';
         csv += helper.convertArrayOfObjectsToCSV(component,stockDataIndirect,indirectKeys,indirectKeysHeader);
     }
     //condition for downloading the direct and indirect data with current or previous year
      else if ((component.get("v.SelectedType")== 3 && component.get("v.SelectedType2")!= 0)||(component.get("v.SelectedType")== 3 && component.get("v.SelectedType3")!= 0))
          {
        
     		var csv = helper.convertArrayOfObjectsToCSV(component,stockDataHDirect,HDirectKeys,HDirectKeysHeader,HinDirectKeys,HinDirectKeysHeader);
              csv += '\n\n';
              csv += 'Direct Data \n';
              csv += helper.convertArrayOfObjectsToCSV(component,stockData,directKeys,directKeysHeader);
               csv += '\n\n';
              csv +='Indirect Data \n';
              csv += helper.convertArrayOfObjectsToCSV(component,stockDataIndirect,indirectKeys,indirectKeysHeader);
     }
     
         if (csv == null){return;} 
    var acc = component.get('v.AccountName');
     console.log("account name"+acc);
     //condition for downloading the only direct data with current or previous year with name Vaxchora Direct.csv
        if(component.get("v.SelectedType")== 1){
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = acc+' '+'-- Vaxchora Direct.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
     
        } 
      //condition for downloading the only indirect data with current or previous year with name Vaxchora Indirect.csv
      if(component.get("v.SelectedType")== 2){
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = acc+' '+'-- Vaxchora Indirect.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
     
        } 
      //condition for downloading the both direct and indirect data with current or previous year with name Vaxchora Direct&Indirect.csv
     if(component.get("v.SelectedType")== 3){
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = acc+' '+'-- Vaxchora Direct&Indirect.csv';  // CSV file Name* you can change it.[only name not .csv] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
     
        } 
 },
    
    
    
 })