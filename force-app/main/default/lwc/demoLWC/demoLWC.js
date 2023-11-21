import {LightningElement,api} from 'lwc';

export default class DemoLWC extends LightningElement {
    _uppercaseItemName
    @api
    get itemName(){
        return this._uppercaseItemName;
    }
    set itemName(value){
    this._uppercaseItemName = value.toUppercase();
    }
    Name = 'Bhawani';
    Company = 'BriskMind';
    Salary = '$100000';
    
}