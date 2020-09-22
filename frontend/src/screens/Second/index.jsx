import React, { useEffect, useState } from 'react'
import './index.css'
import SecondTable from '../../components/SecondTable'
import List from '../../components/List'
import Map from '../../components/Map'
import Modal from '../../components/Modal'
import TripDetail from '../../components/TripDetail'
import { useHistory } from "react-router"

const Main = () => {
  const [data, setdata] = useState(null)
  const [text, settext] = useState(null)
  let history = useHistory()
  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search);
    const id = urlParams.get('id');
    if(id){
      fetch(`https://api.airtable.com/v0/appXmskpsec5kGcry/front_beer_loads/${id}/?api_key=key1lFWEGBRnqbWOs`)
      .then(response => response.json())
      .then(res => {
        if(res.error){
          history.push('/');
        }else{
          setdata(res)
          console.log(res)
        }
      })
    }else{
      history.push('/');
    }
  }, [])

  const update = (name) => {
    var updated = data
    settext(name.toLowerCase())
    delete updated.createdTime
    updated.fields.status = name
    fetch("https://api.airtable.com/v0/appXmskpsec5kGcry/front_beer_loads", {
      body: JSON.stringify({
        records: [updated]
      }),
      headers: {
        Authorization: "Bearer key1lFWEGBRnqbWOs",
        "Content-Type": "application/json"
      },
      method: "PATCH"
    })
    .then(response => response.json())
    .then(res => {
      if(res.records){
        document.getElementById("modal1").classList.add('-open')
      }
    })
  }

  return (
    <div>
      <Modal
        id={data && data.fields.shipment_id}
        text={text}
      />
      <div className="container secondPage" style={{ marginTop: 58 }}>
      <div style={{ marginRight: 37, width: '100%' }}>
        <div className="gridList">
          {
            data && (
              <List
                text="BEER LOAD DETAILS"
                data={[
                  {
                    name: 'SHIP ID',
                    value: data.fields.shipment_id,
                  },
                  {
                    name: 'ORIGIN',
                    value: data.fields.origin_ib,
                  },
                  {
                    name: 'DESTINATION',
                    value: data.fields.destination_ib,
                  },
                  {
                    name: 'CDTY_CD',
                    value: data.fields.cdty_cd,
                  },
                  {
                    name: 'SRVC_CD',
                    value: data.fields.srvc_cd,
                  },
                  {
                    name: 'PULL_TIME',
                    value: data.fields.pull_tm,
                  },
                  {
                    name: 'SCHD_DROP',
                    value: data.fields.schd_drop,
                  },
                  {
                    name: 'EQUIPMENT TYPE',
                    value: data.fields.equipment_type,
                  },
                ]}
              />
            )
          }
          {
            data && (
              <List
                text="RECOMMENDED LOAD DETAILS"
                data={[
                  {
                    name: 'STATUS',
                    value: data.fields.status,
                  },
                  {
                    name: 'ORIGIN',
                    value: data.fields.origin_ob,
                  },
                  {
                    name: 'DESTINATION',
                    value: data.fields.destination_ob,
                  },
                  {
                    name: 'CONTACT',
                    value: data.fields.contact,
                    link: true
                  },
                  {
                    name: 'RATE POSTED',
                    value: data.fields.freight_rate,
                  },
                  {
                    name: 'PICK UP DATE/TIME',
                    value: data.fields.pick_up_date_time_ob,
                  },
                  {
                    name: 'DELIVERY DATE/TIME',
                    value: data.fields.delivery_date_time_ob,
                  },
                  {
                    name: 'EQUIPMENT TYPE',
                    value: data.fields.equipment_type,
                  },
                  {
                    name: 'WEIGHT',
                    value: data.fields.weight,
                  },
                  {
                    name: 'CLIENT',
                    value: data.fields.client_name,
                  },
                  // {
                  //   name: 'QUANTITY',
                  //   value: data.fields.quantity,
                  // },
                  // {
                  //   name: 'CUBE',
                  //   value: data.fields.cube,
                  // },
                ]}
              />
            )
          }
          {/* <div className="btn-group">
            <button className="btn"
              onClick={() => { update('BOOKED') }}
            >BOOK LOAD</button>
            <button className="btn"
              onClick={() => { update('PASSED') }}
            >PASS</button>
            <button className="btn"
              onClick={() => { update('CONFIRMED') }}
            >FINAL CONF</button>
          </div> */}
        </div>
        {
          data && (
            <Map
              fromCor={data.fields.origin_ob_geo.split(";").map((item) => 
                parseFloat(item)
              ).filter((item) => item).join(",")}
              toCor={data.fields.destination_ob_geo.split(";").map((item) => 
                parseFloat(item)
              ).filter((item) => item).join(",")}
              from={data.fields.origin_ob}
              to={data.fields.destination_ob}
            />
          )
        }
      </div>
      <div className="filterContainer" id="filters">
        {
          data && (
            <TripDetail
              data={data.fields}
              update={update}
            />
          )
        }
      </div>
      </div>
    </div>
  )
}

export default Main