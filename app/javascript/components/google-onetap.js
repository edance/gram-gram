import { trackEvent } from '../analytics';
import { loadScript } from '../utils';

function handleCredentialResponse(res) {
  const $form = $('.google-onetap');
  $form.find('input[name=credential]').val(res.credential);
  trackEvent('Google Onetap Success');
  $form.submit();
}

document.addEventListener('turbolinks:load', function() {
  if ($('.google-onetap').length === 0) {
    return;
  }

  loadScript('//accounts.google.com/gsi/client').then(() => {
    google.accounts.id.initialize({
      client_id: window.GOOGLE_CLIENT_ID,
      callback: handleCredentialResponse
    });

    google.accounts.id.prompt((notification) => {
      if (notification.isDisplayed()) {
        trackEvent('Google Onetap Prompted');
      }
    });

  });
});
