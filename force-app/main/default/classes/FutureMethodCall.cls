public with sharing class FutureMethodCall {

    public FutureMethodCall(){
        System.debug('i am constructore');
        method1();
        method2();
        method3();
    }
    @future
   public static void method1(){
    System.debug('i am method1');
    
   }
   @Future 
   public static void method2(){
    System.debug('i am method2 future method');
    FutureTestOtherClass.othermethod();
       method1();
   }
   public void method3(){
    System.debug('i am method3');
   }
}