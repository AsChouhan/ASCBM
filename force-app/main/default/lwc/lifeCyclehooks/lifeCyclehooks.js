import { LightningElement, api } from 'lwc';

export default class LifeCyclehooks extends LightningElement {
// @api name = 'bhawani';
     message = 'Updated count will appear here!';


      connectedCallback() {
        console.log('connectedCallback');
        console.log('Child Connected Call Back called');
        // throw new Error('problem in child component connectedCallback');
        // this.classList.add("new-class");
      }
      constructor() {
        super();
        console.log('constructor');
        this.classList.add("new-class");
      }
    //   errorCallback(error, stack){
    //     console.log(error,message);
    //     console.log('Stack: - ' + stack);
    // }
    

    updateMessage(event) {
        this.message = event.detail.message;
    }
}