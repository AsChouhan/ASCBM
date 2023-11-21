public class zzzzz {
    public Integer a1;
    public Integer a2;
	public Integer a3;
	public String name;    
    
    public zzzzz(Integer a1, Integer a2, Integer a3, String name){
		this.a1 = a1;
        this.a2 = a2;
        this.a3 = a3;
        this.name = name;
    }
    
    public void printName(){
		SYstem.debug(this.name);
    }
    
    public static void PN(){
        SYstem.debug('harsh');
    }
}