import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import Account_Amount from '@salesforce/schema/Account.AnnualRevenue';
export default class ShowErrorOnComponent extends LightningElement {
    @api recordId = '0015g000013swNVAAY';
    @api record;
    @api recordvalue;

    @wire(getRecord, { recordId: '$recordId', fields: [Account_Amount] })
    wireAccount({ error, data }) {

        if (data) {
            this.record = data.fields.AnnualRevenue.value;
            console.log('records is >>>>>>>',this.record);
            this.recordvalue = this.record.fields.AnnualRevenue.value;
            console.log(this.recordvalue);
            if (this.recordvalue != null) {
                console.log(this.recordvalue);
            } else {
                alert('this is error');
            }
        } else if (error) {

            this.error = error;
            this.record = undifined;
        }
    }

}