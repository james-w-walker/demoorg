trigger OpportunityTrigger on Opportunity (after update) {

    // Exercise 1
	// Write a trigger to keep the Bill to and Ship to address fields on Quotes in sync with the Opportunity
	// You will need to replicate the Quote BT/ST Fields on the Opportunity.
	// This means changes on the Opp should push to all the Quote, and if the Quote is primary, changes on the Quote should push to the Opp.

    If(Trigger.isAfter && Trigger.isUpdate)  {
            OpportunityTriggerHandler.HandleAfterUpdate(Trigger.new);
    }
 
}