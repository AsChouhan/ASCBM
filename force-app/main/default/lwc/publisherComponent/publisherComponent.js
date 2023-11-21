import { LightningElement, wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import DataTransferChannel from '@salesforce/messageChannel/DataTransferChannel__c'
export default class PublisherComponent extends LightningElement {

    Name;
    @wire(MessageContext) messageContext;
    
    handleChange(event){
        this.Name = event.target.value;
        console.log('handlechange name >>>', this.Name);
    }
    handleClick(){
        console.log('call handle click');
        let payload = {Name : this.Name}
        publish (this.messageContext, DataTransferChannel ,payload)
    }
}