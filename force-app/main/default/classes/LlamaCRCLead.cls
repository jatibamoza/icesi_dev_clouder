public class LlamaCRCLead {
    @InvocableMethod(label='Consulta lead en CRC' description='Consulta email y teléfonos en CRC')
    public static void LlamaCRC(List<InputVariables> inputs) {
        List<Id> listaFinal = new List<Id>();
        String leadUnico = null;

        for (InputVariables input : inputs) {
            if (input.leadsIds != null) {
                listaFinal.addAll(input.leadsIds);
            }
            if (input.Lead != null) {
                leadUnico = input.Lead;
            }
        }

        // Llamar al método principal
        CRC.CRClead(listaFinal, leadUnico);
    }

    public class InputVariables {
        @InvocableVariable(label='Lead Id individual')
        public String Lead;

        @InvocableVariable(label='Lista de Leads')
        public List<Id> leadsIds;
    }
}