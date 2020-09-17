import React from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  useHistory,
  withRouter
} from "react-router-dom";
// logo
import logo from './logo.png'

// components
import NavBar from './components/NavBar'

// screens
import Main from './screens/Main'
import Second from './screens/Second'

export default function App() {
  return (
    <Router>
      <div>
        <NavBar />
        {/* A <Switch> looks through its children <Route>s and
            renders the first one that matches the current URL. */}
        <Switch>
          <Route path="/2">
            <Second />
          </Route>
          <Route path="/main">
            <Main />
          </Route>
          <Route path="/">
            <Home />
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

function Home() {
  let history = useHistory()
  console.log(history)
  return (
    <div className="container">
      <center>
        <img
          src={logo}
          alt="logo"
          style={{ width: '50%', height: '70%' }}
        />
      </center>
      <center>
        <button onClick={() => {
          history.push("/main")
        }} className="btn"
          style={{ width: 300, marginTop: 30 }}
        >Login</button>
      </center>
    </div>
  )
}

function About() {
  return <h2>About</h2>;
}

function Users() {
  return <h2>Users</h2>;
}
