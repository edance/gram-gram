import autocomplete from 'autocomplete.js';
import { u } from 'umbrellajs';
import { encodeGetParams } from '../utils';

import 'whatwg-fetch';

const MAPBOX_URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

function searchMapbox(query) {
  const params = {
    access_token: window.MAPBOX_ACCESS_TOKEN,
    types: 'address',
    country: 'US',
  };
  const url = `${MAPBOX_URL}/${encodeURIComponent(query)}.json?${encodeGetParams(params)}`;
  return fetch(url);
}

function decodeMapboxSuggestion(suggestion) {
  const primaryLine = [suggestion.address, suggestion.text].filter(x => x).join(' ');
  const context = suggestion.context;
  const address = {};
  context.forEach((item) => address[item.id.split('.')[0]] = item.text);

  return {
    primary_line: primaryLine,
    city: address['place'],
    state: address['region'],
    zip: address['postcode'],
  };
}

function source(query, callback) {
  searchMapbox(query)
    .then(resp => Promise.all([resp, resp.text()]))
    .then(([_, body]) => {
      const data = JSON.parse(body);
      callback(data.features);
    });
}

function selectSuggestion(input, suggestion) {
  const address = decodeMapboxSuggestion(suggestion);
  input.autocomplete.setVal(address.primary_line);
  u('.address-city').attr('value', address.city);
  u('.address-state').attr('value', address.state);
  u('.address-zip').attr('value', address.zip);
}

const globalOptions = {
  hint: false,
  minLength: 3,
};

document.addEventListener('turbolinks:load', function() {
  const input = autocomplete('.address-search', globalOptions, [
    {
      debounce: 500, // 500 ms
      source: source,
      templates: {
        suggestion: function(suggestion) {
          const address = decodeMapboxSuggestion(suggestion);
          return `${address.primary_line}, ${address.city}, ${address.state} ${address.zip}`;
        }
      }
    }
  ]);

  input.on('autocomplete:selected', (_, suggestion) => selectSuggestion(input, suggestion));
});
