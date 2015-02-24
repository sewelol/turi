// See post: http://asmaloney.com/2014/01/code/creating-an-interactive-map-with-leaflet-and-openstreetmap/
var map = L.map( 'map', {
    center: [20.0, 5.0],
    minZoom: 2,
    zoom: 2
});


L.tileLayer( 'http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright" title="OpenStreetMap" target="_blank">OpenStreetMap</a> contributors | Tiles Courtesy of <a href="http://www.mapquest.com/" title="MapQuest" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png" width="16" height="16">',
    subdomains: ['otile1','otile2','otile3','otile4']
}).addTo( map );

var myURL = jQuery( 'script[src$="leaf-demo.js"]' ).attr( 'src' ).replace( 'leaf-demo.js', '' );
var myIcon = L.icon({
    iconUrl: myURL + 'images/pin24.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});


// array for holding the coordinates
var latlngs = Array();

// var to hold popup
var popup = L.popup()

// function to be called on mouse click
function onMapClick(e)
{
    popup
        .setLatLng(e.latlng)
        .setContent("waypoint #"+latlngs.length.toString())
        .openOn(map);

    //  Save push coordinates to latlngs
    latlngs.push(
        L.marker(e.latlng, {icon: myIcon})
            .bindPopup(' <a href="/trips">'+ e.latlng +'</a> ')
            .addTo(map)
            .getLatLng()
    );

    // Draw line between all coordinates
    L.polyline(latlngs, {color: 'red'}).addTo(map);

}

// Event handler for mouse clicks
map.on('click', onMapClick);


// zoom the map to the polyline when a route is loaded on start-up
//map.fitBounds(polyline.getBounds());