import React, { useState } from 'react'
import './index.css'
import arrow from './arrowSelect.svg'

const Select = ({ name, top, options, change }) => {
  const [currentOption, setcurrentOption] = useState(options[0] || null)
  return (
    <div className="selectContainer">
      <p className="secondaryFilter">{top}</p>
      <div className="select">
        <p className="selectText">{currentOption}</p>
        <img
          className="selectArrow"
          src={arrow}
          alt="arrowSelect"
        />
        <select className="noneSelect" onChange={(e) => {
          setcurrentOption(e.currentTarget.value)
          change(name, e.currentTarget.value)
        }}>
          {
            options && (
              options.map((item) => 
                <option value={item}>{item}</option>
              )
            )
          }
        </select>
      </div>
    </div>
  )
}

export default Select
