import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

class ProductApp extends Component {
  render() {
    return (
      <div className="products">
        Products
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  people: selectors.getOrderedPeople(state),
});

const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators(actions, dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(PeopleApp);
