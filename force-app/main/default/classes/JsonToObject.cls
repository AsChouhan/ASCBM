public class JsonToObject {
    @AuraEnabled
    public List<apexDefinedDataType> entries;
	@AuraEnabled
	public Integer limit1;	    //1000
	@AuraEnabled
	public Integer offset;	    //2000
	@AuraEnabled
	public List<order> order;
	@AuraEnabled
	public Integer total_count;	    //5000
    
}