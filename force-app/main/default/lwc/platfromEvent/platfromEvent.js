import { LightningElement, track } from 'lwc';
import { subscribe } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PlatfromEvent extends LightningElement {
    subscription = null;
    chhannelName = '/event/Show_Tost_Message__e';
    @track lastestPayload;
    _title = "your record is successfully updated";

    handelSubscribe(){
        console.log('handelsubscribe');
        const messageCallback = (response)=>{
            var rec = JSON.stringify(response.data.payload.Notification__c);
            this.lastestPayload = rec;
            console.log('this.lastestPayload>>',this.lastestPayload);
            this.showNotification();
        }
        subscribe(this.chhannelName, -1, messageCallback).then((response)=>{
           // console.log('subscribe>>>>', JSON.stringify(response.chhannelName));
        });
    }
    showNotification() {

        const evt = new ShowToastEvent({
          title: this._title,
          message: this.lastestPayload,
          variant: "success",
        });
        this.dispatchEvent(evt);
      }
    connectedCallback(){
        //console.log('call');
        this.handelSubscribe();
    }
}