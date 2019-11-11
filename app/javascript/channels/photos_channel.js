import consumer from "./consumer"

consumer.subscriptions.create("PhotosChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('total_media_count: ' + data['total_media_count']);
    console.log('processed_media_count: ' + data['processed_media_count']);
    // Called when there's incoming data on the websocket for this channel
  }
});
