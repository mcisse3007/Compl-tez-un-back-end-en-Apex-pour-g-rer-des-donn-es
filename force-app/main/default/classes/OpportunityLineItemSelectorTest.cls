@isTest
public class OpportunityLineItemSelectorTest {

    @isTest
    static void testGetNumberOfProduct_Success() {
        // Création d'une opportunité de test
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today(),
            StageName = 'Prospecting'
        );
        insert testOpportunity;

        // Création de OpportunityLineItems associés
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert testProduct;

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Product2Id = testProduct.Id,
            Pricebook2Id = standardPricebook.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert testPricebookEntry;

        OpportunityLineItem testLineItem = new OpportunityLineItem(
            OpportunityId = testOpportunity.Id,
            PricebookEntryId = testPricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100.0
        );
        insert testLineItem;

        // Appel à la méthode pour compter les produits
        Test.startTest();
        Integer productCount = OpportunityLineItemSelector.getNumberOfProduct(testOpportunity.Id);
        Test.stopTest();

        // Vérification du résultat
        System.assertEquals(1, productCount, 'Le nombre de produits devrait être égal à 1');
    }

    @isTest
    static void testGetLineItems_Success() {
        // Création d'une opportunité de test
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today(),
            StageName = 'Prospecting'
        );
        insert testOpportunity;

        // Création de OpportunityLineItems associés
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert testProduct;

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Product2Id = testProduct.Id,
            Pricebook2Id = standardPricebook.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert testPricebookEntry;

        OpportunityLineItem testLineItem = new OpportunityLineItem(
            OpportunityId = testOpportunity.Id,
            PricebookEntryId = testPricebookEntry.Id,
            Quantity = 1,
            UnitPrice = 100.0
        );
        insert testLineItem;

        // Appel à la méthode pour récupérer les produits associés
        Test.startTest();
        List<OpportunityLineItem> lineItems = OpportunityLineItemSelector.getLineItems(testOpportunity.Id);
        Test.stopTest();

        // Vérification des résultats
        System.assertEquals(1, lineItems.size(), 'Il devrait y avoir un produit associé');
        System.assertEquals(testLineItem.Id, lineItems[0].Id, 'Les Id des produits associés devraient correspondre');
    }

    @isTest
    static void testGetNumberOfProduct_NoAccessException() {
        Test.startTest();
        try {
            OpportunityLineItemSelector.getNumberOfProduct('006000000000001');
            System.assert(false, 'Une exception aurait dû être levée en raison d\'un manque d\'accès');
        } catch (AuraHandledException e) {
            System.assertEquals(
                'vous ne pouvez pas faire cette action',
                e.getMessage(),
                'Le message d\'erreur ne correspond pas à celui attendu'
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testGetLineItems_NoAccessException() {
        Test.startTest();
        try {
            OpportunityLineItemSelector.getLineItems('006000000000001');
            System.assert(false, 'Une exception aurait dû être levée en raison d\'un manque d\'accès');
        } catch (AuraHandledException e) {
            System.assertEquals(
                'vous ne pouvez pas faire cette action',
                e.getMessage(),
                'Le message d\'erreur ne correspond pas à celui attendu'
            );
        }
        Test.stopTest();
    }
}
