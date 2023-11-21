public class ss11a extends tryJs {
    public override void write(){
        System.debug('called by exnted class');
    }
    {
        tryJs tj = new tryJs();
        tj.write();
        this.write();
    }
}