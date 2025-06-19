import { LightningElement, api, track } from 'lwc';
import getpais from '@salesforce/apex/Controladorciudades.getpais';
import getDepartamentos from '@salesforce/apex/Controladorciudades.getDepartamentos';
import getCiudades from '@salesforce/apex/Controladorciudades.getCiudades';

export default class Ciudades extends LightningElement {

    @track departamentoOptions = [];
    @track ciudadOptions = [];
    @track paisOptions = [];
    @track selectedDepartamento = '';
    @track selectedCiudad = '';
    @track selectedPais = '';
    @track countryLabel = '';
    @track departmentLabel = '';
    @track cityLabel = '';
    @track showCityCombobox = true;
    @track ciudadText = '';
    @track cityTextOutput = true;



    @api PAIS;
    @api DEPARTAMENTO;
    @api CIUDAD;
    @api CIUDADTEXTO;

    @api CountryLabelInput;
    @api DepartmentLabelInput;
    @api CityLabelInput;
    @api cityText;
    @api cityTextOutput;
    @api cityCheck;

    @api validate() {
    // Capturamos todos los lightning-combobox y lightning-input
    const comboboxes = this.template.querySelectorAll('lightning-combobox');
    const inputs = this.template.querySelectorAll('lightning-input');
    let isValid = true;
    let errorMessage = '';
    let filledCount = 0;
    let emptyCount = 0;

        // Validar lightning-combobox visibles
        comboboxes.forEach(input => {
            const isVisible = input.offsetParent !== null;
            if (isVisible) {
                if (!input.value) {
                    console.log(`El campo ${input.name} NO está lleno.`);
                    emptyCount++;
                } else {
                    console.log(`El campo ${input.name} está lleno.`);
                }
            }
        });


        // Validar el input de texto de ciudad (solo si está visible)
        inputs.forEach(input => {
            if (input.name === 'cityText') {
                const isVisible = input.offsetParent !== null;
                if (isVisible) {
                    if (!input.value) {
                        console.log(`El campo ${input.name} NO está lleno.`);
                        emptyCount++;
                        isValid = false;
                    } else {
                        console.log(`El campo ${input.name} está lleno.`);
                        filledCount++;
                    }
                }
            }
        });

        if(emptyCount > 0){
            errorMessage = 'Ingrese la Información obligatoria';
            return {
                isValid: false,
                errorMessage: 'Hay campos obligatorios que no están llenos. Por favor, complétalos antes de continuar.'
            };
        }


    }


    connectedCallback() {
        this.loadPais();

        this.countryLabel = this.CountryLabelInput; // Etiqueta para el combobox de País
        this.departmentLabel = this.DepartmentLabelInput; // Etiqueta para el combobox de País
        this.cityLabel = this.CityLabelInput;


        // Si ya hay valores seleccionados, los asignamos a las variables correspondientes
        if (this.PAIS) {
            this.selectedPais = this.PAIS;
            this.loadDepartamentos(); // Cargar departamentos si ya hay un país seleccionado
        }
        if (this.DEPARTAMENTO) {
            this.selectedDepartamento = this.DEPARTAMENTO;
            this.loadCiudades(); // Cargar ciudades si ya hay un departamento seleccionado
        }
        if (this.CIUDAD) {
            this.selectedCiudad = this.CIUDAD; // Asignar la ciudad seleccionada
           
        }

        if (this.CIUDADTEXTO) {
            this.ciudadText = this.CIUDADTEXTO; // Asignar la ciudad seleccionada
           
        }
        // Configurar la visibilidad del combobox de ciudad o del input de texto dependiendo del valor del checkbox
        this.showCityCombobox = !this.cityTextOutput;
        
        
    }



    // Método para cargar las opciones de País
    loadPais() {
       // console.log('País seleccionado: ' + this.selectedPais);
        getpais()
            .then(result => {
                this.paisOptions = result;
                //console.log('País seleccionado: ' + this.selectedPais);
                // Si hay un país seleccionado previamente, se selecciona automáticamente
                if (this.selectedPais) {
                    this.selectedPais = this.PAIS;
                }
                //console.log('País seleccionado: ' + result);
            })
            .catch(error => {
                //console.error('Error al obtener países: ', error); // Manejo de errores
            });
    }

    // Método para cargar las opciones de Departamentos
    loadDepartamentos() {

        getDepartamentos({ codPais: this.selectedPais })
            .then(result => {
                this.departamentoOptions = result;

                // Si ya hay un departamento seleccionado, lo asignamos y cargamos las ciudades
                if (this.selectedDepartamento) {
                    this.selectedDepartamento = this.DEPARTAMENTO;
                    this.loadCiudades(); // Cargar ciudades cuando se selecciona el departamento
                }

                //console.error('departamentos '); // Manejo de errores
            })
            .catch(error => {
               // console.error('Error al obtener departamentos: ', error); // Manejo de errores
            });
    }

    // Método para cargar las opciones de Ciudades basadas en el departamento seleccionado
    loadCiudades() {

        getCiudades({ codDepartamento: this.selectedDepartamento })
            .then(result => {
                this.ciudadOptions = result;

                // Si ya hay una ciudad seleccionada, la asignamos
                if (this.selectedCiudad && !this.showCityCombobox == false) {
                    this.selectedCiudad = this.CIUDAD;
                } else {
                    this.ciudadText = this.CIUDADTEXTO;  // Obtener el valor del input de texto
                  
                }
            })
            .catch(error => {
                //console.error('Error al obtener ciudades: ', error); // Manejo de errores
            });
    }

    // Manejar el cambio en el combobox de País
    handlepaisChange(event) {
        this.selectedPais = event.detail.value; // Guardar el país seleccionado
        this.selectedDepartamento = ''; // Resetear la selección del departamento
        this.selectedCiudad = ''; // Resetear la selección de la ciudad
        this.ciudadText = ''; // Resetear la selección de la ciudad ESCRITA
        this.cityTextOutput = !this.showCityCombobox;
        this.loadDepartamentos(); // Cargar departamentos basados en el país seleccionado
    }

    // Manejar el cambio en el combobox de Departamento
    handleDepartamentoChange(event) {
        this.selectedDepartamento = event.detail.value; // Guardar el departamento seleccionado
        this.selectedCiudad = ''; // Resetear la selección de la ciudad
        this.ciudadText = ''; // Resetear la selección de la ciudad ESCRITA
        this.cityTextOutput = !this.showCityCombobox;
        this.loadCiudades(); // Cargar ciudades basadas en el departamento seleccionado
    }

    // Manejar el cambio en el combobox de Ciudad
    handleCiudadChange(event) {
        this.selectedCiudad = event.detail.value; // Guardar la ciudad seleccionada
        // Guardar los valores seleccionados para su uso posterior
        this.PAIS = this.selectedPais;
        this.DEPARTAMENTO = this.selectedDepartamento;
        if (this.showCityCombobox) {
            this.selectedCiudad = event.detail.value; // Guardar la ciudad seleccionada
            this.CIUDAD = this.selectedCiudad;
        } else {
            this.ciudadText = event.target.value;  // Obtener el valor del input de texto
            this.CIUDADTEXTO = this.ciudadText;
        }
        this.cityTextOutput = !this.showCityCombobox;
    }


    handleCheckOtherCity(event) {
        this.showCityCombobox = !event.target.checked;  // Set the visibility based on checkbox state

        this.selectedCiudad = event.detail.value; // Guardar la ciudad seleccionada
        // Guardar los valores seleccionados para su uso posterior
        this.PAIS = this.selectedPais;
        this.DEPARTAMENTO = this.selectedDepartamento;
        if (this.showCityCombobox) {
            this.selectedCiudad = event.detail.value; // Guardar la ciudad seleccionada
            this.CIUDAD = this.selectedCiudad;
        } else {
            this.ciudadText = event.target.value;  // Obtener el valor del input de texto
            this.CIUDADTEXTO = this.ciudadText;
            //console.log('ciudadtexto ' + this.ciudadText);
        }
        this.cityTextOutput = !this.showCityCombobox;

    }

}