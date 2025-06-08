public with sharing class PriceBookEntrySelector {
    
    public static PricebookEntry getPricebookEntry (Id product2Id, Id pricebook2Id){
        if (!Schema.sObjectType.PricebookEntry.fields.Pricebook2Id.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        if (!Schema.sObjectType.PricebookEntry.fields.Product2Id.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        return [SELECT Id
                FROM PricebookEntry
                WHERE Pricebook2Id = :pricebook2Id AND Product2Id = :product2Id
                LIMIT 1];

    }
}