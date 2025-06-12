@isTest
public class TransporteurSelectorTest {

    @isTest
    static void testGetAvailableTransportersSuccess() {
        Transporteur__c transporteur1 = new Transporteur__c(Name = 'Transporteur 1', TypeClientAutorise__c = 'Professionnel',ExternalId__c='1');
        // Préparer des données de test
        TarifTransporteur__c tarif1 = new TarifTransporteur__c(
            Pays__c = 'France',
            Tarif__c = 10,
            DelaiLivraison__c = 2,
            Transporteur__c = transporteur1.Id,
        );
        insert tarif1;

        Test.startTest();
        List<TarifTransporteur__c> results = TransporteurSelector.getAvailableTransporters('France', 'Professionel');
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'The results should not be empty');
        System.assertEquals(tarif1.Id, results[0].Id, 'The returned record should match the inserted one.');
    }


    @isTest
    static void testFindTransporteurByIdSuccess() {
        // Créer un Transporteur__c pour le test
        Transporteur__c transporteur = new Transporteur__c(Name = 'Test Transporteur', 
        TypeClientAutorise__c = 'Particulier', 
        ExternalId__c = '1'
        );
        insert transporteur;

        Test.startTest();
        Transporteur__c result = TransporteurSelector.findTransporteurById(transporteur.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The transporteur should not be null');
        System.assertEquals(transporteur.Id, result.Id, 'The transporteur IDs should match');
    }



    @isTest
    static void testSetTransporteurSuccess() {
        // Créer les enregistrements nécessaires pour le test
        Livraison__c livraison = new Livraison__c(Pays__c = 'France');
        insert livraison;

        Transporteur__c transporteur = new Transporteur__c(Name = 'Test Transporteur', 
        TypeClientAutorise__c = 'Particulier', 
        ExternalId__c = '1');
        insert transporteur;

        TarifTransporteur__c tarif = new TarifTransporteur__c(
            Pays__c = 'France',
            Tarif__c = 15,
            DelaiLivraison__c=2,
            Transporteur__c = transporteur.Id
        );
        insert tarif;

        Test.startTest();
        Livraison__c updatedLivraison = TransporteurSelector.setTransporteur(livraison.Id, transporteur.Id);
        Test.stopTest();

        // Vérifier les résultats
        System.assertNotEquals(null, updatedLivraison, 'The livraison should not be null');
        System.assertEquals(transporteur.Id, updatedLivraison.Transporteur__c, 'The transporteur should be updated');
        System.assertEquals('En préparation', updatedLivraison.StatutLivraison__c, 'The status should be updated');
    }
}