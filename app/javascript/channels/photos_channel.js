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
    const $bar = u('.photos-loading-bar .progress-bar');

    if (data['ended']) {
      width = 100;
      setLoaderWidth($bar, 100);

      setTimeout(() => {
        const $link = u('.photos-link');
        const href = $link.attr('href') || '/app';

        Turbolinks.visit(href, {action: 'replace'});
      }, 1000);
    }
  }
});

document.addEventListener('turbolinks:load', function() {
  const $bar = u('.photos-loading-bar .progress-bar');

  if ($bar.length === 0) {
    return;
  }

  incrementLoader($bar);
});
