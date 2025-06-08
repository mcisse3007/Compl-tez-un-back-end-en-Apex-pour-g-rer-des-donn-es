public with sharing class OpportunityTriggerHandler {

    public static void handleOpportunity(Opportunity opp) {

            Account acc = AccountSelector.getAccountById(opp.AccountId);

            Integer productCount=  OpportunityLineItemSelector.getNumberOfProduct(opp.Id);

            OrderService.validateOrderCreation(acc.TypeClient__c, productCount);

            List<OpportunityLineItem> linesItem = OpportunityLineItemSelector.getLineItems(opp.Id);

            Contract contract = new Contract(
                AccountId = opp.AccountId,
                Status = 'Draft',
                StartDate = System.today(),
                ContractTerm = 12
            );

            insert contract;

             Order newOrder = new Order(
                AccountId = opp.AccountId,  // Associer l'Order à l'Account
                OpportunityId  = opp.Id,    // Associer l'Order à l'Opportunity
                Status = 'Draft',
                ContractId = contract.Id,
                Type = 'New',
                Pays__c = acc.ShippingState,
                EffectiveDate=System.today(),
                ShippingStreet = acc.ShippingStreet,
                ShippingCity = acc.ShippingCity,
                ShippingState = acc.ShippingState,
                ShippingPostalCode = acc.ShippingPostalCode,
                ShippingCountry = acc.ShippingCountry,
                Pricebook2Id = opp.Pricebook2Id
            );
            insert newOrder;


            for(OpportunityLineItem item: linesItem){
                OrderItem orderItem = new OrderItem(
                    Product2Id= item.Product2Id,
                    OrderId=newOrder.Id,
                    Quantity=item.Quantity,
                    UnitPrice=item.UnitPrice,
                    ListPrice=item.UnitPrice,
                    PricebookEntryId=item.PricebookEntryId
                );
                insert orderItem;
            }

            Livraison__c livraison = new Livraison__c (
                Order__c = newOrder.Id,
                Adresse__c = acc.ShippingStreet + ' ' + acc.ShippingCity + '' + acc.ShippingState + ' ' + acc.ShippingPostalCode + ' ' + acc.ShippingCountry,
                Pays__c = acc.ShippingState,
                CodePostal__c = acc.ShippingPostalCode
            );
            insert livraison;


    }
}