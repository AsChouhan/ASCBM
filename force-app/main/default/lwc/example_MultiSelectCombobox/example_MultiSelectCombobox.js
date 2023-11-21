import { LightningElement, track } from 'lwc';

export default class Example_MultiSelectCombobox extends LightningElement {
@track value;
@track options = [
    {label: 'Cricket', value:'Cricket'},
    {label: 'Football', value:'Footbal'},
    {label: 'Golf', value:'Golf'}
];
@track allValues = [];

handlechange(event){
if(!this.allValues.includes(event.target.value)){
    this.allValues.push(event.target.value);
    }
}
handleRemove(event){
    const valueRemoved = event.target.name;
    this.allValues.splice(this.allValues.indexOf(valueRemoved),1);
}
}