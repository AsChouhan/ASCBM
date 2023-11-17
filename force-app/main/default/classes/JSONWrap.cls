public class JSONWrap {
 @AuraEnabled
	public entries[] entries;
	//public Integer limit;	//1000
	 @AuraEnabled
	public Integer offset;	//2000
     @AuraEnabled
	public order[] order;
     @AuraEnabled
	public Integer total_count;	//5000
	class entries {
		public String id;	//12345
		public String etag;	//1
	//	public String type;	//file
		public String sequence_id;	//3
		public String name;	//Contract.pdf
		public String sha1;	//85136C79CBF9FE36BB9D05D0639C70C265C18D37
		public file_version file_version;
	}
	class file_version {
		public String id;	//12345
		//public String type;	//file_version
		public String sha1;	//134b65991ed521fcfe4724b7d814ab8ded5185dc
	}
	class order {
	//	public String by;	//type
		public String direction;	//ASC
	}
}