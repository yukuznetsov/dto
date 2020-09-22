import React, { useState } from 'react'
import './index.css'
import closeIcon from './close.svg'
import arrow from './arrowOpen.svg'
import arrowClose from './arrowClose.svg'

import Select from '../Select'
import Checkbox from '../Checkbox'

const Filters = ({changeFilter, apply, reset}) => {
  const [first, setfirst] = useState(true)
  const [second, setsecond] = useState(true)
  return (
    <div className="filters">
      <img
        className="closeFilters"
        src={closeIcon}
        alt="closeIcon"
        onClick={() => {
          document.getElementById("filters").style.display = 'none'
        }}
      />
      <div className="containerFilter">
        <h1 className="title">FILTER FOR RECS</h1>
        <p className="secondaryFilter">Please select the necessary filters to view recommendations</p>
        <div className="filterView" style={{ marginTop: 30 }}>
          <div>
          <h1 className="filterTitle">The brewery location</h1>
          </div>
          <img
              onClick={() => {
                setfirst(!first)
              }}
              className="arrowFilter"
              src={!first ? arrow : arrowClose}
              alt="arrrow"
            />
        </div>
        {
          first && (
            <div className="filterView">
              <Select
                change={changeFilter}
                name="state"
                top="Beer origin"
                options={['ALL', 'HTN','MERR','STL/GRAN','NWK']}
              />
            </div>
          )
        }
        <hr className="separator" />
        <div className="filterView">
          <h1 className="filterTitle">Advanced filters</h1>
          <img
            onClick={() => {
              setsecond(!second)
            }}
            style={{ paddingLeft: '165px' }}
            className="arrowFilter"
            src={!second ? arrow : arrowClose}
            alt="arrow"
          />
        </div>
        {
          second && (
            <div>
              <div className="filterView">
                <Select
                  change={changeFilter}
                  name="radius"
                  top="Radius Distance, miles"
                  options={['ALL', '<75','75-200','>200']}
                />
              </div>
              <div className="filterView">
                <Select
                  change={changeFilter}
                  name="type"
                  top="Equipment Type"
                  options={['ALL', 'VAN (V)','VAN (VR)']}
                />
              </div>
              <div className="filterViewCheckbox">
                <Checkbox
                  change={changeFilter}
                  name="PASSED"
                  label="Passed"
                />
              </div>
              <div className="filterViewCheckbox">
                <Checkbox
                  change={changeFilter}
                  name="BOOKED"
                  label="Booked"
                />
              </div>
              <div className="filterViewCheckbox">
                <Checkbox
                  change={changeFilter}
                  name="CONFIRMED"
                  label="Confirmed"
                />
              </div>
            </div>
          )
        }
        <hr className="separator" />
        <div className="filterView">
          <button onClick={apply} className="green-btn" style={{
            marginTop: 20
          }}>APPLY</button>
        </div>
        <div className="filterView">
          <a className="reset" href="#" onClick={reset}>Reset</a>
        </div>
      </div>
    </div>
  )
}

export default Filters
