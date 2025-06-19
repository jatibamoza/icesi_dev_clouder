import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import EDUCATION_HISTORY_OBJECT from '@salesforce/schema/hed__Education_History__c';
import getContactId from '@salesforce/apex/EducationHistoryController.getContactId';
import getEstudios from '@salesforce/apex/EducationHistoryController.getEducationHistories';
import deleteRecord from '@salesforce/apex/EducationHistoryController.deleteEducationHistory';

export default class CreateRecordModal extends LightningElement {
    @api objectApiName = EDUCATION_HISTORY_OBJECT;
    @api contactId; 
    valorcontact;

    isOpen = false;
    selectedRecordId = null;

    @track estudios = [];
    @track estudiosParaTabla = []; // Se usa solo para la tabla
    wiredEstudiosResult;

    @track fieldValues = {};

    @track isModalOpen = false;
    @track modalTitle = 'Nuevo Registro'; // Valor por defecto
    @track isEditing = false; // Variable para saber si está en modo edición

    fields = [
        
        { apiName: 'CC_Instituci_n_Educativa__c', label: 'Universidad' , required : true},
        { apiName: 'CC_ProfesinCarrera__c', label: 'Profesión / Carrera' ,required : true},
        { apiName: 'hed__Graduation_Date__c', label: 'Fecha de Graduación',required : true },
        { apiName: 'CC_Grado_de_educaci_n__c', label: 'Grado de Educación',required : true }
    ];

    columns = [
        { label: 'Institución', fieldName: 'Institucion', type: 'text'},
        { label: 'Profesión / Carrera', fieldName: 'Profesion', type: 'text'},
        { label: 'Fecha de Graduación', fieldName: 'hed__Graduation_Date__c', type: 'date' ,  fixedWidth: 150},
        { label: 'Grado de Educación', fieldName: 'CC_Grado_de_educaci_n__c', type: 'text',  fixedWidth: 150  },
        { label: 'Editar/Eliminar', type: 'action', typeAttributes: { rowActions: this.getRowActions },  fixedWidth: 100  }
    ];


    @wire(getEstudios, { contactId: '$contactId' })
    wiredEstudios(result) {
        this.wiredEstudiosResult = result; 
        const { error, data } = result;
        if (data) {
            this.estudios = data;
            this.estudiosParaTabla = data.map(estudio => ({
                ...estudio,
                Institucion: estudio.CC_Instituci_n_Educativa__r ? estudio.CC_Instituci_n_Educativa__r.Name : '',
                Profesion: estudio.CC_ProfesinCarrera__r ? estudio.CC_ProfesinCarrera__r.Name : ''
            }));

        } else if (error) {
            console.error('Error al obtener estudios:', error);
        }
    }

    @wire(getContactId, { contactId: '$contactId' }) 
    wiredContact({ error, data }) {
        if (data) {
            this.valorcontact = data;
        } else if (error) {
            console.error('Error al obtener el Contacto:', error);
        }
    }

    getRowActions(row, doneCallback) {
        doneCallback([
            { label: 'Editar', name: 'edit' },
            { label: 'Eliminar', name: 'delete' }
        ]);
    }

    handleChange(event) {
        const { name, value } = event.target;
        this.fieldValues = { ...this.fieldValues, [name]: value };
    }
    
    openModal() {
        this.selectedRecordId = null;
        this.modalTitle = 'Nuevo Registro';
        this.isEditing = false;
        this.isOpen = true;
    }
    openEditModal(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
    
        if (actionName === 'edit') {
            this.selectedRecordId = row.Id;
            this.modalTitle = 'Actualizar Registro'; // Cambio aquí
            this.isEditing = true;
            this.isOpen = true;
        } else if (actionName === 'delete') {
            this.deleteRecord(row.Id);
        }
    }

    closeModal() {
        this.isOpen = false;
    }


    async handleSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Éxito',
                message: 'Registro guardado correctamente',
                variant: 'success'
            })
        );
        this.closeModal();
        await refreshApex(this.wiredEstudiosResult);
    }

    handleCancel() {
        this.closeModal();
    }

    async deleteRecord(recordId) {
        try {
            await deleteRecord({ recordId });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Éxito',
                    message: 'Registro eliminado correctamente',
                    variant: 'success'
                })
            );
            await refreshApex(this.wiredEstudiosResult);
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'No se pudo eliminar el registro',
                    variant: 'error'
                })
            );
        }
    }
}