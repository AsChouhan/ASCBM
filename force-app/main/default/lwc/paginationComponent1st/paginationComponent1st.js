import { LightningElement, track } from 'lwc';
import getObjects from '@salesforce/apex/PaginationController.getAllObject';
import getAllfields from '@salesforce/apex/PaginationController.getAllfields';

export default class PaginationComponent1st extends LightningElement {
    @track _selected = [];
    value = '';
    @track options = [];
    @track optionsfields = [];

    connectedCallback(){
        getObjects()
        .then(result => {
            this.options = result;
            console.log(result);
        })
        .catch(error => {
            this.error = error;
        });
    }

    handleChange(event) {
        this.value = event.detail.value;
        console.log('value is >>',this.value);
        getAllfields({objectName : this.value}).then(result=>{
            console.log('fields>>>',result);
            this.optionsfields = result;
            
        })
        .catch(error => {
            this.error = error;
        })
    }
    handleChange1(event) {
        this._selected = event.detail.value;
        console.log('selected vallue>>>>',JSON.stringify(this._selected));
    }


}