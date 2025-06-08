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
        System.assertEquals('Commercial', result.TypeClient__c, 'Le TypeClient__c doit correspondre');
    }

    @isTest
    static void testGetAccountByIdNoFieldAccess() {
        // Préparer un appel pour simuler l'absence d'accès au champ Id
        // Fake l'absence d'accès pour empêcher une requête correcte
        System.runAs(new User(Id = UserInfo.getUserId())) {
            // Supposons que ce profil n'a pas accès au champ en modifiant la validation manuelle (Peut requérir un mock)

            Test.startTest();
            try {
                AccountSelector.getAccountById('001000000000000AAA');
                System.assert(false, 'Une exception aurait dû être levée en raison de l\'absence d\'accès au champ');
            } catch (AuraHandledException e) {
                System.assertEquals(
                    'vous ne pouvez pas faire cette action',
                    e.getMessage(),
                    'Le message d\'erreur ne correspond pas'
                );
            }
            Test.stopTest();
        }
    }
}
