import { LightningElement,api } from 'lwc';

export default class LwcVariabale extends LightningElement {
    @api FirstName = '';

    connectedCallback(){
        let name = "sumit";
      
        if(this.FirstName){
          
            window.alert("name:- "+name);
        }
       // window.alert("name:- "+name);
       
    }
    handelClick(){
        window.alert("function calling");
    }
}