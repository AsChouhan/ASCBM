import { LightningElement } from 'lwc';
import nameField from '@salesforce/schema/Account.Name';

export default class TestLWC extends LightningElement {
    objectApiName = 'Account';
    recordId = '0015g00001RuDxbAAF';
    successHandler(Event){
        this.dispatchEvent()
    }
}