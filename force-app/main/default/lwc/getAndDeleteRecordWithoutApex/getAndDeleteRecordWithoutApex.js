import { LightningElement,wire, api, track} from 'lwc';
import { getRecord,deleteRecord } from 'lightning/uiRecordApi';
import Account_Name from '@salesforce/schema/Account.Name';
import Account_INDUSTRY from '@salesforce/schema/Account.Industry';
import Account_PHONE from '@salesforce/schema/Account.Phone';
import Account_OWNER from '@salesforce/schema/Account.Owner.Name';

const FIELDS = [Account_Name, Account_INDUSTRY, Account_PHONE, Account_OWNER];

export default class GetAndDeleteRecordWithoutApex extends LightningElement {
    @api recordId;
    @track AccountDetails;
    @track accountName;
    @track industry;
    @track phone;
    @track owner;
    @track accountid;
    @track showComp = false;

    @wire(getRecord,{ recordId : '$recordId' , fields:FIELDS})
    wireAccount({error,data}){
        if(error){
            alert(console.log(error));
        }
        else if (data){
            this.showComp = true;
            this.AccountDetails = data;
            console.log('records',this.AccountDetails);
            this.accountid = this.AccountDetails.id;
            this.accountName = this.AccountDetails.fields.Name.value;
            this.industry = this.AccountDetails.fields.Industry.value;
            this.phone = this.AccountDetails.fields.Phone.value;
            this.owner = this.AccountDetails.fields.Owner.displayValue;

        }
    }

    deleteAccount(){
        console.log('delete');
        deleteRecord(this.accountid)
            .then(result=>{
               window.alert("Record Deleted"); 
            })
            .catch(error=>{
                console.error("error",error);
            })
    }
}