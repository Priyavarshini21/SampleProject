import { LightningElement,track , api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const options = [
    { label: 'USD', value: 'USD' },
    { label: 'EUR', value: 'EUR' },
    { label: 'CAD', value: 'CAD' },
    { label: 'GBP', value: 'GBP' },
    { label: 'INR', value: 'INR' }];
export default class CallOutFromLwc extends LightningElement {
  
    @track fromCurrencyValue;
    @track toCurrencyValue;
    @track options = options;
    @track toCurrencyOptions = options;
    @track conversionData;
    @api isLoading=false; 


    handleFromCurrencyChange(event) {
        this.fromCurrencyValue = event.detail.value;
    }

    handleToCurrencyChange(event) {
        this.toCurrencyValue = event.detail.value;
    }

    handleCurrencyConversion() {
        this.isLoading = true;
        if(this.fromCurrencyValue != null && this.toCurrencyValue != null){
            fetch('https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency='+
             this.fromCurrencyValue + '&to_currency=' + this.toCurrencyValue + '&apikey=VPZBIF319Q2G9LYP', // End point URL
            {
                method:"GET",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": "OAuth 00DB0000000EfVQ!AQwAQEiiynMU2EsBcS2PhXSQ6KQTTG.Zr0hlDHTFcGcAPqKQOBNDB0rwyASZK44fqIAVe6GrVNZPsAWJ6iqXLNBfSQ.dqvW1",
                }
            })
            .then((response) => {
                return response.json();
            })
            .then((jsonResponse) => {
                this.isLoading = false;
                let objData = {
                    Exchange_Rate : '',
                };
                let exchangeData = jsonResponse['Realtime Currency Exchange Rate'];
                objData.Exchange_Rate = exchangeData['5. Exchange Rate'];

                this.conversionData = objData;
            })
            .catch(error => {
                this.isLoading = false;
                showToast(this,JSON.stringify(error), 'Error', 'Error');  
                console.log('callout error ===> '+JSON.stringify(error));
               
            })
        }
        else{
            this.isLoading = false;
            showToast(this,'Please select currency type and try again', 'Info', 'Info');  
        }
    } 


}
export function showToast(cmp, message, title, variant, mode) {
    if(mode !== undefined){
      const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: mode
      });
      cmp.dispatchEvent(event);
    }else{
      const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
      });
      cmp.dispatchEvent(event);
    }
  }