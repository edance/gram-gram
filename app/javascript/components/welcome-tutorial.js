import { u } from 'umbrellajs';
import { trackEvent } from '../analytics';

document.addEventListener('turbolinks:load', function() {
  const $tutorial = u('.welcome-tutorial');
  const $steps = $('.step');
  let stepNum = 0;

  if ($tutorial.length === 0) {
    return;
  }

  u('.hero-cta-btn').on('click', () => {
    $tutorial.addClass('active');

    // Hide the footer
    $('footer').hide();

    $steps.eq(stepNum).fadeIn();

    trackEvent('Hero CTA Click');
  });

  u('.next-btn').on('click', (e) => {
    if (stepNum >= $steps.length - 1) {
      return;
    }

    e.preventDefault();

    trackEvent(`Step ${stepNum + 1} Click`);

    // Update the dots
    $('.dot.active').removeClass('active');
    $('.dot').eq(stepNum + 1).addClass('active');

    $steps.eq(stepNum).fadeOut(() => {
      stepNum += 1;
      $steps.eq(stepNum).fadeIn();

      // If last step, show the sign up text
      if (stepNum == $steps.length - 1) {
        $('.next-btn .d-none').removeClass('d-none');
      }
    });
  });
});
