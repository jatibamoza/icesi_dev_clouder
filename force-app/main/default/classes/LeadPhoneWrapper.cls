public class LeadPhoneWrapper {
        @AuraEnabled
        @InvocableVariable(required=true)
        public String leadId;

        @AuraEnabled
         @InvocableVariable(required=true)
    public String normalizedPhone;
    }