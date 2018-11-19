---
---
const mapStyle = [
  {
    "featureType": "administrative",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "on"
      },
      {
        "lightness": 33
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "all",
    "stylers": [
      {
        "color": "#f2e5d4"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c5dac6"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "on"
      },
      {
        "lightness": 20
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "all",
    "stylers": [
      {
        "lightness": 20
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c5c6c6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e4d7c6"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fbfaf7"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "all",
    "stylers": [
      {
        "visibility": "on"
      },
      {
        "color": "#acbcc9"
      }
    ]
  }
];

function initMap() {

  // Create the map
  const map = new google.maps.Map(document.getElementsByClassName('map')[0], {
    zoom: 4,
    center: {
      lat: 38.701105,
      lng: -93.227645
    },
		styles: mapStyle
  });

	map.data.addGeoJson(test);

	const infoWindow = new google.maps.InfoWindow();

  map.data.addListener('click', event => {

    let farm_name = event.feature.getProperty('farm_name');
    let owner = event.feature.getProperty('owner');
    let street = event.feature.getProperty('street');
    let city = event.feature.getProperty('city');
    let state = event.feature.getProperty('state');
    let zip = event.feature.getProperty('zip');
    let phone1 = event.feature.getProperty('phone1');
    let phone2 = event.feature.getProperty('phone2');
    let email = event.feature.getProperty('email');
    let website = event.feature.getProperty('website');

    let position = event.feature.getGeometry().get();
    let content = `
      <div class="map-popup">
				${farm_name ? `<h2>${farm_name}` : `<h2>${owner}`}
					${website ? `<a href="http://${website}" target="_blank"><i class="fas fa-link fa-sm"></i></a>` : ``}
					${email ? `<a href="mailto:${email}"><i class="fas fa-envelope fa-sm"></i></a>` : ``}
				</h2>
				${farm_name ? `<p>${owner}</p>` : ``}

        <p>${street}</p>
        <p>${city}, ${state}  ${zip}</p>
				<p>${phone1}</p>
				<p>${phone2}</p>
      </div>
    `;

    infoWindow.setContent(content);
    infoWindow.setPosition(position);
    infoWindow.setOptions({pixelOffset: new google.maps.Size(0, -30)});
    infoWindow.open(map);
  });

}

var test = {
  "type": "FeatureCollection",
  "features": [
	{% for breeder in site.breeders %}{% if breeder.state %}{% if breeder.status == "active" %}{% unless breeder.lat=="NA" %}
	{
		  "geometry": {
		    "type": "Point",
		    "coordinates": [
						{{ breeder.long }}, {{ breeder.lat }}
		    ]
		  },
		  "type": "Feature",
		  "properties": {
				"owner": "{{ breeder.owner}}",
				"farm_name": "{{ breeder.farm_name}}",
				"street": "{{ breeder.street}}",
				"city": "{{ breeder.city}}",
				"state": "{{ breeder.state}}",
				"zip": "{{ breeder.zip}}",
				"phone1": "{{ breeder.phone1}}",
				"phone2": "{{ breeder.phone2}}",
				"email": "{{ breeder.email}}",
				"website": "{{ breeder.website}}"
		  }
		},{% endunless %}{% endif %}{% endif %}{% endfor %}
  ]
}
