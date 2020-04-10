import { u } from 'umbrellajs';
import Masonry from 'masonry-layout';
import LazyLoad from 'vanilla-lazyload';

const CLOUDINARY_FETCH = 'https://res.cloudinary.com/gramgram/image/fetch/dpr_auto,c_scale,f_auto,w_250/';

// Add the images have data-src set
// This function calculates the devicePixelRatio
function setImageSrc(el) {
  const devicePixelRatio = Math.ceil(window.devicePixelRatio || 1);
  const $img = u(el);
  let src = $img.data('src');

  if (window.CLOUDINARY_ENABLED) {
    // Add cloudinary fetch
    src = `${CLOUDINARY_FETCH}${encodeURIComponent(src)}`;

    // Set the pixel ratio
    src = src.replace('dpr_auto', `dpr_${devicePixelRatio}.0`);
  }

  $img.data('src', src);
}

document.addEventListener('turbolinks:load', function() {
  const grid = document.querySelector('.photo-grid');

  if (!grid) {
    return;
  }

  u('.img-fluid').each(setImageSrc);

  const masonry = new Masonry(grid, {
    itemSelector: '.grid-item',
    columnWidth: '.grid-sizer',
    percentPosition: true
  });

  new LazyLoad({
    elements_selector: '.img-lazy',
    callback_loaded: () => masonry.layout(),
  });
});
