public class CustomHomePage {
    @AuraEnabled
    public static user getInfo(){
        Id userId = userinfo.getUserId();
        User userDetails =[SELECT Id, Name, Email,fullphotourl FROM User where Id=:userId ];
       // system.debug('Profile Name:' + userDetails.Email);
        return userDetails;
    }
}