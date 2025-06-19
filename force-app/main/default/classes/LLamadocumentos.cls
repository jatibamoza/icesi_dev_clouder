public class LLamadocumentos {
    @invocableMethod (label='Envia documentos' Description = 'se envia documentos hacia banner')

    public  static void Documentos(List<InputVariables> entrada) {
        Banner.Documentos(entrada[0].Individualapp);
    }

    public class InputVariables {
        @InvocableVariable
        public String Individualapp;
    }
}