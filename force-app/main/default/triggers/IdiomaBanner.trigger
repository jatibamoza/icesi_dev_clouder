trigger IdiomaBanner on hed__Contact_Language__c (before insert) {
    // Recopilar todos los nombres que vienen en la inserción
    Set<String> nombresIdiomas = new Set<String>();
    for (hed__Contact_Language__c cl : Trigger.new) {
        if (cl.CC_Idioma_lok__c != null) {
            nombresIdiomas.add(cl.CC_Idioma_lok__c);
        }
    }

    // Consultar los registros de hed__Language__c que coinciden con esos nombres en Codigo_banner__c
    Map<String, hed__Language__c> idiomasPorEstado = new Map<String, hed__Language__c>();
    for (hed__Language__c lang : [
        SELECT Id, Codigo_banner__c
        FROM hed__Language__c
        WHERE Codigo_banner__c IN :nombresIdiomas
    ]) {
        idiomasPorEstado.put(lang.Codigo_banner__c, lang);
    }

    // Usar los datos encontrados si se necesita hacer algo con ellos
    for (hed__Contact_Language__c cl : Trigger.new) {
        hed__Language__c idiomaRelacionado = idiomasPorEstado.get(cl.CC_Idioma_lok__c);
        if (idiomaRelacionado != null) {
            // Aquí puedes hacer algo con el idioma relacionado, por ejemplo, relacionar el ID:
            cl.hed__Language__c = idiomaRelacionado.Id;
        } else {
            cl.addError('No se encontró un idioma con el estado banner correspondiente: ' + cl.CC_Idioma_lok__c);
        }
    }
}