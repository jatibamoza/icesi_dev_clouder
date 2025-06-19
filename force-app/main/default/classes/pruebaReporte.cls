public class pruebaReporte {

    public void generateOpportunityReport() {
        // Consulta SOQL para obtener las oportunidades cerradas ganadas
        List<AggregateResult> opportunityResults = [
            SELECT Owner.Name, SUM(Amount) totalAmount, COUNT(Id) totalOpportunities
            FROM Opportunity 
            WHERE StageName = 'Closed Won'
            GROUP BY Owner.Name
        ];

        // Procesar los resultados del reporte
        String reportData = 'Propietario, Total de Oportunidades, Monto Total\n';
        
        for (AggregateResult result : opportunityResults) {
            String owner = (String) result.get('Owner.Name');
            Decimal totalAmount = (Decimal) result.get('totalAmount');
            Integer totalOpportunities = (Integer) result.get('totalOpportunities');
            
            reportData += owner + ', ' + totalOpportunities + ', ' + totalAmount + '\n';
        }
        
        System.debug('Reporte de Oportunidades:\n' + reportData);
        
        // Opcional: Llamar a un método para exportar a un archivo CSV o mostrar en la interfaz
    }
}