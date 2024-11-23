import { LightningElement, track } from 'lwc';
import createNpiRecord from '@salesforce/apex/NpiLookupController.createNpiRecord';

export default class NpiForm extends LightningElement {
    @track npiNumber;
    @track showSuccessMessage = false;
    @track showErrorMessage = false;
    @track errorMessage;

    handleNpiChange(event) {
        this.npiNumber = event.target.value;
        console.log('this.npiNumber ',this.npiNumber );
    }

    createNpiRecord() {
        createNpiRecord({ npiNumber: this.npiNumber })
            .then(result => {
               console.log('Record created:', result);
                this.showSuccessMessage = true;
                this.showErrorMessage = false;
                this.npiNumber = '';
            })
            .catch(error => {
               console.log('error:', error);
                this.showSuccessMessage = false;
                this.showErrorMessage = true;
                this.errorMessage = error.body.message;
            });
    }
}