public class Assi5 {
    public static void myMethod(List<opportunity> l){
        for(opportunity o:l){
            if(o.StageName =='closed-won'){
                o.Account.Rating='Hot';
            }
        }
    }

}