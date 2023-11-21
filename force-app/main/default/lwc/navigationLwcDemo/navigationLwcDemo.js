import { LightningElement } from 'lwc';
import {NavigationMixin } from 'lightning/navigation';

export default class NavigationLwcDemo extends NavigationMixin (LightningElement) {
    handleClickNavigation(){
        //Navigate To Tab
       /* this[NavigationMixin.Navigate]({
            type:'standard__navItempage',
            attributes:{
                apiName:'TestAppliction',
            }
        })*/

        //Navigate to object Tab
       /* this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName:'Account',
                actionName:'home'
            }
        })*/

        // Navigate to Account Object Recent filter
       /* this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName:'Account',
                actionName:'list',
            },
            state :{
                filterName : 'Recent'
                //if we need to redirect All Account filter so use filter Id in FilterName.
            }
        })*/

        //Create new account record modal
        /*this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName:'Account',
                actionName:'new'
            }
        })*/
        
        //view object record
       /* this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:'0015j000012mrNZAAY',
                objectApiName:'Account',
                actionName:'view'
            },
        })*/

        //open object record in edit mode

        /*this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:'0015j000012mrNZAAY',
                objectApiName :'Account',
                actionName:'edit'
            },
        })*/

        //Navigate To Url

        this[NavigationMixin.Navigate]({
            type:'standard__webPage',
            attributes:{
                url:'https://www.youtube.com/watch?v=gHo2OeLa1ts&list=PLVILwsgb1PomkLiLDQOCb9MKDW3le7I5N&index=30'
            },
        })
    }
}