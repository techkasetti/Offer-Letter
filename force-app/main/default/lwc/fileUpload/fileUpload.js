import { LightningElement, api ,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile';
import getCandidateId from '@salesforce/apex/FileUploaderClass.getCandidateId';
import { NavigationMixin } from 'lightning/navigation';
export default class FileUploaderCompLwc extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @track isLoading = false;
    fileData
    
    openfileUpload(event) {
        
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            console.log(this.recordId);
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }
   
   
    handleClick() {
        
        console.log(this.fileData);
        console.log('result');
        const { base64, filename, recordId } = this.fileData
        uploadFile({ base64, filename, recordId }).then(result => {
            
            console.log('result>>>'+result);

             this.fileData = null
             let title = `${filename} uploaded successfully!!`
             
             this.toast(title);
             this.isLoading = true;
             setTimeout(() => {
                
                 alert('Inside Timeout');
                 this.candidateId(result);
            }, 180000);
            
            
             
        })

    }

    candidateId(result){
            this.isLoading = false;
             console.log('result12223'+result); 
             getCandidateId({result: result}).then(response =>{
             console.log('response>>>'+response);
             this.navigateToWebPage(response);

             

             }).catch(error =>{
             console.log('Error: '+error.body.message);
             });

    }

    toast(title) {
        //console.log('title>>'+title);
        const toastEvent = new ShowToastEvent({
            title,
            variant: "success"
        })
        this.dispatchEvent(toastEvent)
    }

    navigateToWebPage(response) {
        // Navigate to a URL
        //alert('response');
        console.log('response>>'+response);
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                "componentName": "c__SaveSkillSet"
            },
            state:{
                "c__candDocParserId": response
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }
}