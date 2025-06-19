trigger VerificarTamanio_tgr on ContentVersion (after insert) {

       // Definimos el tamaño máximo permitido en bytes (por ejemplo, 10,2MB)
       // 
      Integer tamanoMaximo = (Integer)10.2 * 1024 * 1024; // 10,710,275 bytes
    
    // Recorremos cada archivo que se está subiendo
    for(ContentVersion cv : Trigger.New) {
        // Verificamos si el tamaño del archivo excede el límite
        if(cv.ContentSize > tamanoMaximo) {
            // Si el tamaño es mayor al límite, lanzamos un error y evitamos la inserción
            System.debug('inside if condition');
            cv.addError('El archivo "' + cv.Title + '" excede el tamaño máximo permitido de 10,2MB.y tiene' + cv.ContentSize );
        }

    }

}