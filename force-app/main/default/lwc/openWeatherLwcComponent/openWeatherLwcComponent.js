import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class OpenWeatherLwcComponent extends LightningElement {

    city
    //showSpinner = false;
    imageURL;
    condition;
    //check field validation
    
    hendalchange(event){
        this.city = event.target.value;
        console.log('this.city>>>>',this.city);
    }
   
    handleClick(){
        console.log('weather api call');
        this.fetchWeatherInfo();
        }
 
    fetchWeatherInfo(){
        console.log('weather fetchWeatherInfo');
        let APIKey = 'e684ce80a08a4c63be5105522232610';
        var endPoint = 'https://api.weatherapi.com/v1/current.json?key='+APIKey+'&q='+this.city;
        console.log('weather endPoint>>',endPoint);
        //get request
        fetch(endPoint, {method: "GET"})
        .then((response) => {
            if (!response.ok) {
                this.error = response;
            }
            return response.json();
        })
        .then((jsonResponse) => {
            console.log('jsonResponse>>',jsonResponse);
           
            //console.log('jsonResponse>>',persData);
            this.imageURL = jsonResponse.current.condition.icon;
            this.condition = jsonResponse.current.condition.text;
             
           
        })
        .catch((error) => {
            console.log(error);
            this.error = error;
            this.handleSpinner();
        });
    }
 
 

    handleSpinner(){
        this.showSpinner = !this.showSpinner;
    }
}