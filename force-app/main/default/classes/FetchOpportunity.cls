public class FetchOpportunity {
    @AuraEnabled
    public static List<Opportunity> getAllOppty(){
        List<Opportunity> opptyList = [SELECT Id,Name,Account.Name,AccountId,Type,LeadSource,Amount FROM Opportunity];
        system.debug('List =>'+opptyList);
        return opptyList;
    }

}