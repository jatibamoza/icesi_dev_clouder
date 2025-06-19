({
    invoke : function(component, event, helper) {
        // Get action Type
        let actionType = component.get( "v.actionType" );
		// Get the record ID attribute
		let value = component.get( "v.recordId" );

        console.log( 'Action Type: ' + actionType );
        console.log( 'value: ' + value );

        if( actionType == "Home" ){
            var navEvt = $A.get("e.force:navigateHome");
            navEvt.fire();
        }
        else if( actionType == "Record" ){
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": value
            });
            navEvt.fire();
        }
        else if( actionType == "sObject Home" ){
            var navEvt = $A.get("e.force:navigateToObjectHome");
            navEvt.setParams({
                "scope": value
            });
            navEvt.fire();   
        }
        else if( actionType == "URL" ){
            var navEvt = $A.get("e.force:navigateToURL");
            navEvt.setParams({
                "url": value,
                "isredirect": "true",
                "target": "_self"
            });
            navEvt.fire();
        }
        else if( actionType == "Reload" ){
            window.location.reload();
        }  
        else{
            window.location.href = value;
        }
	}
})