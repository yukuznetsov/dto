import React from 'react'
import './index.css'

const SecondTable = ({data}) => {
  return (
    <div className="secondTable">
      <table className="openedList secondTableBorder">
      <thead>
          <td>
            <p className="openedListHead">Origin</p>
          </td>
          <td>
            <p className="openedListHead">Destination</p>
          </td>
          <td>
            <p className="openedListHead">Total time</p>
          </td>
          <td>
            <p className="openedListHead">Incremental time</p>
          </td>
          <td>
            <p className="openedListHead">Incremental miles</p>
          </td>
          <td>
            <p className="openedListHead">Revenue</p>
          </td>
          <td>
            <p className="openedListHead">Expense</p>
          </td>
          <td>
            <p className="openedListHead">Benefit</p>
          </td>
        </thead>
        <tr>
          <td>
  <p className="secondTableValue">{data.origin_ob}</p>
          </td>
          <td>
  <p className="secondTableValue">{data.destination_ob}</p>
          </td>
          <td>
            <p className="secondTableValue">{data.total_time} min</p>
          </td>
          <td>
            <p className="secondTableValue">{data.incremental_time} min</p>
          </td>
          <td>
            <p className="secondTableValue">{data.incremental_distance} mi</p>
          </td>
          <td>
  <p className="secondTableValue">+ {data.freight_rate}</p>
          </td>
          <td>
  <p className="secondTableValue">- ${data.expense}</p>
          </td>
          <td>
  <p className="secondTableValue">${data.benefit}</p>
          </td>
        </tr>
      </table>
    </div>
  )
}

export default SecondTable
