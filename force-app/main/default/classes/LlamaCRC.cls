public class LlamaCRC {
    @InvocableMethod(label='Consulta cuenta en CRC' description='Consulta email y teléfonos en CRC')
    public static void LlamaCRC(List<InputVariables> inputList) {
        List<Id> listaFinal = new List<Id>();
        String CuentaUnica = null;


        for (InputVariables input : inputList) {
            if (input.cuentas != null) {
                listaFinal.addAll(input.cuentas);
            }
            if (input.cuenta != null) {
                CuentaUnica = input.cuenta;
            }
        }

        // Llamar al método principal, suponiendo que CRCcuentas recibe una lista de Ids
        CRC.CRCcuentas(listaFinal,CuentaUnica);
    }

    public class InputVariables {

        @InvocableVariable(label='cuenta Id individual')
        public String cuenta;

        @InvocableVariable(label='Lista de cuentas')
        public List<Id> cuentas;
    }
}