public class utilities {
	public static Set<id> getMyChildRoles(id roleID) 
    {
        set<Id> childRoleIDSet = new set<Id>();
        set<Id> currentChildRoleIDSet = new set<Id>();  
        currentChildRoleIDSet.add(roleID);
        Boolean flag = true;
        do
        {
            List<userrole> userRoleList = new List<userrole>();
            userRoleList = [select id from userrole where parentroleID in :currentChildRoleIDSet]; 
            currentChildRoleIDSet.clear();
            for(userrole ur : userRoleList)
            {
                currentChildRoleIDSet.add(ur.id);          
            }
            childRoleIDSet.addAll(currentChildRoleIDSet);
            if(!(userRoleList!=null && userRoleList.size()>0))
            {
                flag = false;
            }
        }while(flag);
            
       return childRoleIDSet;
    }
}