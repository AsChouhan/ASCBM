import { LightningElement,track,api  } from 'lwc';
import fetchLoyaltyInfo from '@salesforce/apex/TUL_responsClass.fetchLoyaltyInfo';
export default class TulLoyaltyPointsInfo extends LightningElement {
   @api recordId;
    @api getIdFromParent;
    @track messageFromApex;
    @track errorMsg = '';
    @track showResult1;
    @track totalLoyaltyPoints = '';
    @track totalPromisedLoyaltyPoints = '';
    @track customerData = [];
    @track customerData1 = [];
    @track selectedOption = 'ALL';

    @track columns = [
        { label: 'Type', initialWidth: 70, type: "button-icon", typeAttributes: { alternativeText: { fieldName: 'alternativeText' }, iconName: { fieldName: 'points_type' } } },
        { label: 'NeuCoins',  initialWidth: 110 , fieldName: 'points', cellAttributes: { class: { fieldName: 'amountColor' } } },
        { label: 'Store Name',  initialWidth: 130,fieldName: 'store', sortable: true },
        { label: 'Time Stamp', fieldName: 'billing_time', type: "date", typeAttributes: { year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit" }, sortable: true },
        { label: 'Redeemable From', fieldName: 'redeemable_from', type: "date", typeAttributes: { year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit" }, sortable: true },
        { label: 'Expiry Date', fieldName: 'redeemable_from', type: "date", typeAttributes: { year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit" }, sortable: true },
    ];

    connectedCallback() {
        this.showResult1 = true;
        fetchLoyaltyInfo()
            .then(result => {
                this.messageFromApex = true;
                    let res = JSON.parse(result);
                    let resList = res.response.transactions;
                    if (resList.length !== 0) {
                    resList.forEach(element => {
                        var type = element.points_type;
                        if (element.points_type == 'reverse') {
                            element.points_type = 'action:change_record_type';
                            element.alternativeText = 'Reverse';
                            element.points = element.points_label + element.points + '(Reverse)';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                        } else if (element.points_type == 'customer_promotion') {
                            element.points_type = 'action:new_event';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                            element.alternativeText = 'Customer Promotion';
                            element.points = element.points_label + element.points + '(Customer Promotion)';
                        } else if (element.points_type == 'return') {
                            element.points_type = 'action:recall';
                            element.points = element.points_label + element.points + '(Return)';
                            element.alternativeText = 'Return';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                        } else if (element.points_type == 'promised_return') {
                            element.points_type = 'action:recall';
                            element.points = element.points_label + element.points + '(Promised Return)';
                            element.alternativeText = 'Promised Return';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                        } else if (element.points_type == 'expired') {
                            element.points_type = 'action:close';
                            element.points = element.points_label + element.points + '(Expired)';
                            element.alternativeText = 'Expired';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error'
                        } else if (element.points_type == 'promised_earn') {
                            element.points_type = 'action:add_relationship';
                            element.points = element.points_label + element.points + '(promised Earn)';
                            element.alternativeText = 'Promised Earn';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                        } else if (element.points_type == 'burn') {
                            element.points_type = 'action:remove_relationship';
                            element.points = element.points_label+ element.points + '(Burn)';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                            element.alternativeText = 'Burn';
                        } else if (element.points_type == 'earn') {
                            element.points_type = 'action:new';
                            element.amountColor = element.points_label == '+' ? 'slds-text-color_success' : 'slds-text-color_error';
                            element.points = element.points_label + element.points + '(Earn)';
                            element.alternativeText = 'Earn';
                        }
                    });
                    this.customerData = resList;
                    this.customerData1 = resList;
                } else {
                    this.showResult1 = false;
                    this.errorMsg = 'Transactions Not Found';
                }
            })
            .catch(error => {
                this.messageFromApex = true;
                console.log('error is :- ', error);
                this.showResult1 = false;
                this.errorMsg = 'To Reach out your transaction, please contact to your administrator';
            });
    }
    closeModal() {
        const ev = new CustomEvent('bhawani');
        this.dispatchEvent(ev);
    }
    changeHandler(event) {
        this.customerData =[];
        let d = new Date();
        var localList = [];
        this.selectedOption = event.target.value;

        if (this.selectedOption == 'ALL') {
            this.customerData1.forEach(function (data) {
                localList.push(data);
            });
            this.customerData = [...localList];

        } else if (this.selectedOption == 30 && this.customerData1.length > 0) {
            this.customerData1.forEach(function (data) {
                var days30back = (Date.now() - (30 * 86400000));
                if (Date.parse(data.billing_time) >= days30back) {
                    localList.push(data);
                }
            });
            this.customerData = [...localList];
           
        } else if (this.selectedOption == 90 && this.customerData1.length > 0) {
            this.customerData1.forEach(function (data) {
                var days90back = (Date.now() - (90 * 86400000));
                if (Date.parse(data.billing_time) >= days90back) {
                    localList.push(data);
                }
            });
            this.customerData = [...localList];
           
        } else if (this.selectedOption == 180 && this.customerData1.length > 0) {
            this.customerData1.forEach(function (data) {
                var days180back = (Date.now() - (180 * 86400000));
                if (Date.parse(data.billing_time) >= days180back) {
                    localList.push(data);
                }
            });
            this.customerData = [...localList];
        }
    }
}