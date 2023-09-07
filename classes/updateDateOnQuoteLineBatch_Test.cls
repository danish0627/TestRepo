@isTest
private class updateDateOnQuoteLineBatch_Test {
    @isTest
      static void testMethod1() {   
       Account acct = new Account(Name = 'testAccount', CurrencyIsoCode = 'EUR', BillingCountry = 'USA', BillingStreet = 'New York"', BillingCity = 'New York"');
        insert acct; 
        Pricebook2 pb = new Pricebook2(Name = 'TestPricebook');
        insert pb;
        Event_Edition__c ee = new Event_Edition__c();
        ee.Name = 'TestEvent';
        ee.Tab1__c = 'tab1';
        ee.Tab4__c = 'tab4';
        ee.Tab7__c = 'tab7';
        ee.Tab8__c = 'Tab8__c';
        ee.Show_Deliverables__c = true;
        ee.Payment_Schedule__c = '25-25-25-25';
        ee.End_Date__c= date.today();
        ee.Start_Date__c = date.today();
        ee.Event_Code__c ='BRA20FRM';
        ee.X50_Cutoff_Date__c = date.today();
        ee.Cutoff_Date_1__c = date.today().addDays(1);
        ee.Cutoff_Date_2__c = date.today().addDays(2);
        ee.Cutoff_Date_3__c = date.today().addDays(3);
        ee.Event_Price_Book__c = pb.Id;
        insert ee;

        Opportunity oppty = new Opportunity(Name = 'testOpp');
        oppty.AccountId = acct.Id;
        oppty.StageName = 'Customize'; 
        oppty.CloseDate = date.today();
        oppty.EventEdition__c = ee.Id;
        oppty.Is_Barter_Opportunity__c = true;
        oppty.Type = 'New';
        insert oppty;  
        
      Product2 prodObj = new Product2(Name = 'testProd');
        insert prodObj;
        SBQQ__Quote__c qtObj = new SBQQ__Quote__c();
        qtObj.SBQQ__Account__c = acct.Id;
        qtObj.SBQQ__Status__c = 'Draft';
        qtObj.SBQQ__Type__c = 'Quote';
        qtObj.SBQQ__StartDate__c = date.today();
        qtObj.Alternate_Currency2__c = 'EUR';
        qtObj.SBQQ__Opportunity2__c = oppty.Id;
        qtObj.Quote_Line_Deliverables__c = 'testing';
        qtObj.SBQQ__Primary__c = true;
        qtObj.Manual__c = false;
        qtobj.IsNotGeneralDocument__c = true;
        insert qtObj;
        SBQQ__QuoteLine__c qlObj = new SBQQ__QuoteLine__c();
        qlObj.SBQQ__Quote__c = qtObj.Id;
        qlObj.SBQQ__Product__c = prodObj.Id;
        qlObj.Start_Date__c = System.today();
        qlObj.End_Date__c = System.today();
        qlObj.MDQ_Product__c = false;
        insert qlObj;
       
        Error_Log__c err = new Error_Log__c();
                        err.Source_Name__c='ProductsOnEventEdition.fetchRelatedProduct()';
                        err.Description__c='Event start and end date update and related product update -';
                        err.Affected_Object__c = 'Product2';
                        err.Affected_Object_Details__c='Event id is';
                   insert err;
          
      Set<Id>ProdIds = new Set<Id>();
      ProdIds.add(prodObj.Id); 
       Test.startTest();
       updateDateOnQuoteLineBatch ub1 = new updateDateOnQuoteLineBatch(ProdIds,System.today(),System.today());
       database.executeBatch(ub1);
        List<SBQQ__QuoteLine__c>qLine = [SELECT Id,Start_Date__c,End_Date__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Product__c IN :ProdIds];
        system.assert(qLine[0].Start_Date__c==system.today() &&qLine[0].End_Date__c==system.today(), 'QuoteLine is Update sucessfully');
        updateDateOnQuoteLineBatch ub = new updateDateOnQuoteLineBatch(ProdIds,system.today().addDays(10),system.today());
        database.executeBatch(ub);
        Test.stopTest(); 
    }  
}