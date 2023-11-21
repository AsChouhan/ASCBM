public class Choice{

    @AuraEnabled
    public String label;
 
    @AuraEnabled
    public String value;
    
    public Choice(
            String label,
            String value
    ) {
        this.label = label;
        this.value = value;
    }
}