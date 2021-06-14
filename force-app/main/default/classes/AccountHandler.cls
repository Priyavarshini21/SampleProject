public with sharing class AccountHandler {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(){
       return [SELECT Id, Name, Phone FROM Account];
   }
}