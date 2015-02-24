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



var waypoints = Array();

//for ( var i=0; i < markers.length; ++i )
//{
//    waypoints.push(L.marker( [markers[i].lat, markers[i].lng], {icon: myIcon} )
//        .bindPopup( '<a href="' + markers[i].url + '" target="_blank">' + markers[i].name + '</a>' )
//        .addTo( map ));
//
//}


var popup = L.popup()
function onMapClick(e)
{
    popup
        .setLatLng(e.latlng)
        .setContent("waypoint #"+waypoints.length.toString())
        .openOn(map);

    waypoints.push(L.marker(e.latlng, {icon: myIcon}).bindPopup(' <a href="/trips">'+ e.latlng +'</a> ').addTo(map));

    latlngs.push(waypoints[waypoints.length - 1].getLatLng());

    L.polyline(latlngs, {color: 'red'}).addTo(map);

    //var myJsonString = JSON.stringify(waypoints);
}
map.on('click', onMapClick);


//waypoints.push(L.marker([30, 0], {icon: myIcon}).addTo(map).bindPopup("<b>Hello!</b><br>wp1"));
//waypoints.push(L.marker([20, -10]).addTo(map).bindPopup("<b>Hello!</b><br>wp2"));
//waypoints.push(L.marker([10, -10]).addTo(map).bindPopup("<b>Hello!</b><br>wp3"));
//waypoints.push(L.marker([10, 0]).addTo(map).bindPopup("<b>Hello!</b><br>wp4"));
//waypoints.push(L.marker([0, 10], {icon: myIcon}).addTo(map).bindPopup("<b>Hello!</b><br>wp5"));



var latlngs = Array();



for (var i = 0; i < waypoints.length; i++)
{

    latlngs.push(waypoints[i].getLatLng());
}

// create a red polyline from an arrays of LatLng points
var polyline = L.polyline(latlngs, {color: 'red'}).addTo(map);

// zoom the map to the polyline
//map.fitBounds(polyline.getBounds());




/*
map.on('click', function(e) {
    L.marker(e.latlng, {icon: myIcon}).bindPopup(' <a href="/trips">Trips</a> ') .addTo(map);


    markers.push({name: '123123', url: 'www.vg.no', lat: 53.1, lng: 32.1});

    markers.push({name: '123123', url: 'www.vg.no', lat: 53.1, lng: 32.1});
    markers.push({name: '123123', url: 'www.vg.no', lat: 54.1, lng: 32.1});
    markers.push({name: '123123', url: 'www.vg.no', lat: 55.1, lng: 32.1});


    for ( var i=0; i < markers.length; ++i )
    {
        L.marker( [markers[i].lat, markers[i].lng], {icon: myIcon} )
            .bindPopup( '<a href="' + markers[i].url + '" target="_blank">' + markers[i].name + '</a>' )
            .addTo( map );

        var polyline = L.polyline([
            [markers[i].lat, markers[i].lng],
            [markers[(i+1)%markers.length].lat, markers[(i+1)%markers.length].lng],
        ]).addTo( map );
    }
});*/
