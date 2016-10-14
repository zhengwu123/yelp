var map = null;
var chicago = new google.maps.LatLng(41.85, -87.65);
var siberia = new google.maps.LatLng(60, 105);
var initialLocation;
var browserSupportFlag = new Boolean();
var pinModeListener;
var GPSlocation;
var editSavedStory = 0;
var markersArray =[];
var editMode = '<div class="container iw-box">' + 
    '<form action="" data-toggle="validator" role="form" id="pin-story">'+'<div class="container vertical">' +'<!-- Story Title--><div class="row top-buffer">' +'<div class="form-group has-feedback">' + '<input type="text" class="form-control" id="story-title" name="story-title" placeholder="Title" required>' +'<span class="glyphicon form-control-feedback" aria-hidden="true"></span>'+'<div class="help-block with-errors"></div>'+'</div>'+'</div>'+'<!-- End of Title --><!-- Story --><div class="row top-buffer">'+'<div class="form-group has-feedback">' + '<textarea class="form-control" rows="8" id="story-content" name="story-content" placeholder="Say something..." required></textarea>' +'<span class="glyphicon form-control-feedback" aria-hidden="true"></span>'+'<div class="help-block with-errors"></div>'+'</div>'+'</div>'+'<!-- End of Story --><!-- Sumbit and Cancel Button --><div class="row top-buffer iw-buttons">' + '<div class="form-inline">' + '<button type="button" class="btn btn-success btn-sm" id="PIN" name="PIN">PIN</button>' + '<button type="button" class="btn btn-warning btn-sm" id="cancel" name="cancel">Cancel</button>'+ '</div>' +'</div>' + '</div>' + '</form>' +'<div>'+'<span id="time" name="time">TIME</span>'+'</div>'+ '</div>';

var checkMode ='<div class="wrapper iw-box">' + 
    '<div class="container vertical" id = "saved-content-all">' + '<div class="row top-buffer" id="user-id">' + '<div id="iw-user-icon-container">' + '<img src="http://icons.iconarchive.com/icons/designbolts/free-multimedia/1024/iMac-icon.png" alt="" id="iw-user-icon">' + '</div>' + '<div id="iw-user-name-container">' + '<span id="iw-user-name">Name</span>' + '</div>' + '</div>' + '<div class="row top-buffer">' + '<span id="saved-title" name="saved-title">Title</span>' + '</div>' + '<div class="row top-buffer" id="story-content-container" name="saved-story-container">' + '<p id="saved-story-content" name="saved-story-content"></p>' + '</div>' + '<div class="row top-buffer">'+'<div class="form-inline" id="bottom-row-layout">' + '<div id = "time-stamp">' + '<span id="CREATE-time" name="CREATE-time">TIME</span>' + '</div>' + '<div class="iw-buttons">' +'<button type="button" class="btn btn-info btn-sm" id="iw-edit-btn">Edit</button>' + '<button type="button" class="btn btn-warning btn-sm" id="iw-del-btn">Delete</button>' + '</div>' +'</div>' + '</div>' + '</div>' +'</div>';


//customize icons of geomarker
var geoImg = {
    url: './images/47112-200.png',
    size: new google.maps.Size(200, 200),
    // The origin for this image is (0, 0).
    origin: new google.maps.Point(0, 0),
    // The anchor for this image is the base of the flagpole at (0, 32).
    anchor: new google.maps.Point(0, 32),
    scaledSize: new google.maps.Size(32, 32)
};

// Shapes define the clickable region of the icon. The type defines an HTML
// <area> element 'poly' which traces out a polygon as a series of X,Y points.
// The final coordinate closes the poly by connecting to the first coordinate.
var shape = {
    coords: [1, 1, 1, 20, 18, 20, 18, 1],
    type: 'poly'
};

function initialize() {  
 var myWrapper = $("#wrapper");
 $("#menu-toggle").click(function(e) {
  e.preventDefault();
  $("#wrapper").toggleClass("toggled");
  myWrapper.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function(e) {
   // code to execute after transition ends
   google.maps.event.trigger(map, 'resize');
  });
 });
    
 //add attr to map
 var mapOptions = {
  zoom: 13,
  //center: siberia,
  center: chicago,
  disableDefaultUI: true,
  mapTypeControl: true,
  mapTypeControlOptions: {
   style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
  },
  zoomControl: true,
  zoomControlOptions: {
   position: google.maps.ControlPosition.RIGHT_CENTER
  },
  navigationControl: true,
  navigationControlOptions:
  {
    style: google.maps.NavigationControlStyle.ZOOM_PAN
  },
  scaleControl: true,
  draggableCursor: 'pointer',     
  styles: [{ featureType: "poi", elementType: "labels", stylers: [{ visibility: "off" }]}],
  mapTypeId: google.maps.MapTypeId.ROADMAP
 };// End of setting map options
    
    
 // Insert map to the page
 map = new google.maps.Map(document.getElementById('map'), mapOptions);
 

 // Try HTML5 geolocation
// if(navigator.geolocation) {
//   navigator.geolocation.getCurrentPosition(function(position) {
//     initialLocation = new google.maps.LatLng(position.coords.latitude,
//                                      position.coords.longitude);
//
//     var infowindow = new google.maps.InfoWindow({
//       map: map,
//       position: initialLocation,
//       content: 'Location found using HTML5.'
//     });
//
//     map.setCenter(initialLocation);
//   }, function() {
//     handleNoGeolocation(true);
//   });
// } else {
//   // Browser doesn't support Geolocation
//   handleNoGeolocation(false);
// }
    
//    if (navigator.geolocation) {
//      navigator.geolocation.getCurrentPosition(success);
//    } else {
//      error('Geo Location is not supported');
//    }
// Try W3C Geolocation (Preferred)
 if (navigator.geolocation) {
  //console.log('Geolocation is supported!');
  browserSupportFlag = true;
  navigator.geolocation.getCurrentPosition(function(position) {
       initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);   
       var marker = new google.maps.Marker({
                map: map,
                position: initialLocation,
                icon: geoImg,
                shape: shape,
                animation: google.maps.Animation.DROP,
                title: 'YOU'
            });
       map.setZoom(13);      
       map.setCenter(initialLocation);
  }, function() {
   handleNoGeolocation(browserSupportFlag);
  });
 }
 // Browser doesn't support Geolocation
 else {
  browserSupportFlag = false;
  handleNoGeolocation(browserSupportFlag);
 }
 //End of geo location
 // Create the DIV to hold the CENTER control and call the CenterControl()
 // constructor passing in this DIV.
 var centerControlDiv = document.createElement('div');
 var centerControl = new CenterControl(centerControlDiv, map);

 centerControlDiv.index = 1;
 // Append the center control on google map
 map.controls[google.maps.ControlPosition.RIGHT_TOP].push(centerControlDiv);
    
    
 // Create div to hold PIN Control
 var pinControlDiv = document.createElement('div');
 var pinControl = new PinControl(pinControlDiv, map);

 pinControlDiv.index = 1;
 // Append the pin control on google map
 map.controls[google.maps.ControlPosition.LEFT_TOP].push(pinControlDiv);
 
// Create div to hold SELECT Control
 var selectControlDiv = document.createElement('div');
 var selectControl = new SelectControl(selectControlDiv, map);

 selectControlDiv.index = 1;
 // Append the select control on google map
 map.controls[google.maps.ControlPosition.LEFT_TOP].push(selectControlDiv);     
    
// // Add event action when user click on map    
 google.maps.event.addListener(map, 'click', function(){
     infoWindow.close();
 });
    
 //Auto complete search bar    
 var acOptions = {
  types: ['establishment']
 };
 var autocomplete = new google.maps.places.Autocomplete(document.getElementById('autocomplete'), acOptions);
 autocomplete.bindTo('bounds', map);
 infoWindow = new google.maps.InfoWindow();
 var marker = new google.maps.Marker({
  map: map
 });

 // Event handling when usr typing in search input field    
 google.maps.event.addListener(autocomplete, 'place_changed', function() {
  infoWindow.close();
  var place = autocomplete.getPlace();
  if (place.geometry.viewport) {
   map.fitBounds(place.geometry.viewport);
  } else {
   map.setCenter(place.geometry.location);
   map.setZoom(17);
  }
  marker.setPosition(place.geometry.location);
  infoWindow.setContent('<div><strong>' + place.name + '</strong><br>');
  infoWindow.open(map, marker);
  google.maps.event.addListener(marker, 'click', function(e) {

   infoWindow.open(map, marker);
  });
 });// End of auto complete
    
 //load markers from database    
 loadMarkers();
 // Add event handling to pins in 50 mile
 document.getElementById('searchNearLocation').addEventListener('click', function(){
     getPinsInRange(50);
     map.setZoom(13);
 });
 document.getElementById('myPins').addEventListener('click', function(){
     clearLocations();
     loadMarkers();
     map.setZoom(4);
 });
} // End of function initialize

function loadMarkers(){
    downloadUrl("../mainPagePin.php", function(data) {
  var xml = data.responseXML;
  if (xml){
      var markers = xml.documentElement.getElementsByTagName("marker");
      console.log("curr number is " + markers.length);
      for (var i = 0; i < markers.length; i++) {

        var title = markers[i].getAttribute("title");
        var content = markers[i].getAttribute("content");
        var email = markers[i].getAttribute("email");
        var point = new google.maps.LatLng(
            parseFloat(markers[i].getAttribute("lat")),
            parseFloat(markers[i].getAttribute("lng")));
        // need to get time
        var owner = markers[i].getAttribute("owner");
        var time = markers[i].getAttribute("time");
        markers[i] = marker;
        var html = '<div class="wrapper iw-box">' + 
        '<div class="container vertical" id = "saved-content-all">' + '<div class="row top-buffer" id="user-id">' + '<div id="iw-user-icon-container">' + '<img src="http://icons.iconarchive.com/icons/designbolts/free-multimedia/1024/iMac-icon.png" alt="" id="iw-user-icon">' + '</div>' + '<div id="iw-user-name-container">' + '<span id="iw-user-name">'+ owner +'</span>' + '</div>' + '</div>' + '<div class="row top-buffer">' + '<span id="saved-title" name="saved-title">' + title + '</span>' + '</div>' + '<div class="row top-buffer" id="story-content-container" name="saved-story-container">' + '<p id="saved-story-content" name="saved-story-content">' + content +'</p>' + '</div>' + '<div class="row top-buffer">'+'<div class="form-inline" id="bottom-row-layout">' + '<div id = "time-stamp">' + '<span id="CREATE-time" name="CREATE-time">'+ time +'</span>' + '</div>' + '<div class="iw-buttons">' +'<button type="button" class="btn btn-info btn-sm" id="iw-edit-btn">Edit</button>' + '<button type="button" class="btn btn-warning btn-sm" id="iw-del-btn">Delete</button>' + '</div>' +'</div>' + '</div>' + '</div>' +'</div>'; 



        var marker = new google.maps.Marker({
          map: map,
          position: point,
        });
        markersArray.push(marker);
        bindInfoWindow(marker, map, infoWindow, html, title, content, time, owner);
      }
    }
 });
}


function success(position) {
     initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
     var marker = new google.maps.Marker({
          position: initialLocation,
          map: map,
         icon: geoImg,
         shape: shape
     });   
     map.setZoom(13);      
     map.setCenter(initialLocation);
}


function handleLocationError(browserHasGeolocation, infoWindow, pos) {
  infoWindow.setPosition(pos);
  infoWindow.setContent(browserHasGeolocation ?
        'Error: The Geolocation service failed.' :
        'Error: Your browser doesn\'t support geolocation.');
}


 // Handling geo location Err
 function handleNoGeolocation(errorFlag) {
  if (errorFlag == true) {
   alert("Geolocation service failed.");
   initialLocation = chicago;
  } else {
   alert("Your browser doesn't support geolocation. We've placed you in Siberia.");
   initialLocation = siberia;
  }
  map.setCenter(initialLocation);
 }

//Add GeoLocation Control on map
function CenterControl(controlDiv, map) {

 // Set CSS for the control border.
 var controlUI = document.createElement('div');
 controlUI.style.backgroundColor = 'transparent';
 controlUI.style.border = '2px solid transparent';
 controlUI.style.borderRadius = '3px';
 controlUI.style.marginTop = '10px';
 controlUI.style.marginRight = '10px';
 controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
 controlUI.style.cursor = 'pointer';
 controlUI.style.textAlign = 'center';
 controlUI.title = 'Click to recenter the map';
 controlDiv.appendChild(controlUI);

 // Set CSS for the control interior.
 var controlIcon = document.createElement('div');
 controlIcon.style.backgroundImage = "url('images/" + "rsz_ic_my_location_black_48dp.png')";   
 controlIcon.style.height = '36px';
 controlIcon.style.width = '36px';
 controlUI.appendChild(controlIcon);

 // Setup the click event listeners: simply set the map to user initialLocation.
 controlUI.addEventListener('click', function() {
  map.setCenter(initialLocation);
  map.setZoom(13);     
 });
}// End of Geo Control


// Create select button
function SelectControl(controlDiv, map) {
 // Set CSS for the control border.
 var controlUI = document.createElement('div');
 controlUI.style.backgroundColor = 'transparent';
 controlUI.style.border = '2px solid transparent';
 controlUI.style.borderRadius = '3px';   
 controlUI.style.marginTop = '10px';
 controlUI.style.marginLeft = '10px';
 controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
 controlUI.style.cursor = 'pointer';
 controlUI.style.textAlign = 'center';
 controlUI.title = 'Click to select item';
 controlDiv.appendChild(controlUI);

 // Set CSS for the control interior.
 var controlIcon = document.createElement('div');
 controlIcon.style.backgroundImage = "url('images/" + "rsz_hand_cursor.png')";   
 controlIcon.style.height = '36px';
 controlIcon.style.width = '36px';
 controlUI.appendChild(controlIcon);

 // Setup the click event listeners: let user put pin on map
 controlUI.addEventListener('click', function() {
    console.log("clicked select");
    map.set('draggableCursor', 'pointer');
    //disable the pin control
     console.log("disable the pinned mode after hitting select");
    google.maps.event.removeListener(pinModeListener);
 });
}


// Create pin button
function PinControl(controlDiv, map) {
 // Set CSS for the control border.
 var controlUI = document.createElement('div');
 controlUI.style.backgroundColor = 'transparent';
 controlUI.style.border = '2px solid transparent';
 controlUI.style.borderRadius = '3px';
 controlUI.style.marginTop = '10px';
 controlUI.style.marginLeft = '10px';
 controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
 controlUI.style.cursor = 'pointer';
 controlUI.style.textAlign = 'center';
 controlUI.title = 'Click to add marker';
 controlDiv.appendChild(controlUI);

 // Set CSS for the control interior.
 var controlIcon = document.createElement('div');
 controlIcon.style.backgroundImage = "url('images/" + "rsz_299087.png')";   
 controlIcon.style.height = '36px';
 controlIcon.style.width = '36px';
 controlUI.appendChild(controlIcon);

 // Setup the click event listeners: let user put pin on map
 controlUI.addEventListener('click', function() {
    console.log("clicked add marker");
     map.set('draggableCursor', 'crosshair');
     pinModeListener = google.maps.event.addListenerOnce(map, 'click', function(event) {
        placeMarker(event.latLng);
        map.set('draggableCursor', 'pointer');
     });
 });
} // End of Pin Control


//Place Marker
function placeMarker(location) {
    GPSlocation = location;
    var marker = new google.maps.Marker({
            position: location, 
            //later might only enable owner of pin to drag 
            draggable: true,
            animation: google.maps.Animation.DROP,
            map: map
        });
    map.panTo(location);

    var infowindow = new google.maps.InfoWindow({
     content: editMode,
     maxWidth: 400
    });
    infowindow.open(map, marker);
    var time;
    // Add action to marker
    google.maps.event.addListener(marker, 'click', function(event) {
         infowindow.open(map, marker);
     });
    
    // Add action to cancel button
    document.getElementById('cancel').addEventListener("click", function(){
        //console.log("called from cancel");
        toCheckMode(infowindow, marker);
    });
    
    // Action after user hit PIN
    document.getElementById('PIN').addEventListener("click", function(){
        //console.log("called from PIN");
        // save time when user push the marker to server		       
        var time = saveCreateTime();
        // Need to push the time to database
        //...
        //send data to server
        var title = document.getElementById("story-title").value;
        var content = document.getElementById("story-content").value;
        if (title && content){
            //only send server valid pin
            console.log("user created a pin");
            markersArray.push(marker);
            console.log(isInfoWindowOpen(infowindow));
            ajax_post();
//             google.maps.event.addListener(map, 'click', function(){
//                 if(!isInfoWindowOpen(infowindow)){
//                     console.log("window closed");
//                     ajax_post();
//                 }
//            });
        }
        toCheckMode(infowindow, marker, title, content, time);
    });
    
    // Close infoWindows when user click on map
    google.maps.event.addListener(map, 'click', function(event) {
         infowindow.close();
         //console.log("called from map");
         google.maps.event.addListener(marker, 'click', function(event) {
            toCheckMode(infowindow, marker);
        });
     });
}// End of place marker

function toCheckMode(infowindow, marker, title, content, time, owner){
    //console.log("in toCheckMode");
    infowindow.setContent(checkMode);
    if (title && content){
        // show user saved pin content
        document.getElementById('saved-title').innerHTML = title;
        document.getElementById('saved-story-content').innerHTML = content;
        //update time stamp here only if user successfully created the marker
        if (time){
            document.getElementById('CREATE-time').innerHTML = time;
        }
    }
    else {
        if (title){
            document.getElementById('saved-title').innerHTML = title;
        }
        if (content){
            document.getElementById('saved-story-content').innerHTML = content;
        }
    }
    if (owner){
            document.getElementById('iw-user-name').innerHTML = owner;
        }
        else {
            document.getElementById('iw-user-name').innerHTML = document.getElementById('profile-username').innerHTML;
        }
    
    if (document.getElementById('iw-edit-btn') != null){
        document.getElementById('iw-edit-btn').addEventListener("click", function(){
            //console.log("called from checkMode");
            editSavedStory = 1;
            toEditMode(infowindow, marker, title, content, time, owner);
        });
    }
    if (document.getElementById('iw-del-btn') != null){
        document.getElementById('iw-del-btn').addEventListener("click", function(){
                    //console.log("del the marker");
                    //need to send server side 
                    var pos = marker.position;
                    var lat = pos.lat();
                    var lng = pos.lng();
                    //console.log(lat);
                    //need to send server side
                    var vars = "title="+title+"&content="+content + "&latitude="+lat+"&longitude="+ lng;
                    delete_marker(vars);
                    marker.setMap(null);
        });     
    }
//    google.maps.event.addListener(map, 'click', function(){
//        //infoWindow.close();
//        updateMarkers();
//    });
}

function toEditMode(infowindow, marker, title, content, time, owner){
    //console.log("in toEditMode");
    //console.log(time);
    if (editSavedStory == 0){
        infowindow.setContent(editMode);
    }
    else {
        //editsavedStory = 1
        infowindow.setContent(editMode);
        if (title){
            document.getElementById('story-title').value = title;
        }
        if (content){
            document.getElementById('story-content').value = content;
        }
        editSavedStory = 0;
    }
    if (document.getElementById('cancel')){
        document.getElementById('cancel').addEventListener("click", function(){
            //console.log("called from EditMode, edit");
            toCheckMode(infowindow, marker, title, content, time, owner);
        });
    }
    if (document.getElementById('PIN')){
        document.getElementById('PIN').addEventListener("click", function(){
            //console.log("called from EditMode, PIN");
            // check if user has changed saved values
            var title0 = document.getElementById('story-title').value;
            var content0 = document.getElementById('story-content').value;
            if(title0 != title || content0 != content){
                var time_new = saveCreateTime();
                document.getElementById('time').value = time_new;
                // update info data in database
                markersArray.push(marker);
                ajax_post();
                // update infowindow if user changed anything
                toCheckMode(infowindow, marker, title0, content0, time_new, owner); 
            }
            else {
             //console.log(time);
             toCheckMode(infowindow, marker,  title, content, time, owner);   
            } 
        });
    }
}


function saveCreateTime(){		
    // Return today's date and time		
    var currentTime = new Date();		
    // returns the month (from 0 to 11)		
    var month = currentTime.getMonth() + 1;		
    var day = currentTime.getDate();		
    var year = currentTime.getFullYear();		
    var hour= currentTime.getHours();		
    var min = currentTime.getMinutes();		
    var sec = currentTime.getSeconds();	
    if (month<10) month="0"+month;
    if (day<10) day="0"+day;
    if (hour<10) hour="0"+hour;
    if (min<10) min="0"+min;
    if (sec<10) sec="0"+sec;
    var time = year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + sec;		
    return time;		
}

function bindInfoWindow(marker, map, infoWindow, html, title, content, time, owner) {
  google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent(html);
    infoWindow.open(map, marker);
    document.getElementById('iw-edit-btn').addEventListener("click", function(){
        editSavedStory = 1;
        GPSlocation = marker.position;
        toEditMode(infoWindow, marker, title, content, time, owner);
    });
    document.getElementById('iw-del-btn').addEventListener("click", function(){
         //console.log("hit del");
         
         var pos = marker.position;
         var lat = pos.lat();
         var lng = pos.lng();
         //console.log(lat);
         //need to send server side
                    var vars = "title="+title+"&content="+content + "&latitude="+lat+"&longitude="+ lng;
                    delete_marker(vars);
                    marker.setMap(null);
     });         
  });
}

function downloadUrl(url,callback) {
 var request = window.ActiveXObject ?
     new ActiveXObject('Microsoft.XMLHTTP') :
     new XMLHttpRequest;

 request.onreadystatechange = function() {
   if (request.readyState == 4) {
     request.onreadystatechange = doNothing;
     callback(request, request.status);
   }
 };

 request.open('GET', url, true);
 request.send(null);
}
 
function doNothing() {}


//code below delete markers on database
function delete_marker(params) {
    var httpc = new XMLHttpRequest(); // simplified for clarity
    var url = "delete_marker.php";
    httpc.open("POST", url, true); // sending as POST

    httpc.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    //httpc.setRequestHeader("Content-Length", params.length); // POST request MUST have a Content-Length header (as per HTTP/1.1)

    httpc.onreadystatechange = function() { //Call a function when the state changes.
    if(httpc.readyState == 4 && httpc.status == 200) { // complete and no errors
        //alert(httpc.responseText); // some processing here, or whatever you want to do with the response
        }
    }
    httpc.send(params);
}

function ajax_post(){
    // Create our XMLHttpRequest object
    var hr = new XMLHttpRequest();
    // Create some variables we need to send to our PHP file
    var url = "parse_pin.php";
    var title = document.getElementById("story-title").value;
    var content = document.getElementById("story-content").value;
    var time = document.getElementById("time").value;
    // issues when user update saved marker
    var lat = GPSlocation.lat();
    var long = GPSlocation.lng();
    
    // Need to check user input
    if (title && content){
        var vars = "title="+title+"&content="+content + "&latitude="+lat+"&longitude="+ long;
        hr.open("POST", url, true);
        // Set content type header information for sending url encoded variables in the request
        hr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        // Access the onreadystatechange event for the XMLHttpRequest object
        hr.onreadystatechange = function() {
          if(hr.readyState == 4 && hr.status == 200) {  
            //var return_data = hr.responseXML;
            var return_data = hr.responseXML;
            //window.alert(return_data);
            // Update markers on map
            updateMarkers();
          }
        }
        // Send the data to PHP now... and wait for response to update the status div
        // Actually execute the request 
        hr.send(vars);
    }
    else {
        // won't save this marker   
    }
}

function updateMarkers(){
    google.maps.event.addListener(map, 'click', function(){
         clearLocations();
         loadMarkers();
    });
}

function isInfoWindowOpen(infoWindow){
    var map = infoWindow.getMap();
    return (map !== null && typeof map !== "undefined");
}



function getPinsInRange(radius){
        clearLocations();
        var center = map.getCenter();
        var center_lat = center.lat();
        var center_lng = center.lng();
        var infoWindow = new google.maps.InfoWindow();
    
        var httpc = new XMLHttpRequest(); // simplified for clarity
        var url = "findPinsInRange.php";
        httpc.open("POST", url, true); // sending as POST
        //var vars = "title="+title+"&content="+content + "&latitude="+lat+"&longitude="+ long;
        var vars = "center_lat="+center_lat+"&center_lng="+center_lng + "&radius="+radius;
        //httpc.setRequestHeader("Content-Type", "text/xml");
        httpc.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        //httpc.setRequestHeader("Content-Length", params.length); // POST request MUST have a Content-Length header (as per HTTP/1.1)
        
        //Call a function when the state changes.
        httpc.onreadystatechange = function() { 
        if(httpc.readyState == 4 && httpc.status == 200) { // complete and no errors
           // some processing here, or whatever you want to do with the response
             httpc.onreadystatechange = doNothing;
             //alert(httpc.responseXML);
             //alert(httpc.responseText);
             var xml = httpc.responseXML;
             var markerNodes = xml.documentElement.getElementsByTagName("marker");
             var bounds = new google.maps.LatLngBounds();
             console.log(markerNodes.length);
             for (var i = 0; i < markerNodes.length; i++) {
                  var title = markerNodes[i].getAttribute("title");
                var content = markerNodes[i].getAttribute("content");
                var email = markerNodes[i].getAttribute("email");
                var point = new google.maps.LatLng(
                    parseFloat(markerNodes[i].getAttribute("lat")),
                    parseFloat(markerNodes[i].getAttribute("lng")));
                // need to get time
                var owner = markerNodes[i].getAttribute("owner");
                var time = markerNodes[i].getAttribute("time");
                markerNodes[i] = marker;
                var html = '<div class="wrapper iw-box">' + 
                '<div class="container vertical" id = "saved-content-all">' + '<div class="row top-buffer" id="user-id">' + '<div id="iw-user-icon-container">' + '<img src="http://icons.iconarchive.com/icons/designbolts/free-multimedia/1024/iMac-icon.png" alt="" id="iw-user-icon">' + '</div>' + '<div id="iw-user-name-container">' + '<span id="iw-user-name">'+ owner +'</span>' + '</div>' + '</div>' + '<div class="row top-buffer">' + '<span id="saved-title" name="saved-title">' + title + '</span>' + '</div>' + '<div class="row top-buffer" id="story-content-container" name="saved-story-container">' + '<p id="saved-story-content" name="saved-story-content">' + content +'</p>' + '</div>' + '<div class="row top-buffer">'+'<div class="form-inline" id="bottom-row-layout">' + '<div id = "time-stamp">' + '<span id="CREATE-time" name="CREATE-time">'+ time +'</span>' + '</div>' + '<div class="iw-buttons">' +'<button type="button" class="btn btn-info btn-sm" id="iw-edit-btn">Edit</button>' + '<button type="button" class="btn btn-warning btn-sm" id="iw-del-btn">Delete</button>' + '</div>' +'</div>' + '</div>' + '</div>' +'</div>'; 

                var marker = new google.maps.Marker({
                  map: map,
                  position: point,
                });
                markersArray.push(marker);
                //console.log(markersArray.length);
                bindInfoWindow(marker, map, infoWindow, html, title, content, time, owner);
             }
            }
        }
        httpc.send(vars);

}

function clearLocations() {
  infoWindow.close();
  if(markersArray){
      for (var i = 0; i < markersArray.length; i++) {
        markersArray[i].setMap(null);
      }
    markersArray.length = 0;
  }
}

function parseXml(str) {
      if (window.ActiveXObject) {
        var doc = new ActiveXObject('Microsoft.XMLDOM');
        doc.loadXML(str);
        return doc;
      } else if (window.DOMParser) {
        return (new DOMParser).parseFromString(str, 'text/xml');
      }
    }
google.maps.event.addDomListener(window, 'load', initialize);