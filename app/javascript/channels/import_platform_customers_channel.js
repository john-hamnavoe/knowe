import consumer from "./consumer"

consumer.subscriptions.create("ImportPlatformCustomersChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("import_platform_customers", data)
    const div_locale = document.getElementById(`platform_customers_browser`);
    if (div_locale)
    { 
      location.reload();
    }
  }
});
