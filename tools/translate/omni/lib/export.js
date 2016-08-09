"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _common = require("common");

var Export = React.createClass({
  displayName: "Export",

  getInitialState: function getInitialState() {
    return {
      filename: null,
      format: null,
      message: null
    };
  },

  handleFilenameChange: function handleFilenameChange(filename) {
    this.setState({ filename: filename });
  },

  handleFormatChange: function handleFormatChange(format) {
    this.setState({ format: format });
  },

  handleClick: function handleClick() {
    // stub
  },

  render: function render() {
    return React.createElement(
      "form",
      null,
      React.createElement(_common.Alert, { message: this.state.message }),
      React.createElement(Filename, { onChange: this.handleFilenameChange }),
      React.createElement(Format, { onChange: this.handleFormatChange }),
      React.createElement(
        "div",
        { className: "form-group" },
        React.createElement(
          "button",
          { className: "btn btn-default btn-block", onClick: this.handleClick },
          "Export"
        )
      )
    );
  }
});

var Filename = React.createClass({
  displayName: "Filename",

  render: function render() {
    return React.createElement(
      "div",
      { className: "form-group" },
      React.createElement(
        "label",
        null,
        " Filename: "
      ),
      React.createElement("input", { type: "text", className: "form-control", onChange: this.props.onChange })
    );
  }
});

var Format = React.createClass({
  displayName: "Format",

  render: function render() {
    return React.createElement(
      "div",
      { className: "form-group" },
      React.createElement(
        "label",
        null,
        " Binary format: "
      ),
      React.createElement(
        "select",
        { className: "form-control", onChange: this.props.onChange },
        React.createElement(
          "option",
          null,
          "Magical Vacation"
        )
      )
    );
  }
});

exports.default = Export;