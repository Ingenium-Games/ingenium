/* 
  Variables
*/

let Key = null;
let Slots = null;
let Characters = null;
let Character_ID = null;
let Created = null;
let First = null;
let Last = null;
let Login = null;
let Phone = null;
let City = null;

/* 
  Functions
*/

function character_select_register_events() {
  character_select_namer()
}

function character_select_namer() {
  $(".character-select-make").submit((e) => {
    if (e.defaultPrevented) {
      return; // Do nothing if the event was already processed
    }
    e.preventDefault();
  })
  .validate({
    rules: {
      FirstName: {
        minlength: 1,
        maxlength: 35,
        required: true,
      },
      LastName: {
        minlength: 1,
        maxlength: 35,
        required: true,
      },
    },
    submitHandler: function (form) {
      form.submit();
      character_select_make();
    },
  });
}



function character_select_connected(data) {
  if (data !== null) {
    $.each(data, function (index, value) {
      let cc = index + 1;
      if (cc <= Slots) {
        $(".character-select-row").prepend(
          '<a id="' +
            value.Character_ID +
            '" class=".character-select-character tooltip" onclick="character_select_selected(' +
            index +
            ')"><img src="' +
            value.Photo +
            '"/><span class="tooltiptext">' +
            value.First_Name +
            " " +
            value.Last_Name +
            "</span></a>"
        );
      }
      // Check permitted slot count vs already indexed.
      // If reached, then remove new button.
      if (cc == Slots) {
        $(".character-select-new").remove();
        return;
      }
    });
  }
}

function character_select_selected(key) {
  if (key === "New") {
    Character_ID = "New";
    // Show or Hide elements
    $(".character-select-options").show();
    $(".character-select-play").show();
    $(".character-select-kill").hide();
    // Set info to nothing.
    $(".character-select-information-name").text("New Character");
    $(".character-select-information-created").text("Click the tick");
    $(".character-select-information-lastseen").text("Click the tick");
    $(".character-select-information-city").text("Click the tick");
    $(".character-select-information-phone").text("Click the tick");
  } else {
    Character_ID = Characters[key].Character_ID;
    Key = Characters[key];
    Created = Number(Characters[key].Created) * 1000;
    First = Characters[key].First_Name;
    Last = Characters[key].Last_Name;
    Login = Number(Characters[key].Last_Seen) * 1000;
    Phone = Characters[key].Phone;
    City = Characters[key].City_ID;
    // Show or Hide elements
    $(".character-select-options").show();
    $(".character-select-play").show();
    $(".character-select-kill").show();
    // Set info to nothing.
    $(".character-select-information-name").text(First + " " + Last);
    $(".character-select-information-created").text(new Date(Created).toLocaleDateString("en-AU"));
    $(".character-select-information-lastseen").text(new Date(Login).toLocaleDateString("en-AU"));
    $(".character-select-information-city").text(City);
    $(".character-select-information-phone").text(Phone);
  }
}

function character_select_delete() {
  if (Character_ID !== null) {
    $.post(
      "https://ig.core/_character-select__delete",
      JSON.stringify({
        ID: Character_ID,
      })
    );
  }
}

function character_select_join() {
  if (Character_ID !== null) {
    $.post(
      "https://ig.core/_character-select__join",
      JSON.stringify({
        ID: Character_ID,
      })
    );
    $(".character-select-info").remove();
    $(".character-select-list").remove();
    $(".character-select-options").remove();
  }
}

function character_select_make() {
  // Prevent form from submitting
  var fn = document.getElementById("FirstName").value;
  var ln = document.getElementById("LastName").value;
  $.post(
    "https://ig.core/_character-select_register",
    JSON.stringify({
      First_Name: fn,
      Last_Name: ln,
    })
  );
  $(".character-select-make").remove();
}

// Called once JQuery has loaded
$(document).ready(function () {
  // Called on window being loaded
  window.onload = (e) => {
    // Add event handlers.
    character_select_register_events()
    // Adding listening event for data
    window.addEventListener("message", (e) => {
      if (e.defaultPrevented) {
        return; // Do nothing if the event was already processed
      }
      let message = e.data.message;
      let data = e.data.data;
      switch (message) {
        case "connected":
          // Set Variabels from data provided
          Characters = data.Characters;
          Slots = data.Slots;
          // run onjoin to get data displayed prior to showing lists.
          character_select_connected(Characters);
          // Show info and list
          $(".character-select-info").show();
          $(".character-select-list").show();
          break;
        case "register":
          $(".character-select-make").show();
          break;
        case "default":
          break;
      }
      e.preventDefault();
    });
  };
});
