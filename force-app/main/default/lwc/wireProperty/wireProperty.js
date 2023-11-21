import { LightningElement,api, wire} from 'lwc';
import getContacs from '@salesforce/apex/WireProperty.getContacs';
export default class WireProperty extends LightningElement {

    @api recordId;
@wire(getContacs,{accId : '$recordId'})
contacts;
}