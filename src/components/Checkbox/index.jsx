import React, { useState } from 'react'
import './index.css'
import checkedIcon from './checked.svg'
import unchekedIcon from './unchecked.svg'

const Checkbox = ({ name, label, change }) => {
  const [checked, setchecked] = useState(false)
  return (
    <div className="checkbox" onClick={() => {
      setchecked(!checked)
      change(name, !checked)
    }}>
      <img
        src={checked ? checkedIcon : unchekedIcon}
        alt="checkedIcon"
      />
      <p className="checkLabel">{label}</p>
    </div>
  )
}

export default Checkbox
