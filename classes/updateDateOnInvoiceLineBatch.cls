/**
* Project:     Informa Markets
* Date:        April, 25 2023
* Created By:  Danish
* Test Class:  updateDateOnInvoiceLineBatch_Test(100%)
* *************************************************************************
* @description This Batch class update Invoice Line
* *************************************************************************
*/
public class updateDateOnInvoiceLineBatch implements Database.Batchable<sObject>, Database.Stateful {
    private Date event_sd;
    private Date event_ed;
    private set<Id>ProdIdSet;
    public updateDateOnInvoiceLineBatch(Set<Id>ProdIds,Date newStartDate,Date newEndDate){
      event_sd = newStartDate;
       event_ed = newEndDate;
       ProdIdSet = ProdIds;   
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id FROM blng__InvoiceLine__c WHERE blng__Product__c IN:ProdIdSet AND MDQ_Product__c = false AND blng__Invoice__r.blng__InvoiceStatus__c='Draft' AND blng__Invoice__r.blng__Order__r.Opportunity.StageName!='Closed Lost' AND (Service_Start_Date__c!=:event_sd OR Service_End_Date__c!=:event_ed)]);
    }
    public void execute(Database.BatchableContext BC,List<blng__InvoiceLine__c> InvoiceLine){
     List<blng__InvoiceLine__c>finalList = new List<blng__InvoiceLine__c>();
        for(blng__InvoiceLine__c invoiceList:InvoiceLine){
          invoiceList.Id = invoiceList.Id;
          finalList.add(invoiceList);  
        } 
        if(!finalList.isEmpty()){
         update finalList; 
        }
        
    }
    public void finish(Database.BatchableContext BC){
     system.debug('Invoice Line is updated..');   
    }

}