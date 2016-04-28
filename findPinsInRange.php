<?php
	ob_start();
   session_start();
   if (!$_SESSION['valid'])
	header("Location: index.php");
    require("includes/db_connect.php");
?>
<?php 
//echo 'Thank you '. $_POST['center_lat']. $_POST['center_lng']." ".$_POST['radius'];

// Get parameters from URL
$center_lat = $_POST['center_lat'];
$center_lng = $_POST['center_lng'];
$radius = $_POST['radius'];
$title1 = mysqli_real_escape_string($connection,$_POST['title']);
$content1 = mysqli_real_escape_string($connection,$_POST['content']);
$latitude1 = $_POST['latitude'];
$longitude1 = $_POST['longitude'];
$emailadd = $_SESSION['email'];

// Start XML file, create parent node
$dom = new DOMDocument("1.0");
$node = $dom->createElement("markers");
$parnode = $dom->appendChild($node); 

/*$query = sprintf("SELECT address, name, lat, lng, ( 3959 * acos( cos( radians('%s') ) * cos( radians( lat ) ) * cos( radians( lng ) - radians('%s') ) + sin( radians('%s') ) * sin( radians( lat ) ) ) ) AS distance FROM markers HAVING distance < '%s' ORDER BY distance LIMIT 0 , 20",
  mysql_real_escape_string($center_lat),
  mysql_real_escape_string($center_lng),
  mysql_real_escape_string($center_lat),
  mysql_real_escape_string($radius));*/


//haversine algorithm to compute distance.
$query = sprintf("SELECT title, content, owner, CreatedOn, longitude, latitude, ( 3959 * acos( cos( radians('%s') ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(%s) ) + sin( radians('%s') ) * sin( radians( latitude ) ) ) ) AS distance FROM makers HAVING distance < '%s' ORDER BY distance LIMIT 0 , 20",$center_lat,$center_lng,$center_lat,$radius);

$result = mysqli_query($connection,$query);

  if(! $result ){
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }
                    
if (mysqli_num_rows($result) > 0) {
    header("Content-type: text/xml");
    // Iterate through the rows, adding XML nodes for each
    while ($row = @mysqli_fetch_assoc($result)){
      $node = $dom->createElement("marker");
      $newnode = $parnode->appendChild($node);
      $newnode->setAttribute("title", $row['title']);
      $newnode->setAttribute("content", $row['content']);
      $newnode->setAttribute("lat", $row['latitude']);
      $newnode->setAttribute("lng", $row['longitude']);
        $newnode->setAttribute("owner", $row['owner']);
        $newnode->setAttribute("time", $row['CreatedOn']);
      $newnode->setAttribute("distance", $row['distance']);
    }
    echo $dom->saveXML();
    //echo $query;
}
else{
    return "0 result";
}
mysqli_close($connection);
?>