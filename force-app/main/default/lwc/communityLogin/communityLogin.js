import { LightningElement, api, wire } from 'lwc';
import login from '@salesforce/apex/CommunityAuthenticator_Utils.login';
import getIsRegistrationEnabled from '@salesforce/apex/CommunityAuthenticator_Utils.isRegistrationEnabled';

export default class CommunityLogin extends LightningElement {
    @api htmlIntroContent = '';
    @api lblUsername = 'Número de Documento';
    @api lblPassword = 'Contraseña';
    @api lblBtnLogin = 'Ingresar';
    @api lblForgotPassword = 'Olvidó Su Contraseña?';
    @api lblSignup = 'Usuario Nuevo?';
    @api errorMessage = 'Se ha producido un error en su intento de inicio de sesión. Asegúrese de que el nombre de usuario y la contraseña son correctos.';
    @api urlForgotPwd = 'ForgotPassword';
    @api urlSignUp = 'SelfRegister';
    @api permSetName = 'Acceso_portal_posgrado';
    _username = '';
    _password = '';
    showError = false;
    showRegistration = false;
    showPassword = false;
    passwordInputType = 'password';
    errorMessageMerged = '';

    @wire(getIsRegistrationEnabled)
    wiredIsRegistrationEnabled({ error, data }) {
        if (data) {
            this.showRegistration = data;
        } else if (error) {
            console.error( JSON.stringify( error ) );
        }
    }

    handleTogglePassword(event) {
        if ( this.showPassword === true ) {
            this.showPassword = false;
            this.passwordInputType = 'password';
        } else {
            this.showPassword = true;
            this.passwordInputType = 'text';
        }
    }

    handlePasswordChange(event) {
        this._password = event.target.value;
    }

    handleUsernameChange(event) {
        this._username = event.target.value;
    }

    handleLogin(event){
        this.showError = false;
        event.preventDefault();
        login({ username: this._username, password: this._password, permissionName: this.permSetName })
            .then((result) => {
                if (this.isValidURL(result)) {
                    window.location.href = result;
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