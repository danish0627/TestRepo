@istest
public class DemoTest
{
    public static testmethod void testadd(){
        integer a;
        integer b;
        integer c;
        
        Demo_Add ad=new Demo_Add();
        ad.a = 10;
        ad.b = 20;
        
        integer res=ad.addt();
        system.assertEquals(30,res);
    }
    
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
    
    public static testmethod void testdiv(){
        integer a;
        integer b;
        integer c;
        
        Demo_Subs dv=new Demo_Subs();
        dv.a = 20;
        dv.b = 10;
        
        integer res=dv.divt();
        system.assertEquals(2,res);
    }
    

}