var MagicalTranslator = React.createClass({
  getInitialState: function() {
    return null;
  },
  handleScriptSelectChange: function(e) {
    var reader = new FileReader();
    reader.addEventListener("loadend", () => {
      this.setState(JSON.parse(reader.result));
    });
    reader.readAsText(e.target.files.item(0));
  },
  render: function() {
    return (this.state
            ? <Editor />
            : <ScriptSelector callback={this.handleScriptSelectChange}/>);
  }
});

var ScriptSelector = React.createClass({
  render: function() {
    return (
      <form>
        <label>Select script JSON file:</label>
        <input className="form-control" type="file"
               onChange={this.props.callback} />
      </form>
    );
  }
});

var Editor = React.createClass({
  render: function() {
    return (
      <div className="row">
      <div className="col-md-2 sidebar">
        <form>
          <label> Binary format: </label>
          <div className="form-group">
            <select className="form-control">
              <option>Magical Vacation</option>
            </select>
          </div>
        </form>

        <hr />

        <form>
          <div className="form-group">
            <input type="search" className="form-control" id="search_text" placeholder="Search for..." />
          </div>
          <div className="form-group">
            <select className="form-control">
              <option>Search source</option>
              <option>Search translation</option>
              <option>Search comments</option>
            </select>
          </div>
        </form>

        <hr />

        <form>
          <div className="form-group">
            <button className="btn btn-default btn-block" id="export">Export</button>
          </div>
        </form>
      </div>

      <div className="col-md-10">
        <p>
          <label>Line:</label>
          <input id="number" disabled="true" type="number" min="0" max="0" step="1"/>
          of <span id="max_number"></span>
        </p>

        <p>
          <label>Source:</label>
          <span id="source"></span>
        </p>

        <p>
          <label>Translation:</label>
          <textarea id="translation"></textarea>
        </p>

        <p>
          <label>Comment:</label>
          <textarea id="comment"></textarea>
        </p>

        <p id="search_results">
        </p>
      </div>
      </div>
    );
  }
});
