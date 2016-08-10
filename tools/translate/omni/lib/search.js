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
      React.createElement(Results, { results: this.searchResults() })
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

var Results = React.createClass({
  displayName: 'Results',

  render: function render() {
    return React.createElement(
      'div',
      null,
      this.props.results
    );
  }
});

exports.default = Search;