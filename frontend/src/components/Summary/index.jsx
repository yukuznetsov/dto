import React from 'react'
import './index.css'

const Summary = ({backhauls, rejected, approved, money, potentional}) => {
  return (
    <div className="infoBlock summary">
      <h1 className="summaryTitle">SUMMARY</h1>
      <table className="openedList" style={{ height: 57 }}>
        <thead>
          <td>
            <p className="openedListHead">Backhauls</p>
          </td>
          <td>
            <p className="openedListHead">Potential matches</p>
          </td>
          <td>
            <p className="openedListHead">Approved</p>
          </td>
          <td>
            <p className="openedListHead">Rejected</p>
          </td>
          <td>
            <p className="openedListHead">All Order Net Benefit</p>
          </td>
        </thead>
        <tr>
          <td>
            <p className="openedListText">{backhauls}</p>
          </td>
          <td>
            <p className="openedListText">{potentional}</p>
          </td>
          <td>
            <p className="openedListText">{approved}</p>
          </td>
          <td>
            <p className="openedListText">{rejected}</p>
          </td>
          <td>
            <p className="openedListText greenText">${money}</p>
          </td>
        </tr>
      </table>
    </div>
  )
}

export default Summary
