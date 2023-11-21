import { LightningElement } from 'lwc';
import getWeatherinfo from '@salesforce/apex/WeatherApi.getWeatherinfo';
export default class WeatherAPI extends LightningElement {
    city;
    imageURL
    condition

    hendalchange(event){
        this.city = event.target.value;
        console.log('this.city>>>>',this.city);
    }

    handleClick(){
        getWeatherinfo({ city: this.city}).then((response) => {
            console.log('###response>>>>',response);
            let persData = JSON.parse(response);
            this.imageURL = persData.current.condition.icon;
            this.condition = persData.current.condition.text;
        })
        .catch((error) =>{
            this.condition = 'no matching loctaion found';
            console.log('###response>>>>',error);
        })
        }
}