import { LightningElement,api, wire ,track } from 'lwc';
import getRecords from '@salesforce/apex/MultiSelect_Combobox.getRecords';
export default class Child_MultiSelectCombobox extends LightningElement {
   @api object;
   @api toggle;
   @track searchString;
   @track Count=0;
   @track label='Selected Option is :-';
   @api myName = 'one';
   @track listOfPiclistRecord = [];
   @track allValues = [];

    @wire(getRecords, {selectedObjectName: '$object' , })
    WireResult({ data, error }) {
        if (data) {
            this.listOfPiclistRecord = data.map(item => ({ label: item.Name, value: item.Name, }));
            console.log('data', data);
        } else if (error) {
            console.error(error);
        }
    }

    getPiclistObjectRecords(event){
        if(this.toggle == true){
            this.allValues.push(event.target.value);
            this.Count++;
            }
        console.log(this.Count);
    }
    
    handleRemove(event){
        const valueRemoved = event.target.name;
        this.allValues.splice(this.allValues.indexOf(valueRemoved),1);
        this.Count--;
        console.log(this.Count);
    }
}