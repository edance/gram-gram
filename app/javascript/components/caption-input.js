function setCount() {
  const $input = $('.caption-input');
  const $message = $('.caption-input-msg');
  const max = $input.attr('maxlength');
  const count = $input.val().length;

  $message.text(`${count} / ${max}`);
}

document.addEventListener('turbolinks:load', function() {
  const $input = $('.caption-input');

  if ($input.length === 0) {
    return;
  }

  setCount();

  $input.on('keyup', setCount);
});
