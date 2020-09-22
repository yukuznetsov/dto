import React, { Component } from 'react';
import GoogleMapReact from 'google-map-react';
import TripView from './TripView'

class SimpleMap extends Component {
  state = {
    center: {
      lat: 59.95,
      lng: 30.33
    },
    zoom: 7
  };
 
  componentDidMount() {
    this.setState({
      center: {
        lat: parseFloat(this.props.fromCor[0]),
        lng: parseFloat(this.props.toCor[1])
      }
    })  
  }
  
  handleApiLoaded = (map, maps) => {
    if(!this.props.route){
      var directionsDisplay = new maps.DirectionsRenderer;
      var directionsService = new maps.DirectionsService;
      var directionsDisplay = new maps.DirectionsRenderer;
      directionsDisplay.setMap(map);

      directionsService.route({
        origin: this.props.fromCor,
        destination: this.props.toCor,
        travelMode: 'DRIVING'
      }, function(response, status) {
        if (status === 'OK') {
          directionsDisplay.setDirections(response);
        } else {
          window.alert('Directions request failed due to ' + status);
        }
      });

    }
  }

  render() {
    return (
      // Important! Always set the container height explicitly
      <div style={{ height: '400px', width: '100%', marginTop: '20px', position: 'relative' }}>
        <div className="tripDetail">
          <div className="tripContainer">
            <p className="tripTitle">TRIP DETAILS</p>
            <div className="routeData">
              <TripView
                from={this.props.from}
                to={this.props.to}
              />
              {/* <img
                src={routeIcon}
                alt="routeIcon"
              /> */}
            </div>
          </div>
        </div>
        <GoogleMapReact
          bootstrapURLKeys={{ key: 'AIzaSyB8VIPnEHz-PQNP_gi6bbLEZbmzb54GMYk' }}
          defaultCenter={this.state.center}
          defaultZoom={this.state.zoom}
          yesIWantToUseGoogleMapApiInternals
          onGoogleApiLoaded={({ map, maps }) => this.handleApiLoaded(map, maps)}        
        ></GoogleMapReact>
      </div>
    );
  }
}
 
export default SimpleMap;
