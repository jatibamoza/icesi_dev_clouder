({
    invoke : function(component, event, helper) {
		// Get the record ID attribute
        var refreshOnly = component.get( "v.refreshOnly" );

        if( refreshOnly && refreshOnly == true ){
            window.location.reload();
        }
        
	}
})