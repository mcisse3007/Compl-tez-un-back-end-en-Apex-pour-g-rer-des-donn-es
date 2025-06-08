public with sharing class OrderTriggerHandler {

    public static void handleOrder(Order order) {
        if (!Schema.sObjectType.Livraison__c.fields.Id.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        Livraison__c livraison = OrderService.findLivraison(order.Id);
        if (livraison.Transporteur__c == null) {
             order.addError('Choisissez un transporteur');
             return;
        }
         Transporteur__c transporteur =  TransporteurSelector.findTransporteurById(livraison.Transporteur__c);
         TarifTransporteur__c tarif = TransporteurSelector.findTarifTransporteur(transporteur.Id, order.Pays__c);
         Contract contract = OrderService.findContractById(order.ContractId);
         if(contract.Status == 'Draft') {
             contract.Status = 'Activated';
             update contract;
         }
         livraison.DateExpedition__c = System.today();
         livraison.DateReceptionEstimee__c = System.today().addDays( Integer.valueOf(tarif.DelaiLivraison__c));
         livraison.StatutLivraison__c = 'Expédiée';
         update livraison;

    }
}