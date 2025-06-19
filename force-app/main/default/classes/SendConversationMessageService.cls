public with sharing class SendConversationMessageService {
    
    public class MessageRequestWrapper {
        @InvocableVariable(label='Message Definition API Name')
        public String messageDefinitionName;

        @InvocableVariable(label='Messaging End User IDs')
        public List<Id> messagingEndUserIds;

        @InvocableVariable(label='Request Type' description='Usually: SendNotificationMessages')
        public String requestType = 'SendNotificationMessages';

        @InvocableVariable(label='Allowed Session Status')
        public String allowedSessionStatus = 'Any';

        @InvocableVariable(label='Enforce Consent?')
        public Boolean isEnforceMessagingChannelConsent = true;

        @InvocableVariable(label='Channel Consent Type')
        public String channelConsentType = 'MessagingEndUser';

        @InvocableVariable(label='Input Parameters')
        public List<MessageParameter> messagingDefinitionInputParameters;
    }

    public class MessageParameter {
        @InvocableVariable
        public String name;

        @InvocableVariable
        public String textValue;
    }

    @InvocableMethod(label='Send WhatsApp Messages via Messaging Component')
    public static void sendMessages(List<MessageRequestWrapper> requests) {
        for (MessageRequestWrapper req : requests) {
            HttpRequest httpReq = new HttpRequest();
            httpReq.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data/v59.0/actions/standard/sendConversationMessages');
            httpReq.setMethod('POST');
            httpReq.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            httpReq.setHeader('Content-Type', 'application/json');

            // Prepare Input Parameters
            List<Map<String, Object>> inputParams = new List<Map<String, Object>>();
            for (MessageParameter param : req.messagingDefinitionInputParameters) {
                Map<String, Object> paramMap = new Map<String, Object>{
                    'name' => param.name,
                    'textValue' => param.textValue
                };
                inputParams.add(paramMap);
            }

            Map<String, Object> input = new Map<String, Object>{
                'messageDefinitionName' => req.messageDefinitionName,
                'requestType' => req.requestType,
                'isEnforceMessagingChannelConsent' => req.isEnforceMessagingChannelConsent,
                'channelConsentType' => req.channelConsentType,
                'allowedSessionStatus' => req.allowedSessionStatus,
                'messagingEndUserIds' => req.messagingEndUserIds,
                'messagingDefinitionInputParameters' => inputParams
            };

            Map<String, Object> payload = new Map<String, Object>{
                'inputs' => new List<Object>{ input }
            };

            httpReq.setBody(JSON.serialize(payload));

            Http http = new Http();
            HTTPResponse res = http.send(httpReq);

            if (res.getStatusCode() != 200 && res.getStatusCode() != 201) {
                System.debug('❌ Error sending message: ' + res.getBody());
                throw new AuraHandledException('Failed to send conversation message.');
            } else {
                System.debug('✅ Message sent successfully: ' + res.getBody());
            }
        }
    }
}