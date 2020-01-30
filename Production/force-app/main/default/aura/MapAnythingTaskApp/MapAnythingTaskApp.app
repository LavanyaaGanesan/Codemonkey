<aura:application access="global" extends="ltng:outApp">
    <aura:attribute name="recordId" type="String" default="a194N000007QaUOQA0" /> 
    <aura:attribute name="recordType" type="String" default="LogACall" />
    <c:MapAnythingTask recordId="{!v.recordId}" recordType="{!v.recordType}" />
    <!--aura:dependency resource="c:MapAnythingTask"/-->
</aura:application>