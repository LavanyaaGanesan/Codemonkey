public class NewTaskMapApex {
 @AuraEnabled
 public String var {get;set;}

  //public NewTaskMapApex (ApexPages.StandardController controller){ }
    public Pagereference pageredir()
    {

        var= ApexPages.currentPage().getParameters().get('RecordId'); 
        system.debug('RecordId'+var);
            if(var!=null)
            {
            Pagereference newpage = new Pagereference ('/'+var);
            newpage.setRedirect(true);    
            return newpage;
            }
        else
            {
            Pagereference newpage =Page.VFMapLAC; 
            return newpage;
            }    
}
}