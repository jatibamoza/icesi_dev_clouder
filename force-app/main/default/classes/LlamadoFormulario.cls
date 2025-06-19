public class LlamadoFormulario {
    @invocableMethod (label='Envia formulario' Description = 'se envia formulario hacia banner')

    public  static void CreacionCliente(List<InputVariables> entrada) {
        Banner.CreacionCliente(entrada[0].Individualapp);
    }

    public class InputVariables {
        @InvocableVariable
        public String Individualapp;
    }
}