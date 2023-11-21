public class INvocableApex {
    @InvocableMethod
    public static void getData(List<List<fileVersion>> files){
        for(List<fileVersion> ls : files){
            for(fileVersion fs: ls){
                System.debug(fs.name);
			}            
        }
        System.debug('invocable called');
    }  
}