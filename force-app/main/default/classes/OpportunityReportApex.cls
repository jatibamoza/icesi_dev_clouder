public class OpportunityReportApex {

    // Método para generar el reporte y exportarlo como archivo CSV
    public void generateOpportunityReport() {
        // Consulta SOQL para obtener las oportunidades cerradas ganadas
        List<IndividualApplication> opportunityResults = [
            
            SELECT AccountId, Name, Status
			FROM IndividualApplication
        ];

        // Procesar los resultados del reporte en formato CSV
        String csvHeader = 'AccountName, Name, Origen, Status, Carrera, Codigo, ID\n';
        String csvBody = '';
        
        for (IndividualApplication result : opportunityResults) {
            String AccountName = (String) result.get('AccountId');
            String Status = (String) result.get('Status');
            
            csvBody += AccountName + ', ' + Status + '\n';
        }
        
        String csvData = csvHeader + csvBody;

        // Crear un archivo CSV dentro de Salesforce
        ContentVersion csvFile = new ContentVersion();
        csvFile.Title = 'Reporte de Oportunidades';
        csvFile.PathOnClient = 'ReporteOportunidades.csv';
        csvFile.VersionData = Blob.valueOf(csvData);
        insert csvFile;

        System.debug('Archivo CSV creado con éxito.');
    }
}