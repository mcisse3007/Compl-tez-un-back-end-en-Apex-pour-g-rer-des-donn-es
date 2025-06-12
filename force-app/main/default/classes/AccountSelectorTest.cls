@isTest
public class AccountSelectorTest {

    @isTest
    static void testGetAccountByIdSuccess() {
        // Création d'un compte fictif pour le test
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

        // Appel à la méthode pour vérifier si elle renvoie le bon résultat
        Test.startTest();
        Account result = AccountSelector.getAccountById(testAccount.Id);
        Test.stopTest();

        // Vérification des valeurs
        System.assertNotEquals(null, result, 'Le compte ne doit pas être null');
        System.assertEquals(testAccount.Id, result.Id, 'Les Id doivent être identiques');
        System.assertEquals('Test Account', result.Name, 'Le nom du compte doit correspondre');
        System.assertEquals('Particulier', result.TypeClient__c, 'Le TypeClient__c doit correspondre');
    }

}
