"use strict";

var MagicalTranslator = React.createClass({
  displayName: "MagicalTranslator",

  getInitialState: function getInitialState() {
    return null;
  },
  handleScriptSelectChange: function handleScriptSelectChange(e) {
    var _this = this;

    var reader = new FileReader();
    reader.addEventListener("loadend", function () {
      _this.setState(JSON.parse(reader.result));
    });
    reader.readAsText(e.target.files.item(0));
  },
  render: function render() {
    return this.state ? React.createElement(Editor, null) : React.createElement(ScriptSelector, { callback: this.handleScriptSelectChange });
  }
});

var ScriptSelector = React.createClass({
  displayName: "ScriptSelector",

  render: function render() {
    return React.createElement(
      "form",
      null,
      React.createElement(
        "label",
        null,
        "Select script JSON file:"
      ),
      React.createElement("input", { className: "form-control", type: "file",
        onChange: this.props.callback })
    );
  }
});

var Editor = React.createClass({
  displayName: "Editor",

  render: function render() {
    return React.createElement(
      "div",
      { className: "row" },
      React.createElement(
        "div",
        { className: "col-md-2 sidebar" },
        React.createElement(
          "form",
          null,
          React.createElement(
            "label",
            null,
            " Binary format: "
          ),
          React.createElement(
            "div",
            { className: "form-group" },
            React.createElement(
              "select",
              { className: "form-control" },
              React.createElement(
                "option",
                null,
                "Magical Vacation"
              )
            )
          )
        ),
        React.createElement("hr", null),
        React.createElement(
          "form",
          null,
          React.createElement(
            "div",
            { className: "form-group" },
            React.createElement("input", { type: "search", className: "form-control", id: "search_text", placeholder: "Search for..." })
          ),
          React.createElement(
            "div",
            { className: "form-group" },
            React.createElement(
              "select",
              { className: "form-control" },
              React.createElement(
                "option",
                null,
                "Search source"
              ),
              React.createElement(
                "option",
                null,
                "Search translation"
              ),
              React.createElement(
                "option",
                null,
                "Search comments"
              )
            )
          )
        ),
        React.createElement("hr", null),
        React.createElement(
          "form",
          null,
          React.createElement(
            "div",
            { className: "form-group" },
            React.createElement(
              "button",
              { className: "btn btn-default btn-block", id: "export" },
              "Export"
            )
          )
        )
      ),
      React.createElement(
        "div",
        { className: "col-md-10" },
        React.createElement(
          "p",
          null,
          React.createElement(
            "label",
            null,
            "Line:"
          ),
          React.createElement("input", { id: "number", disabled: "true", type: "number", min: "0", max: "0", step: "1" }),
          "of ",
          React.createElement("span", { id: "max_number" })
        ),
        React.createElement(
          "p",
          null,
          React.createElement(
            "label",
            null,
            "Source:"
          ),
          React.createElement("span", { id: "source" })
        ),
        React.createElement(
          "p",
          null,
          React.createElement(
            "label",
            null,
            "Translation:"
          ),
          React.createElement("textarea", { id: "translation" })
        ),
        React.createElement(
          "p",
          null,
          React.createElement(
            "label",
            null,
            "Comment:"
          ),
          React.createElement("textarea", { id: "comment" })
        ),
        React.createElement("p", { id: "search_results" })
      )
    );
  }
});