import consumer from "./consumer"

consumer.subscriptions.create("PhotosChannel", {
  connected() {
    alert('connected');
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    alert('disconnected');
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('total_photo_count: ' + data['total_photo_count']);
    console.log('processed_photo_count: ' + data['processed_photo_count']);
    // Called when there's incoming data on the websocket for this channel
  }
});
