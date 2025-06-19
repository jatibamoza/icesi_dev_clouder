import { LightningElement, api } from 'lwc';
import reset from '@salesforce/apex/CommunityAuthenticator_Utils.resetPassword';

export default class CommunityPasswordReset extends LightningElement {
    @api htmlIntroContent = '';
    @api lblUsername = 'Número de Documento';
    @api lblBtnReset = 'Reiniciar Contraseña';
    @api errorMessage = 'Se ha producido un error en su intento de reinicio de contraseña.';
    @api urlPwdCheck = '/login/CheckPasswordResetEmail';
    _username = '';
    showError = false;
    errorMessageMerged = '';

    handleUsernameChange(event) {
        this._username = event.target.value;
    }

    handleReset(event){
        this.showError = false;
        event.preventDefault();
        reset({ username: this._username })
            .then((result) => {
                if (this.isValidURL(result)) {
                    window.location.href = result + '/s' + this.urlPwdCheck;
                }
                else {
                    this.showError = true;
                    this.errorMessageMerged = this.errorMessage.replaceAll('{0}', result );
                    console.error( result );
                }
            })
            .catch((error) => {
                this.showError = true;
                this.errorMessageMerged = this.errorMessage.replaceAll('{0}', error );
                console.error( JSON.stringify( error ) );
        });
    }

    isValidURL(url) {
        const urlPattern = /^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$/;
        return urlPattern.test(url);
    }
}