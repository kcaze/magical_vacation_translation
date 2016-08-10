import Export from './export.js'
import Search from './search.js'

var MagicalTranslator = React.createClass({
  getInitialState: function() {
    return {
      script: null
    };
  },
  handleScriptSelectChange: function(e) {
    var reader = new FileReader();
    reader.addEventListener("loadend", () => {
      this.setState({script: JSON.parse(reader.result)});
    });
    reader.readAsText(e.target.files.item(0));
  },
  handleScriptChange: function(script) {
    this.setState({script: script});
  },
  renderMain: function() {
    return (
      <div className="row">
        <Sidebar script={this.state.script} />
        <div className="col-md-10">
        </div>
      </div>
    );
  },
  renderScriptSelector: function() {
    return <ScriptSelector callback={this.handleScriptSelectChange}/>;
  },
  render: function() {
    return this.state.script ? this.renderMain() : this.renderScriptSelector();
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

var Sidebar = React.createClass({
  render: function() {
    return (
      <div className="col-md-2 sidebar">
        <Export script={this.props.script} />
        <hr />
        <Search script={this.props.script} />
      </div>
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
          <span id="source">{this.props.script[0][28].source}</span>
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

export default MagicalTranslator;
