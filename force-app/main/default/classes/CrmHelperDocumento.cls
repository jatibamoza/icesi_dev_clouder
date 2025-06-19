public class CrmHelperDocumento {

    @future(callout=false)
    public static void procesarDocumentos(List<Id> contentDocIds) {
        if (contentDocIds == null || contentDocIds.isEmpty()) {
            return;
        }

        // 1. Obtener las últimas versiones de los documentos
        Map<Id, ContentVersion> latestVersions = new Map<Id, ContentVersion>();

        for (ContentVersion cv : [
            SELECT Id, Title, ContentDocumentId 
            FROM ContentVersion 
            WHERE ContentDocumentId IN :contentDocIds 
            AND IsLatest = TRUE
        ]) {
            latestVersions.put(cv.ContentDocumentId, cv);
        }

        // 2. Extraer los IDs de IndividualApplication
        Set<String> individualApplicationIds = new Set<String>();
        Map<String, IndividualApplication> iaMap = new Map<String, IndividualApplication>();

        for (ContentVersion cv : latestVersions.values()) {
            if (cv.Title.startsWith('CPI01_')) {  
                String[] parts = cv.Title.split('_');
                system.debug(parts.size());
                if (parts.size() > 2) {
                    
                    system.debug(parts[2].trim());
                    String iaId = parts[2].trim();
                    individualApplicationIds.add(iaId);
                }
            }
        }

        if (individualApplicationIds.isEmpty()) {
            return;
        }

        // 3. Consultar los registros de IndividualApplication
        for (IndividualApplication ia : [
            SELECT Id, CC_Constancia_de_pago__c 
            FROM IndividualApplication 
            WHERE Id IN :individualApplicationIds
        ]) {
            iaMap.put(ia.Id, ia);
        }

        // 4. Actualizar los registros de IndividualApplication
        List<IndividualApplication> iaToUpdate = new List<IndividualApplication>();

        for (String iaId : individualApplicationIds) {
            if (iaMap.containsKey(iaId)) {
                IndividualApplication iaRecord = iaMap.get(iaId);
                iaRecord.CC_Constancia_de_pago__c = true;
                iaToUpdate.add(iaRecord);
            }
        }

        if (!iaToUpdate.isEmpty()) {
            update iaToUpdate;
        }
    }
}