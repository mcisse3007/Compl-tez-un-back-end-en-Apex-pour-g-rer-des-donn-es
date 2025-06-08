/* c/myModal.js */

import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
  // Data is passed to api properties via .open({ options: [] })
  @api options = [];

  handleOptionClick(e) {
    const { target } = e;
    const { id } = target.dataset;
    // this.close() triggers closing the modal
    // the value of `id` is passed as the result
    console.log("id", id)
    this.close(id);
  }
}