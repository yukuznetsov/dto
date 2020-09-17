import React from 'react'
import { useHistory } from "react-router"
import './index.css'
import mapIcon from './map.svg'
import arrow from './arrowOpen.svg'

const OpenedList = ({data}) => {
  let history = useHistory()
  const open = (e) => {
    history.push("/2?id="+e.currentTarget.id);
  }
  return (
    <table className="openedList">
      <tr>
        <td>
          <p className="openedListHead">Origin</p>
        </td>
        <td>
          <p className="openedListHead">Destination</p>
        </td>
        <td>
          <p className="openedListHead">Pick up Date/Time</p>
        </td>
        <td>
          <p className="openedListHead">Delivery Date/Time</p>
        </td>
        <td>
          <p className="openedListHead">Rate</p>
        </td>
        <td>
          <p className="openedListHead">Net benefit</p>
        </td>
      </tr>
      {
        data && data.map((item) => 
          <tr className="openTR" onClick={open} id={item.id}>
            <td>
              <p className="openedListText">{item.fields.origin_ob}</p>
            </td>
            <td>
              <p className="openedListText">{item.fields.destination_ob}</p>
            </td>
            <td>
              <p className="openedListText">{item.fields.pick_up_date_time_ob}</p>
            </td>
            <td>
              <p className="openedListText">{item.fields.delivery_date_time_ob}</p>
            </td>
            <td>
              <p className="openedListText">{item.fields.freight_rate}</p>
            </td>
            <td>
              <p className="greenText">${item.fields.benefit}</p>
            </td>
          </tr>
        )
      }
    </table>
  )
}

export default OpenedList
