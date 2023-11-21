import { LightningElement } from 'lwc';

export default class Parentcomponent extends LightningElement {
    CountValue = 0;
    handleDecrement(){
        this.CountValue--;
    }
    handleadd(){
        this.CountValue++;
    }
    handlemultiply(event){
    const multiplyingnumber = event.detail;
    this.CountValue *= multiplyingnumber;
    }
    handlereset(){
        this.CountValue = 0;
    }
}