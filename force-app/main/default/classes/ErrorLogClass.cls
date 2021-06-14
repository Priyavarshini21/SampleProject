public class ErrorLogClass {

	public class ErrorInput {
        @InvocableVariable(required=true)
        public String ErrorMessage;
      }
    @InvocableMethod(label='Get Error Message')
    public static List<ErrorInput> getOrderStatus(List<ErrorInput> orderInputs) {
      return null;  
    }
}