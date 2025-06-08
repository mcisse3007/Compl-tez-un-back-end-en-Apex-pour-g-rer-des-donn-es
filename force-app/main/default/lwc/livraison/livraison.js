import { LightningElement, wire, track, api  } from 'lwc';
import Transporteurs from "./transporteurs";
import getAvailableTransporters  from '@salesforce/apex/TransporteurSelector.getAvailableTransporters';
import getLivraison  from '@salesforce/apex/OrderService.findLivraison';
import setTransporteur  from '@salesforce/apex/TransporteurSelector.setTransporteur';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';



export default class Livraison extends NavigationMixin(LightningElement) {
    @api recordId;
    @track livraisonResult
    @track transporteurs;
    @track livraison;

    @wire(getLivraison, { orderId: '$recordId' })
    wiredFindLivraison(result) {
        this.livraisonResult = result;
        const { data, error } = result;
        console.debug('data', data);
        if (data) {
            this.livraison = data;
            
        } else if (error) {
            console.error('Erreur lors de la récupération des données :', error);
            this.error = error;
            this.livraison = null; 
        }
    }

    @api
    get canChooseTransporteur() {
        return this.livraison.Transporteur__c == null || this.livraison.StatutLivraison__c == 'En préparation';
    }


    @api
    get hasTransporteur() {
        return !!this.livraison.Transporteur__c;
    }

    

    handleChooseTransporteur() {

        getAvailableTransporters({country : this.livraison.Pays__c, customerType: this.livraison.Order__r.TypeClient__c})
        .then(
            (data) => {
                const moinscher = data.reduce((min, obj) => (obj.Tarif__c < min ? obj.Tarif__c : min), data[0].Tarif__c);
                const plusRapide = data.reduce((min, obj) => (obj.DelaiLivraison__c < min ? obj.DelaiLivraison__c : min), data[0].DelaiLivraison__c);
                console.log('moinscher', moinscher);
                console.log('plusRapide', plusRapide);
                this.transporteurs = data.map(e => {
                    const classe = e.Tarif__c == moinscher ? 'slds-box slds-theme_alert-texture' : e.DelaiLivraison__c == plusRapide ? 'slds-box slds-theme_default' : 'slds-box slds-theme_shade' ;
                    return {
                        ...e,
                        isPlusRapide: e.DelaiLivraison__c == plusRapide,
                        isMoinsCher: e.Tarif__c == moinscher,
                        classe: classe
                        
                    };
                }).sort((a,b)=> b.isPlusRapide - a.isPlusRapide)
                .sort((a,b)=> b.isMoinsCher - a.isMoinsCher);
                console.log('transporteurs', this.transporteurs);
                Transporteurs.open({
                    options: this.transporteurs
                    
                  }).then((result) => {
                      console.log("result", result);
                      if(result){
                        setTransporteur({idLivraison: this.livraison.Id, idTransporteur: result}).then((data) => {
                            this.livraison = data;
                      });
                  }});
            }).catch(
            (error) => {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error getting transporteurs',
                                    message: error.body.message,
                                    variant: 'error'
                                    })
                                );
                        }
            );
        
      }
}