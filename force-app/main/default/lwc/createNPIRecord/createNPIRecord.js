import { LightningElement, track } from 'lwc';
import lookupNpi from '@salesforce/apex/NpiLookupController.lookupNpi';

export default class NpiLookup extends LightningElement {
  @track npiNumber;
  @track lookupComplete = false;
  @track npiData;

  handleNpiChange(event) {
    this.npiNumber = event.target.value;
  }

  async handleLookup() {
    this.lookupComplete = false;

    try {
      const result = await lookupNpi({ npiNumber: this.npiNumber });
      if (result) {
        this.npiData = result;
      } else {
        this.npiData = null;
      }
    } catch (error) {
      this.npiData = null;
      console.error(error);
    }

    this.lookupComplete = true;
  }
}