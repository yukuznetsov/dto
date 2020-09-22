import React from 'react'
import './index.css'

const List = ({data, text}) => {
  return (
    <div className="list">
      <h1 className="listTitle">{text}</h1>
      <div className="listView">
        <table className="listTable">
          {
            data && (
              data.map((item) => 
                <tr>
                  <td>
                    <p className="listTableTitle">{item.name}</p>
                  </td>
                  <td style={{ textAlign: 'right' }}>
                    <p className={item.link ? "link" : "listTableValue"}>{item.value}</p>
                  </td>
                </tr>
              )
            )
          }
        </table>
      </div>
    </div>
  )
}

export default List
