import { LightningElement, track, api, wire } from 'lwc';
import STATUS from '@salesforce/schema/Account.Status__c';
import getAccounts from'@salesforce/apex/DynamicTable.picListValue';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParentComponentForDT extends LightningElement {
    @track enableEdit = null;
    @track hideSave = false;
    @track hideEdit = true;
    @track disableEdit = true;
    @track disableEdit;
    @api recordId;

    @track status;

    @wire(getRecord, { recordId: '$recordId', fields: STATUS })
    account({ data, error }) {
        if (data) {
            this.status = getFieldValue(data, STATUS);
                console.log('bhanu', this.status);
        } else {
            console.log(error);
        }
    }

    get gEnable() {
        console.log('get Enble called');
        var childMethod = this.template.querySelector('c-child-Account');
        console.log(childMethod);
        console.log(childMethod.disableD());
        return childMethod.disableD();
    }

    connectedCallback() {
        // console.log('connected call back called');
        // // setTimeout(() => {
        //     console.log(this.status);
        //     if (this.status === 'close') {
        //         console.log('inside open status');
        //         this.enableEdit = true;
        //         this.disableEdit = true;
               
        //     }else{
        //         this.disableEdit = false;
                
        //     }
        getAccounts({ recordId: this.recordId})
        .then(result => {
            this.status = result;
            console.log('Status picklist value:', this.status);
            if(this.status == 'Close'){
                // this.disableEdit = true;
                // this.inputEnabel = true;
                this.enableEdit = true;
                this.disableEdit = true
            }
            else{
                this.disableEdit = false;
                // this.disableEdit = false;
                // this.inputEnabel = true;
            }
        })
        .catch(error => {
            console.error('Error fetching record data', error);
        });
            console.log('The====>>', this.enableEdit);
            console.log('The====>>',this.disableEdit);
        // }, 2000);
    }

    pressEdit() {
        var childMethod = this.template.querySelector('c-child-Account');
        var contactcus = this.template.querySelector('c-child-Contact');
        var caseCus = this.template.querySelector('c-child-Case');
        var contractCus = this.template.querySelector('c-child-Contract');


        childMethod.enable_disable_EditFunctionalities();
        contactcus.enable_Disable_With_Update();
        caseCus.enable_Disable_With_Update();
        contractCus.enable_Disable_With_Update();

        this.enableEdit = false;
        this.hideEdit = false;
        this.hideSave = true;
    }

    pressSave() {
        var childMethod = this.template.querySelector('c-child-Account');
        var contactcus = this.template.querySelector('c-child-Contact');
        var caseCus = this.template.querySelector('c-child-Case');
        var contractCus = this.template.querySelector('c-child-Contract');

        this.hideEdit = true;
        this.hideSave = false;
        childMethod.enable_disable_EditFunctionalities().then(result => {
            if (result == true) {
                contactcus.enable_Disable_With_Update().then(result => {
                    if (result == true) {
                        caseCus.enable_Disable_With_Update().then(result => {
                            if (result == true) {
                                contractCus.enable_Disable_With_Update().then(result => {
                                    if (result == true) {
                                        console.log('comes at the end contract');
                                        this.enableEdit = false;
                                        this.ShowToast('Success!', 'Saved.', 'Success');
                                    }
                                    else {
                                        childMethod.enable_disable_EditFunctionalities();
                                        contactcus.enable_Disable_With_Update();
                                        caseCus.enable_Disable_With_Update();
                                        this.ShowToast('Error!', 'Failed To Save At Contract.', 'error');
                                    }
                                })
                            } else {
                                childMethod.enable_disable_EditFunctionalities();
                                contactcus.enable_Disable_With_Update();
                                this.ShowToast('Error!', 'Failed To Save At Case.', 'error');
                            }
                        })
                    } else {
                        childMethod.enable_disable_EditFunctionalities();
                        this.ShowToast('Error!', 'Failed To Save At Contact.', 'error');
                    }
                })
            } else {
                this.enableEdit = true;
                this.ShowToast('Error!', 'Failed To Save At Account.', 'error');
            }
        })
    }


    ShowToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}