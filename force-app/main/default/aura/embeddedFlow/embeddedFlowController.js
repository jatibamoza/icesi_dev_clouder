({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
        // In that component, start your flow. Reference the flow's API Name.
        flow.startFlow("Landing_por_programa");
    },
    handleStatusChange : function (component, event) {
     if(event.getParam("status") === "FINISHED") {
            var outputVariables = event.getParam("outputVariables");
            if(outputVariables != null) {
                            var outputVar;
          for(var i = 0; i < outputVariables.length; i++) {
             outputVar = outputVariables[i];
             // Pass the values to the component's attributes
             if(outputVar.name === "finishURL" && outputVar.name != null) {
                    window.location.assign(outputVar.value);
             }  
          }
            } 
      
     }
 }
})