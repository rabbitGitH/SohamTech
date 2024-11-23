// apexController.js
import { LightningElement, track, wire } from 'lwc';
import createNpiRecord from '@salesforce/apex/NpiController.createNpiRecord';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NPI_API_URL from '@salesforce/label/c.NPI_API_URL';

const FIELDS = ['Lead.FirstName', 'Lead.LastName'];

export default class NpiLookup extends LightningElement {
    @track npiNumber;
    @track leadFirstName;
    @track leadLastName;
    @track npiFirstName;
    @track npiLastName;
    @track recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    lead;

    get leadFields() {
        if (this.lead.data) {
            return {
                FirstName: getFieldValue(this.lead.data, 'Lead.FirstName'),
                LastName: getFieldValue(this.lead.data, 'Lead.LastName')
            };
        }
        return {};
    }

    handleNpiNumberChange(event) {
        this.npiNumber = event.target.value;
    }

    handleNpiLookup() {
        if (!this.npiNumber) {
            return;
        }

        fetch(`${NPI_API_URL}${this.npiNumber}`)
            .then(response => response.json())
            .then(data => {
                if (data.results && data.results.length > 0) {
                    const npi = data.results[0];
                    this.npiFirstName = npi.basic.first_name;
                    this.npiLastName = npi.basic.last_name;
                } else {
                    this.npiFirstName = null;
                    this.npiLastName = null;
                    const event = new ShowToastEvent({
                        title: 'No Results',
                        message: 'No NPI results were found for the given number.',
                        variant: 'warning'
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                console.error(error);
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while looking up the NPI.',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            });
    }

    handleNpiRecordCreation() {
        createNpiRecord({ 
            npiFirstName: this.npiFirstName, 
            npiLastName: this.npiLastName 
        })
            .then(result => {
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'NPI record created successfully.',
                    variant: 'success'
                });
                this.dispatchEvent(event);
                this.clearFields();
            })
            .catch(error => {
                console.error(error);
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'An error occurred while creating the NPI record.',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            });
    }

    clearFields() {
        this.npiNumber = null;
        this.leadFirstName = null;
        this.leadLastName = null;
        this.npiFirstName = null;
        this.npiLastName = null;
    }

    handleRecordId(event) {
        this.recordId = event.detail.id;
    }
}