@isTest
public class OpportunityTriggerHandlerTest {
    @testSetup
    static void setupTestData() {
        // Création d'un compte
        Account testAccount = new Account(
            Name = 'Test Account',
            TypeClient__c = 'Particulier',
            ShippingStreet = '123 Test Street',
            ShippingCity = 'Test City',
            ShippingState = 'Test State',
            ShippingCountry = 'Test Country',
            ShippingPostalCode = '12345'
        );
        insert testAccount;

        // Création d'une opportunité
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            AccountId = testAccount.Id,
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert testOpportunity;

        // Ajout de produits dans la Pricebook
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert testProduct;

        PricebookEntry testPricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert testPricebookEntry;

        // Ajout de lignes de produits à l'opportunité
        OpportunityLineItem testLineItem = new OpportunityLineItem(
            OpportunityId = testOpportunity.Id,
            Quantity = 2,
            UnitPrice = 100,
            PricebookEntryId = testPricebookEntry.Id
        );
        insert testLineItem;
    }

    @isTest
    static void testHandleOpportunity() {
        // Récupérer les données de test
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Opportunity testOpportunity = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        Test.startTest();

        // Appeler la méthode handleOpportunity
        OpportunityTriggerHandler.handleOpportunity(testOpportunity);

        Test.stopTest();

        // Vérifier la création du contrat
        Contract createdContract = [SELECT Id, AccountId, Status, ContractTerm FROM Contract WHERE AccountId = :testAccount.Id LIMIT 1];
        System.assertNotEquals(null, createdContract, 'Un contrat doit être créé.');
        System.assertEquals('Draft', createdContract.Status, 'Le statut du contrat doit être Draft.');
        System.assertEquals(12, createdContract.ContractTerm, 'La durée standard du contrat doit être de 12 mois.');

        // Vérifier la création de la commande
        Order createdOrder = [SELECT Id, OpportunityId, AccountId, Status, Type, Pays__c FROM Order WHERE OpportunityId = :testOpportunity.Id LIMIT 1];
        System.assertNotEquals(null, createdOrder, 'Une commande doit être créée.');
        System.assertEquals('Draft', createdOrder.Status, 'Le statut de la commande doit être Draft.');
        System.assertEquals(testOpportunity.AccountId, createdOrder.AccountId, 'La commande doit être associée au bon compte.');
        System.assertEquals('Test State', createdOrder.Pays__c, 'Le champ Pays__c de la commande doit correspondre à l’état du compte.');

        // Vérifier la création des lignes de commande
        List<OrderItem> orderItems = [SELECT Id, OrderId, Product2Id, Quantity FROM OrderItem WHERE OrderId = :createdOrder.Id];
        System.assertEquals(1, orderItems.size(), 'Une ligne de commande doit être créée.');
        System.assertEquals(2, orderItems[0].Quantity, 'La quantité de la ligne de commande doit correspondre à la quantité de OpportunityLineItem.');

        // Vérifier la création de la livraison
        Livraison__c createdLivraison = [SELECT Id, Order__c, Adresse__c, Pays__c, CodePostal__c FROM Livraison__c WHERE Order__c = :createdOrder.Id LIMIT 1];
        System.assertNotEquals(null, createdLivraison, 'Une livraison doit être créée.');
        System.assertEquals(createdOrder.Id, createdLivraison.Order__c, 'La livraison doit être liée à la commande.');
        System.assertEquals('Test State', createdLivraison.Pays__c, 'Le champ Pays__c de la livraison doit être correct.');
        System.assertEquals('12345', createdLivraison.CodePostal__c, 'Le champ CodePostal__c de la livraison doit être correct.');
    }
}