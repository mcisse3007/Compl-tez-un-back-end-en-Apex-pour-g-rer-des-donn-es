
trigger OpportunityCloseWonToOrderTrigger on Opportunity(before  update) 
{
    for (Opportunity opp : Trigger.new) {
     // Vérifier si l'opportunité est passée en Close Won
     if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won')
      {       
        OpportunityTriggerHandler.handleOpportunity(opp);
     }
     else {
         System.debug('L\'opportunité ' + opp.Name + ' est passée à Autre etape');
     }
    
    }
}