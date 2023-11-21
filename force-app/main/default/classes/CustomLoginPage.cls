public class CustomLoginPage {
  @AuraEnabled
    public static String login(String userName, String password, String startUrl){
        System.debug('hii apex');
        try{
            ApexPages.pageReference lgn = site.login(userName,password,startUrl);
            aura.redirect(lgn);
            return 'success';
        }catch(Exception e){
            System.debug(e.getMessage());
            return e.getMessage();
        }
    }
}