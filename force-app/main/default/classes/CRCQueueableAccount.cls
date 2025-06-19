public class CRCQueueableAccount implements Queueable, Database.AllowsCallouts {

    private List<Id> accountIds;
    private String cuentaUnica;

    public CRCQueueableAccount(List<Id> accountIds, String cuentaUnica) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {
        CRC.CRCcuentas(accountIds, null);
    }
}