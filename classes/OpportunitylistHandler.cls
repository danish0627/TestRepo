public class OpportunitylistHandler {
    public static void onafterinsert(list <opportunity> oplist){
        list <opportunityLineItem> olilist = new list<opportunityLineItem>();
        list <PricebookEntry> priceBookList = [SELECT Id,Product2.Id,Product2.Name from PricebookEntry where PriceBook2.isStandard=true LIMIT 1];
        for(opportunity opp:oplist){
            opportunityLineItem oli = new opportunityLineItem();
            oli.Id= opp.Id;
            oli.PricebookEntryId = priceBookList[0].Id;
            olilist.add(oli);
        }
        if(olilist!=null && olilist.size()>0)
        insert olilist;
    }
}