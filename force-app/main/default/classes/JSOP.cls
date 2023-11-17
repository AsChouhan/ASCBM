public class JSOP {
    @AuraEnabled @InvocableVariable
    public String ste;
    @AuraEnabled @InvocableVariable
    public List<FileFolderwrapper> entries ;
    
    public class FileFolderwrapper{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String type;
        
        public FileFolderwrapper(String id, String name, String type ){
            this.id = id;
            this.name = name;
            this.type = type;
        }
        
   }
}