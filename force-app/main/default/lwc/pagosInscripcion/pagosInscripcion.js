import { LightningElement, api, wire } from 'lwc';
import getIndividualApplication from '@salesforce/apex/PagosInscripcionHelper.getIndividualApplication';
import getFormConfig from '@salesforce/apex/PagosInscripcionHelper.getFormConfig';
import getpais from '@salesforce/apex/PagosInscripcionHelper.getpais';
import getciudad from '@salesforce/apex/PagosInscripcionHelper.getciudad';

export default class PagosInscripcion extends LightningElement {
    @api recordId;
    @api showVars;
    @api buttonLabel;
    objIA;
    extra1;
    ciudad;
    Name;
    pais; // Aquí almacenaremos el valor String
    @wire( getFormConfig, { formType: 'Inscripcion' })objConfig;

    @wire(getpais, { recordId: '$recordId' })
    wiredPais({ error, data }) {
        if (data) {
            this.pais = data; // Asignamos directamente el String
        } else if (error) {
            console.error('Error retrieving país:', error);
            this.pais = null; // O manejar el error como prefieras
        }
    }

    @wire(getciudad, { recordId: '$recordId' })
    wiredciudad({ error, data }) {
        if (data) {
            this.ciudad = data; // Asignamos directamente el String
        } else if (error) {
            console.error('Error retrieving país:', error);
            this.ciudad = null; // O manejar el error como prefieras
        }
    }

    @wire( getIndividualApplication, { recordId: '$recordId' })
    wiredIndividualApplication({ error, data }) {
        if (data) {
            this.objIA = data;
            this.extra1 = "inscripcion-";
            this.extra1 += this.objIA.Monto_factura__c; 
            this.extra1 += "-0-";
            this.extra1 += this.objIA.Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c;
            this.extra1 += "-0-0-recruiter";
            this.Name = this.objIA.Account.FirstName + ' ' + this.objIA.Account.LastName;
        
          
        } else if (error) {
            // Handle error
            console.error(error);
        }
    }
    
    connectedCallback() {
        // Verifica si el objeto objIA está disponible antes de refrescar la página
        if (this.objIA) {
            window.location.reload();
        }
    }
    @wire( getFormConfig, { formType: 'Inscripcion' })objConfig;
}