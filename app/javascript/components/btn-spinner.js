import { u } from 'umbrellajs';

function startSpin(button) {
  const $button = u(button);
  const width = $button.size().width;
  const text = $button.html();

  $button.attr('disabled', true);
  $button.data('text', text);
  $button.attr('style', `width: ${width}px`);
  $button.html(`
    <div class="spinner-border spinner-border-sm" role="status">
      <span class="sr-only">Loading...</span>
    </div>
  `);
}

function stopSpin(button) {
  const text = button.dataset.text;
  button.removeAttribute('disabled');
  button.innerHTML = text;
}

document.addEventListener("turbolinks:load", function() {
  u('form').on('submit', (e) => {
    u(e.target)
      .find('button.btn-spinner')
      .each(el => startSpin(el));
  });

  u('form').on('error', (e) => {
    u(e.target)
      .find('button.btn-spinner')
      .each(el => stopSpin(el));
  });
});
