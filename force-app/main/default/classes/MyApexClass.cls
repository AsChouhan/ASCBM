public class MyApexClass {
    @InvocableMethod(label='Process Wrappers')
    public static void processWrappers(List<List<MyApexWrapper>> wrappers) { 
        // Perform your logic using the wrapper objects  
        // You can iterate over the list and access the wrapper properties
        /*for (MyApexWrapper wrapper : wrappers) {
            String property1 = wrapper.property1;
            Integer property2 = wrapper.property2;
            // Process the wrapper data
        }*/
    }
}