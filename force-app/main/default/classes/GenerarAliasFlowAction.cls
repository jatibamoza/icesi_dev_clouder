public class GenerarAliasFlowAction {

    @InvocableMethod(label='Generar Alias' description='Genera un alias basado en FirstName y LastName')
    public static List<Resultado> generarAlias(List<Entrada> entradas) {
        
        List<Resultado> resultados = new List<Resultado>();
        
        for (Entrada entrada : entradas) {
            
            String firstInitial = (entrada.firstName != null && entrada.firstName.length() > 0) 
                ? entrada.firstName.substring(0,1) 
                : '';
            
            String combined = firstInitial + (entrada.lastName != null ? entrada.lastName : '');
            
            // Quitar espacios
            combined = combined.replace(' ', '');
            
            // Limitar a 7 caracteres
            String alias = (combined.length() > 7) ? combined.substring(0,7) : combined;
            
            // Pasar a minúsculas
            alias = alias.toLowerCase();
            
            // Crear resultado
            Resultado res = new Resultado();
            res.aliasGenerado = alias;
            resultados.add(res);
        }
        
        return resultados;
    }
    
    public class Entrada {
        @InvocableVariable(label='First Name' required=true)
        public String firstName;
        
        @InvocableVariable(label='Last Name' required=true)
        public String lastName;
    }
    
    public class Resultado {
        @InvocableVariable(label='Alias Generado')
        public String aliasGenerado;
    }
}