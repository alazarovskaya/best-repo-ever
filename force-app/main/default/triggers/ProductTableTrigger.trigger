trigger ProductTableTrigger on ProductTable__c (before insert, before update) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
        ProductTableTriggerHelper.beforeInsert(trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        ProductTableTriggerHelper.beforeUpdate(trigger.new);
    }
}