import { LightningElement, api, track, wire} from 'lwc';
export default class ChildClientSidePagination extends LightningElement {
    @api record;
    @api fieldname;

    @track data = {};

    connectedCallback(){
        let obj = JSON.parse(JSON.stringify(this.record));
        this.data = obj[this.fieldname];
    }
}