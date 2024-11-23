import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    @track displayText = "NOW IT'S TRUE";
    @track binding = "One Way Data Binding";
    @track binding2 = "Two Way Data Binding";
    @track name = "Harshal";
    @track tech = "LWC";
    @track isVisible = false;
    @track onkeyText;

    carArray = ['Audi','Mercedies','BMW']

    ceoList = [
                 {Id:1, Name:"Harshal",Class:"MCA"},
                 {Id:2, Name:"Amol", Class:"Agriculture"},
                 {Id:3, Name:"Priti", Class:"MCA"}
    ]
    
    @track obj = {
        Name: "Harshal",
        Class: "MCA",
        Designation: "Senior Salesforce Developer"
    };
    
    @track obj1 = {
        Name: "ZZZ",
        Class: "Provide The Value Here"
    };
    
    @track no1 = 10;
    @track no2 = 40;
    @track users = ["a", "B", "C"];
    
    toggleText() {
        this.displayText = this.displayText === "NOW IT'S TRUE" ? "NOW IT'S FALSE" : "NOW IT'S TRUE";
    }

    changeHandler(event) {
        this.binding2 = event.target.value;
    }

    handleClick() {
        this.isVisible = true;
    }

    onKeyHandler(event) {
        this.onkeyText = event.target.value;
    }

    get isHiPresent() {
        return this.onkeyText === 'Hi';
    }

    designationUpdater(event) {
        this.obj = { ...this.obj, Designation: event.target.value };
    }

    updateClass(event) {
        this.obj1 = { ...this.obj1, Class: event.target.value };
    }

    get multiplication() {
        return this.no1 * this.no2;
    }

    get displayFirstUser() {
        return this.users[0].toUpperCase();
    }
}