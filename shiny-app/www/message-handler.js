// Custom message handler for logging
Shiny.addCustomMessageHandler("logmessage",
  function(message) {
    alert(JSON.stringify(message));
  }
);