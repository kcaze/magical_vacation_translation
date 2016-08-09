import { Alert } from 'common'

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

  handleClick: function() {
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
  render: function() {
    return (
      <div className="form-group">
        <label> Filename: </label>
        <input type="text" className="form-control" onChange={this.props.onChange}/>
      </div>
    );
  }
});

var Format = React.createClass({
  render: function() {
    return (
      <div className="form-group">
        <label> Binary format: </label>
        <select className="form-control" onChange={this.props.onChange}>
          <option>Magical Vacation</option>
        </select>
      </div>
    );
  }
});

export default Export;
