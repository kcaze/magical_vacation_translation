"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
/* Renders a Bootstrap alert if the message property is specified
   else renders nothing */
var Alert = React.createClass({
  displayName: "Alert",

  render: function render() {
    if (this.props.message) {
      return React.createElement(
        "div",
        { className: "alert alert-danger" },
        this.props.message
      );
    } else {
      return null;
    }
  }
});

exports.Alert = Alert;