import { LightningElement,track,api } from 'lwc';
import callgetContact from "@salesforce/apex/MyFirstRestApiCallout.callgetContact";
 

const columns = [
    { label: 'Name', fieldName: 'LastName' },
    { label: 'Email', fieldName: 'Email' },
    { label: 'Department', fieldName: 'Department'},
    { label: 'External Id',fieldName: 'External_Id__c'}
];

export default class ApiLwcForContactDisplay extends LightningElement {
    columns = columns;
    @track conList = [];
    @track departmentType = '';
    @track showContactList = false;
    connectedCallback(){}
       /* callgetContact()
        .then(result =>{  
            this.conList = result;
        })
        .catch(error => {
            console.log('Errpr => '+JSON.stringify(error));
        })
    }*/
    inputChangeHandler(event){
        this.departmentType = event.detail.value;
    }
    getContactDetails(){
        if(this.departmentType != null){
           
            callgetContact({
                department : this.departmentType
            })
            .then(result =>{  
                this.showContactList = true;
                this.conList = result;
            })
            .catch(error => {
                console.log('Errpr => '+JSON.stringify(error));
            })
        }
        else{
            showToast(this,'Please enter department name and try again');
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