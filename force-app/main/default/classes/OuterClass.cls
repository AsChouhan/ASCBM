public class OuterClass {
    @AuraEnabled @InvocableVariable(required = true)
    public List<InnerClass> innerClassList;
    public OuterClass() {}

    public class InnerClass {
        @InvocableVariable // missing
        public Integer var1;
        @InvocableVariable // missing
        public String var2;
    
        public InnerClass() {
            this.var1= 1;

        }
    }  
}