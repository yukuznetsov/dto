import React from 'react'
import './index.css'
import closeIcon from './close.svg'

const Modal = ({id,text}) => {
  const close = () => {
    document.getElementById("modal1").classList.remove("-open"); 
  }
  return (
    <div class="modal" id="modal1">
      <div class="modal_inner">
        <img
          onClick={close}
          className="closeIcon"
          src={closeIcon}
          alt="closeIcon"
        />
        <p className="modalText">You have successfully {text}<br /> shipment # {id}</p>
        <center>
          <button onClick={close} className="btn btnCloseModal">OK</button>
        </center>
      </div>
    </div>
  )
}

export default Modal
