public class LlamaAdmision {
     @invocableMethod (label='Envia desicion de admisión' Description = 'se envia cambios de estado de formulario a banner')

    public  static void admision(List<InputVariables> entrada) {
        Banner.admision(entrada[0].Individualapp);
    }

    public class InputVariables {
        @InvocableVariable
        public String Individualapp;
    }
}