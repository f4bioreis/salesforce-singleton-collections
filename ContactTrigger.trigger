trigger ContactTrigger on Contact (before insert) {
    
    Boolean beforeInsert = Trigger.operationType == TriggerOperation.BEFORE_INSERT;

    if (beforeInsert) {
        ContactTriggerHandler.setAccountNames(Trigger.new);
    }

    // Resets singleton collections whenever the trigger's batch records finish being processed.
    // This is because of how Salesforce handles DML, by processing records in batches of 200,
    // so the following batches of records can take advantage of the singleton collections
    ContactUtil.resetCollections();
}