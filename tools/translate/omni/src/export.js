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

  handleClick: function(e) {
    e.preventDefault();

    if (!this.state.filename) {
      this.setState({message: 'Enter a filename!'});
      return;
    }
    if (!this.state.format) {
      this.setState({message: 'Choose a format!'});
      return;
    }
    console.log('Success');
    // stub
  },

  render: function() {
    return (
      <form>
        <Alert message={this.state.message} />
        <Filename onChange={this.handleFilenameChange} />
        <Format onChange={this.handleFormatChange} />
        <div className="form-group">
          <button className="btn btn-default btn-block" onClick={this.handleClick}>
            Export
          </button>
        </div>
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

export default Export;
