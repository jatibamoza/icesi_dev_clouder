import { LightningElement, track, wire } from 'lwc';
import getEducationHistory from '@salesforce/apex/EducationHistoryController.getEducationHistory';

export default class EducationForm extends LightningElement {
    @track educationRecords = [];

    @wire(getEducationHistory)
    wiredEducation({ error, data }) {
        if (data) {
            this.educationRecords = [...data, this.createEmptyRow()];
        } else if (error) {
            console.error('Error al cargar registros:', error);
        }
    }

    createEmptyRow() {
        return { Id: null, Grado_de_Educacion__c: '', Profesion_Carrera__c: '', Fecha_Titulo__c: '', Universidad__c: '' };
    }

    addNewRow() {
        this.educationRecords = [...this.educationRecords, this.createEmptyRow()];
    }
}