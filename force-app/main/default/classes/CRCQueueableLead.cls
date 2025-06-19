public class CRCQueueableLead implements Queueable, Database.AllowsCallouts {

    private List<Id> leadIds;
    private String leadUnico;

    public CRCQueueableLead(List<Id> leadIds, String leadUnico) {
        this.leadIds = leadIds;
    }

    public void execute(QueueableContext context) {
        CRC.CRClead(leadIds, null);
    }
}