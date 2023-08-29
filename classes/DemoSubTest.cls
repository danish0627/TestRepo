@isTest
public class DemoSubTest {
	    public static testmethod void testsub(){
        integer a;
        integer b;
        integer c;
        
        Demo_Subs sb=new Demo_Subs();
        sb.a = 20;
        sb.b = 10;
        
        integer res=sb.subt();
        system.assertEquals(10,res);
    }
}