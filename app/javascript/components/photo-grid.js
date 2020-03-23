import Masonry from 'masonry-layout';

document.addEventListener('turbolinks:load', function() {
  const grid = document.querySelector('.photo-grid');

  new Masonry(grid, {
    itemSelector: '.grid-item',
    columnWidth: '.grid-sizer',
    percentPosition: true
  });
});
