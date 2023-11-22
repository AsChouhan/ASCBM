public class AutoSchedualTesting2 {
    public static void TestError(){
        try{
            User ur = new User(FirstName = 'as singh');
            insert ur;
        }catch(System.Exception ex){
            System.debug(ex.getMessage());
        }   
    }
}