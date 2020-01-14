import Turbolinks from 'turbolinks';
import consumer from './consumer';
import { u } from 'umbrellajs';

let width = 0;

function setLoaderWidth($bar) {
  $bar.attr('style', `width: ${width}%`);
}

// first 70% linear, then wait
function incrementLoader($bar) {
  setTimeout(() => {
    if (width >= 70) {
      return;
    }

    width = width + 1;
    setLoaderWidth($bar, width);

    incrementLoader($bar);
  }, 400);
}

consumer.subscriptions.create('PhotosChannel', {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const $loader = u('.loading-bar');
    const $bar = $loader.find('.progress-bar');

    // first 70% linear, then wait
    if (data['started']) {
      $loader.removeClass('d-none');

      incrementLoader($bar);
    }

    if (data['ended']) {
      width = 100;
      setLoaderWidth($bar, 100);

      setTimeout(() => {
        $loader.addClass('d-none');

        Turbolinks.visit(window.location, {action: 'replace'});
      }, 1000);
    }
  }
});
