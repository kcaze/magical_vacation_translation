'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _common = require('./common.js');

var Export = React.createClass({
  displayName: 'Export',

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

  handleClick: function handleClick(e) {
    e.preventDefault();

    if (!this.state.filename) {
      this.setState({ message: 'Enter a filename!' });
      return;
    }
    if (!this.state.format) {
      this.setState({ message: 'Choose a format!' });
      return;
    }
    console.log('Success');
    // stub
  },

  render: function render() {
    return React.createElement(
      'form',
      null,
      React.createElement(_common.Alert, { message: this.state.message }),
      React.createElement(Filename, { onChange: this.handleFilenameChange }),
      React.createElement(Format, { onChange: this.handleFormatChange }),
      React.createElement(
        'div',
        { className: 'form-group' },
        React.createElement(
          'button',
          { className: 'btn btn-default btn-block', onClick: this.handleClick },
          'Export'
        )
      )
    );
  }
});

var Filename = React.createClass({
  displayName: 'Filename',

  onChange: function onChange() {
    var value = this.refs.input.value;
    this.props.onChange(value == '' ? null : value);
  },
  render: function render() {
    return React.createElement(
      'div',
      { className: 'form-group' },
      React.createElement('input', { type: 'text', className: 'form-control', onChange: this.onChange,
        placeholder: 'Filename', ref: 'input' })
    );
  }
});

var Format = React.createClass({
  displayName: 'Format',

  onChange: function onChange() {
    var value = this.refs.input.value;
    this.props.onChange(value == '' ? null : value);
  },
  render: function render() {
    return React.createElement(
      'div',
      { className: 'form-group' },
      React.createElement(
        'select',
        { className: 'form-control', ref: 'input', onChange: this.onChange },
        React.createElement(
          'option',
          { value: '' },
          '-Format-'
        ),
        React.createElement(
          'option',
          { value: 'magical_vacation' },
          'Magical Vacation'
        )
      )
    );
  }
});

exports.default = Export;