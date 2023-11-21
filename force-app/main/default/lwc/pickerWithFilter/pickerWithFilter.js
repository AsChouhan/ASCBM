import { LightningElement } from "lwc";
export default class RecordPickerWithFilter extends LightningElement {
    matchingInfo = {
        primaryField: { fieldPath: "Name" },
        additionalFields: [{ fieldPath: "Site" }],
    };
    displayInfo = {
        additionalFields: ["Site"],
    };
    // filter Contacts having Accounts starting with "Madison" 
    filter = {
        criteria: [
            {
            fieldPath: 'Site',
            operator: 'eq',
            value: null,
            },
        ],
    };
    handleChange(event) {
        var test = event.detail.recordId;
        console.log('test>>',test);
    }
}