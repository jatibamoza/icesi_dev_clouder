import { LightningElement } from 'lwc';

export default class MiPrimerLWC extends LightningElement {
    mensaje = '';

    handleClick() {
        this.mensaje = '¡Botón clickeado!';
    }
}