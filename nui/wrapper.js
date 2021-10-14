const ui = Vue.createApp()

var app
var data

$(document).ready(function () {
window.addEventListener("message", (event) => {
switch (event.data.message) {
  case "app":
    if (event.data.app != null) {
        // Setting wrapper as top layer vue instance
        app = event.data.app
        ui.component("ui",{
            template: app
        })
        ui.mount("wrapper")
    }
    break;
  case "data":
    if (event.data.data != null) {
      data = event.data.data;
    }
    break;
  case "default":
    break;
}
});
});

