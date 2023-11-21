import { LightningElement, api, wire } from 'lwc';
import CreateDeepClone from '@salesforce/apex/DeepClone.CreateDeepClone';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class DeepClone extends LightningElement {
    @api recordId;

  
    connectedCallback() {
        if (!this.recordId) {
            this._getRecordId().then(recordId => {
                this.recordId = recordId;
                console.log('hii ');
                console.log('Record Id:', this.recordId);
                CreateDeepClone({ recordId: this.recordId})
                    .then(result => {
                        console.log('created....', result);
                        this.closeModal()
                    })
                    .catch(error => {
                        console.log('Error: ', error);
                    });
            });
        } else {
            console.log('Record Id:', this.recordId);
        }
    }

    _getRecordId() {
        return new Promise(resolve => {
            const interval = setInterval(() => {
                if (this.recordId) {
                    clearInterval(interval);
                    resolve(this.recordId);
                }
            }, 100);
        });
    }
    closeModal() {

        this.dispatchEvent(new CloseActionScreenEvent());
        
        }
}