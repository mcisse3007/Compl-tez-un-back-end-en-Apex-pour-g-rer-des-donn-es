@isTest
public class OrderTriggerHandlerTest {

    @isTest
    static void testHandleOrderSuccess() {
        // Préparation des données pour le test
        Contract contract = new Contract(Status = 'Draft');
        insert contract;

        Livraison__c livraison = new Livraison__c(
            Order__c = 'fakeOrderId',
            Transporteur__c = 'fakeTransporteurId'
        );
        insert livraison;

        Transporteur__c transporteur = new Transporteur__c();
        insert transporteur;

        TarifTransporteur__c tarif = new TarifTransporteur__c(
            DelaiLivraison__c = 5
        );
        insert tarif;

        // Mock de l'objet Order avec dépendances
        Order order = new Order(
            Id = livraison.Order__c,
            ContractId = contract.Id,
            Pays__c = 'Test Country'
        );

        // Simulation des services utilisés
        Test.startTest();
        OrderTriggerHandler.handleOrder(order);
        Test.stopTest();

        // Vérifications
        livraison = [SELECT DateExpedition__c, DateReceptionEstimee__c, StatutLivraison__c FROM Livraison__c WHERE Id = :livraison.Id];
        contract = [SELECT Id, Status FROM Contract WHERE Id = :contract.Id];

        System.assertEquals(System.today(), livraison.DateExpedition__c, 'La date d’expédition devrait être aujourd’hui.');
        System.assertEquals(System.today().addDays(5), livraison.DateReceptionEstimee__c, 'La date réception estimée ne correspond pas au délai.');
        System.assertEquals('Expédiée', livraison.StatutLivraison__c, 'Le statut livraison devrait être "Expédiée".');
        System.assertEquals('Activated', contract.Status, 'Le statut du contrat aurait dû être changé en "Activated".');
    }

    @isTest
    static void testHandleOrderFieldAccessException() {
        // Simulation des permissions d'accès restreintes
        Test.startTest();
        User user = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(user) {
            try {
                Order order = new Order(Id = 'fakeOrderId');
                OrderTriggerHandler.handleOrder(order);
                System.assert(false, 'Une exception aurait dû être levée en raison de permissions restreintes.');
            } catch (AuraHandledException e) {
                System.assertEquals(
                    'vous ne pouvez pas faire cette action',
                    e.getMessage(),
                    'Le message d’erreur ne correspond pas pour le cas des permissions.'
                );
            }
        }
        Test.stopTest();
    }

    @isTest
    static void testHandleOrderMissingTransporteur() {
        // Préparation des données : Livraison sans transporteur
        Livraison__c livraison = new Livraison__c(Order__c = 'fakeOrderId');
        insert livraison;

        Order order = new Order(Id = livraison.Order__c);

        // Simulation
        Test.startTest();
        try {
            OrderTriggerHandler.handleOrder(order);
            System.assert(false, 'Une erreur aurait dû se produire pour un transporteur manquant.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Choisissez un transporteur'), 'Le message d’erreur ne correspond pas.');
        }
        Test.stopTest();
    }

    @isTest
    static void testHandleOrderContractNotActivated() {
        // Cas où le contrat est déjà activé
        Contract contract = new Contract(Status = 'Activated');
        insert contract;

        Livraison__c livraison = new Livraison__c(
            Order__c = 'fakeOrderId',
            Transporteur__c = 'fakeTransporteurId'
        );
        insert livraison;

        Order order = new Order(
            Id = livraison.Order__c,
            ContractId = contract.Id
        );

        Test.startTest();
        OrderTriggerHandler.handleOrder(order);
        Test.stopTest();

        // Vérification que le statut n’a pas changé
        contract = [SELECT Id, Status FROM Contract WHERE Id = :contract.Id];
        System.assertEquals('Activated', contract.Status, 'Le statut ne devrait pas être modifié.');
    }
}