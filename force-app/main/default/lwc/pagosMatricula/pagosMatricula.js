import { LightningElement, api, wire } from 'lwc';
import getIndividualApplication from '@salesforce/apex/PagosInscripcionHelper.getIndividualApplication';
import getFormConfig from '@salesforce/apex/PagosInscripcionHelper.getFormConfig';
import getpais from '@salesforce/apex/PagosInscripcionHelper.getpais';
import getciudad from '@salesforce/apex/PagosInscripcionHelper.getciudad';

export default class PagosMatricula extends LightningElement {
    @api recordId;
    @api showVars;
    @api buttonLabel;
    objIA;
    ref_venta;
    total;
    extra1;
    fechahoy;
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
            const date1 = new Date();
            let year = date1.getFullYear();
            let month = this.addZero( date1.getMonth() + 1 );
            let day = this.addZero( date1.getDate() );
            let hour = this.addZero( date1.getHours() );
            let minute = this.addZero( date1.getMinutes() );
            let second = this.addZero( date1.getSeconds() );

            this.ref_venta = this.objIA.Numero_de_factura_matricula__c;
            this.ref_venta += "-";
            this.ref_venta += year + month + day + hour + minute + second;

            this.total = 0;
            if( this.objIA.Monto_factura_matricula__c ){
                this.total += this.objIA.Monto_factura_matricula__c;
            }
            if( this.objIA.Monto_procultura__c ){
                this.total += this.objIA.Monto_procultura__c;
            }

            this.extra1 = "autoservicio-";
            this.extra1 += this.objIA.Monto_factura_matricula__c; 
            this.extra1 += "-0-";
            this.extra1 += this.objIA.Carrera_de_mayor_interes__r.CC_CODIGO_BANNER__c;
            this.extra1 += "-0-banner";

            const hoy = new Date();
            const dia = hoy.getDate();
            const mes = hoy.getMonth() + 1;
            const año = hoy.getFullYear();

            const fechaHoy = `${dia}-${mes}-${año}`;
            this.fechahoy = fechaHoy;
        
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

    addZero( i ) {
        if( i < 10 ){
            i = "0" + i;
        }
        return i;
    }
}