import { LightningElement, track } from 'lwc';
import getfile from '@salesforce/apex/salesforceintiApex.getFiles';
import uploadFiles from '@salesforce/apex/salesforceintiApex.uploadFiles';
export default class SalesforceToSalesforce extends LightningElement {
@track ListOfFiles;
@track listOfName;

connectedCallback(){
    getfile()
    .then(result=>{
        
        this.ListOfFiles = result;
        console.log('mmmmmmmmmmmmmmmm',result);
       
    })
}

handleUploadFile(event){
    uploadFiles()
    console.log('start');
  var uploadedFile = event.detail.files;
  console.log('uploadFile');
        var name = uploadedFile[0].name;
        console.log(name);
        //var pathid = '';
        console.log('a');
        var file1 = btoa(JSON.stringify(uploadedFile[0]));
        uploadFiles({filename : name , file64 : file1})
        .then(result =>{
          if(result == 'Upload Success'){
            this.ListOfFiles = [];
            getfile()
            .then(result=>{
                this.ListOfFiles = result;
                console.log('mmmmmmmmmmmmmmmm',result);           
            })
          }
        });
}
get acceptedFormats() {
    return ['.pdf', '.png', '.csv', '.png', '.doc', '.docx', '.pdf'];
  }
}