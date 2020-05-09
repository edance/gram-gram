import * as ScrollMagic from 'scrollmagic';

document.addEventListener('turbolinks:load', function() {
  if ($('#preview').length === 0) {
    return;
  }

	// init controller
	var controller = new ScrollMagic.Controller();

	// build scene
	new ScrollMagic.Scene({
    triggerElement: '#preview',
    triggerHook: 0.2,
    duration: '150%',
  }).setPin('#preview')
    .addTo(controller);

  new ScrollMagic.Scene({
    triggerElement: "#photo-text",
  }).setClassToggle("#preview", "active") // add class toggle
    .addTo(controller);

  new ScrollMagic.Scene({
    triggerElement: "#mail-text",
  }).setClassToggle("#preview", "flip") // add class toggle
    .addTo(controller);
});
