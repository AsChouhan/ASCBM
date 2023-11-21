public class tryAPEX {
   public static void creatAccount(){
        try{
            List<Contact> ct = [select name from contact limit 1];
           	ct[0].lastName = '';
            update ct;
        }catch(DmlException  e){
            system.debug('\nThe job failed for record ' + e.getDmlId(0));
            
          
        }
    }
   
}