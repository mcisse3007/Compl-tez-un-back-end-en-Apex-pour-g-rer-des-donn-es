@isTest
public class TransporteurSelectorTest {

    @isTest
    static void testGetAvailableTransportersSuccess() {
        // Préparer des données de test
        TarifTransporteur__c tarif1 = new TarifTransporteur__c(
            Pays__c = 'France',
            Tarif__c = 10,
            DelaiLivraison__c = 2,
            Transporteur__c = '001000000000000',
            Transporteur__r = new Transporteur__c(Name = 'Transporteur 1', TypeClientAutorise__c = 'Professionel')
        );
        insert tarif1;

        Test.startTest();
        List<TarifTransporteur__c> results = TransporteurSelector.getAvailableTransporters('France', 'Professionel');
        Test.stopTest();

        System.assertNotEquals(0, results.size(), 'The results should not be empty');
        System.assertEquals(tarif1.Id, results[0].Id, 'The returned record should match the inserted one.');
    }

    @isTest
    static void testGetAvailableTransportersFieldAccess() {
        // Simuler une condition où les champs requis ne sont pas accessibles
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            try {
                TransporteurSelector.getAvailableTransporters('France', 'Professionel');
                System.assert(false, 'Expected exception due to insufficient field access');
            } catch (AuraHandledException e) {
                System.assertEquals(
                    'you do not have access to the required fields',
                    e.getMessage(),
                    'The error message for field access should match'
                );
            }
            Test.stopTest();
        }
    }

    @isTest
    static void testFindTransporteurByIdSuccess() {
        // Créer un Transporteur__c pour le test
        Transporteur__c transporteur = new Transporteur__c(Name = 'Test Transporteur');
        insert transporteur;

        Test.startTest();
        Transporteur__c result = TransporteurSelector.findTransporteurById(transporteur.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The transporteur should not be null');
        System.assertEquals(transporteur.Id, result.Id, 'The transporteur IDs should match');
    }

    @isTest
    static void testFindTransporteurByIdFieldAccess() {
        // Simuler une condition où l'accès aux champs est restreint
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            try {
                TransporteurSelector.findTransporteurById('001000000000000');
                System.assert(false, 'Expected exception due to insufficient field access');
            } catch (AuraHandledException e) {
                System.assertEquals(
                    'vous ne pouvez pas faire cette action',
                    e.getMessage(),
                    'The error message for field access should match'
                );
            }
            Test.stopTest();
        }
    }

    @isTest
    static void testSetTransporteurSuccess() {
        // Créer les enregistrements nécessaires pour le test
        Livraison__c livraison = new Livraison__c(Pays__c = 'France');
        insert livraison;

        Transporteur__c transporteur = new Transporteur__c(Name = 'Test Transporteur');
        insert transporteur;

        TarifTransporteur__c tarif = new TarifTransporteur__c(
            Pays__c = 'France',
            Tarif__c = 15,
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

    @isTest
    static void testSetTransporteurFieldAccess() {
        // Simuler une condition où les champs ne sont pas modifiables
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            try {
                TransporteurSelector.setTransporteur('001000000000000', '002000000000000');
                System.assert(false, 'Expected exception due to insufficient field update permissions');
            } catch (AuraHandledException e) {
                System.assertEquals(
                    'vous ne pouvez pas faire cette action',
                    e.getMessage(),
                    'The error message for field update permissions should match'
                );
            }
            Test.stopTest();
        }
    }
}