// Called once JQuery has loaded
$(document).ready(function () {
  // Called on window being loaded
  window.onload = (e) => {
    // Adding listening event for data
    window.addEventListener("message", (e) => {
      if (e.defaultPrevented) {
        return; // Do nothing if the event was already processed
      }
      let message = e.data.message;
      let data = e.data.data;
      switch (message) {
        // message is returned as nil, thus completed.
        case "default":
          break;
        // message is returned as ok, thus completed.
        case "ok":
          break;
        // message is returned as error, data is string.
        case "error":
          console.log(data)
          break;
      }
      e.preventDefault();
    });
    // Adding close window keypresses, default is esc, backspace, del
    window.onkeydown = (e) => {
      if (e.defaultPrevented) {
        return; // Do nothing if the event was already processed
      }
      switch (e.keyCode) {
        case 27: // esc
          _c__close();
          break;
        case 9: // backspace
          _c__close();
          break;
        case 46: // delete
          _c__close();
          break;
        default:
          return;
      }
      e.preventDefault();
    };
  };
});
// Close Function
function _c__close() {
  $.post(
    "https://ig.core/_c__close",
    JSON.stringify({message: "_c__close", data: {} })
  );
}
