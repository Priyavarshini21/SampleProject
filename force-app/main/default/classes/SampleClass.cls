public with sharing class SampleClass {

    @AuraEnabled
    public static Id m_Insert_A_Contact_Record(String a_First_Name, String a_Last_Name, String a_Email){
    
        try{
            Contact a_Rec = new Contact();

            a_Rec.FirstName = a_First_Name;
            a_Rec.LastName = a_Last_Name;
            a_Rec.Email = a_Email;
          

            Insert a_Rec;
            return a_Rec.Id;
            }
            catch(Exception ex){
                            System.debug('An Exception: '+ex);
                            return null;
        }
    }
}