import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import Account_Object from '@salesforce/schema/Account';
import Name_Field from '@salesforce/schema/Account.Name';
export default class CreateRecordWithoutApex extends LightningElement {
    accountId;
    name='';
    handleNameChange(event){
        this.name = event.target.value;
    }
    hendleCreateAccount(event){
        const fields = {};
        fields[Name_Field.fieldApiName] = this.name;

        const recordInput = { apiName:Account_Object.objectApiName,fields};
        createRecord(recordInput)
        .then(result=>{
            this.accountId = result.id;
        })
    }
}