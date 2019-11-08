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
