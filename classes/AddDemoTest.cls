@isTest
public class AddDemoTest {
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
}