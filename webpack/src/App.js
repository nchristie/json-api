import React, { Component, PropTypes } from 'react';

export default class App extends Component {
  static propTyes = {
    children: PropTypes.element.isRequired,
  };

  render() {
    return (
      <div>
        <div className="page-container">
          // Navbar component

          <div className="wrapper">
            { this.props.children }
          </div>

          // Footer component
        </div>
      </div>
    );
  }
}
