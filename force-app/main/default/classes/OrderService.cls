public with sharing class OrderService {

    public static void validateOrderCreation(String typeClient, Integer numberOfProduct){
        if(
            ('Particulier'.equals(typeClient) && numberOfProduct < 3) ||
            ('Professionel'.equals(typeClient) && numberOfProduct < 5)
        ) {
            throw new AuraHandledException('Not enough products');     
        } 
    }

    public static Contract findContractById(Id contractId){
        if (!Schema.sObjectType.Contract.fields.Id.isAccessible() || 
            !Schema.sObjectType.Contract.fields.Status.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        if (String.isBlank(contractId)) {
            return null;
        }
        return [Select Id, Status from contract where Id = :contractId LIMIT 1 ];
    }

    @AuraEnabled(cacheable=true)
    public static Livraison__c findLivraison(Id orderId) {
        if (!Schema.sObjectType.Livraison__c.fields.Order__c.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
    }
        return [Select Id, Name, Adresse__c, Pays__c, StatutLivraison__c, DateExpedition__c,DateReceptionEstimee__c, Transporteur__c, Order__c, Order__r.TypeClient__c, Tarif__c from Livraison__c where Order__c = :orderId LIMIT 1];
    }
  

}
