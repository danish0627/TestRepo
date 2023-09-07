/**
* Project:     Informa Markets
* Date:        April, 13 2023
* Created By:  Danish
* Test Class:  updateDateOnQuoteLineBatch_Test(100%)
* *************************************************************************
* @description This Batch class update the start date & end date on quoteline asociated with event edition products.
* *************************************************************************
*/

public class updateDateOnQuoteLineBatch implements Database.Batchable<sObject>, Database.Stateful {
    private Date startDate;
    private Date endDate;
    private Set<Id> ProductsId;
    List<Database.SaveResult> updateResults = new List<Database.SaveResult>();
    public updateDateOnQuoteLineBatch(Set<Id>ProdIds,Date newStartDate,Date newEndDate){
        startDate = newStartDate;
        endDate = newEndDate;
        ProductsId = ProdIds; 
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id>QuoteIds = new Set<Id>();
        List<SBQQ__QuoteLine__c> qryResult = [SELECT Id,SBQQ__Quote__c,Start_Date__c,End_Date__c,SBQQ__Product__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Product__c IN:ProductsId AND SBQQ__Quote__r.SBQQ__Opportunity2__r.StageName!='Closed Lost' AND MDQ_Product__c=false AND SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__Ordered__c=false AND(Start_Date__c!=:startDate OR End_Date__c!=:endDate)];
        for(SBQQ__QuoteLine__c q:qryResult){
          QuoteIds.add(q.SBQQ__Quote__c);  
        }
        return Database.getQueryLocator([SELECT Id FROM SBQQ__Quote__c WHERE Id IN:QuoteIds]);
    }  
    public void execute(Database.BatchableContext BC,List<SBQQ__Quote__c> QuoteList){
    List<SBQQ__QuoteLine__c>finalList = new List<SBQQ__QuoteLine__c>();
        Set<Id>quoteIdSet = new Set<Id>();
            for(SBQQ__Quote__c qtlst :QuoteList){
               quoteIdSet.add(qtlst.Id) ; 
            }
           List<SBQQ__QuoteLine__c>listQuoteLine = [SELECT Id,SBQQ__Quote__c,Start_Date__c,End_Date__c,SBQQ__Product__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Product__c IN:ProductsId AND SBQQ__Quote__c IN:quoteIdSet AND SBQQ__Quote__r.SBQQ__Opportunity2__r.StageName!='Closed Lost' AND MDQ_Product__c=false AND SBQQ__Quote__r.SBQQ__Opportunity2__r.SBQQ__Ordered__c=false AND(Start_Date__c!=:startDate OR End_Date__c!=:endDate)];
           for(SBQQ__QuoteLine__c quoteLine : listQuoteLine){
            quoteLine.Start_Date__c = startDate; 
            quoteLine.End_Date__c = endDate;  
            finalList.add(quoteLine); 
        }
        
        if(!finalList.isEmpty()){  
         updateResults = database.update(finalList,false); 
          // Insert the error into the error log if any record are Failure at the time of updation
            List<Error_Log__c>ErrorList = new List<Error_Log__c>();
                for(Integer i=0;i<updateResults.size();i++){ 
                    if(!updateResults.get(i).isSuccess()){  
                       Error_Log__c err = new Error_Log__c(); 
                        err.Source_Name__c='updateDateOnQuoteLineBatch';
                        err.Description__c='Event start and end date update and related quote line update - '+JSON.serialize(updateResults.get(i).getErrors());
                        err.Affected_Object__c = 'Quote Line';
                        err.Affected_Object_Details__c='Failed Quote Line id is' +finalList.get(i).Id;
                        ErrorList.add(err);     
                    } } 
                     if(!ErrorList.isEmpty()){
                       insert ErrorList; 
                  }            
        } 
        
    }
    public void finish(Database.BatchableContext BC){
     //Passing Parameter to updateDateOnQuoteLineBatchWitoutInvoice 
     updateDateOnQuoteLineBatchWitoutInvoice updatequotLine = new updateDateOnQuoteLineBatchWitoutInvoice(ProductsId,startDate,endDate); 
     database.executeBatch(updatequotLine,1); 
   //Passing Parameter to updateDateOnInvoiceLineBatch 
      updateDateOnInvoiceLineBatch invoiceLineBatch = new updateDateOnInvoiceLineBatch(ProductsId,startDate,endDate);
      database.executeBatch(invoiceLineBatch, 1);    
    }
  
}