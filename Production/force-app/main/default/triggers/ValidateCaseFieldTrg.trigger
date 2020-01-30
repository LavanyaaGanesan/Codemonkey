/* ***************************************************************
* Owner/Modify by Name : Vivek A
* @description: ValidateCaseFieldTrg trigger is used to restrict Vivotif_Pochette_Pouch_with_PIs__c,
				Vaxchora “2-8C” FAQ Flashcard,Vaxchora “2-8” Reminder Cling,Vaxchora_Reconstitution_Cling__c with certain values.
			    trigger on before insert and before update.
* @Change:  
* @last modify by:  Vivek A
* @last modify date:  08-Jan-2020
* *************************************************************** */
trigger ValidateCaseFieldTrg on Case (before insert,before update) 
{
     //get the Organization default Custom Settings for Case object
    Case_Trigger_Setting__c spSetting =  Case_Trigger_Setting__c.getOrgDefaults();
    //check IsActiveTrigger__c =true else it will InActive trigger
    if (spSetting.Is_Active__c)
   
     {
    
    //Fecth the Profile of system administrator.
    Profile pr = [select id from Profile where name='System Administrator'];
    //if user profile is not system administrator it continues into the loop else doesn't execute the code.
   if(UserInfo.getProfileId()!=pr.id){
        //For insert operation
        if(Trigger.IsInsert)
        {
            For(Case c : trigger.new)
            {
                //to make the error message dynamic this is initialzed.
                string fieldVal='';
                
                //check Vivotif_Pochette_Pouch_with_PIs__c is not 0 and not null
                if(c.Vivotif_Pochette_Pouch_with_PIs__c!=0 && c.Vivotif_Pochette_Pouch_with_PIs__c!=Null && spSetting.Vivotif_Pochette_Pouch__c!=Null )
                {
                    //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfo method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfo(c);
                        //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add error message stored in the pvCaseLimitError custom label ,as it exceeds limit.
                            c.addError(string.valueOf(spSetting.Vivotif_Pochette_Pouch_with_PIs_c_Error__c).replace('##value##',spSetting.Vivotif_Pochette_Pouch__c));
                        }
                    }
                }
                
                /*for Vaxchora “2-8C” FAQ Flashcard field check it is not 0 and not null*/
                if(c.Vaxchora_2_8C_FAQ_Flashcard__c!=0 && c.Vaxchora_2_8C_FAQ_Flashcard__c!=Null && spSetting.Vaxchora_2_8C_FAQ__c!=Null )
                {
                    //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfoV28cFAQ method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfoV28cFAQ(c);
                        //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add (Vaxchora “2-8C” FAQ Flashcard) to the string "fieldVal"
                            fieldVal=' "Vaxchora “2-8C” FAQ Flashcard"'+' limit is '+spSetting.Vaxchora_2_8C_FAQ__c ;
                            //add error message.
                            c.addError(string.valueOf(spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c).replace('##value##',fieldVal));
                        }
                    }
                }
                 /*for Vaxchora_2_8_Reminder_Cling__c field check it is not 0 and not null*/
                if(c.Vaxchora_2_8_Reminder_Cling__c!=0 && c.Vaxchora_2_8_Reminder_Cling__c!=Null && spSetting.Vaxchora_2_8_Reminder__c!=Null )
                {
                    //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfoV28RC method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfoV28RC(c);
                        //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add ( Vaxchora “2-8” Reminder Cling) to the string "fieldVal"
                            fieldVal=(fieldVal!=''?fieldVal + ',':'')+' "Vaxchora “2-8” Reminder Cling"'+' limit is '+spSetting.Vaxchora_2_8_Reminder__c ;
                            //add error message.
                             c.addError(string.valueOf(spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c).replace('##value##',fieldVal));
                        }
                    }
                }
                /*for Vaxchora_Reconstitution_Cling__c field check it is not 0 and not null*/
                if(c.Vaxchora_Reconstitution_Cling__c!=0 && c.Vaxchora_Reconstitution_Cling__c!=Null && spSetting.Vaxchora_Reconstitution__c!=Null)
                {
                     //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfoVRC method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfoVRC(c);
                        //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add (Vaxchora Reconstitution Cling) to the string "fieldVal"
                            fieldVal=(fieldVal!=''?fieldVal + ',':'')+' "Vaxchora Reconstitution Cling"'+' limit is '+spSetting.Vaxchora_Reconstitution__c; 
                            //add error message.
                            c.addError(string.valueOf(spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c).replace('##value##',fieldVal));
                                       
                        }
                    }
                }
            }
        }
        //For insert operation
        if(Trigger.IsUpdate)
        {
            For(Case c : trigger.new)
            {
                //to make the error message dynamic this is initialzed.
                string fieldVal='';
               
               /*for Vivotif_Pochette_Pouch_with_PIs__c field check it is not 0 and not null*/
                if(c.Vivotif_Pochette_Pouch_with_PIs__c!=0 && c.Vivotif_Pochette_Pouch_with_PIs__c!=Null && spSetting.Vivotif_Pochette_Pouch__c!=Null)
                {
                    //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfo method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfo(c);
                         //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add error message.
                            c.addError(string.valueOf(spSetting.Vivotif_Pochette_Pouch_with_PIs_c_Error__c).replace('##value##',spSetting.Vivotif_Pochette_Pouch__c));
                        }
                    }
                }
                
                 /*for Vaxchora_2_8C_FAQ_Flashcard__c field check it is not 0 and not null*/
                if(c.Vaxchora_2_8C_FAQ_Flashcard__c!=0 && c.Vaxchora_2_8C_FAQ_Flashcard__c!=Null && spSetting.Vaxchora_2_8C_FAQ__c!=Null )
                {
                     //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfoV28cFAQ method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfoV28cFAQ(c);
                        //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add (Vaxchora “2-8C” FAQ Flashcard) to the string "fieldVal"
                            fieldVal=' "Vaxchora “2-8C” FAQ Flashcard"'+' limit is '+spSetting.Vaxchora_2_8C_FAQ__c;
                            //add error message
                            c.addError(string.valueOf(spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c).replace('##value##',fieldVal));
                        }
                    }
                }
                /*for Vaxchora_2_8_Reminder_Cling__c field check it is not 0 and not null*/
                if(c.Vaxchora_2_8_Reminder_Cling__c!=0 && c.Vaxchora_2_8_Reminder_Cling__c!=Null && spSetting.Vaxchora_2_8_Reminder__c!=Null )
                {
                    //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfoV28RC method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfoV28RC(c);
                        //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add (Vaxchora “2-8” Reminder Cling) to the string "fieldVal"
                            fieldVal=(fieldVal!=''?fieldVal + ',':'')+' "Vaxchora “2-8” Reminder Cling" '+' limit is '+spSetting.Vaxchora_2_8_Reminder__c;
                            //add error message
                            c.addError(string.valueOf(spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c).replace('##value##',fieldVal));
                        }
                    }
                }
                /*for Vaxchora_Reconstitution_Cling__c field check it is not 0 and not null*/
                if(c.Vaxchora_Reconstitution_Cling__c!=0 && c.Vaxchora_Reconstitution_Cling__c!=Null && spSetting.Vaxchora_Reconstitution__c!=Null  )
                {
                    //check Account id or Salesplanner id is not null
                    if(c.AccountId!=NULL || c.Sales_Planner__c!=NULL)
                    {
                        //Call getInfoV28RC method of ValidateCaseField class and pass the inserted case as argument.
                        String result=ValidateCaseField.getInfoVRC(c);
                         //if returned value contains true enter if loop
                        if(result.contains('true'))
                        {
                            string str=result.remove('true');
                            string StrDose=(str=='1' ? '': 's');
                            //add (Vaxchora Reconstitution Cling) to the string "fieldVal"
                            fieldVal=(fieldVal!=''?fieldVal + ',':'')+' "Vaxchora Reconstitution Cling" '+' limit is '+spSetting.Vaxchora_Reconstitution__c;  
                            //add error message.
                            c.addError(string.valueOf(spSetting.Vax_Flashcard_Reconstitution_Remind_Erro__c).replace('##value##',fieldVal));
                        }
                    }
                }
            }
        }
    } 
  }
}