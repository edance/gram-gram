import { loadScript } from '../utils';

let photosUploaded = [];

function createWidget() {
  return cloudinary.createUploadWidget({
    cloud_name: 'gramgram',
    uploadPreset: 'hwamb59g',
    multiple: false,
    resourceType: 'image',
    clientAllowedFormats: ['png', 'gif', 'jpeg'],
  }, function(error, result) {
    if (result && result.event === 'close') {
      // Create photos through api
      console.log('creating photos', photosUploaded);
    }

    if (!error && result && result.event === 'success') {
      photosUploaded.push(result.info.url);
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
      photosUploaded = [];
      widget.open();
    });
  });
});
