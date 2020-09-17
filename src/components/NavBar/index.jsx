import React from 'react'
import './index.css'

// icons
import searchIcon from './search.svg'
import notification from './notification.svg'
import info from './info.svg'
import arrow from './arrow.svg'
import avatar from './avatar.svg'
import logo from './logo.svg'

const NavBar = () => {
  return (
    <div className="navbar">
      <div className="searchBlock">
        <div className="navbarLogo">
          <img
            style={{
              width: 161,
              marginTop: 14,
              marginLeft: 40
            }}
            src={logo}
            alt="navbarLogo"
          />
        </div>
        {/* <img
          className="searchIcon"
          src={searchIcon}
          alt="searchIcon"
        />
        <input
          placeholder="Search"
          className="search"
        /> */}
      </div>
      <div className="userInfo">
        <div className="icons">
          <img
            className="icon"
            src={notification}
            alt="notification"
          />
          <img
            className="icon"
            src={info}
            alt="info"
          />
        </div>
        <div className="userData">
          <p className="userName">
            Pavel Frank
          </p>
          <img
            className="avatar"
            src={avatar}
            alt="avatar"
          />
          <img
            className="arrow"
            src={arrow}
            alt="arrow"
          />
        </div>
      </div>
    </div>
  )
}

export default NavBar
