import { LightningElement,api,track } from 'lwc';
import getAllOppty from "@salesforce/apex/FetchOpportunity.getAllOppty";

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Opportunity Id', fieldName: 'Id' },
    { label: 'Account Name', fieldName: 'Account'},
    { label: 'AccountId', fieldName: 'AccountId' },
    { label: 'Amount', fieldName: 'Amount'},
    { label: 'Type', fieldName: 'Type'},
    { label: 'LeadSource', fieldName: 'LeadSource'},
];

export default class DisplayOpprtunityList extends LightningElement {
@api opptyList=[];
columns = columns;
connectedCallback(){
    getAllOppty({})
    .then(result => {
        this.opptyList = result;
        console.log('Oppty List => '+ JSON.stringify(this.opptyList));
    })
    .catch(error => 
        {
            console.log('Error => '+ error);
        })
}
}