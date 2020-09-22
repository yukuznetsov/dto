import React, { useEffect, useState } from 'react'
import { useHistory } from "react-router"
import './index.css'
import fake from './1.svg'
import ClosedList from '../../components/ClosedList'
import OpenedList from '../../components/OpenedList'
import Filters from '../../components/Filters'
import Summary from '../../components/Summary'

const Main = () => {
  let history = useHistory()
  const [beer, setbeer] = useState(null)
  const [recomended, setrecomended] = useState(null)
  const [combined, setcombined] = useState(null)
  const [filtersData, setfiltersData] = useState({
    state: 'ALL',
    radius: 'ALL',
    type: 'ALL',
    PASSED: false,
    BOOKED: false,
    CONFIRMED: false
  })

  useEffect(() => {
    fetch(`https://api.airtable.com/v0/appXmskpsec5kGcry/front_beer_loads/?api_key=key1lFWEGBRnqbWOs`)
      .then(response => response.json())
      .then(res => {
        if(res.error){

        }else{
          combinData(res.records)
          setbeer(res.records)
        }
      })
  }, [])

  const changeFilter = (name, value) => {
    var tmp = filtersData
    tmp[name] = value
    console.log(tmp)
    setfiltersData(tmp)
  }

  const resetFilter = () => {
    window.location.reload()
  }

  const applyFilter = () => {
    const state = filtersData.state !== 'ALL' ? 
      `%7Bstate%7D+%3D+'${filtersData.state}'` : ''
    const radius = filtersData.radius !== 'ALL' ? 
      `%7Bradius%7D+%3D+'${filtersData.radius}'` : ''
    const type = filtersData.type !== 'ALL' ? 
      `%7Bequipment_type%7D+%3D+'${filtersData.type}'` : ''
    const statusARR = [
      {
        name: 'PASSED',
        bool: filtersData.PASSED
      },
      {
        name: 'BOOKED',
        bool: filtersData.BOOKED
      },
      {
        name: 'CONFIRMED',
        bool: filtersData.CONFIRMED
      }
    ].filter((item) => item.bool)
    var status = ''
    if(statusARR.length > 0){
      status = 'OR('
      + 
        statusARR.map((item) => 
          `%7Bstatus%7D+%3D+'${item.name}'`
        ).join("%2C+")
      +
      ')'
    }
    const comma = [
      state, radius, type, status
    ].filter((item) => item !== '').join("%2C+")
    const url = `https://api.airtable.com/v0/appXmskpsec5kGcry/front_beer_loads?filterByFormula=AND(${comma})&api_key=key1lFWEGBRnqbWOs`
    fetch(url)
    .then(response => response.json())
    .then(data => {
      combinData(data.records)
      console.log('NEW', data);
    })
  }

  const combinData = (data) => {
    var combined = []
    var open = true
    data.forEach(item => {
      item.fields.benefit = parseInt(item.fields.benefit)
      if(combined.length > 0){
        if(item.fields.status !== 'passed'){
          if(combined.filter((a) => 
            a.shipment_id === item.fields.shipment_id
          ).length > 0){
            const index = combined.map((e) => e.shipment_id)
            .indexOf(
              item.fields.shipment_id
            )
            combined[index].data.push(item)
          }else{
            combined.push({
              shipment_id: item.fields.shipment_id,
              // client_name: item.fields.client_name,
              data: [item]
            })
          } 
        }
      }else{
        combined.push({
          shipment_id: item.fields.shipment_id,
          open,
          data: [item]
        })
        open = false
      }
    })
    setcombined(combined.map((item) => {
      return {
        shipment_id: item.shipment_id,
        data: item.data.sort(function(a, b){
          if(a.fields.benefit> b.fields.benefit) return -1;
          if(a.fields.benefit <b.fields.benefit) return 1;
          return 0;
        })
      }
    }))
    console.log(combined);
  }  

  return (
    <div className="container mainPage">
      <div className="mainPageData">
        <Summary
          backhauls={
            combined && combined.length
          }
          potentional={
            combined && combined.filter((item) => 
              item.data
            ).length
          }
          approved={
            beer && beer.filter((item) => 
              'status' in item.fields ?
              (
                item.fields.status === 'CONFIRMED' ||
                item.fields.status === 'BOOKED'
              ) : false
            ).length
          }
          rejected={
            beer && beer.filter((item) => 
              'status' in item.fields ?
              item.fields.benefit.status === 'PASSED' : false
            ).length
          }
          money={
            beer && beer.filter((item) => 
            item.fields.status === 'CONFIRMED'
            ).map((item => parseInt(item.fields.benefit, 10))). reduce((a, b) => a + b, 0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ")
          }
        />
        {
          combined && combined.map((item, i) => 
            <div className="infoBlock">
              {
                i === 0 && (
                  <h1 className="currentSearch">CURRENT SEARCH</h1>
                )
              }
              <ClosedList
                id={i}
                open={item.open}
                close={(id) => {
                  setcombined(combined.map((a, p) => {
                    if(p === id){
                      a.open = !a.open
                    }
                    return a
                  }))
                }}
                shipmentId={item.shipment_id}
                best={
                  Math.max.apply(Math, item.data.map((item) => parseInt(item.fields.benefit, 10)))
                }
                length={item.data.length}
                poss={item.data.filter((item) => 
                  item.fields.status !== 'CONFIRMED'  
                ).length}
              />
              {
                item.open && (
                  <OpenedList
                    history={history}
                    data={item.data}
                  />
                )
              }
              {/* <img src={fake} /> */}
            </div>
          )
        }
      </div>
      <div className="filterContainer" id="filters">
        <Filters
          changeFilter={changeFilter}
          apply={applyFilter}
          reset={resetFilter}
        />
      </div>
    </div>
  )
}

export default Main
