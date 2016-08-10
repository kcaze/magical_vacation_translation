var Search = React.createClass({
  getInitialState: function() {
    return {
      query: null,
      option: 'source'
    }
  },
  handleQueryChange: function(query) {
    this.setState({query: query});
  },
  handleOptionChange: function(option) {
    this.setState({option: option});
  },
  searchResults: function() {
    if (!this.state.query || !this.state.option) {
      return null;
    }
    var results = [];
    for (const section of this.props.script) {
      for (var ii = 0; ii < section.length; ii++) {
        if (section[ii][this.state.option].includes(this.state.query)) {
          results.push(<p>{section.name}: {ii}</p>);
        }
      }
    }
    return React.createElement('div', {className: 'search-results'}, ...results);
  },
  render: function() {
    return (
      <div>
        <form>
          <Searchbar onChange={this.handleQueryChange} />
          <Options onChange={this.handleOptionChange} />
        </form>
        <div>
          {this.searchResults()}
        </div>
      </div>
    );
  }
});

var Searchbar = React.createClass({
  onChange: function() {
    var value = this.refs.input.value;
    this.props.onChange(value == '' ? null : value);
  },
  render: function() {
    return (
      <div className="form-group">
        <input type="search" className="form-control" onChange={this.onChange}
               ref="input" placeholder="Search for..." />
      </div>
    );
  }
});

var Options = React.createClass({
  onChange: function() {
    this.props.onChange(this.refs.input.value);
  },
  render: function() {
    return (
      <div className="form-group">
        <select ref="input" className="form-control" onChange={this.onChange}>
          <option value='source'>Search source</option>
          <option value='translation'>Search translation</option>
          <option value='comment'>Search comments</option>
        </select>
      </div>
    );
  }
});

export default Search;
