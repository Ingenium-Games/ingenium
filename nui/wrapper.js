
// app is the returned html of the app being imported.
const apps 
//
const data

// Vue instance the prefix "ui"
const ui = Vue.createApp({data(){return data}})

$(document).ready(function () {
  window.addEventListener("message", (event) => {
  switch (event.data.Message) {
    case "NewApp":
      if (event.data.IsNew != null || event.data.IsNew != false) {
          // Setting wrapper as top layer vue instance
          apps[event.data.Name] = {App: event.data.App}
          data[event.data.Name] = {Data: event.data.Data}
          ui.component("ui-" + event.data.Name,{
              template: apps[apps.length].App
          })
          ui.mount("wrapper")
      }
      break;
    case "UpdateApp":
      if (event.data.Update != null && event.data.Name != null && event.data.Data != null) {
        if (apps[event.data.Name] != event.data.Name) {
          data[event.data.Name] = {Data: event.data.Data}
        } 
      }
      break;
    case "RebuildApp":
      if (event.data.Name != null) {
        ui.component("ui-" + event.data.Name)
        
      }
      break;
    case "default":
      break;
  }
  });
});