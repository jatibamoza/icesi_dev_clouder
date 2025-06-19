public class OpportunityExcelExporter {

    public void exportOpportunityReportToExcel() {
        List<AggregateResult> opportunityResults = [
            SELECT Owner.Name, SUM(Amount) totalAmount, COUNT(Id) totalOpportunities
            FROM Opportunity
            WHERE StageName = 'Closed Won'
            GROUP BY Owner.Name
        ];

        // Construir el contenido HTML
        String excelData = '<table border="1">';
        excelData += '<tr><th>Propietario</th><th>Total de Oportunidades</th><th>Monto Total</th></tr>';

        for (AggregateResult result : opportunityResults) {
            String owner = (String) result.get('Owner.Name');
            Decimal totalAmount = (Decimal) result.get('totalAmount');
            Integer totalOpportunities = (Integer) result.get('totalOpportunities');
            
            excelData += '<tr>';
            excelData += '<td>' + owner + '</td>';
            excelData += '<td>' + totalOpportunities + '</td>';
            excelData += '<td>' + totalAmount + '</td>';
            excelData += '</tr>';
        }

        excelData += '</table>';

        // Crear archivo Excel dentro de Salesforce
        ContentVersion excelFile = new ContentVersion();
        excelFile.Title = 'Reporte de Oportunidades';
        excelFile.PathOnClient = 'ReporteOportunidades.xls';
        excelFile.VersionData = Blob.valueOf(excelData);
        insert excelFile;

        System.debug('Archivo Excel creado con éxito.');
    }
}