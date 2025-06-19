public class ConversionLead_apx {
    // Clase interna para almacenar los resultados de la conversión
    public class ConversionResult {
        public Id accountId;
        public Id contactId;
        
        public ConversionResult(Id accountId, Id contactId) {
            this.accountId = accountId;
            this.contactId = contactId;
        }
    }

    public static ConversionResult convertLead(Id leadId, Id accountId, Id contactId ) {
        // Crear una instancia de LeadConvert
        Database.LeadConvert leadConvert = new Database.LeadConvert();
        leadConvert.setLeadId(leadId);

        if( accountId != null) {
            leadConvert.setAccountId( accountId );
            if( contactId != null ){
                leadConvert.setContactId( contactId );
            }
        }

        // Opciones de configuración de la conversión
        leadConvert.setDoNotCreateOpportunity(false);
        leadConvert.setConvertedStatus('Convertido'); // Asegúrate de que este estado sea válido en tu organización

        try {
            // Ejecutar la conversión
            Database.LeadConvertResult result = Database.convertLead(leadConvert);
            if (result.isSuccess()) {
                System.debug('El Lead se ha convertido exitosamente.');
                return new ConversionResult(result.getAccountId(), result.getContactId());
            } else {
                System.debug('Error en la conversión: ' + result.getErrors());
            }
        } catch (Exception e) {
            System.debug('Error en la conversión del Lead: ' + e.getMessage());
        }

        return null; // Retornar null si no fue exitosa la conversión
    }
}