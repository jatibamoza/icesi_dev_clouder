public class ConvertLeadAction {
    @invocableMethod(label='Convierte lead' description='Acción que convierte un lead, dado su Id. Si el ID de la cuenta es enviada el lead se asocia a dicha cuenta. Igualmente para contacto. Si se envía contacto, la cuenta debe ser enviada también. Retorna LeadId, AccountId y ContactId')
    public static List<OutputVariables> convertLead(List<InputVariables> entrada) {
        List<OutputVariables> outputs = new List<OutputVariables>();
        
        for (InputVariables input : entrada) {
            // Llamada al método convertLead en ConversionLead_apx y obtén los resultados
            ConversionLead_apx.ConversionResult result = ConversionLead_apx.convertLead(input.Lead, input.accountId, input.contactId);
            
            // Crear una instancia de OutputVariables para almacenar los IDs de resultado
            OutputVariables output = new OutputVariables();
            output.Lead = input.Lead; // ID del lead que se está convirtiendo
            output.AccountId = result != null ? result.accountId : null;
            output.ContactId = result != null ? result.contactId : null;
            
            outputs.add(output);
        }
        
        return outputs; // Retornar la lista de resultados
    }

    public class InputVariables {
        @InvocableVariable(required=true)
        public Id Lead;

        @InvocableVariable
        public Id AccountId;

        @InvocableVariable
        public Id ContactId;
    }

    public class OutputVariables {
        @InvocableVariable
        public Id Lead;
        
        @InvocableVariable
        public Id AccountId;

        @InvocableVariable
        public Id ContactId;
    }
}