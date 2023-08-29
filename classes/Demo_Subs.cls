public class Demo_Subs {
    public integer a;
    public integer b;
    public integer c;
    
    public integer subt(){
        c=a-b; 
        system.debug('the result is'+c);
        return c;
    }
    
    public Integer divt(){
        c=a/b;
        system.debug('the result is'+c);
        return c;
    }   
    
}