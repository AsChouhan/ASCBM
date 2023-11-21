import { LightningElement, track, wire } from 'lwc';
import getAllObjectList from '@salesforce/apex/MultiSelect_Combobox.getAllObjectList';
import getRecords from '@salesforce/apex/MultiSelect_Combobox.getRecords';
// import ACCOUNT_OBJECT from '@salesforce/schema/Account';
// import TYPE_FIELD from '@salesforce/schema/Account.Type';
//import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';


export default class MultiSelectPickListParent extends LightningElement {
    @track selectedValue = this.keyElement;
    @track selectedValueList=[this.keyElement];
    @track options; //= options;
    @track objectList = [];
    @track togglebutton = false;
    @track object;
    @track keyElement;
    
    connectedCallback() { 
        getAllObjectList()
        .then((result) => {
            if (result) {
                this.objectList = [];
                for (let key in result ) {
                    this.objectList.push({ label: key, value: key });
                }
            } else {
                console.log('Error in getting objects ')
            }
           
        })
        .catch((error) => {
            console.log('Catch Error in getting objects   ')
        });
        
    }
    onObjectChange(event) { 
        this.object = event.detail.value;
        console.log(this.object+'this.objectName');
        console.log('hey call child ',this.callChild);
        
    }
    @wire(getRecords, {selectedObjectName: '$object'})
    WireResult({ data, error }) {
        if (data) {
            this.options = data.map(item => ({ label: item.Name, value: item.Name }));
            this.keyElement = this.options[0].label;
            console.log('data', data);
             console.log(' this.keyElement ', this.keyElement);
        } else if (error) {
            console.error(error);
        }
    }
    togglechange(event) {
        if(this.togglebutton == false){
            this.togglebutton = event.target.checked;
            console.log(this.togglebutton);
        }else{
            this.togglebutton = false;
            console.log(this.togglebutton);
        }
    }
     
    //for single select picklist
    handleSelectOption(event){
        console.log(event.detail);
        this.selectedValue = event.detail;
    }
 
    //for multiselect picklist
    handleSelectOptionList(event){
        console.log(event.detail);
        this.selectedValueList = event.detail;
        console.log(this.selectedValueList);
    }
}