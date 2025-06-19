<aura:application extends="force:slds"> 
    <!--Attribute to hold the selected records--> 
    <aura:attribute name="accList" type="Object[]"/> 
        <lightning:card footer="" title="Single Record Selection/Multiple Record Selection"> 
            <p class="slds-p-horizontal_small"> 
                <!--Here the metadataName attribute is the developerName of the metadata record created in Step 1--> 
                <TnzMultilookup:CustomLookupComponent metadataName = "Account_Lookup" selectedRecordList="{!v.accList}"/> 
                <aura:if isTrue="{!v.accList.length > 0}"> <br/> 
                    <!--This is how we can access the Account Name (The value for Field Text in metadata record is set to Name)--> 
                    Selected Account Name : <Strong>{!v.accList[0].text}</Strong> <br/> 
                    <!--This is how we can access the Account Website (The value for Additional Field in metadata record is set to Website)--> 
                    Account Website: <Strong>{!v.accList[0].additionalInfo} </Strong><br/><br/> 
                </aura:if> 
            </p> 
        </lightning:card>     
</aura:application>