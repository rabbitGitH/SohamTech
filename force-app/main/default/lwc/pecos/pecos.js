import { LightningElement, track } from 'lwc';

export default class ExampleIframe extends LightningElement {
  @track url = 'https://progress.oandp.com/pecos/opie/';
  @track height = '900px';
  @track width = '100%';
}