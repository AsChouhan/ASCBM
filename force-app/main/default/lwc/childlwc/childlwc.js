import { LightningElement } from 'lwc';

export default class Childlwc extends LightningElement {

    handlesubstract(){
        this.dispatchEvent(new CustomEvent('substract'));
    }
    handleAdd(){
        this.dispatchEvent(new CustomEvent('add'));
    }
    handleReset(){
        this.dispatchEvent(new CustomEvent('reset'));
    }
    handleMultiply(event){
        const valueForMultiply = event.target.value;
        this.dispatchEvent(new CustomEvent('multiply',{
            detail : valueForMultiply
        }));
    }
}