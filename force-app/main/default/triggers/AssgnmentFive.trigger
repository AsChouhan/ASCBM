trigger AssgnmentFive on Opportunity (before insert, After update,After insert) {	
    Hot.mainMethod(trigger.new);
}