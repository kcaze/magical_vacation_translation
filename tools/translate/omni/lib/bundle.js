(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
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
},{}],2:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _export = require('./export.js');

var _export2 = _interopRequireDefault(_export);

var _search = require('./search.js');

var _search2 = _interopRequireDefault(_search);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var MagicalTranslator = React.createClass({
  displayName: 'MagicalTranslator',

  getInitialState: function getInitialState() {
    return {
      script: null
    };
  },
  handleScriptSelectChange: function handleScriptSelectChange(e) {
    var _this = this;

    var reader = new FileReader();
    reader.addEventListener("loadend", function () {
      _this.setState({ script: JSON.parse(reader.result) });
    });
    reader.readAsText(e.target.files.item(0));
  },
  handleScriptChange: function handleScriptChange(script) {
    this.setState({ script: script });
  },
  renderMain: function renderMain() {
    return React.createElement(
      'div',
      { className: 'row' },
      React.createElement(Sidebar, { script: this.state.script }),
      React.createElement('div', { className: 'col-md-10' })
    );
  },
  renderScriptSelector: function renderScriptSelector() {
    return React.createElement(ScriptSelector, { callback: this.handleScriptSelectChange });
  },
  render: function render() {
    return this.state.script ? this.renderMain() : this.renderScriptSelector();
  }
});

var ScriptSelector = React.createClass({
  displayName: 'ScriptSelector',

  render: function render() {
    return React.createElement(
      'form',
      null,
      React.createElement(
        'label',
        null,
        'Select script JSON file:'
      ),
      React.createElement('input', { className: 'form-control', type: 'file',
        onChange: this.props.callback })
    );
  }
});

var Sidebar = React.createClass({
  displayName: 'Sidebar',

  render: function render() {
    return React.createElement(
      'div',
      { className: 'col-md-2 sidebar' },
      React.createElement(_export2.default, { script: this.props.script }),
      React.createElement('hr', null),
      React.createElement(_search2.default, { script: this.props.script })
    );
  }
});

var Editor = React.createClass({
  displayName: 'Editor',

  render: function render() {
    return React.createElement(
      'div',
      { className: 'row' },
      React.createElement(
        'div',
        { className: 'col-md-2 sidebar' },
        React.createElement(
          'form',
          null,
          React.createElement(
            'label',
            null,
            ' Binary format: '
          ),
          React.createElement(
            'div',
            { className: 'form-group' },
            React.createElement(
              'select',
              { className: 'form-control' },
              React.createElement(
                'option',
                null,
                'Magical Vacation'
              )
            )
          )
        ),
        React.createElement('hr', null),
        React.createElement(
          'form',
          null,
          React.createElement(
            'div',
            { className: 'form-group' },
            React.createElement('input', { type: 'search', className: 'form-control', id: 'search_text', placeholder: 'Search for...' })
          ),
          React.createElement(
            'div',
            { className: 'form-group' },
            React.createElement(
              'select',
              { className: 'form-control' },
              React.createElement(
                'option',
                null,
                'Search source'
              ),
              React.createElement(
                'option',
                null,
                'Search translation'
              ),
              React.createElement(
                'option',
                null,
                'Search comments'
              )
            )
          )
        ),
        React.createElement('hr', null),
        React.createElement(
          'form',
          null,
          React.createElement(
            'div',
            { className: 'form-group' },
            React.createElement(
              'button',
              { className: 'btn btn-default btn-block', id: 'export' },
              'Export'
            )
          )
        )
      ),
      React.createElement(
        'div',
        { className: 'col-md-10' },
        React.createElement(
          'p',
          null,
          React.createElement(
            'label',
            null,
            'Line:'
          ),
          React.createElement('input', { id: 'number', disabled: 'true', type: 'number', min: '0', max: '0', step: '1' }),
          'of ',
          React.createElement('span', { id: 'max_number' })
        ),
        React.createElement(
          'p',
          null,
          React.createElement(
            'label',
            null,
            'Source:'
          ),
          React.createElement(
            'span',
            { id: 'source' },
            this.props.script[0][28].source
          )
        ),
        React.createElement(
          'p',
          null,
          React.createElement(
            'label',
            null,
            'Translation:'
          ),
          React.createElement('textarea', { id: 'translation' })
        ),
        React.createElement(
          'p',
          null,
          React.createElement(
            'label',
            null,
            'Comment:'
          ),
          React.createElement('textarea', { id: 'comment' })
        ),
        React.createElement('p', { id: 'search_results' })
      )
    );
  }
});

exports.default = MagicalTranslator;
},{"./export.js":3,"./search.js":5}],3:[function(require,module,exports){
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
},{"./common.js":1}],4:[function(require,module,exports){
'use strict';

var _components = require('./components.js');

var _components2 = _interopRequireDefault(_components);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

ReactDOM.render(React.createElement(_components2.default, null), $('#content')[0]);
},{"./components.js":2}],5:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
var Search = React.createClass({
  displayName: 'Search',

  getInitialState: function getInitialState() {
    return {
      query: null,
      option: 'source'
    };
  },
  handleQueryChange: function handleQueryChange(query) {
    this.setState({ query: query });
  },
  handleOptionChange: function handleOptionChange(option) {
    this.setState({ option: option });
  },
  searchResults: function searchResults() {
    var _React;

    if (!this.state.query || !this.state.option) {
      return null;
    }
    var results = [];
    var _iteratorNormalCompletion = true;
    var _didIteratorError = false;
    var _iteratorError = undefined;

    try {
      for (var _iterator = this.props.script[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
        var section = _step.value;

        for (var ii = 0; ii < section.length; ii++) {
          if (section[ii][this.state.option].includes(this.state.query)) {
            results.push(React.createElement(
              'p',
              null,
              section.name,
              ': ',
              ii
            ));
          }
        }
      }
    } catch (err) {
      _didIteratorError = true;
      _iteratorError = err;
    } finally {
      try {
        if (!_iteratorNormalCompletion && _iterator.return) {
          _iterator.return();
        }
      } finally {
        if (_didIteratorError) {
          throw _iteratorError;
        }
      }
    }

    return (_React = React).createElement.apply(_React, ['div', { className: 'search-results' }].concat(results));
  },
  render: function render() {
    return React.createElement(
      'div',
      null,
      React.createElement(
        'form',
        null,
        React.createElement(Searchbar, { onChange: this.handleQueryChange }),
        React.createElement(Options, { onChange: this.handleOptionChange })
      ),
      React.createElement(
        'div',
        null,
        this.searchResults()
      )
    );
  }
});

var Searchbar = React.createClass({
  displayName: 'Searchbar',

  onChange: function onChange() {
    var value = this.refs.input.value;
    this.props.onChange(value == '' ? null : value);
  },
  render: function render() {
    return React.createElement(
      'div',
      { className: 'form-group' },
      React.createElement('input', { type: 'search', className: 'form-control', onChange: this.onChange,
        ref: 'input', placeholder: 'Search for...' })
    );
  }
});

var Options = React.createClass({
  displayName: 'Options',

  onChange: function onChange() {
    this.props.onChange(this.refs.input.value);
  },
  render: function render() {
    return React.createElement(
      'div',
      { className: 'form-group' },
      React.createElement(
        'select',
        { ref: 'input', className: 'form-control', onChange: this.onChange },
        React.createElement(
          'option',
          { value: 'source' },
          'Search source'
        ),
        React.createElement(
          'option',
          { value: 'translation' },
          'Search translation'
        ),
        React.createElement(
          'option',
          { value: 'comment' },
          'Search comments'
        )
      )
    );
  }
});

exports.default = Search;
},{}]},{},[4]);
