global class ScheduleBatchUpdate implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Ejecutar el batch
        UpdateLeadTimeBatch batch = new UpdateLeadTimeBatch();
        Database.executeBatch(batch);
    }
}