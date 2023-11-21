import { LightningElement } from 'lwc';
import ToastContainer from "lightning/toastContainer";
import Toast from "lightning/toast";
export default class ToastUpdates extends LightningElement {



    connectedCallback() {
        const toastContainer = ToastContainer.instance();
        toastContainer.maxToasts = 5;
        toastContainer.toastPosition = "top-right";
        this.showToast();
    }
    showToast() {
        Toast.show(
            {
                label: "This is a toast title with a {0} placeholder google link {1} that gets replaced by labelLinks",
                labelLinks: [
                    {
                        url: "https://www.lightningdesignsystem.com/components/toast/",
                        label: "Toast link",
                    },
                    {
                        url: "https://www.google.com",
                        label: "Google Link"
                    }
                ],
                mode: "sticky",
                variant: "success",
                onclose: () => {
                    console.log('close');
                }
            }
        )
    }
}