public class UpdateOwnerBatchAction {
    
    @InvocableMethod(label='Actualizar Propietario en Batch' description='Ejecuta un Batch para cambiar el propietario de registros de cualquier objeto.')
    public static void updateOwners(List<Request> requests) {
        if (requests == null || requests.isEmpty()) {
            return;
        }

        for (Request req : requests) {
            if (req.recordIds == null || req.recordIds.isEmpty() || req.newOwnerId == null || String.isEmpty(req.sObjectType)) {
                continue;
            }

            // Ejecutar el batch
            Database.executeBatch(new BatchUpdateOwner(new Set<Id>(req.recordIds), req.newOwnerId, req.sObjectType));
        }
    }

    // Clase interna para recibir los parámetros desde Flow
    public class Request {
        @InvocableVariable(label='Lista de IDs de registros' required=true)
        public List<Id> recordIds;

        @InvocableVariable(label='Nuevo Propietario' required=true)
        public Id newOwnerId;

        @InvocableVariable(label='Tipo de Objeto' required=true)
        public String sObjectType;
    }
}