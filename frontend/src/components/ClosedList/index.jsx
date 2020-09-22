import React from 'react'
import './index.css'
import mapIcon from './map.svg'
import arrow from './arrowOpen.svg'

const ClosedList = ({shipmentId, best, length, poss, close, id, open}) => {
  return (
    <table className="closedList">
      <tr>
        <td>
          <img
            className="mapIcon"
            src={mapIcon}
            alt="mapIcon"
          />
        </td>
        <td>
  <p className="closedListText" id="shipmentId">{shipmentId}</p>
        </td>
        <td>
          <p className="closedListText">{length} Available Matches</p>
        </td>
        <td>
          {/* status !== comfirmed */}
          <p className="closedListText">{poss} Potential Matches</p>
        </td>
        <td>
          <p className="closedListText">Best Net Benefit: <b style={{
            color: '#5C841F'
          }}>${best}</b></p>
        </td>
        <td>
          <img
            className="arrowClose"
            style={ open ? {transform: 'rotate(180deg)'} : {transform: 'rotate(0deg)'}}
            onClick={() => close(id)}
            src={arrow}
            alt="arrow"
          />
        </td>
      </tr>
    </table>
  )
}

export default ClosedList
