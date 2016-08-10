import { Alert } from './common.js'

var Export = React.createClass({
  getInitialState: function() {
    return {
      filename: null,
      format: null,
      message: null
    }
  },

  handleFilenameChange: function(filename) {
    this.setState({filename: filename});
  },

  handleFormatChange: function(format) {
    this.setState({format: format});
  },

  handleExportFail: function(message) {
    this.setState({message: message});
  },

  handleExportSuccess: function(message) {
    this.setState({message: null});
  },

  render: function() {
    return (
      <form>
        <Alert message={this.state.message} />
        <Filename onChange={this.handleFilenameChange} />
        <Format onChange={this.handleFormatChange} />
        <ExportButton filename={this.state.filename}
                      format={this.state.format}
                      script={this.props.script}
                      onFail={this.handleExportFail}
                      onSuccess={this.handleExportSuccess} />
      </form>
    );
  }
});

var Filename = React.createClass({
  onChange: function() {
    var value = this.refs.input.value;
    this.props.onChange(value == '' ? null : value)
  },
  render: function() {
    return (
      <div className="form-group">
        <input type="text" className="form-control" onChange={this.onChange}
               placeholder="Filename" ref="input" />
      </div>
    );
  }
});

var Format = React.createClass({
  onChange: function() {
    var value = this.refs.input.value;
    this.props.onChange(value == '' ? null : value)
  },
  render: function() {
    return (
      <div className="form-group">
        <select className="form-control" ref="input" onChange={this.onChange}>
          <option value=''>-Format-</option>
          <option value="magical_vacation">Magical Vacation</option>
        </select>
      </div>
    );
  }
});

var ExportButton = React.createClass({
  onClick: function(e) {
    e.preventDefault();

    try {
      exportScript(this.props.filename,
                   this.props.format,
                   this.props.script);
      this.props.onSuccess();
    } catch (error) {
      this.props.onFail(error);
    }
  },

  render: function() {
    return (
      <div className="form-group">
        <button className="btn btn-default btn-block" onClick={this.onClick}>
          Export
        </button>
      </div>
    );
  }
});

/* Exports script. Throws exceptions on failure */
function exportScript(filename, format, script) {
  if (!filename) throw "Missing filename!"
  if (!format) throw "Missing format!"
  if (!script) throw "Missing script!"

  // Export JSON.
  try {
    var JSONblob = new Blob([JSON.stringify(script)],
                            {type: 'text/plain;charset=utf-8'});
    saveAs(JSONblob,  `${filename}.json`)
  } catch (e) {
    throw 'Failed to export JSON!';
  }
}

export default Export;
