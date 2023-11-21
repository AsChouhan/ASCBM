import { LightningElement, track } from 'lwc';

export default class CalculatorLWC extends LightningElement {
    @track addNumber;
    inputValue = ' ';
    @track resultValue;


    handleClick(event){
        var label = event.target.label;
        console.log('label>>>>',label);
        this.inputValue =this.inputValue+label;
        console.log('this.inputValue>>>>',this.inputValue);
    }

    clear(){
        this.inputValue = ' ';
        this.resultValue = ' ';
    }

    getResult() {
        console.log(eval(this.inputValue));
        this.resultValue = eval(this.inputValue);
    }

}