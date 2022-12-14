
/*
    -- Notification Start
*/

//
function notification(data) {
    const colours = [
      "black",
      "blue",
      "orange",
      "red",
      "green",
      "pink",
      "purple",
      "yellow",
    ];
    let text = data.text;
    let colour = data.colour;
    let fade = data.fade;
    //
    let element = $('<div class="notification"></div>');
    //
    if (colours.indexOf(colour) !== -1) {
      $(element).addClass(colour);
    } else {
      $(element).addClass("black");
    }
    $(element).text(text);
    $(".notification-window").append(element);
    //
    $(element).fadeIn(750);
    setTimeout(function () {
      $(element).fadeOut(fade);
      setTimeout(function () {
        $(element).remove();
      }, fade);
    }, fade / 2);
  }
  /*
      -- Notification End
  */

      // Called once JQuery has loaded
$(document).ready(function () {
    // Called on window being loaded
    window.onload = (e) => {
      // Add event handlers.
      //
      // Adding listening event for data
      window.addEventListener("message", (e) => {
        if (e.defaultPrevented) {
          return; // Do nothing if the event was already processed
        }
        let message = e.data.message;
        let data = e.data.data;
        switch (message) {
          case "notification":
            notification(data);
            break;
          case "default":
            break;
        }
        e.preventDefault();
      });
    };
  });
  