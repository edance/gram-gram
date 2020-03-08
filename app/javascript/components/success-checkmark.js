document.addEventListener('turbolinks:load', function() {
  const $checkmark = $('.success-checkmark');

  if ($checkmark.length === 0) {
    return;
  }

  setTimeout(() => {
    $checkmark.toggle();
  }, 1000);
});
