import { loadScript } from '../utils';

let photoUrl;

function createWidget() {
  return cloudinary.createUploadWidget({
    cloud_name: 'gramgram',
    uploadPreset: 'hwamb59g',
    multiple: false,
    resourceType: 'image',
    clientAllowedFormats: ['png', 'gif', 'jpeg'],
  }, function(error, result) {
    if (result && result.event === 'close' && photoUrl) {
      // Create photos through api
      console.log('creating photos', photoUrl);
      $.ajax({
        type: 'POST',
        url: '/api/photos',
        data: {
          photo: {
            url: photoUrl,
          },
        }
      }).then(function(resp) {
        const href = `/photos/${resp.id}/new`;
        Turbolinks.visit(href);
      });
    }

    if (!error && result && result.event === 'success') {
      photoUrl = result.info.url;
    }
  });
}

document.addEventListener("turbolinks:load", function() {
  const $button = $('.btn-upload');

  if ($button.length === 0) {
    return;
  }

  loadScript('//widget.cloudinary.com/v2.0/global/all.js').then(() => {
    const widget = createWidget();

    $('.btn-upload').click(function() {
      photoUrl = null;
      widget.open();
    });
  });
});
