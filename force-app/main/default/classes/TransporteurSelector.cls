
public with sharing class TransporteurSelector {

    @AuraEnabled(cacheable=true)
    public static List<TarifTransporteur__c> getAvailableTransporters(String country, String customerType) {
        if(!Schema.sObjectType.TarifTransporteur__c.fields.Pays__c.isAccessible()||
            !Schema.sObjectType.TarifTransporteur__c.fields.Transporteur__c.isAccessible()||
            !Schema.sObjectType.TarifTransporteur__c.fields.Tarif__c.isAccessible()||
            !Schema.sObjectType.TarifTransporteur__c.fields.Name.isAccessible()
            ){
                throw new AuraHandledException('you do not have access to the required fields');
            }
        try {
            return [
                SELECT Id, Pays__c, Tarif__c, Transporteur__c, Transporteur__r.Name, DelaiLivraison__c
                FROM TarifTransporteur__c
                WHERE Pays__c = :country AND Transporteur__r.TypeClientAutorise__c = :customerType
                ORDER BY Tarif__c ASC, DelaiLivraison__c ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération des transporteurs.');
        }
    }

    public static Transporteur__c findTransporteurById(Id idTransporteur){
        if (!Schema.sObjectType.Transporteur__c.fields.Id.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        return [SELECT Id, Name FROM Transporteur__c WHERE Id = :idTransporteur];
    }

    public static TarifTransporteur__c findTarifTransporteur(Id idTransporteur, String pays){
        if (!Schema.sObjectType.TarifTransporteur__c.fields.Id.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        return [SELECT Id, Tarif__c, Transporteur__c, Pays__c, DelaiLivraison__c FROM TarifTransporteur__c WHERE Transporteur__c = :idTransporteur and Pays__c = :pays];
    }

    @AuraEnabled
    public static Livraison__c setTransporteur(Id idLivraison, Id idTransporteur){
        if (!Schema.sObjectType.Livraison__c.fields.Transporteur__c.isUpdateable()||
            !Schema.sObjectType.Livraison__c.fields.StatutLivraison__c.isUpdateable()||
            !Schema.sObjectType.Livraison__c.fields.Tarif__c.isUpdateable()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        try {
            Livraison__c livraison = [Select Id, Pays__c from Livraison__c where Id =:idLivraison];
            livraison.Transporteur__c = idTransporteur;
            livraison.StatutLivraison__c = 'En préparation';
            livraison.Tarif__c = [SELECT Tarif__c FROM TarifTransporteur__c WHERE Transporteur__c = :idTransporteur and Pays__c = :livraison.Pays__c].Tarif__c;

            update livraison;
            return livraison;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}