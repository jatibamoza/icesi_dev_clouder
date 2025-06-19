@IsTest
public class mockHttpCallout implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        // Obtén el endpoint de la solicitud
        String endpoint = req.getEndpoint();
 
        CC_Datos_Banner__mdt datos = [SELECT clientId__c, clientSecret__c,CC_End_Point__c FROM CC_Datos_Banner__mdt LIMIT 1];
        // Simula la respuesta basada en el endpoint

        if (endpoint.contains('/person/create_person')) {
            
            res.setBody('  {"status": "SUCCESS","data": {"id": "A00411955","amount": "150000","invoiceNumber": "U0988876","result": null},"error": null,"message": null}');
            res.setStatusCode(200);
        }else if(endpoint.contains('/auth/token?clientId=' + datos.clientId__c + '&clientSecret=' + datos.clientSecret__c)) {
            res.setBody(' {"status": "SUCCESS","data": {"access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqd3FzNHVqc21rZV9RakhBdXFIN0w4QVFVdDhhIiwiZXhwIjoxNzE4ODI3MzgwLCJpYXQiOjE3MTg4MjcwMjAsImF1dGhvcml0aWVzIjoiIn0.SJoVhWi72MmgVFbvbn8m8TJB08ZWJS7osqv-HH7A9L7V9oW1gPy96fnxSnfCrc2NiLnIDWCfCH59VY-DTc8uPw","scope": "","token_type": "Bearer","expires_in": 360},"error": null,"message": null}');
            res.setStatusCode(200);
        }else if(endpoint.contains('/person/upload_files')) {
            res.setBody('{"status": "SUCCESS","data": [{"primaryKey": {"bannerPidm": 83946,"bannerDocumentCode": "0002","bannerTermCode": "202510","salesforceAccountId": "001WK00000KuT5SYAV"},"bannerPersonId": "A00305784","salesforceApplicationId": "0iTWK0000002QhZ2AU","salesforceDocumentId": "068WK000002PQe6YAG","bdmDocumentId": null,"bdmDocumentRef": null,"documentSize": 184090,"documentName": "PRUEBA ICFES O EQUIVALENTE","documentExt": "png","documentType": "PNG","documentVersion": 1,"documentUrl": "https://icesi--newsconfig.sandbox.file.force.com/sfc/servlet.shepherd/version/download/068WK000002PQe6","createdAt": "2024-10-17T08:21:49.066","updatedAt": "2024-10-17T10:05:17.813","status": "PENDIENTE_ACTUALIZACION","retryCount": 0}],"error": null,"message": null}');
            res.setStatusCode(200);
        }else if(endpoint.contains('/admission/decision')) {
            res.setBody('{ "status": "SUCCESS","data": {"id": "A00411955","result": "Mensaje segun Code"},"error": null,"message": null}');
            res.setStatusCode(200);
        }

        else if(endpoint.contains('/person/address/')) {
            res.setBody('{ "status": "SUCCESS","data": {"id": "A00411955","result": "Mensaje segun Code"},"error": null,"message": null}');
            res.setStatusCode(200);
        }else if(endpoint.contains('/person/job/')) {
            res.setBody('{ "status": "SUCCESS","data": {"id": "A00411955","result": "Mensaje segun Code"},"error": null,"message": null}');
            res.setStatusCode(200);
        }else if(endpoint.contains('/person/phone/')) {
            res.setBody('{ "status": "SUCCESS","data": {"id": "A00411955","result": "Mensaje segun Code"},"error": null,"message": null}');
            res.setStatusCode(200);
        }else if(endpoint.contains('/person/academic/')) {
            res.setBody('{ "status": "SUCCESS","data": {"id": "A00411955","result": "Mensaje segun Code"},"error": null,"message": null}');
            res.setStatusCode(200);
        }
        return res;
    }
}