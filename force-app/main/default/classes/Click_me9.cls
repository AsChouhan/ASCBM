public class Click_me9 {
    public integer num=10; 
    public List<Integer> firstList;
    public List<Integer> SecondList;
    public List<Integer> thList;
    
    public List<Integer> getOne(){
        if(firstList==null){
            firstList=new Integer[10];
        }
        for(Integer i=1;i<=num;i++){
            FirstList.add(i);
        }
        return firstList;
    }
    public void Click(){
        if(SecondList==null){
            SecondList=new Integer[10];
        }
        for(Integer i=1;i<=num;i++){
            integer m=10*(i+1);
            SecondList.add(m);
        }
    }
}