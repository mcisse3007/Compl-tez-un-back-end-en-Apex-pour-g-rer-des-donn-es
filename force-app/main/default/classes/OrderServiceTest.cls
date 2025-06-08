@isTest
public class OrderServiceTest {

    @isTest
    static void testValidateOrderCreationSuccess() {
        // Test scenario where validation should pass
        Test.startTest();
        try {
            OrderService.validateOrderCreation('Particulier', 5);
            OrderService.validateOrderCreation('Professionel', 10);
        } catch (Exception e) {
            System.assert(false, 'No exception should be thrown for valid inputs');
        }
        Test.stopTest();
    }

    @isTest
    static void testValidateOrderCreationFailure() {
        // Test scenario where validation fails and exception is thrown
        Test.startTest();
        try {
            OrderService.validateOrderCreation('Particulier', 2); // Should fail
            System.assert(false, 'Expected exception for insufficient products for Particulier');
        } catch (AuraHandledException e) {
            System.assertEquals(
                'Not enough products',
                e.getMessage(),
                'Error message does not match'
            );
        }

        try {
            OrderService.validateOrderCreation('Professionel', 3); // Should fail
            System.assert(false, 'Expected exception for insufficient products for Professionel');
        } catch (AuraHandledException e) {
            System.assertEquals(
                'Not enough products',
                e.getMessage(),
                'Error message does not match'
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testFindContractByIdSuccess() {
        // Create a contract for the test
        Contract testContract = new Contract(Status = 'Active');
        insert testContract;

        Test.startTest();
        Contract result = OrderService.findContractById(testContract.Id);
        Test.stopTest();

        // Verifying result
        System.assertNotEquals(null, result, 'The contract should not be null');
        System.assertEquals(testContract.Id, result.Id, 'The contract IDs should match');
        System.assertEquals('Active', result.Status, 'The Status should match');
    }

    @isTest
    static void testFindContractByIdFieldAccess() {
        // Test scenario where field access is restricted
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            try {
                OrderService.findContractById('003000000000000');
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
    static void testFindLivraisonSuccess() {
        // Create a Livraison__c record for the test
        Livraison__c testLivraison = new Livraison__c(
            Order__c = '001000000000000',
            Adresse__c = '123 Test Street',
            Pays__c = 'Test Country'
        );
        insert testLivraison;

        Test.startTest();
        Livraison__c result = OrderService.findLivraison(testLivraison.Order__c);
        Test.stopTest();

        // Verifying result
        System.assertNotEquals(null, result, 'The livraison should not be null');
        System.assertEquals(testLivraison.Id, result.Id, 'The livraison IDs should match');
        System.assertEquals('123 Test Street', result.Adresse__c, 'The Adresse__c should match');
        System.assertEquals('Test Country', result.Pays__c, 'The Pays__c should match');
    }

    @isTest
    static void testFindLivraisonFieldAccess() {
        // Test scenario where field access is restricted
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Test.startTest();
            try {
                OrderService.findLivraison('001000000000000');
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
}
