import { LightningElement, api, wire } from 'lwc';
import createUser from '@salesforce/apex/CommunityAuthenticator_Utils.createPortalUser';
import addPermissions from '@salesforce/apex/CommunityAuthenticator_Utils.addPermissions';
import getIdTypePicklistValues from '@salesforce/apex/CommunityAuthenticator_Utils.getIdTypePicklistValues';

export default class CommunitySelfRegister extends LightningElement {
    @api htmlIntroContent = '';
    @api errorMessage = 'Se ha producido un error en su intento de inicio de sesión. Asegúrese de que el nombre de usuario y la contraseña son correctos.';
    @api lblBtnRegister = 'Crear Usuario';
    @api lblIdType = 'Tipo documento identidad';
    @api lblIdNumber = 'Número documento identidad';
    @api lblFirstName = 'Nombre';
    @api lblLastName = 'Apellido';
    @api lblEmail = 'Correo electrónico';
    @api lblPhone = 'Celular';
    @api lblDOB = 'Fecha de nacimiento';
    @api lblPassword1 = 'Contraseña';
    @api lblPassword2 = 'Confirmación de Contraseña';
    @api pwdMinCharacters = 14;
    @api pwdMaxCharacters = 50;
    @api pwdAge = 5;
    @api pwdUpperCase = false;
    @api pwdLowerCase = false;
    @api pwdNumbers = false;
    @api pwdSpecialCharacters = false;
    @api pwdSpaceCharacter = false;
    @api urlTerms = 'https://www.icesi.edu.co/politica-de-tratamiento-de-datos-personales/';
    @api urlIntro = 'Autorizo el tratamiento de datos.';
    @api urlText = 'Política de tratamiento de datos personales - Universidad Icesi.';
    @api accRecordType = 'Person Account';
    @api usrProfile = 'Usuario Comunidad Posgrado';
    @api lblBtnRegisterProcessing = 'Registrando usuario...';
    @api errorRequired = 'Este campo es obligatorio, por favor ingrese un valor.';
    @api errorLettersOnly = 'Este campo solo acepta letras.';
    @api errorNumbersOnly = 'Este campo solo acepta números.';
    @api errorInvalidEmail = 'Correo electrónico inválido.';
    @api errorDOB = 'Fecha de nacimiento inválida.';
    @api errorMinChar = 'Este campo debe tener al menos {0} caracteres.';
    @api errorMaxChar = 'Este campo debe tener máximo {0} caracteres.';
    @api errorExactCharText = 'Este campo debe tener exactamente {0} caracteres.';
    @api errorExactCharNumber = 'Este campo debe tener exactamente {0} dígitos.';
    @api errorMaxDOB = 'La fecha máxima de nacimiento es {0}.';
    @api errorMinDOB = 'La fecha mínima de nacimiento es {0}.';
    @api dobYearOffset = 10;
    @api dobYearQuantity = 90;
    @api pwdTxtMinChar = 'Al menos {0} caracteres';
    @api pwdTxtMaxChar = 'No más de {0} caracteres';
    @api pwdTxtUpper = 'Contiene una letra mayúscula (A-Z)';
    @api pwdTxtLower = 'Contiene una letra minúscula (a-z)';
    @api pwdTxtNumber = 'Contiene un número (0-9)';
    @api pwdTxtSpecial = 'Contiene un caracter especial (@#$%^&*!?_)';
    @api pwdTxtSpace = 'No contiene espacios';
    @api pwdTxtCoincidence = 'La confirmación de contraseña debe coincidir';
    @api pwdTxtAge = 'No se pueden reutilizar las últimas {0} contraseñas';
    @api pwdConditionsIntro = 'Para la definición de contraseña, recuerde que debe cumplir con los siguientes requisitos:';
    @api urlForgotPwd = 'ForgotPassword';
    @api urlLogin = 'login';
    @api permSetName = 'Acceso_portal_posgrado';
    @api urlRegisterCheck = 'check-register';

    _errorMessageDefault = this.errorMessage;
    _defaultContainerClass = 'slds-form-element';
    idType = '';
    idTypeError = '';
    idTypeIsInvalid = true;
    idTypeClass = this._defaultContainerClass;
    idNumber = '';
    idNumberError = '';
    idNumberIsInvalid = true;
    idNumberClass = this._defaultContainerClass;
    @api idNumberMinChar = -1;
    @api idNumberMaxChar = 11;
    firstName = '';
    firstNameError = '';
    firstNameIsInvalid = true;
    firstNameClass = this._defaultContainerClass;
    @api firstNameMinChar = -1;
    @api firstNameMaxChar = 25;
    lastName = '';
    lastNameError = '';
    lastNameIsInvalid = true;
    lastNameClass = this._defaultContainerClass;
    @api lastNameMinChar = -1;
    @api lastNameMaxChar = 25;
    email = '';
    errorEmail = '';
    emailIsInvalid = true;
    emailClass = this._defaultContainerClass;
    @api emailMinChar = -1;
    @api emailMaxChar = 60;
    phone = '';
    phoneError = '';
    phoneIsInvalid = true;
    phoneClass = this._defaultContainerClass;
    @api phoneMinChar = 10;
    @api phoneMaxChar = 10;
    dob = '';
    errorDOB = '';
    dobIsInvalid = true;
    dobClass = this._defaultContainerClass;
    password1 = '';
    password2 = '';
    showError = false;
    showPassword1 = false;
    showPassword2 = false;
    btnRegisterDisabled = true;
    passwordInputType1 = 'password';
    passwordInputType2 = 'password';
    termsAccepted = false;
    isProcessing = false;
    idOptions = [];
    pwdClassDefault = 'pwd-conditions-container bg-light accordion-pwd-container';
    pwdClass = this.pwdClassDefault + ' hide';
    errorMessageMerged = '';

    passwordConditions = {
        minLength: { class: 'invalid', icon: 'utility:error', isValid: false },
        maxLength: { class: 'valid', icon: 'utility:success', isValid: true },
        hasUpper: { class: 'invalid', icon: 'utility:error', isValid: false },
        hasLower: { class: 'invalid', icon: 'utility:error', isValid: false },
        hasNumber: { class: 'invalid', icon: 'utility:error', isValid: false },
        hasSpecial: { class: 'invalid', icon: 'utility:error', isValid: false },
        noSpaces: { class: 'valid', icon: 'utility:success', isValid: true },
        coincidence: { class: 'valid', icon: 'utility:success', isValid: true }
    };

    @wire(getIdTypePicklistValues)
    wiredPicklist({ error, data }) {
        if (data) {
            this.idOptions = data;  // Directly use returned list of objects
        } else if (error) {
            console.error('Error fetching ID types:', error);
        }
    }

    get showPwdAge(){
        return this.pwdAge != -1;
    }

    get showPwdMinChars(){
        return this.pwdMinCharacters != -1;
    }

    get showPwdMaxChars(){
        return this.pwdMaxCharacters != -1;
    }
    /*
    Removed as no password is needed for registration
    get isButtonDisabled() {
        const allFieldsValid = !this.idTypeIsInvalid && !this.idNumberIsInvalid && !this.firstNameIsInvalid && !this.lastNameIsInvalid &&
                                !this.emailIsInvalid && !this.phoneIsInvalid && !this.dobIsInvalid && this.password1 != '' && this.password2 != '';
        const allConditionsMet = Object.values(this.passwordConditions).every(condition => condition.isValid);        
        return !(allFieldsValid && allConditionsMet && this.termsAccepted);
    }
    */

    get isButtonDisabled() {
        const allFieldsValid = !this.idTypeIsInvalid && !this.idNumberIsInvalid && !this.firstNameIsInvalid && !this.lastNameIsInvalid &&
                                !this.emailIsInvalid && !this.phoneIsInvalid && !this.dobIsInvalid;
        const allConditionsMet = Object.values(this.passwordConditions).every(condition => condition.isValid);
        return !(allFieldsValid && this.termsAccepted);
    }

    get dobMinDate(){
        const d = new Date();
        let year = d.getFullYear() - this.dobYearQuantity;
        return year + "-01-01";
    }

    get dobMaxDate(){
        const d = new Date();
        let year = d.getFullYear() - this.dobYearOffset;
        return year + "-12-31";
    }

    get pwdTxtMinCharMerged(){
        return this.pwdTxtMinChar.replaceAll('{0}', this.pwdMinCharacters );
    }
    
    get pwdTxtMaxCharMerged(){
        return this.pwdTxtMaxChar.replaceAll('{0}', this.pwdMaxCharacters );
    }
    
    get pwdTxtAgeMerged(){
        return this.pwdTxtAge.replaceAll('{0}', this.pwdAge );
    }

    get pwd2Invalid(){
        return this.password2 !== '' && this.password2 !== this.password1;
    }

    get pwd2Class(){
        return this.pwd2Invalid ? 'slds-form-element slds-has-error' : 'slds-form-element';
    }

    onShowValidations(event) {
        this.pwdClass = this.pwdClassDefault + ' show';
    }

    onHideValidations(event) {
        this.pwdClass = this.pwdClassDefault + ' hide';
    }

    handleInputChange(event) {
        const { name, value } = event.target;
        if (name === 'pwd1') {
            this.password1 = value;
            this.validatePassword();
        } else if (name === 'pwd2') {
            this.password2 = value;
            this.validatePassword();
        } else if (name === 'terms') {
            this.termsAccepted = event.target.checked;
        } else {
            this.setValidationValues( name, false, '' );
            this[name] = value;
            
            if (name === 'idType') {
                this.fieldValidation( value, name, -1, -1, '' );
            } else if (name === 'idNumber') {
                this.fieldValidation( value, name, this.idNumberMinChar, this.idNumberMaxChar, '' );
            } else if (name === 'firstName') {
                this.fieldValidation( value, name, this.firstNameMinChar, this.firstNameMaxChar, 'TEXT_ONLY' );
            } else if (name === 'lastName') {
                this.fieldValidation( value, name, this.lastNameMinChar, this.lastNameMaxChar, 'TEXT_ONLY' );
            } else if (name === 'email') {
                this.fieldValidation( value, name, this.emailMinChar, this.emailMaxChar, '' );
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                if( !emailPattern.test(value) ){
                    this.setValidationValues( name, true, this.errorInvalidEmail );
                }
            } else if (name === 'phone') {
                this.fieldValidation( value, name, this.phoneMinChar, this.phoneMaxChar, 'NUMBERS_ONLY' );
            } else if (name === 'dob') {
                this.fieldValidation( value, name, -1, -1, '' );
                if( value > this.dobMaxDate ){
                    this.setValidationValues( name, true, this.errorMaxDOB.replaceAll('{0}', this.dobMaxDate ) );
                } else if( value < this.dobMinDate ){
                    this.setValidationValues( name, true, this.errorMinDOB.replaceAll('{0}', this.dobMinDate ) );
                }
            } 
        }
    }

    validatePassword() {
        this.passwordConditions = {
            minLength: ( this.pwdMinCharacters == -1 || this.password1.length >= this.pwdMinCharacters ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            maxLength: ( this.pwdMaxCharacters == -1 || this.password1.length <= this.pwdMaxCharacters ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            hasUpper: ( !this.pwdUpperCase || /[A-Z]/.test(this.password1) ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            hasLower: ( !this.pwdLowerCase || /[a-z]/.test(this.password1) ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            hasNumber: ( !this.pwdNumbers || /\d/.test(this.password1) ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            hasSpecial: ( !this.pwdSpecialCharacters || /[@#$%^&*!?_]/.test(this.password1) ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            noSpaces: ( !this.pwdSpaceCharacter || !/\s/.test(this.password1) ) ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false },
            coincidence: this.password1 == this.password2 ? { class: 'valid', icon: 'utility:success', isValid: true } : { class: 'invalid', icon: 'utility:error', isValid: false }
        };
    }

    handleTogglePassword1(event) {
        if ( this.showPassword1 === true ) {
            this.showPassword1 = false;
            this.passwordInputType1 = 'password';
        } else {
            this.showPassword1 = true;
            this.passwordInputType1 = 'text';
        }
    }

    handleTogglePassword2(event) {
        if ( this.showPassword2 === true ) {
            this.showPassword2 = false;
            this.passwordInputType2 = 'password';
        } else {
            this.showPassword2 = true;
            this.passwordInputType2 = 'text';
        }
    }

    handleFocus(event) {
        if (event.target.name === 'dob') {
            event.target.type = 'date';
        }
    }

    handleBlur(event) {
        if (event.target.name === 'dob' && !event.target.value) {
            event.target.type = 'text';
        }
    }
    
    handleRegister(event){
        this.showError = false;
        this.isProcessing = true;
        event.preventDefault();
        createUser({    firstName: this.firstName, lastName: this.lastName, email: this.email, phone: this.phone, 
                        dob: this.dob, idType: this.idType, idNumber: this.idNumber, password: this.password1,
                        accRTName: this.accRecordType, usrProfileId: this.usrProfile, permissionName: this.permSetName })
            .then((result) => {
                if (this.isValidURL(result)) {
                    window.location.href = result;
                }
                else if ( result.startsWith( 'OK' ) ) {
                    this.callAddPermissions();
                }
                else {
                    this.showError = true;
                    this.errorMessageMerged = this.errorMessage.replaceAll('{0}', result ).replaceAll('{URL_LOGIN}', this.urlLogin ).replaceAll('{URL_RESET}', this.urlForgotPwd );
                }
                this.isProcessing = false
            })
            .catch((error) => {
                this.showError = true;
                this.errorMessageMerged = this.errorMessage.replaceAll('{0}', error ).replaceAll('{URL_LOGIN}', this.urlLogin ).replaceAll('{URL_RESET}', this.urlForgotPwd );
                this.isProcessing = false
        });
    }
    
    callAddPermissions(){
        this.isProcessing = true;
        addPermissions({ username: this.idNumber, permissionName: this.permSetName })
            .then((result) => {
                window.location.href = this.urlRegisterCheck;
                this.isProcessing = false
            })
            .catch((error) => {
                this.showError = true;
                this.errorMessageMerged = this.errorMessage.replaceAll('{0}', error ).replaceAll('{URL_LOGIN}', this.urlLogin ).replaceAll('{URL_RESET}', this.urlForgotPwd );
                this.isProcessing = false
        });
    }

    isValidURL(url) {
        const urlPattern = /^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$/;
        return urlPattern.test(url);
    }

    setValidationValues( fieldName, isError, errorMessage ){
        this[ fieldName + 'Class' ] = isError ? this._defaultContainerClass + ' slds-has-error' : this._defaultContainerClass;
        this[ fieldName + 'IsInvalid' ] = isError;
        this[ fieldName + 'Error' ] = errorMessage;
    }

    fieldValidation( value, fieldName, min, max, condition ){
        const textPattern = /^[A-Za-zÁáÉéÍíÓóÚúÑñ\s]+$/;
        if( value == '' ){
            this.setValidationValues( fieldName, true, this.errorRequired );
        } else if( condition === 'NUMBERS_ONLY' && isNaN( value ) ){
            this.setValidationValues( fieldName, true, this.errorNumbersOnly );
        } else if( condition === 'TEXT_ONLY' && !textPattern.test(value) ){
            this.setValidationValues( fieldName, true, this.errorLettersOnly );
        } else if( min != -1 || max != -1 ){                
            if( min == max && value.length != min ){
                this.setValidationValues( fieldName, true, this.errorExactCharText.replaceAll('{0}', min ) );
            } else if( min != -1 && value.length < min ){
                this.setValidationValues( fieldName, true, this.errorMinChar.replaceAll('{0}', min ) );
            } else if( max != -1 && value.length > max ){
                this.setValidationValues( fieldName, true, this.errorMaxChar.replaceAll('{0}', max ) );
            }
        }
    }
}