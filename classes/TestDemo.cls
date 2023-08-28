@isTest
public class TestDemo {
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
}