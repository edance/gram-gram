export function trackEvent(eventName) {
  window.dataLayer = window.dataLayer || [];
  window.dataLayer.push({'event': eventName});
}
