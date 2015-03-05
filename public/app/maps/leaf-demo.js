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

var wayPointIcon = L.icon({
    iconUrl: myURL + 'images/Waypoint.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});

var startIcon = L.icon({
    iconUrl: myURL + 'images/Start.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});

var endIcon = L.icon({
    iconUrl: myURL + 'images/End.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14]
});


var undoButtonOptions = {
    'text': '',  // string
    'iconUrl': myURL + 'images/Undo.png',  // string
    'onClick': undoOnClick,  // callback function
    'hideText': true,  // bool
    'maxWidth': 30,  // number
    'doToggle': false,  // bool
    'toggleStatus': false  // bool
};

var resetButtonOptions = {
    'text': '',  // string
    'iconUrl': myURL + 'images/Reset.png',  // string
    'onClick': resetOnClick,  // callback function
    'hideText': true,  // bool
    'maxWidth': 30,  // number
    'doToggle': false,  // bool
    'toggleStatus': false  // bool
};

var doneButtonOptions = {
    'text': '',  // string
    'iconUrl': myURL + 'images/Done.png',  // string
    'onClick': doneOnClick,  // callback function
    'hideText': true,  // bool
    'maxWidth': 30,  // number
    'doToggle': false,  // bool
    'toggleStatus': false  // bool
};

// button (used as a UNDO button atm)
var undoButton = new L.Control.Button(undoButtonOptions).addTo(map);

var resetButton = new L.Control.Button(resetButtonOptions).addTo(map);

var doneButton = new L.Control.Button(doneButtonOptions).addTo(map);

// layer for holding the route (markers and lines)
var waypointLayer = L.layerGroup();

// array for holding the coordinates
//var latlngs = Array();

//array for holding markers
var markers = Array();

// var to hold popup
var popup = L.popup();


function drawMap() {
    // clear old waypoint layer
    waypointLayer.clearLayers();


    if (markers.length != 0) {
        markers[0].setIcon(startIcon);
    }


    // adds all makers to waypoint layer
    for(var i = 0; i < markers.length; i++) {



        markers[i].addTo(waypointLayer);

        if (i != 0) {
            // adds all lines to the waypoint layer
            L.polyline([markers[i - 1].getLatLng(), markers[i].getLatLng()], {color: 'red'})
                .addTo(waypointLayer);
        }
    }




    // draw waypoint layer to map
    waypointLayer.addTo(map);

}


// function to be called on mouse click
function onMapClick(e)
{
    console.log("someone clicked my map");

    popup
        .setLatLng(e.latlng)
        .setContent("waypoint #"+markers.length.toString())
        .openOn(map);


    var temp = L.marker(e.latlng, {icon: wayPointIcon})
        .bindPopup("waypoint #"+markers.length.toString());

    temp.title = "waypoint #"+markers.length.toString();



    //addInputFieldForWaypoint(temp);

    $('#waypoint-form')
        .append('My waypoint: ' + markers.length.toString() +
        ': <input type="text" value="' + temp.title  + '" name="desc"/> ' +
        ': <input type="text" value="' + temp.getLatLng().lat  + '" name="lat"/> ' +
        ': <input type="text" value="' + temp.getLatLng().lng  + '" name="lng"/> ' +
        ': <input type="text" value="' + temp.title  + '" name="type"/> ' +
        '<br/>')

    markers.push(temp);

    drawMap();

}


function resetOnClick() {

    if (markers.length > 0) {
        var temp = markers[0].getLatLng();

        //while (latlngs.length > 0) {
        //    latlngs.pop();
        //}
        while (markers.length > 0) {
            markers.pop();
        }

        popup
            .setLatLng(temp)
            .setContent("route removed.")
            .openOn(map);

        drawMap();
    } else {
        console.log("nothing to reset");
    }
}


// handle button clicks, button is atm a UNDO button
function undoOnClick() {
    console.log("someone clicked my button");

    if (markers.length > 0) {
        popup
            .setLatLng(markers[markers.length - 1].getLatLng())
            .setContent("waypoint removed.")
            .openOn(map);
        //latlngs.pop();
        markers.pop();

        drawMap();
    } else {
        console.log("nothing to undo");
    }
}

function doneOnClick() {

    //{desc, lat, lng, type}

    var route = Array();
    var type;


    for(var i = 0; i < markers.length; i++) {
        var waypoint = {};

        if (i == 0) {
            type = "START";
            markers[i].title = "Start Location";
        } else if (i==markers.length-1) {
            type = "END";
            markers[i].title = "End Location";
        } else {
            type = "WP";
        }
        waypoint["lat"] = markers[i].getLatLng().lat;
        waypoint["lng"] = markers[i].getLatLng().lng;
        waypoint["desc"] = markers[i].title;
        waypoint["type"] = type;
        waypoint["index"] = i;

        route.push(waypoint);
    }



    //var geojson = waypointLayer.toGeoJSON();
    //
    //waypointLayer.clearLayers();
    //
    //L.geoJson(geojson).addTo(map);

    markers[markers.length-1].setIcon(endIcon);
    drawMap();

    POST(route);

    console.log(JSON.stringify(route));
}

function POST (route) {
    var dat = JSON.stringify(route);

    console.log("I am about to POST this: \n\n" + dat);

    $.post( "ajax/test.html", function( dat ) {
        //$( ".result" ).html( data );
    });


}


// Event handler for mouse clicks
map.on('click', onMapClick);



// zoom the map to the polyline when a route is loaded on start-up
//map.fitBounds(polyline.getBounds());
