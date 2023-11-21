import { LightningElement, track ,api} from 'lwc';
import getAllObjectList from '@salesforce/apex/MultiSelect_Combobox.getAllObjectList';

export default class MultiSelect_Combobox extends LightningElement {
   
    @track togglebutton = false;
    @track parentValue ='second value';
    @track objectList = [];
    @track listOfPiclistRecord = [];
    @track objectName; 
    @track listOfSelectedRecords = '';  
    @track allValues = [];
    @track callChild = false;
    @track ToggleButton = 'Toggle Button ';
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
        this.objectName = event.detail.value;
        console.log(this.objectName+'this.objectName');
        this.callChild = true;
        console.log('hey call child ',this.callChild);
        // this.template.querySelector('c-child_-multi-select-combobox').handleGetPicklistRecords();
       // childCompVar.handleGetPicklistRecords();
       
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
}