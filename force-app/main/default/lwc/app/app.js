import { LightningElement,track } from 'lwc';
import {add, minus} from './utils.js'
export default class App extends LightningElement {
   connectCallback(){
       add(5,2)
       minus(5,2)                   
   }
}