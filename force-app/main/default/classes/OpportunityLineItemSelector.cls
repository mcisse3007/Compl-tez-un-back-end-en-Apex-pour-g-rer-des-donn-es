public with sharing class OpportunityLineItemSelector {
    
     public static Integer getNumberOfProduct(Id oppId) {
        if (!Schema.sObjectType.OpportunityLineItem.fields.OpportunityId.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
    }

        return [SELECT COUNT() FROM OpportunityLineItem WHERE OpportunityId = :oppId];
    }

    public static List<OpportunityLineItem> getLineItems(Id oppId){
        if (!Schema.sObjectType.OpportunityLineItem.fields.OpportunityId.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }

        return [SELECT Id, Product2Id, Product2.Name, UnitPrice, TotalPrice, Quantity, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId=:oppId];
    }


}