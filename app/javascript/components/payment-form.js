import { u } from 'umbrellajs';
import { loadScript } from '../utils';
import { colors, fonts } from '../variables';

function createCardElement(element, stripe) {
  // Create an instance of Elements.
  const elements = stripe.elements({
    fonts: [
      {
        cssSrc: 'https://fonts.googleapis.com/css?family=Poppins',
      },
    ],
  });

  const style = {

    base: {
      color: colors.black,
      fontFamily: fonts.base,
      fontSmoothing: 'antialiased',
      fontSize: '16px',
      '::placeholder': {
        color: '#6c757d',
      },
    },
    invalid: {
      color: colors.theme['danger'],
      iconColor: colors.theme['danger'],
    }
  };

  const classes = {
    base: 'form-control',
    invalid: 'is-invalid',
  };

  // Create an instance of the card Element.
  const card = elements.create('card', {classes, style});

  card.mount(element);

  return card;
}

// Handle real-time validation errors from the card Element.
function addListenersToCard(card, errorContainer) {
  card.addEventListener('change', function(event) {
    if (event.error) {
      errorContainer.textContent = event.error.message;
    } else {
      errorContainer.textContent = '';
    }
  });
}

// Submit the form with the token ID.
function stripeTokenHandler(form, token) {
  const input = u(form).find('.stripe-token-input');
  input.attr('value', token.id);

  // Submit the form
  form.submit();
}

function addListenersToForm(form, card, errorContainer, stripe) {
  form.addEventListener('submit', function(event) {
    event.preventDefault();

    errorContainer.textContent = '';

    stripe.createToken(card).then(function(result) {
      if (result.error) {
        // Inform the user if there was an error.
        errorContainer.textContent = result.error.message;

        // Unset spinner buttons
        form.dispatchEvent(new CustomEvent('error', { target: form }));
      } else {
        // Send the token to your server.
        stripeTokenHandler(form, result.token);
      }
    });
  });
}

document.addEventListener("turbolinks:load", function() {
  const $form = u('.payment-form');
  const $cardContainer = u('.card-input-group');

  if ($form.length === 0 || $cardContainer.length === 0) {
    return;
  }

  // prevent form submits without a stripe token
  $form.on('ajax:beforeSend', (e) => {
    const token = $form.find('.stripe-token-input').attr('value');
    if (!token) e.preventDefault();
  });

  loadScript('//js.stripe.com/v3/').then(() => {
    $form.each(element => {
      const cardElement = $cardContainer.find('.credit-card-input').first();
      const errorContainer = $cardContainer.find('.invalid-feedback').first();
      const stripe = window.Stripe(window.STRIPE_PUBLISHABLE_KEY);
      const card = createCardElement(cardElement, stripe);
      addListenersToCard(card, errorContainer);
      addListenersToForm(element, card, errorContainer, stripe);
    });
  });
});
