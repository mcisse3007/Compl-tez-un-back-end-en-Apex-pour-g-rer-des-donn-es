@isTest
public class PriceBookEntrySelectorTest {
    
    @testSetup
    static void setupTestData() {
        // Create test data for Pricebook2
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert testProduct;
        
        PricebookEntry testEntry = new PricebookEntry(
            Pricebook2Id = standardPriceBook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert testEntry;
    }
    
    @isTest
    static void testGetPricebookEntry_Success() {
        // Arrange
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
        
        // Act
        PricebookEntry result = PriceBookEntrySelector.getPricebookEntry(
            testProduct.Id,
            standardPriceBook.Id
        );
        
        // Assert
        System.assertNotEquals(null, result, 'PricebookEntry should be returned');
    }
    
    @isTest
    static void testGetPricebookEntry_NoAccessToFields() {
        // Arrange
        Test.startTest();
        
        Product2 testProduct = [SELECT Id FROM Product2 LIMIT 1];
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
        
        // Act & Assert
        try {
            PriceBookEntrySelector.getPricebookEntry(
                testProduct.Id,
                standardPriceBook.Id
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
    
    @isTest
    static void testGetPricebookEntry_NoRecordsFound() {
        // Arrange
        Id invalidProduct2Id = '000000000000000';  // Non-existent Product2 Id
        Id invalidPricebook2Id = '000000000000001';  // Non-existent Pricebook2 Id
        
        // Act
        PricebookEntry result = PriceBookEntrySelector.getPricebookEntry(
            invalidProduct2Id,
            invalidPricebook2Id
        );
        
        // Assert
        System.assertEquals(null, result, 'No PricebookEntry should be returned');
    }
}
