import { LightningElement, api, track } from 'lwc';
   
// Currency options
const options = [
    { label: 'USD', value: 'USD' },
    { label: 'EUR', value: 'EUR' },
    { label: 'CAD', value: 'CAD' },
    { label: 'GBP', value: 'GBP' },
    { label: 'INR', value: 'INR' }];
export default class RestApiUsingLwc extends LightningElement {
    //accesstoken = '';
   // clientId = '3MVG9fe4g9fhX0E7__Z7wPOyivBiCmytOKNuMLjgOtm8EVZ2c7fgy4cx8r4vZMaZ72LzO6vn0n4NARcExRiGb';
    //clientSecret = 'CF99FEB9E71E670D401112DDD48B51B9D2818712B409B11950DEAD63FE3F094C';
    //username = 'priyavarshini.d@mindful-fox-hxfqee.com';
    //password = '1001percentagesec';
   // serviceToken = 'viFbNvFyWp5nFlPruCIdU9e1';
  /*  repos =[];
    connectedCallback(){
        fetch('https://api.github.com/repositories?since=364',
		{
			method : "GET"
        
		}).then(response =>{
            console.log('Response => '+JSON.stringify(response));
            this.repos = response;
			return response.json();
		})
		.catch(e=>console.log(e));
	}*/


//export default class HTTPCalloutInLWC extends LightningElement {
    @track fromCurrencyValue;
    @track toCurrencyValue;
    @track options = options;
    @track toCurrencyOptions = options;
    @track conversionData;
    
    // Getting Base currency value
    handleFromCurrencyChange(event) {
        this.fromCurrencyValue = event.detail.value;
    }

    // getting exchange currency value
    handleToCurrencyChange(event) {
        this.toCurrencyValue = event.detail.value;
    }


    // Making Callout using Fetch
    handleCurrencyConversion() {
        fetch('https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=' 
                    + this.fromCurrencyValue + '&to_currency=' + this.toCurrencyValue + '&apikey=VPZBIF319Q2G9LYP', // End point URL
        {
            // Request type
            method:"GET",
            
            headers:{
                // content type
                "Content-Type": "application/json",
                // adding your access token 
                "Authorization": "OAuth 00DB0000000EfVQ!AQwAQEiiynMU2EsBcS2PhXSQ6KQTTG.Zr0hlDHTFcGcAPqKQOBNDB0rwyASZK44fqIAVe6GrVNZPsAWJ6iqXLNBfSQ.dqvW1",
            }
        })
        .then((response) => {
            return response.json(); // returning the response in the form of JSON
        })
        .then((jsonResponse) => {

            let objData = {
                From_Currency_Name : '',
                From_Currency_Code : '',
                To_Currency_Name : '',
                To_Currency_Code : '',
                Exchange_Rate : '',
                Last_Refersed : '',
            };

            window.console.log('jsonResponse ===> '+JSON.stringify(jsonResponse));
            // retriving the response data
            let exchangeData = jsonResponse['Realtime Currency Exchange Rate'];

            // adding data object
            objData.From_Currency_Code = exchangeData['1. From_Currency Code'];
            objData.From_Currency_Name = exchangeData['2. From_Currency Name'];
            objData.To_Currency_Code = exchangeData['3. To_Currency Code'];
            objData.To_Currency_Name = exchangeData['4. To_Currency Name'];
            objData.Exchange_Rate = exchangeData['5. Exchange Rate'];
            objData.Last_Refershed = exchangeData['6. Last Refreshed'];

            // adding data object to show in UI
            this.conversionData = objData;
        })
        .catch(error => {
            window.console.log('callout error ===> '+JSON.stringify(error));
        })
    } 

}