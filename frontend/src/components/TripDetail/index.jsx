import React from 'react'
import { useHistory } from "react-router"
import './index.css'
import back from './back.svg'
import arrow from './arrowOpen.svg'
import map from './map.svg'
import money from './money.svg'
import time from './time.svg'

const Filters = ({data, update}) => {
  let history = useHistory()
  return (
    <div className="filters" style={{ marginTop: 10, top: 78, left: 'auto', right: 30 }}>
      <div className = "btn-block">
        <div className="filterView custom-style">
            <button onClick={() => {update('BOOKED')}} className="green-btn" style={{
              marginTop: 20
            }}>BOOK LOAD</button>
          </div>
          <div className="filterView custom-style">
            <button onClick={() => {update('CONFIRMED')}} className="blue-btn" style={{
              marginTop: 20
            }}>FINAL CONFIRM</button>
          </div>
          <div className="filterView custom-style">
            <button onClick={() => {update('PASSED')}} className="grey-btn" style={{
              marginTop: 20
            }}>PASS</button>
          </div>
        <img
          className="closeFilters"
          src={back}
          alt="back"
          onClick={() => {
            history.push('/main');
          }}
        />
      </div>
      <div className="containerFilter">
        <h1 className="title">DETAIL</h1>

        <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="map"
              src={map}
            />
            <p className="detailTitleText">Origin location</p>
          </div>
          <p className="detailValue">{data.origin_ob}</p>
        </div>
        <hr className="separator" />
        <div className="detailCell">
          <div className="detailTitle">
              <img
                alt="map"
                src={map}
              />
              <p className="detailTitleText">Destination location</p>
            </div>
            <p className="detailValue">{data.destination_ob}</p>
          </div>
          <hr className="separator" />
          <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="map"
              src={time}
            />
            <p className="detailTitleText">Total time</p>
          </div>
          <p className="detailValue">{data.total_time} min</p>
        </div>
        <hr className="separator" />
        <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="time"
              src={time}
            />
            <p className="detailTitleText">Incremental time</p>
          </div>
          <p className="detailValue">{data.incremental_time} min</p>
        </div>
        <hr className="separator" />
        <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="time"
              src={time}
            />
            <p className="detailTitleText">Incremental miles</p>
          </div>
          <p className="detailValue">{data.incremental_distance} mi</p>
        </div>
        <hr className="separator" />
        <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="map"
              src={map}
            />
            <p className="detailTitleText">Revenue</p>
          </div>
          <p className="detailValue">+ {data.freight_rate}</p>
        </div>
        <hr className="separator" />
        <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="money"
              src={money}
            />
            <p className="detailTitleText">Expense</p>
          </div>
          <p className="detailValue">- ${data.expense}</p>
        </div>
        <hr className="separator" />
        <div className="detailCell">
          <div className="detailTitle">
            <img
              alt="money"
              src={money}
            />
            <p className="detailTitleText">Benefit</p>
          </div>
          <p className="detailValue">${data.benefit}</p>
        </div>
        <hr className="separator" />
      </div>
    </div>
  )
}

export default Filters
