import { LightningElement, track,api, wire } from 'lwc';
import getAllObjects from '@salesforce/apex/Client_Side_Pagination_Controller.getAllObjects';
import fetchFieldsList from '@salesforce/apex/Client_Side_Pagination_Controller.fetchFieldsList';
import fetchRecords from '@salesforce/apex/Client_Side_Pagination_Controller.fetchRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Client_Side_Pagination extends LightningElement {
    @track showFields = false;
    @track objectList =[];
    @api selectedObject;
    @track fieldsList;
    @track selectedFields;
    @track pageNumber = 1;
    @track recordSize = '10';
    @track displayRecords;
    @track records;
    @track totalRecords;
    @track totalPages;
    @track columns;
    @track values;
    @track showSpinner;
    @api pageNoList;
    @api prevButtonBoolean;
    @api nextButtonBoolean;
    @track sortedBy;
    @track sortedDirection;
    @api showBoolean = false;

    connectedCallback() {
        getAllObjects()
            .then(result =>{
                if (result) {
                    this.selectedFieldList = [];
                    this.objectList = [];
                    for (let key in result ) {
                        this.objectList.push({ label: result[key], value: key });
                    }
                    this.objectList.sort((a, b) => (a.label > b.label) ? 1 : -1);
                } else {
                    console.log('Error in getting objects ')
                }
            })
            .catch(error =>{
                this.error = error;
                alert(error);
            });
    }
    
    handleObjectChange(event) {
        this.showFields = true;
        this.showBoolean = false;
        this.selectedFieldList = [];
        this.values = [];
        this.showSpinner = true;
        let selectedObject1 = event.detail.value;
        this.selectedObject = selectedObject1;
        fetchFieldsList({
            objectName : this.selectedObject
        })
        .then(result => {
            this.fieldsList = result;
            this.showSpinner = false;
        }).catch(error => {
            console.log(error);
            this.showSpinner = false;
        });
    }
    
    pageListButton(event){
        this.pageNoList = [];
        if(this.totalPages <= 5){
            for(var i = 1 ; i <= this.totalPages ; i++ ){
                this.pageNoList.push({'label':i, 'value':i, 'disabled':false});
            }
        }

        else{
            if(this.pageNumber==1 || this.pageNumber==2 || this.pageNumber==3){
                for(var i = 1 ; i <= 5 ; i++ ){
                    this.pageNoList.push({'label':i, 'value':i, 'disabled':false});
                }
            } 
          
            else if(this.pageNumber >= this.totalPages-2){
                for(var i = this.totalPages-4 ; i <= this.totalPages ; i++ ){
                    this.pageNoList.push({'label':i, 'value':i, 'disabled':false});
                }
            }
            else if(this.pageNumber < this.totalPages-2){
                for(var i = this.pageNumber-2 ; i <= this.pageNumber+2 ; i++ ){
                    this.pageNoList.push({'label':i, 'value':i, 'disabled':false});
                }
            }
        }  
        this.disablePreviousButtons();   
        this.disableNextButtons();

        for(var i = 0 ; i<this.pageNoList.length ; i++){
            if(this.pageNumber == this.pageNoList[i].label){
                this.pageNoList[i].disabled = true;
            }
        }

    }

   

    handleFieldsChange(event) {
        this.selectedFields = event.detail.value;
    }
    resetButton(event){
        this.selectedObject;
        this.fieldsList = [];
        this.selectedFields = [];
        this.showBoolean = false;
        this.showFields = false;
    }
    get getRecordSizeList() {
        let recordSizeList = [];
        recordSizeList.push({'label':'10', 'value':'10'});
        recordSizeList.push({'label':'25', 'value':'25'});
        recordSizeList.push({'label':'50', 'value':'50'});
        recordSizeList.push({'label':'100', 'value':'100'});
        return recordSizeList;
    }

    handleNavigation(event){
        let buttonName = event.target.label;
        if(buttonName == 'First') {
            this.pageNumber = 1;
        } else if(buttonName == 'Last') {
            this.pageNumber = this.totalPages;
        }
        else {
            this.pageNumber = buttonName;    
        }
        this.processRecords();
        this.pageListButton();
    }

    handleRecordSizeChange(event) {
        this.recordSize = event.detail.value;
        this.pageNumber = 1;
        this.totalPages = Math.ceil(this.totalRecords / Number(this.recordSize));
        this.processRecords();
        this.pageListButton();
    }

    onSort(event) {
        this.sortedBy = event.currentTarget.dataset.name;
        this.sortedDirection = event.currentTarget.dataset.title;
        this.sortData(this.sortedBy,this.sortedDirection);
    }

    sortData(fieldname,direction) {
        for(var i = 0 ; i<this.columns.length; i++){
            if(this.columns[i].fieldName == fieldname){
                if(direction == 'asc'){
                    this.columns[i].sortDirection = 'desc'
                }
                else{
                    this.columns[i].sortDirection = 'asc'
                }
            }
        }
        let parseData = JSON.parse(JSON.stringify(this.displayRecords));
        let keyValue = (a) => {
          return a[fieldname];
        };
        let isReverse = direction === "asc" ? 1 : -1;
        parseData.sort((x, y) => {
          x = keyValue(x) ? keyValue(x) : "";
          y = keyValue(y) ? keyValue(y) : "";
          return isReverse * ((x > y) - (y > x));
        });
        this.displayRecords = parseData;
    }

    disablePreviousButtons() {
        if(this.selectedFields == undefined || this.selectedFields.length == 0 || this.pageNumber == 1)
            this.prevButtonBoolean = true;
        else
            this.prevButtonBoolean = false;
    }

    disableNextButtons() {
        if(this.selectedFields == undefined || this.selectedFields.length == 0 || this.pageNumber == this.totalPages)
            this.nextButtonBoolean = true;
        else
            this.nextButtonBoolean = false;
    }

    get disableCombobox() {
        if(!this.records || this.records.length == 0)
            return true;
    }

    get recordViewMessage() {
        return 'Total Records - ' + this.totalRecords + ' | Current Page - ' + this.pageNumber + '/' + this.totalPages;
    }

    processRecords() {
        var uiRecords = [];
        var startLoop = ((this.pageNumber - 1) * Number(this.recordSize));
        var endLoop =  (this.pageNumber * Number(this.recordSize) >= this.totalRecords) ? this.totalRecords : this.pageNumber * Number(this.recordSize);
        for(var i = startLoop; i < endLoop; i++) {
            uiRecords.push(JSON.parse(JSON.stringify(this.records[i])));
        }
        this.displayRecords = JSON.parse(JSON.stringify(uiRecords));
        this.pageListButton();
    }

    fetchRecords(event) {
        this.showSpinner = true;
        fetchRecords({
            objectName : this.selectedObject,
            fieldsList : this.selectedFields
        })
        .then(result => {
            if(result != null && result != undefined) {
                this.records = JSON.parse(JSON.stringify(result));
                var uiRecords = [];
                if(result.length>=10){
                    for(var i = 0; i < Number(this.recordSize); i++) {
                        uiRecords.push(result[i]);
                    }
                }
                else{
                    for(var i = 0; i < Number(result.length); i++) {
                        uiRecords.push(result[i]);
                    }
                }

                this.displayRecords = JSON.parse(JSON.stringify(uiRecords));
                this.totalRecords = Number(result.length);
                this.totalPages = Math.ceil(result.length / Number(this.recordSize));

                let fieldsColumn = [];
                for(var i = 0; i < this.fieldsList.length; i++) {
                    for(var j = 0; j < this.selectedFields.length; j++) {
                        if(this.fieldsList[i].value == this.selectedFields[j]) {
                            fieldsColumn.push(this.fieldsList[i]);
                        }
                    }
                }
                let columnList = [];
                for(var j = 0; j < fieldsColumn.length; j++) {
                    columnList.push({'label': fieldsColumn[j].label, 'fieldName': fieldsColumn[j].value, 'type': fieldsColumn[j].datatype, 'sortable': "true", sortDirection : 'asc'});
                }
                this.columns = columnList;
            }
            this.showSpinner = false;
        }).catch(error => {
            console.log(error);
            if(error && error.body && error.body.message)
                this.showNotification(error.body.message, 'error');
            this.showSpinner = false;
        })
        this.pageListButton();
        this.showBoolean = true;
    }

    showNotification(message, variant) {
        const evt = new ShowToastEvent({
            'message': message,
            'variant': variant
        });
        this.dispatchEvent(evt);
    }
}