trigger OrderTrigger on Order (before update) {

    for (Order order : Trigger.new) {
        if(order.Status == 'Activated' && order.Status != Trigger.oldMap.get(order.Id).Status) {
            OrderTriggerHandler.handleOrder(order);
            
        }

    }

}