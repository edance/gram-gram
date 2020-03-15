export function loadScript(url) {
  const script = document.createElement('script');
  script.src = url;
  script.async = true;
  const promise = new Promise((resolve, reject) => {
    script.onload = resolve;
    script.onerror = reject;
  });
  document.body && document.body.appendChild(script);
  return promise;
}

export function encodeGetParams(params) {
  return Object.entries(params).map(kv => kv.map(encodeURIComponent).join('=')).join('&');
}
