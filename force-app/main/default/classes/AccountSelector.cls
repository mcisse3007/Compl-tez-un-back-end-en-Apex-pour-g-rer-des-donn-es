public with sharing class AccountSelector {

    public static Account getAccountById(ID accountId) {
        if (!Schema.sObjectType.Account.fields.Id.isAccessible()) {
            throw new AuraHandledException('vous ne pouvez pas faire cette action');
        }
        return [
                SELECT Id, Name, TypeClient__c , 
                    ShippingStreet,
                    ShippingCity,
                    ShippingState,
                    ShippingCountry,
                    ShippingPostalCode
                    FROM Account
                WHERE Id = :accountId
                LIMIT 1
        ];

    }
}