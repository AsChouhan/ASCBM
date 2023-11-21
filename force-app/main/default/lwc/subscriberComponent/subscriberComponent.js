import { LightningElement, wire } from 'lwc';
import { MessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import DataTransferChannel from '@salesforce/messageChannel/DataTransferChannel__c'

export default class SubscriberComponent extends LightningElement {

    Name= '';
    sub = null;

    @wire(MessageContext) messageContext;

    connectedCallback(){
        this.handelsub();
    }
    disconnectedCallback(){
        this.handelUnsubscribe();
    }
    handelsub(){
        if(!this.sub){
            this.sub = subscribe(this.messageContext,DataTransferChannel,(parameter)=>{this.Name = parameter.Name})
        }
    }
    handelUnsubscribe(){
        unsubscribe(this.sub);
        this.sub = null;
    }
}