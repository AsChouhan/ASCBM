import { LightningElement,api} from 'lwc';

export default class Childinterview extends LightningElement {
   // @api firstname = '';
    count = 0;
    // connectedCallback(){
    //     let name = "sumit";
      
    //     if(this.FirstName){
          
    //         window.alert("name:- "+name);
    //     }
    // }
    increaseCount() {
        this.dispatchEvent(new CustomEvent('increasecount', {
            detail: {
                message: 'Increased count to ' + (++this.count)
            }
        }));
    }
}