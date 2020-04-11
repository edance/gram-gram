import { u } from 'umbrellajs';

function startSpin(button) {
  const $button = u(button);
  const width = $button.size().width;
  $button.attr('disabled', true);
  $button.attr('style', `width: ${width}px`);
  $button.html(`
    <div class="spinner-border spinner-border-sm" role="status">
      <span class="sr-only">Loading...</span>
    </div>
  `);
}

document.addEventListener("turbolinks:load", function() {
  u('form').on('submit', (e) => {
    u(e.target)
      .find('button.btn-spinner')
      .each(el => startSpin(el));
  });
});
