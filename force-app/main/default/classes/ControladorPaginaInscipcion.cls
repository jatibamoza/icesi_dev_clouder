public with sharing class ControladorPaginaInscipcion {

    public ApexPages.StandardController standardController;
    public String id { get; set; }
    public String pais { get; set; }
    public String tipodoc { get; set; }
    public String ciudad { get; set; }
    public String departamento { get; set; }
    public String tipo { get; set; }
    public String hora { get; set; }
    public Decimal total { get; set; }



    public ControladorPaginaInscipcion(ApexPages.StandardController controller) {
        this.standardController = controller;
        // Obtener el Id del registro actual
           id = ApexPages.currentPage().getParameters().get('id');
        // INFROMACIÓN DEL FORMULARIO

        IndividualApplication IA = new IndividualApplication();
        IA = [SELECT AccountId,CC_Periodo_academico__r.Codigo_periodo__c, toLabel(Carrera_de_mayor_interes__r.Tipo_de_programa__c),Monto_factura_matricula__c,Monto_procultura__c,CC_Pago_confirmado__c FROM IndividualApplication WHERE Id= :id];

        Account acc = new Account();
        acc = [SELECT toLabel(CC_Acc_Tipo_id__c),toLabel(CC_Pa_s_cuenta__c) ,toLabel(CC_Departamento__c) ,CC_Ciudad__r.Name FROM Account WHERE Id= :IA.AccountId];

        tipodoc = acc.CC_Acc_Tipo_id__c;
        pais = acc.CC_Pa_s_cuenta__c;
        departamento = acc.CC_Departamento__c;
        ciudad = acc.CC_Ciudad__r.Name;
        tipo = IA.Carrera_de_mayor_interes__r.Tipo_de_programa__c;

        Datetime fechaHoraActual = Datetime.now();
        String yearStr = String.valueOf(fechaHoraActual.year());
        String monthStr = fechaHoraActual.month() < 10 ? '0' + String.valueOf(fechaHoraActual.month()) : String.valueOf(fechaHoraActual.month());
        String dayStr = fechaHoraActual.day() < 10 ? '0' + String.valueOf(fechaHoraActual.day()) : String.valueOf(fechaHoraActual.day());
        String hourStr = fechaHoraActual.hour() < 10 ? '0' + String.valueOf(fechaHoraActual.hour()) : String.valueOf(fechaHoraActual.hour());
        String minuteStr = fechaHoraActual.minute() < 10 ? '0' + String.valueOf(fechaHoraActual.minute()) : String.valueOf(fechaHoraActual.minute());
        String secondStr = fechaHoraActual.second() < 10 ? '0' + String.valueOf(fechaHoraActual.second()) : String.valueOf(fechaHoraActual.second());

        String formattedDateTime = yearStr + monthStr + dayStr + hourStr + minuteStr + secondStr;

        System.debug('Fecha y Hora Actual Formateada: ' + formattedDateTime);

        hora = formattedDateTime;

        total = 0;
        if(IA.Monto_factura_matricula__c != null && IA.Monto_factura_matricula__c != null){
            total = IA.Monto_factura_matricula__c + IA.Monto_procultura__c;
        }
        else if(IA.Monto_factura_matricula__c != null && IA.Monto_procultura__c == null) {
            total = IA.Monto_factura_matricula__c ;
        }
        

    }
}