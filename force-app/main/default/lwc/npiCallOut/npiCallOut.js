import { LightningElement, track } from 'lwc';
import getAPIDetails from '@salesforce/apex/NPIRegistryAPIIntegration.getAPIDetails';

export default class NPIRegistry extends LightningElement {
  @track npiNumber;
  @track firstName;
  @track lastName;
  @track isResultAvailable = false;

  handleInputChange(event) {
    this.npiNumber = event.target.value;
  }

  handleSearchClick() {
    console.log('ONE');
    getAPIDetails({num: this.npiNumber})
      .then(result => {
        let apiResponse = JSON.parse(result);
        console.log('apiResponse',apiResponse)
        console.log('apiResponse.results[0].basic',apiResponse.results[0].basic)
        console.log('apiResponse.results[0].addresses',apiResponse.results[0].addresses)
        console.error(apiResponse);
        this.firstName       = apiResponse.results[0].basic.first_name;
        this.lastName        = apiResponse.results[0].basic.last_name;
        this.gender          = apiResponse.results[0].basic.gender;
        this.credential      = apiResponse.results[0].basic.credential;
        this.desc            = apiResponse.results[0].taxonomies[0].desc;
        this.country_code    = apiResponse.results[0].addresses[0].country_code;
        this.country_name    = apiResponse.results[0].addresses[0].country_name;
        this.address_purpose = apiResponse.results[0].addresses[0].address_purpose;
        this.address_type    = apiResponse.results[0].addresses[0].address_type;
        this.address_1       = apiResponse.results[0].addresses[0].address_1;
        this.city            = apiResponse.results[0].addresses[0].city;
        this.state           = apiResponse.results[0].addresses[0].state;


 

        this.isResultAvailable = true;
      })
      .catch(error => {
        console.error(error);
      });
  }
}