/* Renders a Bootstrap alert if the message property is specified
   else renders nothing */
var Alert = React.createClass({
  render: function() {
    if (this.props.message) {
      return (
        <div className="alert alert-danger">
          {this.props.message}
        </div>
      );
    } else {
      return null;
    }
  }
});

export { Alert };
