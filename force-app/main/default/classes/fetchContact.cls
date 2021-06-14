public  class fetchContact {
      Contact contact1;
    public fetchContact(){
        Id id= ApexPages.currentPage().getParameters().get('id');
        if(id==null){
            contact1=new Contact();
        }
        else{
           contact1 = [Select Id,FirstName,LastName,Phone,Email FROM Contact where Id =:id ];
        }
    }
               public  Contact getContact(){
                return contact1;
    }
    public PageReference save(){
  try {
      contact1.id=ApexPages.currentPage().getParameters().get('id');
       upsert(contact1)  ;
     }
        catch(System.DMLException e) {
         ApexPages.addMessages(e);
         return null;
        }
        PageReference view = new ApexPages.StandardController(contact1).view();
         return (view);
    }
}