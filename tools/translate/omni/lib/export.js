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

  handleExportFail: function handleExportFail(message) {
    this.setState({ message: message });
  },

  handleExportSuccess: function handleExportSuccess(message) {
    this.setState({ message: null });
  },

  render: function render() {
    return React.createElement(
      'form',
      null,
      React.createElement(_common.Alert, { message: this.state.message }),
      React.createElement(Filename, { onChange: this.handleFilenameChange }),
      React.createElement(Format, { onChange: this.handleFormatChange }),
      React.createElement(ExportButton, { filename: this.state.filename,
        format: this.state.format,
        script: this.props.script,
        onFail: this.handleExportFail,
        onSuccess: this.handleExportSuccess })
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

var ExportButton = React.createClass({
  displayName: 'ExportButton',

  onClick: function onClick(e) {
    e.preventDefault();

    try {
      exportScript(this.props.filename, this.props.format, this.props.script);
      this.props.onSuccess();
    } catch (error) {
      this.props.onFail(error);
    }
  },

  render: function render() {
    return React.createElement(
      'div',
      { className: 'form-group' },
      React.createElement(
        'button',
        { className: 'btn btn-default btn-block', onClick: this.onClick },
        'Export'
      )
    );
  }
});

/* Exports script. Throws exceptions on failure */
function exportScript(filename, format, script) {
  if (!filename) throw "Missing filename!";
  if (!format) throw "Missing format!";
  if (!script) throw "Missing script!";

  // Export JSON.
  try {
    var JSONblob = new Blob([JSON.stringify(script)], { type: 'text/plain;charset=utf-8' });
    saveAs(JSONblob, filename + '.json');
  } catch (e) {
    throw 'Failed to export JSON!';
  }
}

exports.default = Export;