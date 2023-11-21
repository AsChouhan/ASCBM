import { LightningElement } from 'lwc';
import getFile from '@salesforce/apex/AllIntegration.getFiles1';
import getfileGoogleDrive from '@salesforce/apex/AllIntegration.getfileGoogleDrive';

const columns = [
    { label: 'Name', fieldName: 'name', type: 'text'},
    { label: 'Type', fieldName: 'type', type: 'text' }
];
export default class BoxNameAuth extends LightningElement {
    data = [];
    google = [];
    columns = columns;
    connectedCallback(){
        console.log('check for exp');
        getFile()
        .then(result=>{
            console.log('check for exp');
            console.log('result-->',result);
            this.data = result;
            console.log('this.data-->',this.data);
        })
        getfileGoogleDrive()
        .then(result=>{
            console.log('result-->',result);
            this.google = result;
        })
    }
    
}