import { LightningElement, api, track } from 'lwc';
import checkUserInDatabase from '@salesforce/apex/Dropbox.checkUserInDatabase';
import getAuthorizationCode from '@salesforce/apex/Dropbox.getAuthorizationCode';
import checkAccessToken from '@salesforce/apex/Dropbox.checkAccessToken';
import getAccessToken from '@salesforce/apex/Dropbox.getAccessToken';
import getFiles from '@salesforce/apex/Dropbox.getFiles';
import getNewAccessToken from '@salesforce/apex/Dropbox.getNewAccessToken';
import downloadFiles from '@salesforce/apex/Dropbox.downloadFiles';
import deleteFile from '@salesforce/apex/Dropbox.deleteFile';
import createFolder1 from '@salesforce/apex/Dropbox.createFolder1';
import uploadFile1 from '@salesforce/apex/Dropbox.uploadFile1';

export default class Dropbox_Integration extends LightningElement {
  @api code = '';
  @track filesList = [];
  @track error;
  @track myBreadcrumbs = [{'label': 'Home', 'value': ''}];
  @track isShowModal = false;
  @track fileName = '';
  @track folderId = '';
  @api parentFolderId='';
  @api fil;
  @api myRecordId;

  connectedCallback() {
    const startingUrl = new URL(window.location.href);
    const authcode = startingUrl.searchParams.get('code');
    this.code = authcode;
    
    checkUserInDatabase()
      .then(result => {
        if (result == 'Found') {
          console.log('CheckAccessToken');
          checkAccessToken()
            .then(result => {
              if (result == 'NOT EXPIRED') {
                console.log('not Expired');
                this.getFilesInJs();
              } else {
                console.log('getnew Access Token');
                getNewAccessToken()
                  .then(result => {
                    if (result == 'UPDATED') {
                      console.log(result);
                      console.log('update');
                      this.getFilesInJs();
                    }
                  })
                  .catch(error =>{
                    this.error = error;
                  })
              }
            });
        } else {
          console.log('getAuthorization');
          if (this.code == null) {
            getAuthorizationCode()
              .then(result => {
                console.log(result);
                window.location.href = result;
                const startingUrl = new URL(window.location.href);
                const authcode = startingUrl.searchParams.get('code');
                this.code = authcode;
                console.log(this.code);
                console.log('i am getAccess');
              })
              .catch(error => {
                this.error = error;
              });
          } else {
            console.log('getAccessToken');
            console.log(this.code);
            getAccessToken({ code: this.code })
              .then(result => {
                console.log(result);
                this.AccessToken = result;
                console.log('get file 3rd time ');
                this.getFilesInJs();
              })
              .catch(error => {
                this.error = error;
              });
          }
        }
      });
  }

  handleDownloadFile(event) {
    console.log(event);
    let fileId = event.target.dataset.fileId;
    console.log(fileId);
    downloadFiles({ path: fileId })
      .then(result => {
        console.log(result);
        window.open(result);
      })
      .catch(error => {
        this.error = error;
      });
  }

  getFilesInJs(){
    getFiles({folId : this.parentFolderId})
    .then(result=>{
        this.filesList = result;
        this.addIsFolder();
    })
  }

  addIsFolder(){
      for(var x of this.filesList){
        if(x.tag == "folder"){
            x.isFolder = true;
        }else{
          x.isFolder = false;
        }
      }
  }

  handleDeleteFile(event){
    console.log(event);
    let fileId = event.target.dataset.fileId;
    deleteFile({ FileId: fileId })
      .then(result => {
        if(result == 'Success'){
        alert("successfully file delete");
        }
        console.log(result);
        return getFiles({folId : this.parentFolderId})
          .then(result => {
            for(var x of result){
              if(x.type == 'folder'){
                x.isfolder = true;
              }else{
                x.isfolder = false;
              }
            }
            console.log('getfiles');
            console.log(result);
            this.filesList = result;
          });
      })
      .catch(error => {
        this.error = error;
      });
  }

  showModalBox() {  
    this.isShowModal = true;
}

hideModalBox(event) {  
  this.isShowModal = false;
}
createFolder(event){
  this.fileName = this.template.querySelector('lightning-input').value;
  console.log(this.fileName);
  console.log(this.parentFolderId);
  //var path = '';
  createFolder1({folderPath : this.parentFolderId , folderName : this.fileName})
  .then(result =>{
    console.log(result);
    console.log(this.parentFolderId);
    this.getFilesInJs();
  })
  this.isShowModal = false;
}

get acceptedFormats() {
  return ['.pdf', '.png', '.csv', '.png', '.doc', '.docx', '.pdf'];
}
handleUploadFile(event) {
  console.log('start');
  var uploadedFile = event.detail.files;
  console.log('uploadFile');
        var type = uploadedFile[0].type;
        console.log(type);
        var name = uploadedFile[0].name;
        console.log(name);
        //var pathid = '';
        console.log('a');
        var file1 = btoa(JSON.stringify(uploadedFile[0]));
        uploadFile1({filename : name , path : this.parentFolderId , file : file1})
        .then(result =>{
          if(result == 'Success'){
            this.getFilesInJs();
          }
        });
  }

  open(event){
    console.log('hii open');
     var folderOpenId = event.target.dataset.fileId;
     console.log(folderOpenId);
     var filename = event.target.name;
     console.log('fodler name => '+filename);
     console.log('parentFolderId',this.parentFolderId);
     this.parentFolderId = folderOpenId;
    console.log(folderOpenId);
    var item = {
      'label' : filename,
      'value' : folderOpenId
    }
    this.myBreadcrumbs.push(item);
    console.log('parentFolderId',this.parentFolderId);
    this.getFilesInJs();
  }

  handleNavigateTo(event){
    var ids = event.target.name;
    console.log(ids);
    var tmpList = [];
    for(var x of this.myBreadcrumbs){
        console.log(x.value +' == '+ids);
        if(x.value == ids){
            tmpList.push(x);
            break;
        }
        tmpList.push(x);
    }
    this.myBreadcrumbs = tmpList;
    this.parentFolderId = ids;
      this.getFilesInJs();
  }
}