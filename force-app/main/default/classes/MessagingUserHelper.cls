public with sharing class MessagingUserHelper {

    @InvocableMethod(label='Filtrar Leads con teléfono único')
    public static List<UniqueLeadOutputWrapper> filterUniquePhones(List<LeadPhoneWrapper> inputLeads) {
        Set<String> phonesToCheck = new Set<String>();
        Map<String, String> leadPhoneMap = new Map<String, String>();

        for (LeadPhoneWrapper lead : inputLeads) {
            if (String.isNotBlank(lead.normalizedPhone)) {
                phonesToCheck.add(lead.normalizedPhone);
                leadPhoneMap.put(lead.normalizedPhone, lead.leadId);
            }
        }

        Set<String> existingPhones = new Set<String>();
        for (MessagingEndUser mu : [
            SELECT MessagingPlatformKey FROM MessagingEndUser
            WHERE MessagingPlatformKey IN :phonesToCheck
        ]) {
            existingPhones.add(mu.MessagingPlatformKey);
        }

        List<UniqueLeadOutputWrapper> results = new List<UniqueLeadOutputWrapper>();
        for (String phone : phonesToCheck) {
            if (!existingPhones.contains(phone)) {
                UniqueLeadOutputWrapper out = new UniqueLeadOutputWrapper();
                out.leadId = leadPhoneMap.get(phone);
                out.normalizedPhone = phone;
                results.add(out);
            }
        }

        return results;
    }
}