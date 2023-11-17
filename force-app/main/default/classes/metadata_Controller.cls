public class metadata_Controller {
    
    //Wrapper for store metadata object xmlName.
    public class MetadataObjectWrapper{
        String label;
        String value;

        
        public MetadataObjectWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
    
    //Method for retreve all metadata objects.
    public static void describeMetaData(Double version){
        MetadataFactory.MetadataOutlet mo=	MetadataFactoryUtil.getPort();
        MetadataFactory.DescribeMetadataResult result = mo.describeMetadata(version);
        for(MetadataFactory.DescribeMetadataObject MD : result.metadataObjects){
            System.debug(MD.xmlName);
        }
        
    }
}