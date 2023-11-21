import { LightningElement,track,api } from 'lwc';

export default class TUL_ButtongroupForCustomer1 extends LightningElement {
    @track showLoyaltyFlag = false;
    @track buttonName = '';
    @api recordId = '001928029292';
    @track showConsent = false;


    openModal2(event) {
        // to open modal set isModalOpen tarck value as true

        this.buttonName = event.target.label;
        console.log('<><>buttonName<><>' + this.buttonName);
        this.showConsent = true;

    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        console.log('close Model');
        this.showConsent = false;
        this.showLoyaltyFlag = false;
    }
    showClickCashDetails() {
        if (this.buttonName == 'CliQ Cash Statement') {
            this.cash = true;
        } else if (this.buttonName == 'NeuCoins') {
            console.log('newCoins');
            this.showLoyaltyFlag = true;
        }
        this.showConsent = false;
        // createFeedItem({ accountId: this.recordId, clickLocation: this.buttonName })
        //     .then(result => {
        //         console.log('<><Feed created><');
        //         console.log('<><this.buttonNamed><' + this.buttonName);
        //     })
        //     .catch(error => {
        //         console.log('<><Feed not created><');
        //     })
    }

}