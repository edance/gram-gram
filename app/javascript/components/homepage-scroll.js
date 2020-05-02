import * as ScrollMagic from 'scrollmagic';

document.addEventListener('turbolinks:load', function() {
	// init controller
	var controller = new ScrollMagic.Controller();

	// build scene
	new ScrollMagic.Scene({
    triggerElement: '#preview',
    triggerHook: 0.2,
    duration: '170%',
  }).setPin('#preview')
    .addTo(controller);

  new ScrollMagic.Scene({
    triggerElement: "#photo-section",
  }).setClassToggle("#preview", "active") // add class toggle
    .addTo(controller);

  new ScrollMagic.Scene({
    triggerElement: "#mail-section",
  }).setClassToggle("#preview", "flip") // add class toggle
    .addTo(controller);
});
