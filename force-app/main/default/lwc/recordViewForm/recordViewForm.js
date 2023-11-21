import { LightningElement,api} from 'lwc';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';

import Company_Name from '@salesforce/schema/BM_Company__c';
import Employe_Name from '@salesforce/schema/BM_Company__c.Name';
import Email from '@salesforce/schema/BM_Company__c.Email__c';
import Employe_PhoneNumber from '@salesforce/schema/BM_Company__c.Phone_Number__c';
import Employe_workExperience from '@salesforce/schema/BM_Company__c.work_Experience__c';

export default class RecordViewForm extends LightningElement {
    
    ObjectApiName = Company_Name;
    nameField = Employe_Name;
    emailField = Email;
    phoneNumberField = Employe_PhoneNumber;
    workExperienceField = Employe_workExperience;
 
    @api recordId; 
}