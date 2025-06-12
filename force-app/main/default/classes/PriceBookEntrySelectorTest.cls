@isTest
public class PriceBookEntrySelectorTest {
    
    @testSetup
    static void setupTestData() {
        // Create test data for Pricebook2
        
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert testProduct;
        
        PricebookEntry testEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert testEntry;
    }
    
    @isTest
    static void testGetPricebookEntry_Success() {
        // Arrange
        Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
        
        // Act
        PricebookEntry result = PriceBookEntrySelector.getPricebookEntry(
            testProduct.Id,
            Test.getStandardPricebookId()
        );
        
        // Assert
        System.assertNotEquals(null, result, 'PricebookEntry should be returned');
    }
    
    @isTest
    static void testGetPricebookEntry_NoAccessToFields() {
        // Arrange
        Test.startTest();
        
        Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
        
        // Act & Assert
        try {
            PriceBookEntrySelector.getPricebookEntry(
                testProduct.Id,
                Test.getStandardPricebookId()
            );
            System.assert(false, 'Exception was not thrown when fields are inaccessible');
        } catch (AuraHandledException e) {
            System.assertEquals(
                'vous ne pouvez pas faire cette action',
                e.getMessage(),
                'Exception message does not match'
            );
        }
        Test.stopTest();
    }
    
    
}
